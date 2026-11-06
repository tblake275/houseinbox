# MCR ground truth: findings

Research date: 2026-11-06. Source: Claude research report (full text in the claude.ai conversation).

## What an Austin residential MCR is

- DSD (Development Services Department) emails an MCR when any reviewer rejects a residential application. Approval needs all rejection comments resolved.
- Structure: one section per review discipline, each with the reviewer's name and contact.
- Comment ID format: discipline prefix + 2-digit number, for example `RZ03. Outdoor kitchen cannot be in setback.`
- Code citations appear in some comments, not all. The schema must treat the citation as optional.
- Each review cycle gives a new MCR. Site-plan MCRs mark cycles as `UPDATE: U0`, `U1: Comment cleared.`, `Comment remains`. Residential use of this notation is not confirmed (70% confident it is the same).
- A discipline can be absent from an early MCR because its review did not run (for example, Technical skipped after a Zoning rejection).
- A resubmittal includes a response narrative, clouded changes, and the full plan set as one PDF. Each cycle gives a (comment, response, revised sheet) triple.

## Bulk data

| Dataset | ID | Use |
| --- | --- | --- |
| Issued Construction Permits | `3syk-w9eu` | Population of permits: class, work class, units, dates, valuation |
| Plan Review Cases | `n8ck-xkda` | PR case number, applicant organization (find volume builders), dates |
| Residential Plan Review Cases Status | `7aas-g4y3` | Review status and on-time flag. Check columns for cycle counts. |

- No dataset or API holds MCR text.
- Public Information Act requests can get MCRs by permit number. Plan sheets may be refused or offered for inspection only (copyright).

## Austin numbers

- Review targets from 2026-07-01: 10 business days for new construction, 7 for updates, 5 for Volume Builder and S.M.A.R.T. Housing.
- HOME Phase 1 (cumulative): 931 applications reviewed, 742 approved, 1,482 units approved.
- Third-party estimate: median about 108 calendar days from application to issue for new single-family permits issued 2025–26.
- No official first-pass approval rate was found. Compute it from `n8ck-xkda` joined to `7aas-g4y3`.
- Outside benchmark: Honolulu had 3.4 review cycles and 23.5 corrections per one- and two-family application before AI pre-screening.

## Review triggers (extra disciplines)

- Tree: trees 19 in. or larger on or next to the lot
- Fire: over 3,600 sf under roof, WUI, within 200 ft of a hazardous pipeline, NFPA 13D
- Floodplain: within 100 ft of the 100-year floodplain
- Grading/drainage: storm inlet within 10 ft of a driveway curb cut
- Historic: structures 45 years or older
- Erosion Hazard Zone: within 100 ft of a creek centerline
- OSSF: septic lots
- Transportation: driveway or sidewalk work
- Visitability: new homes with first-floor habitable space
- Austin Energy: BSPA no longer required from October 2026. Older Austin Energy comments may not predict current ones.

## Surrounding jurisdictions

| Jurisdiction | Portal | IRC | AI pre-check |
| --- | --- | --- | --- |
| Round Rock | Trimble Cityworks | not confirmed | none found |
| Georgetown | MGO Connect | not confirmed | none found |
| Kyle | Tyler EnerGov CSS | not confirmed | none found |
| Leander | Development Hub | 2021 | none found |
| Cedar Park | MGO Connect (conflicting reports) | 2021 | none found |
| Pflugerville | not confirmed | 2021 + amendments | none found |
| San Marcos | MGO Connect | 2021 | none found |
| Austin | AB+C (AMANDA) | 2024 | Archistar (zoning) |

Recommended order: Round Rock, Georgetown, Kyle. Verify permit volume first.
