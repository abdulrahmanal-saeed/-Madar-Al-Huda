# Active task board — Phase 0

Project-level roadmap and statuses: [../plan/README.md](../plan/README.md) and [../plan/TRACKER.md](../plan/TRACKER.md). This bridge tracks only active agent handoffs; if stale, update it to match the tracker.

| ID | Task | Owner | Status | Acceptance |
|---|---|---|---|---|
| MHD-000 | Establish repo and specification baseline | ChatGPT | DONE | Docs, branch, PR exist and links verified |
| MHD-001 | Build Flutter Android skeleton with Arabic/English (`P00-06`) | Coding agent (Claude Code) | REVIEW | Debug build, navigation, RTL/LTR smoke tests — implemented on branch `claude/serene-galileo-f2ia01`, [PR #4](https://github.com/abdulrahmanal-saeed/madar-al-huda/pull/4); see IMPLEMENTATION.md |
| MHD-002 | Verify Quran source and legal edition | Content lead | BLOCKED | Rights log, attribution, fixed checksum |
| MHD-003 | Prototype prayer time + Qibla calculation | Coding agent | TODO | UAE/Egypt fixtures + timezone/DST tests |
| MHD-004 | Quran reader wireframes and palette QA | Design lead | TODO | RTL/LTR, contrast and responsive review |
| MHD-005 | Verify reciter and tafsir distribution rights | Content lead | BLOCKED | 3 reciters and 2 tafsir sources assessed |
| MHD-006 | Define fiqh reviewer workflow | Content lead | BLOCKED | Qualified reviewer and approval gates documented |
| MHD-008 | Dev update channel: signed dev APK on GitHub prereleases + Obtainium (`P00-11`) | Coding agent (Claude Code) | REVIEW | Workflow after green CI on main; fixed dev key via secrets; `.dev` app id; docs/DEV_UPDATES.md — branch `phase-00/p00-11-dev-updates`, [PR #6](https://github.com/abdulrahmanal-saeed/madar-al-huda/pull/6), stacked on PR #5 |
| MHD-007 | QA rules, Definition of Done, PR template (`P00-09`) | Coding agent (Claude Code) | REVIEW | DoD per task type, manual QA checklist, PR template; no duplicate CI — branch `phase-00/p00-09-qa-dod`, [PR #5](https://github.com/abdulrahmanal-saeed/madar-al-huda/pull/5), stacked on PR #4 |

## Execution rules
- Explicit owner, branch, tests and reviewer comments for each task.
- Never infer content reuse rights from public web availability.
- Keep unfinished or blocked tasks clearly labeled.
