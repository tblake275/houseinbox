# Status

Last updated: 2026-11-06

## Phase

Phase 0 · Data and setup (week 1)

## Done

- Strategy doc written: https://claude.ai/artifact/LVCSVLcdMcvTT15qUbPoTk
- MCR ground-truth research done: `docs/research/mcr-ground-truth.md`
- Repo scaffold, schema v1, grading taxonomy v1, MCR parser stub
- Local Supabase setup: `supabase/config.toml`, 3 private buckets, `docs/local-dev.md`. Migration 0001 tested on Postgres 16: 14 tables, RLS on all, 4 jurisdictions seeded.

## Source data found (AHFH Supabase `seyglttfkzntsnwuymzy`, read-only)

- Bill of Origins = schema `carbon`: 33 manufacturers, 36 plants, 16 supply chains, 35 EPDs, 68 materials, cost-code map.
- `estimator`: 10 plans with geometry + `takeoff` JSON, 275 materials, 525 prices.
- `takeoffs`: 24 vendors, 16 templates, 104 template line items.
- `drawings_selections`: 20 drawing sets, 397 pages. Only 6 distinct plans (1285B, 1408A, 1408B, 1498A, 1498B, 1498BR), all Whisper Valley. Several are construction sets, not permit sets. 19 of 20 link to an estimator plan.
- Conclusion: the drawing sets are a good **takeoff** answer key (plan PDF ↔ estimator takeoff). They are too few distinct designs for **MCR** calibration. MCR calibration needs the MCR + permit-set archive.

## Next tasks

1. On Travis's machine: install Docker + Supabase CLI, run `supabase start` and `supabase db reset` (see `docs/local-dev.md`).
2. Get written AHFH terms on IP, data use, and outside work.
3. Connect the folder of MCRs and permit sets. Fill `data/manifest_template.csv` for the first 20 projects.
4. Run `scripts/parse_mcr.py` on the first 20 MCRs. Fix the parser until 95%+ of comments parse.
5. Hand-label the first 20 MCRs with the taxonomy. Freeze a 20% test split.
6. Build the takeoff benchmark: 6 plans × (permit/construction PDF, estimator takeoff).

## Blockers

- AHFH data agreement not signed.
- No hosted Supabase slot. Both free slots are used (`ahfh-training`, `blake-spend-tracker`). Phase 0 runs locally. Hosted slot frees up if `ahfh-training` moves to an AHFH org on Pro.

## Hosting decision

- Phase 0: local Supabase only. Decision: `docs/decisions/0002-local-first.md`.
- `blake-spend-tracker` stays on Supabase (daily SimpleFIN sync + 3 cron jobs; cannot pause).

## Open questions

- Which 2 surrounding jurisdictions first? Research suggests Round Rock, Georgetown, or Kyle.
- Are MCRs stored as the emailed PDFs or as text (Procore, spreadsheet)?
