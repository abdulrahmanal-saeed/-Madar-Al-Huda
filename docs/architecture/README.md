# Architecture review pack — P00-05

1. [ADR-0001](ADR-0001.md): decisions, mobile/backend trust boundaries and major deferrals.
2. [ERD](ERD.md): normalized logical entities and composite key invariants.
3. [RLS_MATRIX](RLS_MATRIX.md): grants, client privileges and policy intent.
4. [SCHEMA_BLUEPRINT.sql](SCHEMA_BLUEPRINT.sql): **reference SQL only** for future development migration; never auto-run.
5. [THREAT_MODEL](THREAT_MODEL.md): risks, mitigations and downstream verification.

**Not deployed:** no remote Supabase changes, migration runs, CMS, Quran source assets, or user data were introduced. The blueprint requires isolated Postgres/Supabase validation before becoming a migration.

**Current stack:** existing Flutter 3.50 app, Riverpod 3, GoRouter, local preferences. Supabase client version intentionally unchosen due to November 2026 v3 breaking changes and evolving docs. Next.js admin and Drift remain planned, not installed.
