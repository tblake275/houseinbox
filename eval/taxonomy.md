# Grading taxonomy v1

Each city comment and each tool finding gets three labels.

## L1 · Discipline

| Code | Discipline |
| --- | --- |
| ZON | Zoning |
| BLD | Building Technical (structural, egress, energy, visitability) |
| TRE | Tree |
| FIR | Fire |
| FLD | Floodplain |
| DRN | Grading / Drainage |
| EHZ | Erosion Hazard Zone |
| HIS | Historic |
| AWU | Austin Water (taps, plot plan stamp, OSSF) |
| TRN | Transportation (driveway, sidewalk) |
| AEN | Austin Energy |
| AVN | Aviation |
| ADM | Intake / Administrative |

Map MCR comment prefixes to L1 in `eval/prefix_map.csv` as you find them (for example `RZ` → ZON).

## L2 · Issue type

| Code | Issue type |
| --- | --- |
| a | Missing or incomplete information (dimensions, labels, sheets) |
| b | Dimensional or code noncompliance (setback, coverage, impervious cover, height, FAR, IRC item) |
| c | Cross-sheet or calculation inconsistency |
| d | Missing documentation or certification (seal, survey, stamp, report) |
| e | Administrative (fees, forms, old approval stamps) |

## L3 · Topic

Open list. Start with: setback, impervious_cover, building_coverage, far_subchapter_f, height, unit_count_use, visitability, foundation, bracing, egress, energy, tree_crz, driveway, sidewalk, plot_plan, survey, seal.

Add a topic only when 3 or more comments need it.

## Match rule

A finding is a true positive when all three are true:

1. L1 matches.
2. L3 matches.
3. The sheet or plan area matches (same sheet ID, or same area named in the comment).

Code citation is optional and does not affect the match.

## Scores

- Report precision and recall at L1 and at L1+L3.
- Grade against the U0 MCR only.
- Exclude a discipline from recall if its review did not run in that cycle.
