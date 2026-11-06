# House In Box

House In Box sells house plans, permitting, and material packages, as a set or one at a time, on the model of the Sears catalog houses (1908–1940).

The first product is a **permit pre-review tool**. A builder uploads a residential plan set (PDF) and an address. The tool predicts the comments in the city's Master Comment Report (MCR). The tool is graded against real MCRs.

## Repo layout

| Path | Contents |
| --- | --- |
| `STATUS.md` | Current phase, next tasks, blockers. Update at the end of each work session. |
| `CLAUDE.md` | Rules for any agent that works in this repo. |
| `docs/strategy.md` | Strategy summary and link to the full strategy doc. |
| `docs/research/` | Research reports, one file per topic. |
| `docs/decisions/` | Decision records, one file per decision. |
| `docs/glossary.md` | Terms and abbreviations. |
| `eval/` | Grading taxonomy, match rules, takeoff tolerances. |
| `data/` | Data rules and manifest template. Raw plan sets and MCRs are **not** committed. |
| `supabase/` | Local Supabase config, buckets, migrations, seed. Setup: `docs/local-dev.md`. |
| `scripts/` | Ingest and parse scripts. |
| `app/` | Web app (Next.js on Vercel). Not started. |

## Stack

- Web: Next.js on Vercel
- Database, storage, functions: Supabase (Postgres, Storage, Edge Functions, pgvector)
- Models: Claude API for sheet reading and tier 3 review
- Cost data: 1build API; supplier quotes for binding prices

## Phases

| Phase | Weeks | Gate |
| --- | --- | --- |
| 0 · Data and setup | 1–2 | 50 labeled plan set + MCR pairs; rubric written |
| 1 · Pre-review MVP | 3–8 | Recall 40%+, precision 70%+ on the frozen eval set |
| 2 · Pilot | 9–14 | Grader agrees with human labels 90%+ |
| 3 · Paid + first plans | Months 4–6 | 10 paying users |
| 4 · Packages + trades | Months 7–12 | Go / no-go on the 10-plan catalog |

Gate numbers are proposed targets. Set final values after phase 0 measures the baseline.
