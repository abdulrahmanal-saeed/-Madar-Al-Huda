# RLS and grants matrix — P00-05

Supabase access is governed by **both grants and RLS**. This document is the design specification, not proof of deployed policies.

| Table / group | Exposed? | `anon` | `authenticated` | Trusted server | Policy |
|---|---|---|---|---|---|
| `mh_private.sources / rights` | **No** | none | none | read/write via protected service | permissions, license expiry, evidence never client-readable |
| `mh_private.quran_*` | No | none | none | import/verify only | immutable edition and checksum required |
| `mh_private.content_revisions / reviews / audit` | No | none | none | append-only editorial operations | separate approvals; audit is never directly user-editable |
| `mh_private.fiqh_*` / hadith gradings | No | none | none | approved staff only through server | attribution, academic reviewer checks |
| `public.mh_published_items` | Yes | SELECT valid published only | SELECT valid published only | publishing service only for writes | `published_at IS NOT NULL AND withdrawn_at IS NULL AND (rights_expires_at IS NULL OR rights_expires_at > now()) AND rights_verified AND editorial_approved` |
| `public.mh_user_bookmarks` | Yes | none | own SELECT/INSERT/UPDATE/DELETE | owned-data maintenance | `user_id = (select auth.uid())` for USING and WITH CHECK |
| `public.mh_user_positions` | Yes | none | own SELECT/INSERT/UPDATE/DELETE | owned-data maintenance | same owner checks, foreign key verse/edition |
| `public.mh_lesson_progress` | Yes | none | own SELECT/INSERT/UPDATE/DELETE | owned-data maintenance | same owner checks |
| Supabase Storage buckets | TBD | none until licensed | none until policy approved | protected object publishing | allow-list explicit MIME, path and owner/rights |
| Auth profiles | later | none | own profile only | server security admin | no roles sourced from user-editable metadata |

## Exact SQL policy shape (blueprint)
```sql
alter table public.mh_user_bookmarks enable row level security;
create policy "bookmarks_select_owner" on public.mh_user_bookmarks
  for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "bookmarks_insert_owner" on public.mh_user_bookmarks
  for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "bookmarks_update_owner" on public.mh_user_bookmarks
  for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
create policy "bookmarks_delete_owner" on public.mh_user_bookmarks
  for delete to authenticated
  using ((select auth.uid()) = user_id);
```

## Security safeguards
- **Grant least privilege first, then enable RLS** for every exposed table. Recheck `pg_class.relrowsecurity`, `pg_policies`, `information_schema.role_table_grants`, and default privileges after each migration.
- `authenticated` alone is not authorization; per-user ownership predicates mandatory. UPDATE requires SELECT and matching `WITH CHECK`.
- Public content uses `SELECT` only with server-owned verified status and revocation fields; no client role can INSERT/UPDATE/DELETE publications.
- Views must be `security_invoker = true` (Postgres 15+) or kept off public API; avoid broad access to `mh_private`.
- No `SECURITY DEFINER` endpoints in exposed schemas; default `PUBLIC EXECUTE` must be considered if a future function is added.
- Reviewer/editor/publisher identity and approvals come only from trusted server-owned records; JWT app metadata can be stale and JWT `user_metadata` is user-editable.
- Never put a `service_role` key in Flutter, repo, released APK, or public web bundle.
- Test with users A and B: A cannot read or modify B; anonymous cannot write/read private records; public cannot see drafts or withdrawn/expired content; only publisher can release reviewed material.
- Separate Data API schema exposure configuration and SQL GRANT checks. Enabling RLS alone does not automatically grant access, and grants alone do not filter rows.

## Required implementation evidence (future P04-01/P05-02)
Run migrations in isolated dev Supabase, then test all roles with pgTAP or integration tests; run security/performance advisors. This was **not executed** during architecture design.

Source documentation (reviewed 2026-11-19):
- https://supabase.com/docs/guides/database/postgres/row-level-security
- https://supabase.com/docs/guides/api/securing-your-api
- https://supabase.com/changelog (including supabase-flutter v3 breaking changes)
