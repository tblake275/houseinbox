# Data

## Rules

- `data/raw/` and `data/processed/` are git-ignored. Do not commit plan sets, MCRs, response letters, addresses, or owner names.
- Long-term storage is Supabase Storage in the House In Box project, private buckets only.
- AHFH data is used only under a written data-license agreement.

## Layout for each project

```
data/raw/<project_id>/
  plans/U0.pdf          first submittal plan set
  plans/U1.pdf          revised set for update 1
  mcr/U0.pdf            MCR for the first submittal
  mcr/U1.pdf            MCR for update 1
  response/U1.pdf       response narrative sent with update 1
  takeoff.csv           estimator takeoff for the final set
```

`project_id` is a short internal code (for example `AUS-0001`). Map it to the address only in `manifest.csv`, which is also git-ignored.

## Manifest

Copy `manifest_template.csv` to `data/raw/manifest.csv` and fill one row per project.

## Splits

- 80% calibration, 20% frozen test.
- Assign the split once, by `project_id`, and never move a project between splits.
