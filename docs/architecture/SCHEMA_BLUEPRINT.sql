-- MADAR AL-HUDA · P00-05 DATABASE SECURITY BLUEPRINT
-- DESIGN REFERENCE ONLY. NOT A MIGRATION; NOT EXECUTED.
-- To implement: generate a correctly named migration using the verified Supabase CLI,
-- then run it in an isolated dev DB with role tests before application.
-- Do not apply blindly to existing schemas or any production project.

create schema if not exists mh_private;
revoke all on schema mh_private from public, anon, authenticated;

create table mh_private.sources (
  id uuid primary key,
  title text not null,
  edition text not null,
  rights_status text not null default 'pending'
    check (rights_status in ('pending','approved','revoked','expired')),
  permission_reference text,
  attribution text,
  offline_allowed boolean not null default false,
  cache_allowed boolean not null default false,
  reviewed_at timestamptz,
  expires_at timestamptz
);

create table mh_private.quran_editions (
  edition_id text primary key,
  source_id uuid not null references mh_private.sources(id),
  riwayah text not null,
  source_release text not null,
  sha256_hex char(64) not null,
  surah_count integer not null check (surah_count = 114),
  verified_ayah_total integer not null check (verified_ayah_total > 0),
  locked_at timestamptz not null
);
create table mh_private.surahs (
  edition_id text not null references mh_private.quran_editions(edition_id),
  surah_number integer not null check (surah_number between 1 and 114),
  ayah_count integer not null check (ayah_count > 0),
  name_ar text not null,
  primary key (edition_id, surah_number)
);
create table mh_private.ayahs (
  edition_id text not null,
  surah_number integer not null,
  ayah_number integer not null check (ayah_number > 0),
  text_uthmani text not null,
  primary key (edition_id, surah_number, ayah_number),
  foreign key (edition_id, surah_number)
    references mh_private.surahs(edition_id, surah_number)
    on delete restrict
);

create table mh_private.content_revisions (
  id uuid primary key,
  content_id uuid not null,
  previous_id uuid references mh_private.content_revisions(id),
  kind text not null check (kind in ('lesson','article','story','hadith','fiqh','dhikr','dua','tafsir','quote')),
  language text not null check (language in ('ar','en')),
  body text not null,
  source_id uuid not null references mh_private.sources(id),
  authored_at timestamptz not null default now()
);
create index on mh_private.content_revisions(content_id, authored_at desc);

create table mh_private.content_reviews (
  id uuid primary key,
  revision_id uuid not null references mh_private.content_revisions(id),
  reviewer_user_id uuid not null references auth.users(id),
  check_kind text not null check (check_kind in ('source','rights','scholarly','language_ar','language_en')),
  decision text not null check (decision in ('approved','rejected')),
  reviewed_at timestamptz not null default now(),
  evidence_ref text not null
);
create table mh_private.publication_events (
  id uuid primary key,
  content_id uuid not null,
  revision_id uuid not null references mh_private.content_revisions(id),
  actor_user_id uuid not null references auth.users(id),
  action text not null check (action in ('published','corrected','withdrawn')),
  created_at timestamptz not null default now(),
  reason text not null
);
create index on mh_private.publication_events(content_id, created_at desc);

-- Public items MUST be projected by a trusted publishing service
-- only after verifying rights, required scholarly review and language checks.
-- This table is not an editorial source of truth.
create table public.mh_published_items (
  id uuid primary key,
  revision_id uuid not null unique references mh_private.content_revisions(id),
  content_kind text not null,
  language text not null check (language in ('ar','en')),
  title text not null,
  body text not null,
  attribution text not null,
  rights_verified boolean not null default false,
  editorial_approved boolean not null default false,
  published_at timestamptz,
  withdrawn_at timestamptz
);
create index on public.mh_published_items(content_kind, language, published_at desc)
  where withdrawn_at is null;

-- Only explicitly signed-in accounts sync state to these cloud tables.
-- Guests continue storing bookmarks and progress locally.
create table public.mh_user_bookmarks (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  edition_id text not null,
  surah_number integer not null,
  ayah_number integer not null,
  note text,
  created_at timestamptz not null default now(),
  foreign key (edition_id, surah_number, ayah_number)
    references mh_private.ayahs(edition_id, surah_number, ayah_number)
);
create index on public.mh_user_bookmarks(user_id, created_at desc);

create table public.mh_user_positions (
  user_id uuid not null references auth.users(id) on delete cascade,
  edition_id text not null,
  surah_number integer not null,
  ayah_number integer not null,
  updated_at timestamptz not null default now(),
  primary key (user_id, edition_id),
  foreign key (edition_id, surah_number, ayah_number)
    references mh_private.ayahs(edition_id, surah_number, ayah_number)
);

create table public.mh_lesson_progress (
  user_id uuid not null references auth.users(id) on delete cascade,
  lesson_id uuid not null,
  progress_percent smallint not null default 0 check (progress_percent between 0 and 100),
  updated_at timestamptz not null default now(),
  primary key (user_id, lesson_id)
);

-- Defense in depth on *every* table, including the non-exposed schema.
alter table mh_private.sources enable row level security;
alter table mh_private.quran_editions enable row level security;
alter table mh_private.surahs enable row level security;
alter table mh_private.ayahs enable row level security;
alter table mh_private.content_revisions enable row level security;
alter table mh_private.content_reviews enable row level security;
alter table mh_private.publication_events enable row level security;
alter table public.mh_published_items enable row level security;
alter table public.mh_user_bookmarks enable row level security;
alter table public.mh_user_positions enable row level security;
alter table public.mh_lesson_progress enable row level security;

-- No client can write published religious content.
revoke all on public.mh_published_items from anon, authenticated;
grant select on public.mh_published_items to anon, authenticated;
create policy "approved_published_read"
  on public.mh_published_items for select to anon, authenticated
  using (
    published_at is not null and
    published_at <= now() and
    withdrawn_at is null and
    rights_verified and editorial_approved
  );

-- User data: every exposed access checks authenticated owner;
-- UPDATE requires SELECT and WITH CHECK.
revoke all on public.mh_user_bookmarks from anon, authenticated;
revoke all on public.mh_user_positions from anon, authenticated;
revoke all on public.mh_lesson_progress from anon, authenticated;
grant select, insert, update, delete on
  public.mh_user_bookmarks, public.mh_user_positions, public.mh_lesson_progress
  to authenticated;

create policy "bookmarks_read_self" on public.mh_user_bookmarks
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "bookmarks_insert_self" on public.mh_user_bookmarks
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "bookmarks_update_self" on public.mh_user_bookmarks
  for update to authenticated using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "bookmarks_delete_self" on public.mh_user_bookmarks
  for delete to authenticated using ((select auth.uid()) = user_id);

create policy "positions_read_self" on public.mh_user_positions
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "positions_insert_self" on public.mh_user_positions
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "positions_update_self" on public.mh_user_positions
  for update to authenticated using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "positions_delete_self" on public.mh_user_positions
  for delete to authenticated using ((select auth.uid()) = user_id);

create policy "progress_read_self" on public.mh_lesson_progress
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "progress_insert_self" on public.mh_lesson_progress
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "progress_update_self" on public.mh_lesson_progress
  for update to authenticated using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "progress_delete_self" on public.mh_lesson_progress
  for delete to authenticated using ((select auth.uid()) = user_id);

-- Future implementation must verify: Postgres grants/default privileges,
-- schema exposure configuration, storage policies, role A/B isolation tests,
-- publisher transaction and revocation, and Supabase advisors.
