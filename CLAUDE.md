# Rules for agents in this repo

## Start and end of each session

1. Read `STATUS.md` first.
2. At the end of the session, update `STATUS.md`: what changed, next tasks, blockers.
3. Record each new decision as a file in `docs/decisions/` (`NNNN-short-name.md`).

## Writing

- Write prose in ASD-STE100 Simplified Technical English: active voice, short sentences (20 words max for procedures, 25 for descriptions), one term per concept.
- State confidence as a percentage with the reason. Do not hedge.

## Data rules

- Never commit plan sets, MCRs, response letters, addresses, or owner names. They stay in `data/raw/` (git-ignored) or in Supabase Storage.
- Plan sets can be copyrighted by the designer. Use them only for calibration under a written data agreement.
- Data from Austin Habitat for Humanity (AHFH) is used only under a written data-license agreement. House In Box is a separate venture.

## Grading rules

- Grade predictions only against the first-cycle MCR (U0) for that plan set version.
- A discipline that is absent from an early MCR is not a pass. That review may not have run.
- Match rule: see `eval/taxonomy.md`.
- A change to a prompt, rule, or model ships only if recall and precision on the frozen test split do not drop.

## Stack

- Supabase: local stack for Phase 0 (`docs/local-dev.md`). No hosted project yet. Never put House In Box tables in an AHFH project or in `blake-spend-tracker`.
- AHFH Construction Platform Supabase (`seyglttfkzntsnwuymzy`): read-only source. Bill of Origins is its `carbon` schema; also `estimator`, `takeoffs`, `drawings_selections`. Never write to it from House In Box work. AHFH schema changes follow the AHFH migration process in repo `tblake275/ahfh-construction-platform`.
- Do not apply migrations to a remote project without a matching file in `supabase/migrations/`.
