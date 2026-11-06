# 0002 · Run Phase 0 on a local Supabase stack

Date: 2026-11-06 · Status: accepted

## Decision

Phase 0 uses the Supabase CLI local stack. Create a hosted project only before the pilot (Phase 2).

## Reasons

- Both free Supabase slots are in use: `ahfh-training` (AHFH platform) and `blake-spend-tracker` (personal; daily bank sync, cannot pause).
- Supabase counts free projects across all orgs where Travis is Owner or Admin. A second personal org does not add slots.
- Phase 0 work (MCR parsing, labeling, scoring) needs no public endpoint.
- The same migrations apply to a hosted project with `supabase db push`.

## Result

- Back up local data with `supabase db dump --local --data-only` before each `db reset`.
- Hosted slot plan: move `ahfh-training` to an AHFH-owned org on Pro (also gives AHFH daily backups). Fallback: Neon free plan for Postgres + Vercel Blob for files.
