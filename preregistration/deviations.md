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

---
## D3. 機捷 opening-date source (v2.1 §2, sign-off item 5)

- Entry written: 2026-10-31. No outcome file had been opened.
- Fare-start / formal opening, 2017-03-02: confirmed by the official open-data row of 交通部鐵道局,
  data.gov.tw dataset 96918 (鐵道局轄管計畫已完成通車啟用時間, 政府資料開放授權條款 v1):
  "機場捷運計畫, 106.3.2, 本計畫全線, A1-台北車站 … A21-環北站" (ROC 106.3.2 = 2017-03-02).
  CSV: https://www.rb.gov.tw/api/proxy/v4/file-service/Opendata%2F%E9%90%B5%E9%81%93%E5%B1%80%E8%BD%84%E7%AE%A1%E8%A8%88%E7%95%AB%E5%B7%B2%E5%AE%8C%E6%88%90%E9%80%9A%E8%BB%8A%E5%95%9F%E7%94%A8%E6%99%82%E9%96%93.csv (file undated).
- Public free rides from 2017-02-16: still supported only by pages published before that day
  (Newtalk 2017-01-25; 風傳媒 2017-02-15, https://www.storm.mg/article/223925). No page dated on or after
  2017-02-16 could be opened.
- Consequence: none. Under the 45-day rule (§2), 2017-02-16 leaves 44 days in 2017Q1 and 2017-03-02 leaves 30,
  so both give k = 0 = 2017Q2. The primary and R19 are unchanged.
```

---
## D5. Ruling on the D2 gate failure: kill-rule thresholds, small cells, line shocks, and one fresh rerun (referee)

- Entry written: 2026-10-31. No outcome file had been opened. Code v2 and its gate results are code/analysis-code-v2.md (ba06c4e).
- **The gate failed** on the kill rules' false fires and on the stress case. The new placebo inference works: under the null it rejects 5.6% and covers 94.2%.
- **K2a:** p < 0.05. The small-sample widening factor calibrated by simulation is rejected, because it would tune a threshold by simulation, which D2 ruled out.
- **K2b:** the one-sided tail is now < 0.05. The referee's earlier 20% tail fired at least 20% of the time by construction. K2b now tests a trend-shaped pre-violation. The "large but not significant" role moves to R15 (HonestDiD): "If the 95% HonestDiD interval at M̄ = 1 includes 0, the abstract says so and the effect is described as not robust to pre-trends." That is a disclosure, not a kill.
- **Small cells:** the registered 1.5 imputation stays. Its bias is −0.019, about 4% of the effect, and it pushes against H1. The null run shows no bias. If the export provides coarser unsuppressed sums (cohort × ring × quarter), report the imputation bias against them, labelled as not gating. After opening, report the share of suppressed cells by group and by pre/post period.
- **Line × quarter variance:** σ²_j is estimated from line j's R2 ring (800–1,500 m), using only quarters k = −20 to −1. It is the variance of the ring's quarter-by-quarter mean deviation from F, minus its sampling variance, floored at 0. It is added to cluster j's placebo draws through the statistic's quarter weights. The stress simulation applies the line × quarter shock to every 村里 within 1,500 m of the line. If the stress case still fails after this, the abstract states: "Inference assumes no line-wide quarterly shocks beyond those estimated from each line's 800–1,500 m ring." That is disclosed, not a stop. Loosening the limits instead was rejected.
- **The restated gate. It runs on FRESH seeds, once. All rates are reported with Monte Carlo SEs, and every scenario is also run with the line variance on.**

  | Scenario | Seeds | Hard limits |
  | --- | --- | --- |
  | Null | 500 | Rejection within 3.0–7.5%; coverage ≥ 92.5%; each kill rule ≤ 12.5% |
  | Effect | 200 | Coverage ≥ 92.5% on the unsuppressed run; on the suppressed run, bias ≤ 0 and \|bias\| ≤ 10% of the truth; each kill rule ≤ 12.5%; any-kill ≤ 25%; power reported |
  | Pre-trend | 200 | Any kill ≥ 80% |
  | Stress | 200 | Rejection ≤ 7.5% and coverage ≥ 92.5% with the line variance on; otherwise the disclosure above |

- **If any hard limit fails on the fresh seeds:** the study is written up as a short note on design and power, and no outcome file is opened for H1.
- **R20 and R27** stay on v1's residuals, labelled "check, v1 residuals". Neither can gate.
- **HonestDiD:** R ≥ 4.4 is installed after the rerun passes, with a second lockfile. Before any outcome file opens, the authors confirm the primary is reproduced to 10 digits on the new R.

---
## D6. The D5 rerun fails one hard limit; D5 applies as written (referee ruling)

- Entry written: 2026-10-31. No outcome file had been opened. Rerun doc: https://claude.ai/artifact/5DDRhsDYctGGN6c4ij4hYn. The seeds were committed in the doc before any v3 run: null 50001–50500, effect 60001–60200, pre-trend 70001–70200, stress 80001–80200.
- **Result:** unsuppressed effect coverage was 91.5% with σ²_j on (90.5% off), against a limit of 92.5%, with a Monte Carlo SE of 2.0 points. Every other hard limit passed with σ²_j on.
- **Ruling:** the gate fails. No outcome file is opened for H1. A limit fixed in advance does not bend because the miss is small, and every proposed remedy would be a second rerun after seeing a failure.
- **The referee's own error, for the record:** a 92.5% limit tested on 200 seeds (SE about 2 points) made the result partly luck near the boundary. That is a flaw in the gate's design, not in the authors' work, and it does not change the ruling.
- **The short note must contain:**
  1. H1 and the signed v2.1 (a743f88), with D1–D6 and their commits.
  2. The statement: "No registration, closure, price or population-series file was opened."
  3. All four simulation rounds in one table: every limit, every rate and its Monte Carlo SE, with failures shown as failures.
  4. The two mechanisms found, stated as findings:
     - comparison residuals built on one shared base quarter understate the treated noise (fixed by D2's placebo construction);
     - treatment raises Poisson noise on the treated side, which untreated placebos cannot see, so intervals come out about 10% narrow under a 40% effect.
  5. Design facts from pre-outcome files only: Appendix A, power and the minimum detectable effect.
  6. The note's limits: the synthetic DGP is assumed, and the gate has its own Monte Carlo imprecision.
  7. The referee reports, with the referee's errors stated as errors.
- **Stage 3:** only work that touches no outcome file. That means the data/pre bundle, Appendix A with hashes, and the note. No primary, secondary or robustness test is run, and no outcome file is opened even descriptively. HonestDiD and R 4.5 are not needed.
- **A successor study** is legitimate as new work only if all of these hold:
  - (a) the note is public first, and the new pre-registration cites it as the second design on this question;
  - (b) the treated-side variance fix is specified in full;
  - (c) the gate limits are no looser than D5's, with a Monte Carlo SE ≤ 0.75 points (about 1,000 seeds per scenario), and every seed committed in advance;
  - (d) there is one gate run, with a fixed failure rule; a second failure ends the question on this data;
  - (e) the reviewing referee is new to this design;
  - (f) everything that passed is carried over unchanged, or each change is justified in writing.
