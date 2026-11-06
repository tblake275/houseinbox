# Local development

Phase 0 runs on a local Supabase stack. No hosted project is needed until the pilot.

## One-time setup

1. Install Docker Desktop. Start it. The stack needs about 2 GB of disk.
2. Install the Supabase CLI:
   - Mac: `brew install supabase/tap/supabase`
   - Windows: `scoop bucket add supabase https://github.com/supabase/scoop-bucket.git` then `scoop install supabase`
   - Any OS with Node: use `npx supabase <command>`
3. Clone the repo: `git clone https://github.com/tblake275/houseinbox.git` then `cd houseinbox`.
4. Start the stack: `supabase start`. The first start downloads images and takes 5–10 minutes.
5. Apply the schema: `supabase db reset`. This runs every file in `supabase/migrations/`, then `supabase/seed.sql`.
6. Copy the printed `API URL`, `anon key`, and `service_role key` into `.env.local`. Do not commit `.env.local`.

## Local URLs

| Service | URL |
| --- | --- |
| Studio (table editor) | http://127.0.0.1:54323 |
| API | http://127.0.0.1:54321 |
| Postgres | `postgresql://postgres:postgres@127.0.0.1:54322/postgres` |

## Daily use

1. `supabase start` to start the stack. `supabase stop` to stop it. Data stays between restarts.
2. Add each schema change as a new file: `supabase migration new <name>`. Write the SQL in the new file.
3. Run `supabase db reset` to rebuild from all migrations. **This deletes local data.** Back up first (next section).

## Back up local data

Labeled MCR data is the most valuable asset. Back it up before each `db reset` and at the end of each work session:

```
supabase db dump --local --data-only -f backups/data-$(date +%Y%m%d).sql
```

`backups/` is git-ignored. Copy dumps to a private drive.

## Storage buckets

`config.toml` creates 3 private buckets: `plan-sets` (200 MiB per file), `mcrs` (25 MiB), `responses` (50 MiB). Path convention: `<project_id>/U<cycle>.pdf`, for example `AUS-0001/U0.pdf`.

## Move to a hosted project later

1. `supabase link --project-ref <project-id>`
2. `supabase db push` applies all migrations.
3. Load data: `psql "<hosted connection string>" -f backups/data-<date>.sql`
4. Copy Storage files with `scripts/` (to be written). `db push` does not copy files.
5. Check limits before the move: the free plan allows 500 MB database and 1 GB file storage. Plan PDFs can go to Cloudflare R2 or Vercel Blob if they pass 1 GB.
