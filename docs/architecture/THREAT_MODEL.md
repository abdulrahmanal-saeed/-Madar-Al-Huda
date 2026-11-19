# P00-05 — Threat model and acceptance

| Threat | Risk | Prevention | Verification task |
|---|---|---|---|
| Altered Quran byte sequence | Critical religious integrity | fixed source/edition SHA-256, immutable display data, signed manifest, allow-listed version | P01-01 |
| Unlicensed tafsir or audio republished | Legal/content takedown | rights register per edition/assets, cache TTL and permission gate | P00-07/P02-07 |
| Non-approved fiqh published | Incorrect religious guidance | qualified human review, source citations, no direct client publication | P00-08/P03-07 |
| Drafts visible through API/Storage | Data leak and misinformation | private schema, no client grants, approved projection, RLS SELECT policies | P04-01/P05-02 |
| User A reads/mutates B state | Privacy breach / BOLA | `auth.uid()` predicates on both USING/WITH CHECK, foreign keys, role tests | P04-01/P05-02 |
| Attackers promote own editorial role | Privilege escalation | never rely on user metadata; server-controlled reviewer membership | P04-01 |
| JWT role stale after revocation | Privilege persists | server-side role lookup for every editorial approval; short access JWT lifetime | P04-01 |
| Exposure of service role in app | Full database compromise | secret scanning, trusted server boundary, separate publishable key | P04-01/P05-02 |
| Wrong local prayer time | Worship impact | explicit method/time zone, official comparable fixtures, user override | P00-10 |
| Unsafe content cache after withdrawal | Legal/religious impact | revocation index, TTL, offline permitted only, disable removed content upon next sync | P04-07 |
| Lost reading place on sync | User data loss | guest-local first, explicit one-time merge, edition-aware mapping | P01-03 |
| Public data costly to serve | Availability/cost | indexed published projection, versioned export, measured egress, optional CDN | P06-04 |

## Engineering review checklist
- [x] Backend and app boundaries documented.
- [x] Source manifest / edition immutability invariant documented.
- [x] ERD records composite keys and four schools' non-consensus rule.
- [x] Privileged editor rights not user-mutable.
- [x] Public projection and user records RLS matrix documented.
- [x] Specific threat-to-test mapping documented.
- [ ] Live Supabase schema and policies deployed **later** to isolated test project.
- [ ] RLS role tests and advisor reports executed when backend work starts.
- [ ] Real Quran/source publication unlocked only when rights and scholarly gates pass.
