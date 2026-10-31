# Deviations from the pre-registration

Every change or disclosure after the pre-registration merge (a743f88, 2026-10-31T01:34:00Z) is logged here, with its
date, its reason and whether any outcome data had been seen. Results under the original plan are still reported.

---
## D1. Pre-commit exposure of whole-window export totals (disclosed)

- Entry written: 2026-10-31. Event: before the pre-registration merge (a743f88, 2026-10-31T01:34:00Z).
- What was exposed: while building the one-off export, the M1 posted three whole-window totals, on bizmap #205 and in the export tarball's MANIFEST:
  1. 1,732,175 sales in prices.csv;
  2. 680,654 registrations, 2011Q1–2026Q3;
  3. the number of cells marked <3 in each file.
- Not exposed: no figure by 村里, quarter, station, line, district or distance ring.
- Who saw it: the cloud manager. The research manager, its subagents and the referee did not see these totals before the merge. The research manager learned of them on 2026-10-31 from this disclosure, after the merge.
- Effect on the registered plan: none. The totals are sums over all places and all quarters, so they carry no information about the difference between treated and comparison 村里 or about timing around any opening. No choice in v2.1 was made or changed after they existed. The share of <3 cells bears only on the small-cell rule, and that rule (§4: 1.5 or 1, with both ends in R16) was fixed in v2.1 before any count was known.
- Action: none to the plan. The disclosure is recorded here and will be stated in the working paper's data section.

---
## D2. §6 inference rebuilt on placebo residuals; K2b, r and two implementation choices (referee ruling)

- Entry written: 2026-10-31. No outcome file had been opened. The issue was found by running analysis code v1 (code/analysis.R, f56e15b) on synthetic data.
- **Finding (authors), confirmed by the referee: the plan was at fault, not the code.**
  - v2.1 §6 step 1 averages a comparison district over every post cell it enters, so up to 6 cohorts and 6 base quarters.
  - A treated line reuses one base quarter (k = −13) in all 12 cells.
  - So base-quarter noise averages down in the comparison residuals but not in the treated statistic.
  - Over 5 synthetic seeds, the estimates had an SD of about 0.11, against an implied SE of about 0.036. True coverage was near 50%, not 95%, and the kill rules fired falsely in 4 of 5 seeds.
- **Change 1, replacing v2.1 §6 steps 1–4.** For each treated cluster j and each comparison district c, c's placebo contribution is computed exactly as j's:
  - same cohorts, with j's k = 0 dates assigned to c;
  - same single base k = −13;
  - same (g, e) cells and C&S weights;
  - comparison pool = the primary pool minus c.

  Residuals are these placebo contributions minus their mean across c. The draws for cluster j come only from j's placebo residuals, rescaled by the variance model. K2a, K3a and K3b use the same construction on their own cells.
- **Change 2, K2b.** It fires when the extrapolated value at k = +5.5 has the same sign as the primary, is at least 50% of the primary's absolute value, and lies beyond the 80th percentile of the placebo distribution of that same extrapolation in the primary's direction (one-sided p < 0.20). This partly reverses the referee's own N2 change in v2.1.
- **Change 3, new robustness test R28.** Base = the mean of k = −16 to −13. It is reported, not gating. A multi-quarter base was rejected as the primary, because it changes the estimand and shortens the pre-test window.
- **Rejected: calibrating kill-rule thresholds by simulation.** Simulation is used only to validate the rules.
- **Change 4, the variance floor.** Fit a + b/n with a, b ≥ 0 (NNLS), then apply the floor 0.25 × mean r². Report the number of clusters floored.
- **Change 5, R11.** Cohort sizes are passed as weights to twowayfeweights. The Goodman-Bacon share is labelled "unweighted cohort-mean diagnostic". It is a benchmark only.
- **Change 6, the breakdown ratio r, which replaces §8's.** T registrations in post cells (k ≥ 0) are divided by r; base quarters are unchanged. r* = Σ w_T y_T,t / (Σ w_T y_T,b + Σ w_C δ_C). For a positive primary, the effect is not called real if r* < 1.25. This replaces "outside 0.8–1.25".
- **Simulation gate, before any outcome file is opened.** The results are committed with the code hash. Every seed redraws the layout, with B = 999 per seed.

  | Scenario | Seeds | Must show |
  | --- | --- | --- |
  | Null (τ = 0, no pre-trend) | 500 | Rejection at 5% within 3.0–7.5%; 95% CI coverage ≥ 92.5%; false-fire rate ≤ 12.5% for each of K2a, K2b, K3a and K3b; the any-kill rate reported |
  | Effect (τ = 0.5) | 200 | Coverage ≥ 92.5%; the same per-rule false-fire limits; power reported |
  | Pre-trend (slope 0.04) | 200 | How often any kill rule fires; target ≥ 80% |
  | Stress (null, plus district × quarter and line × quarter shocks, each SD 10% of the rate) | 200 | The same limits as the null |

  If any limit fails, nothing is opened, and the result goes back to the referee.
- **Also logged before the real run:**
  - R ≥ 4.4 for HonestDiD, with a new snapshot pin;
  - the mapping for the 112 stations with no opening date;
  - the projection to TWD97 TM2.
- **Results under v2.1's original §6** are still reported, labelled as such.
