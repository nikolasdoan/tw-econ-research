# MRT pilot: pre-registration v2

Oct 30, 2026 · @Niko

## Change log from v1

v2 answers every item of the referee's report on v1 (verdict: fix then sign). No outcome data has been opened.

| Item | Referee's point | What v2 does | Section |
| --- | --- | --- | --- |
| M1 | Opening-date rule inconsistent; 綠山 source predates opening; R19 uses a group-only date | One rule (first day the general public rode without invitation); both public-opening and fare-start dates listed with sources dated on or after the event; 綠山 source replaced; operator release added for 環狀; R19 redefined as fare-start k = 0 | 2, 9 |
| M2 | 綠線 is not never-treated; cutoff undated; identified cells unlisted | G leaves the pool from 2023Q3 (13 quarters before the north section's end-2026 target); identified cells listed per cohort; `aggte(dynamic, min_e = 0, max_e = 11)` over identified cells; minimum 30 comparison 村里 per cell | 3, 5 |
| M3 | Ferman–Pinto with 3–5 control groups cannot reach p < 0.05; fallback broke estimator–inference link; FP for staggered C&S unspecified | Primary pool fixed now as G + not-yet-treated T + F, in both estimate and test; 5 line-level treated clusters and district comparison clusters (v2.1); FP procedure written step by step; smallest attainable p reported; N₀ ≥ 19 required; K2a uses one statistic | 3, 6, 7 |
| M4 | Denominator fails if 村里 population starts in 2015 | End-2012 村里 population from 內政部戶政司 requested; fallback is district end-2012 × earliest 村里 share; R22 drops 機捷 and 綠山 | 4, 9 |
| M5 | Branches, boundary vintage, centroid type, address timing left to the data | Branches excluded (re-request if not separable); vintage named; geometric centroid (R23 population-weighted); current-address bias stated, bounded and tested (R26) | 4, 8 |
| S1 | Line heterogeneity; development zones | Line-level ATTs for every result; R24 excludes four named zones; ≥ 5 T 村里 per line | 3, 9 |
| S2 | 12-quarter anticipation rests on one price thesis | R4 shown beside the primary; sign difference goes in the abstract | 5 |
| S3 | K2b fires on noise | Needs same sign, ≥ 50% of the primary and a significant slope; HonestDiD reported | 7 |
| S4 | K3a lenient, K3b unspecified | Both stated in full; threshold 33%; K3b compared with k = 0–3 | 7 |
| S5 | R1 base undefined for A22 | Latest earlier quarter as base (A22: 2019Q4); per-cohort contributions listed | 8 |
| S6 | Survivorship formula under-corrects | Formula fixed when closure founding dates exist; direction stated otherwise; r enters "effect is real" | 1, 8 |
| S7 | Population series opened before commit | Only the base-year cross-section is opened before commit | 10 |
| S8 | Stale repo name | One repo, branch and path, in sections 1 and 10 | 1, 10 |
| m1 | 21 tests could be cherry-picked; R3 p-values meaningless | One forest plot of all tests; R3 point estimates only | 6, 9 |
| m2 | Line selection looks discretionary | Reason given: earlier lines lack 20 pre-quarters | 3 |
| m3 | A22 is an infill | Stated; reported separately | 3 |
| m4 | K2a window vs base | Clarified | 5 |
| m5 | `did` version | Named with pin date | 6 |

**v2.1** (referee's second read, fix then sign; R1/綠山 k = 0–3 agreed):

- N1 (§6): treated contributions aggregated to 5 line clusters (A22 separate); comparison clusters are districts; the false claim about 4 lines is removed; minimum p ≈ 1 / (N₀ + 1) with 9,999 draws; district-level treated clustering added as R27; K3a's G is one treated cluster.
- N2 (§7): K2b's slope-significance condition removed.
- Sign-off (§10): signatures first; Appendix A (with SHA-256 input hashes) and the 機捷 post-event source are committed as dated deviations.md entries before any outcome file is opened; no redesign if N₀ < 19 or a line drops.
- m5 (§6): did 2.5.1 confirmed on [CRAN](https://cran.r-project.org/package=did), published 2026-07-08 (2.5.0 archived 2026-06-13).

## 1. Status and hypotheses

Draft v2, written before any outcome data has been seen or received. It replaces v1 (commit 18c8e44, branch `prereg-v1`). It is committed as `preregistration/mrt-pilot-v2.md` on branch `prereg-v1` of `nikolasdoan/tw-econ-research`. It becomes binding when Niko and one reviewer sign and it is merged to `main`. The merge commit's date is the proof of timing.

**Question.** Did new MRT and light-rail stations change how many businesses open nearby, compared with similar 村里 that got no station?

- **H1.** In the 12 quarters after opening (k = 0 to 11), new business registrations per 1,000 residents in 村里 within 500 m of a new station rise relative to the comparison 村里.
- **H0.** No difference. H0 is a valid result. It is written up with its confidence interval, the smallest attainable p-value and the minimum detectable effect.

**The one primary estimate.** The overall dynamic ATT, `did::aggte(type = "dynamic", min_e = 0, max_e = 11)`, averaged over identified cells only (section 5), for 村里 within 500 m, against the primary comparison group (section 3), in registrations per 1,000 residents per quarter.

**The effect is real if** all of these hold:

1. The primary estimate is positive with a two-sided p < 0.05 under the primary inference (section 6).
2. No kill rule fires (section 7).
3. It stays positive without 2020Q1–2022Q4 (R1).
4. It stays positive with the survivorship-corrected outcome (R17).
5. The survivorship breakdown ratio r lies outside 0.8–1.25, so a survival gap of more than 20% between treated and comparison firms would be needed to explain it away (section 8).

Anything not listed in this document is exploratory and is labelled so.

## 2. Opening dates

Six opening events on four lines (機捷 with A22; 淡海 with 綠山 and 藍海; 環狀; 安坑).

**One rule for every line.**

- **Public-opening date (primary):** the first day the line carried the general public without invitation or booking, free or paid.
- **Fare-start date (R19):** the first day regular fares were charged.
- **k = 0:** the first calendar quarter with at least 45 days of service from the date used. If fewer than 45 days remain in that quarter, k = 0 is the next quarter.
- Every date has an opened source published on or after the event, except where marked.

| Event | Public opening | k = 0 | Fare start | k = 0 under R19 | Sources (opened) |
| --- | --- | --- | --- | --- | --- |
| 機場捷運 A1–A21 | 2017-02-16 (group-only rides from 02-02 do not count) | 2017Q2 (44 days in Q1, one under the cut) | 2017-03-02 | 2017Q2 | [Newtalk, 2017-01-25](https://newtalk.tw/news/view/2017-01-25/81370) (announces the schedule before the event; no post-event page yet, see note) |
| 淡海 綠山線 | 2018-12-24 (ceremony 12-23) | 2019Q1 | 2019-02-01 | 2019Q1 | [CNA, 2018-12-23](https://www.cna.com.tw/news/firstnews/201812230188.aspx); fare: [TVBS/CNA, 2019-01-22](https://news.tvbs.com.tw/life/1070300) |
| 環狀線 phase 1 | 2020-01-31 | 2020Q1 | 2020-03-01 | 2020Q2 | [臺北捷運 timeline](https://www.metro.taipei/cp.aspx?n=B27E7BC8CBBCDA61) (operator); [新北市捷運局](https://www.dorts.ntpc.gov.tw/about/route/zj6Dd5ajdA1o); [PTS, 2020-01-31](https://news.pts.org.tw/article/464655); fare: [Newtalk, 2020-02-29](https://newtalk.tw/news/view/2020-02-29/373449) |
| 淡海 藍海線 phase 1 | 2020-11-15 | 2020Q4 | 2020-12-15 | 2021Q1 | [Taiwan News, 2020-11-15](https://www.taiwannews.com.tw/ch/news/4054224); fare: [新北捷運公司](https://www.ntmetro.com.tw/basic/?mode=detail&node=286) (operator, undated) |
| 安坑輕軌 | 2023-02-10 | 2023Q1 | 2023-03-13 | 2023Q2 | [自由時報, 2023-02-10](https://news.ltn.com.tw/amp/news/life/breakingnews/4207247); fare: [CNA, 2023-03-12](https://www.cna.com.tw/news/ahel/202303120213.aspx); [新北市交通局, 2023-03-03](https://www.ntpc.gov.tw/ch/home.jsp?id=28&dataserno=202303030030) |
| 機捷 A22 老街溪 | 2023-07-31 | 2023Q3 | 2023-07-31 (only the A21–A22 segment was free to 08-31) | 2023Q3 | [行政院, 2023-07-31](https://www.ey.gov.tw/Page/9277F759E41CCD91/a1f8914c-3eae-4b6d-8c48-6f2ab0404e7c); fare: [桃園捷運公司, 2023-07-27](https://www.tymetro.com.tw/tymetro-new/tw/_pages/news/show-1822-1.html) (operator) |

Under R19, k = 0 moves one quarter later for 環狀, 藍海 and 安坑, and stays the same for the other three.

Notes:

- **綠山.** The v1 source (TVBS, 2018-12-19) gave only a target date; it is replaced by CNA of 2018-12-23. No 新北捷運 or 捷運局 release could be opened; the export's station file should add one.
- **環狀.** Operator pages confirm the opening date. The fare start rests on Newtalk; no operator page stating it could be opened.
- **機捷.** The 02-16 public start is from a page published before the event. A page dated on or after 2017-02-16 (or the 96918 dataset row) is committed as a dated deviations.md entry before any outcome file is opened. Either 02-16 or 03-02 gives 2017Q2, so k = 0 does not depend on it.
- News pages are cited for dates only, as facts.

**Planned control line: 桃園捷運綠線.** The official target for the north section (坑口 to 藝文中心) is end-2026, per [桃園市政府新聞處, 2025-06-05](https://news.tycg.gov.tw/News_Content.aspx?n=5016&sms=7885&s=1536688), restated in [CNA via udn, 2026-01-28](https://udn.com/news/story/7324/9294959). The same release gives G08 in 2028 and the full main line in 2030. The earliest target, 2026Q4, sets G's cutoff at 2023Q3 for all G stations (section 3).

## 3. Units, groups and comparison pool

The unit is the 村里, on the boundary vintage named in section 4. Distance d is the straight-line distance from the 村里's geometric centroid to the nearest station. All groups are fixed from the station and boundary files alone, before any outcome file is opened.

| Group | Definition | Role |
| --- | --- | --- |
| **T** (treated) | d ≤ 500 m to a study-line station | Treated in its cohort; not-yet-treated comparison before its anticipation window |
| **R1** | 500 < d ≤ 800 m | Ring estimate only (R7) |
| **R2** | 800 < d ≤ 1,500 m | Ring estimate (R7); secondary comparison (R5) |
| Buffer | 1,500 < d < 2,000 m | Excluded |
| **F** (far control) | 2,000 ≤ d ≤ 5,000 m from every study-line and 綠線 station, in Taipei, New Taipei or Taoyuan | Primary comparison (never treated) |
| **G** (planned) | d ≤ 500 m to a 桃園綠線 planned station | Primary comparison until its cutoff |

**Primary comparison pool: G + not-yet-treated T + F. This is decided now, not left to a count.**

- Why: the referee's rule needs at least 19 comparison clusters for the primary test to be able to reach p < 0.05. Without F, the pool's clusters (鄉鎮市區) are at most about 13: 綠線 crosses at most 5 districts, and later cohorts' T 村里 sit in about 8 (新店, 中和, 板橋, 新莊, 淡水, 中壢 and neighbours). F spans dozens of districts.
- F is in **both** the estimator and the inference. Nothing is added to one and not the other.
- Cost: F is less like the treated places than G. Two listed tests answer that: R25 (pool G + T only, identified cells only, point estimates and wild bootstrap) and R14 (doubly robust with baseline covariates).
- The exact cluster count goes in Appendix A, committed before any outcome file is opened. If it is below 19 even with F, H1 cannot be confirmed and the write-up says so.

**綠線 cutoff, fixed now.** The north section targets opening at end-2026 (2026Q4), per the dated source in section 2. G 村里 leave the comparison pool from **2023Q3** (13 quarters before 2026Q4), so they serve up to 2023Q2. This holds for the south section too unless its official target, dated in section 2, is earlier, in which case its own cutoff applies. Later changes to the official target do not move this cutoff. G is not "never treated in window".

**Assignment rules**

1. A 村里 near stations of several cohorts belongs to the earliest cohort.
2. A 村里 is assigned by its nearest station; rings use the same distance.
3. Distances are computed once and frozen in a committed file before any outcome file is opened.

**Exclusions (from every group)**

1. d ≤ 500 m to any rail station (MRT, light rail, TRA, HSR) open before 2011. A new station there is a different treatment. This drops most 環狀線 interchange areas.
2. d ≤ 800 m to a station on a non-study line that opened or closed between 2011Q1 and the end of the data.
3. Fewer than 500 household-registered residents in the base year (section 4). Kept in the Poisson check R12.
4. Not matchable to the named boundary vintage after the aggregation in section 4.

**Minimum sizes (part of K1).** At least 30 T 村里 in total and at least 5 per line after exclusions. A line below 5 is dropped from the primary, and the cluster count is restated, before outcome data is opened. Per-line counts go in Appendix A.

**Why these lines and not others.** 信義線 (2013), 松山線 (2014) and other openings before 2017 lack 20 pre-quarters from 2011Q1, so they cannot pass the pre-trend test window. They fall under exclusion 2.

**A22 is a second dose.** A22 村里 were already 0.8–1.5 km from 機捷 stations from 2017, with trains passing without stopping. Its estimate is reported separately and read as an infill effect.

**Development zones.** 機捷 and 淡海 stations sit in new-town zones, so treatment there bundles land development. R24 excludes 村里 intersecting 林口特定區 (林口新市鎮), 淡海新市鎮特定區, 高速鐵路桃園車站特定區 and 桃園航空城特定區, using the official 都市計畫 boundaries committed with the distance file. Line-level ATTs are reported for every result.

## 4. Outcome, denominator and data decisions

**Primary outcome**, in levels, never log(1+y) or arcsinh:

```latex
y_{it} = 1000 \times \frac{N^{\text{公司}}_{it} + N^{\text{商業}}_{it}}{P_i}
```

- N: registry records for 村里 i with an establishment (核准設立) date in quarter t. 公司 and 商業 are summed.
- Unit: registrations per 1,000 residents per quarter.

**Denominator \P_i, fixed now.**

1. **First choice:** household-registered population of 村里 i at end-2012, from 內政部戶政司. The export is asked to add 村里 year-end population for 2011–2013.
2. **Fallback**, if step 1 cannot be met before outcome data is opened: P\_i = the 鄉鎮市區's end-2012 population × the 村里's share of its 鄉鎮市區 at the earliest available year-end. Open data at 村里 level appear to start in 2014 or 2015 ([data.gov.tw 8411](https://data.gov.tw/dataset/8411), [32973](https://data.gov.tw/dataset/32973), 戶政司, 政府資料開放授權條款 v1), so the earliest share is Dec 2014 or Dec 2015.
3. That share year falls inside 機捷's anticipation window (from 2014Q2) and near 綠山's (from 2016Q1), and new towns there grew fast. R22 drops both cohorts.
4. Whichever P is used also drives exclusion 3 and K1. The choice and the file dates are logged in `deviations.md` before outcome data is opened.

**Branch offices.** 分公司 and 商業分支機構 are excluded. If the export cannot separate them, it is re-requested before outcome files are opened. If they still cannot be separated, they are included and that is logged.

**Boundary vintage.** 村里 boundaries are 內政部地政司 村里界歷史圖資, version 114年 ([data.gov.tw 130549](https://data.gov.tw/dataset/130549), 政府資料開放授權條款 v1). 村里 merged or split since 2011-01-01 are aggregated to the smallest common unit that is stable from 2011 to the present, using 戶政司 村里 change records. All files use that unit.

**Centroid.** Geometric centroid of the named vintage. Population-weighted centroid is R23.

**Address.** N uses the address at establishment if the export has it; otherwise the current address, with the bias handled in section 8.

**Cells below 3.** If the export suppresses counts of 1–2 and shows 0 as 0, a suppressed cell is set to 1.5. If it suppresses 0–2 together, it is set to 1. The primary is rerun at both ends (R16); if the sign flips, the abstract says so. Imputation is done for 公司 and 商業 separately, then summed.

## 5. Event window and identified cells

Event quarters run from k = −20 to +11. The base is k = −13 for every cohort.

- **Pre-trend test window: k = −20 to −14**, each measured against the base k = −13. (v1 wrote −20 to −13; it is the same window, since −13 is the base.)
- **Anticipation window: k = −12 to −1.** Allowed to move; reported as an anticipation estimate. It rests on one price thesis (林口, 機捷), so R4 (8 quarters) is shown beside the primary in the main table. If R4 and the primary differ in sign, the abstract says so.
- **Post window: k = 0 to 11.**

**Calendar quarters by cohort** (k = 0 from the public-opening rule, section 2):

| Cohort | k = −20 | Base k = −13 | k = 0 | k = 11 | Primary: post cells identified | R25 (no F): post cells identified |
| --- | --- | --- | --- | --- | --- | --- |
| 機捷 | 2012Q2 | 2014Q1 | 2017Q2 | 2020Q1 | k = 0–11 | k = 0–11 |
| 綠山 | 2014Q1 | 2015Q4 | 2019Q1 | 2021Q4 | k = 0–11 | k = 0–11 |
| 環狀 | 2015Q1 | 2016Q4 | 2020Q1 | 2022Q4 | k = 0–11 | k = 0–11 (G only after 2020Q2) |
| 藍海 | 2015Q4 | 2017Q3 | 2020Q4 | 2023Q3 | k = 0–11 | k = 0–10 |
| 安坑 | 2018Q1 | 2019Q4 | 2023Q1 | 2025Q4 | k = 0–11 | k = 0–1 |
| A22 | 2018Q3 | 2020Q2 | 2023Q3 | 2026Q2 | k = 0–11 if data reach 2026Q2 | none |

How the cells were worked out: with anticipation = 12, a comparison unit is valid at quarter t only if its own k = 0 is after t + 12. F is never treated, so it is always valid. G is valid up to 2023Q2. A later cohort's T is valid for an earlier cohort only up to 13 quarters before its own k = 0; the last such quarter is 2020Q2 (A22). So without F, cells after 2023Q2 have no valid comparison.

**Rules**

1. A cell is estimated only if it has at least 30 comparison 村里. Appendix A lists every post cell with its comparison count, from station, boundary and base-year population files only, before sign-off.
2. The primary averages over identified post cells only: `aggte(type = "dynamic", min_e = 0, max_e = 11)`. Each event time e gets equal weight; within e, cohorts are weighted by their number of T 村里.
3. If the data end before 2026Q2, A22 contributes only the quarters it has. R18 (balanced k = 0–7) checks the effect of this changing mix.
4. Data needed: 2011Q1 to the latest quarter, at least 2026Q2.

## 6. Estimator and inference

**Estimator.** Callaway & Sant'Anna (2021) group-time ATTs with the R package `did`, version 2.5.1 (CRAN release of 2026-07-08; pinned 2026-10-30). Settings: `control_group = "notyettreated"` with F and G coded as never treated (G with its cutoff applied by dropping G rows from 2023Q3), `anticipation = 12`, `base_period = "universal"`, no covariates, `est_method = "reg"`, each 村里 weighted equally. Primary statistic: `aggte(type = "dynamic", min_e = 0, max_e = 11)`.

**Clusters.** Treated contributions are aggregated to the line (A22 separate from A1–A21), so there are 5 treated clusters. Comparison clusters are districts (鄉鎮市區). Steps 1–6 below apply unchanged. District-level treated clustering is reported as a check (R27). Line-level treated clusters keep shocks that hit a whole line inside one cluster; splitting a line into districts would ignore them and could over-reject.

**Primary inference: Ferman & Pinto (2019), applied as follows.**

1. For each district cluster c, form its contribution to the primary statistic: the C&S-weighted average, over the post cells it enters, of its mean (y\_t − y\_base) across its 村里. The primary statistic is the weighted treated contributions minus the weighted comparison contributions.
2. Residuals come from comparison clusters only: each comparison cluster's contribution minus the comparison mean.
3. Heteroskedasticity: the variance of a cluster's contribution is modelled as a + b / n\_c, where n\_c is its number of 村里, fitted by regressing squared comparison residuals on 1 / n\_c.
4. Under H0, each treated cluster's contribution is replaced by a comparison residual drawn with replacement and rescaled to that treated cluster's n\_c. The statistic is recomputed. 9,999 draws.
5. Two-sided p = share of draws with |statistic| ≥ |observed|. 95% interval by test inversion over a grid of null effects.
6. The smallest attainable p depends on N₀, the number of comparison clusters, not on the number of treated clusters. With 9,999 draws it is about 1 / (N₀ + 1), and it is reported. N₀ ≥ 19 is required for H1 to be confirmable; Appendix A records N₀.

The code for steps 1–6 is fixed in the committed analysis script and tested on synthetic data before outcome files are opened.

**Check only: wild cluster bootstrap.** Restricted wild cluster bootstrap-t, Webb six-point weights, 9,999 draws, same clusters as the primary (R20). Reported next to the primary p. It cannot rescue or overturn the primary.

**One test.** H1 is tested once, two-sided, at 5%. Event-time coefficients are shown with pointwise intervals and are descriptive.

**All robustness results in one figure.** Every R-test appears in a single forest plot in the main text, so none can be chosen afterwards.

## 7. Kill rules and reported checks

If a kill rule fires, H1 cannot be claimed. The project writes up what happened as a failed design, with all numbers. It does not change the design and try again. "Same sign" always means the same sign as the primary estimate.

| Rule | Fires when | Checked |
| --- | --- | --- |
| **K1** Too few treated | Fewer than **30** T 村里 in total after exclusions. (A line with fewer than 5 is dropped from the primary, not a kill.) | Before outcome data is opened (Appendix A) |
| **K2a** Pre-trend level | The mean of the event-time ATTs for k = −20 to −14 (one statistic, against base k = −13) has **p < 0.10** under the section 6 procedure | First result looked at |
| **K2b** Pre-trend slope | A straight line fitted to the k = −20 to −14 ATTs, extended to k = +5.5, has the same sign** and an absolute value ≥ 50% of the primary's** | With K2a |
| **K3a** Placebo station | See full statement below; fires on same sign, **p < 0.10** and size **≥ 33%** of the primary | After the primary |
| **K3b** Placebo date | See full statement below; same sign, **p < 0.10** and size **≥ 33%** of the primary's k = 0–3 ATT | After the primary |

**K3a in full.** Treated: G 村里, given a fake k = 0 at 2020Q1. Comparison: F only. Anticipation 0, base 2019Q4 (fake k = −1), post 2020Q1–2022Q4 (fake k = 0–11), all before G's cutoff. Statistic: `aggte(dynamic, min_e = 0, max_e = 11)`. Inference: the section 6 procedure, with G aggregated to one treated cluster (the line) and F's districts as comparison clusters.

**K3b in full.** Each real cohort's T 村里 get a fake k = 0 at their real k = −16. Only real quarters up to k = −13 are used. Anticipation 0, base at real k = −17, post at real k = −16 to −13 (fake k = 0–3). Comparison pool and inference as in the primary. The pooled `aggte(dynamic, min_e = 0, max_e = 3)` is compared with the primary's own `aggte(dynamic, min_e = 0, max_e = 3)`.

**Reported checks (not kill rules)**

- HonestDiD (Rambachan & Roth 2023), relative-magnitude bounds M̄ = 0.5, 1, 2 (R15). If the 95% interval at M̄ = 1 includes 0, the abstract says so.
- A pre-trend that is opposite in sign to the primary is reported, not a kill.
- Red-team placebos (stage 5) beyond K3a and K3b are reported, not kills.

Why K2b changed: in v1 it could fire on noise alone, since a 7-point slope extended 18.5 quarters can be large by chance. It now fires only when the fitted line at k = +5.5 has the same sign as the primary and an absolute value ≥ 50% of the primary's.

## 8. Survivorship, relocation and COVID

### Survivorship

The registry lists only firms that still exist at the extraction date E. A firm founded in quarter t and closed before E is missing, so observed registrations undercount births, most in early quarters.

**Survival estimate** for district d, separately for 公司 and 商業, from monthly district closure counts:

```latex
h_{dm} = \frac{C_{dm}}{K_{dm}}, \quad K_{dm} = A_{dm} + \sum_{m' \ge m} C_{dm'} - \sum_{m' \ge m} C^{\,\text{founded} \ge m}_{dm'}, \quad \hat S_d(t) = \prod_{m=t}^{E} (1 - h_{dm})
```

- C = closures in d, month m. A = surviving registry firms in d founded before m. The last term removes later closures of firms founded at or after m, which were not active at m.
- If closures do not carry founding dates, the last term is dropped. K is then too large, h too small, and the correction **under-corrects**. The write-up says so.
- Before 2013 there are no closure counts; h is set to the district's 2013 average.
- The hazard is assumed not to depend on firm age. Young firms close more often, so this also under-corrects recent cohorts.

**Corrected outcome:** ỹ\_it = y\_it / Ŝ\_d(i)(t), applied to 公司 and 商業 separately before summing (R17).

**Bound: breakdown ratio r.** The district correction cannot see a station changing survival of new firms. We report r = (survival of T firms) / (survival of comparison firms) at which the primary estimate would fall to zero. If r lies inside 0.8–1.25, the effect is not called real (section 1, condition 5).

### Relocation (current address)

The registry holds each firm's current address, not its address at founding. A firm founded elsewhere that later moved near a station is counted as a birth there, at its founding date. That back-dates movers into the pre-period and inflates pre-opening counts, which biases the effect toward zero and can create a fake pre-trend. Firms that moved away are lost.

- N uses the address at establishment if the export has it (field requested, section 10).
- Otherwise N uses the current address. The bias is stated as a limit, and the share of firms with any 遷址 record is reported by group and cohort.
- R26: counts excluding firms with any 遷址 record, if the export can flag them.

### COVID check (R1)

Calendar quarters 2020Q1–2022Q4 are dropped for every unit, then the primary is re-estimated. A cohort whose base (k = −13) falls in the dropped window uses the latest earlier quarter as base: **A22 uses 2019Q4** instead of 2020Q2.

What each cohort contributes in R1:

| Cohort | Post quarters kept |
| --- | --- |
| 機捷 | k = 0–10 (2017Q2–2019Q4) |
| 綠山 | k = 0–3 (2019Q1–2019Q4) |
| 環狀 | none |
| 藍海 | k = 9–11 (2023Q1–2023Q3) |
| 安坑 | k = 0–11 |
| A22 | k = 0–11 (data permitting) |

(The referee's note listed 綠山 as k ≥ 5; by the quarters above it is k = 0–3.) R2a drops 環狀; R2b drops every cohort with k = 0 in 2019Q1–2020Q4.

## 9. Robustness tests and secondary outcomes

Every test below is run and reported, all in one forest plot in the main text. Only R1 and R17 (and r from R17) enter the "effect is real" rule. No other test can rescue or overturn the primary. Line-level and cohort-level ATTs are reported for every result.

| # | Test |
| --- | --- |
| R1 | Drop 2020Q1–2022Q4 (COVID), base rule and contributions in section 8 |
| R2a / R2b | Drop 環狀 / drop all cohorts with k = 0 in 2019Q1–2020Q4 |
| R3 | Leave one line out (4 runs). Point estimates only; no p-values |
| R4 | Anticipation 8 quarters, base k = −9. Shown beside the primary in the main table |
| R5 | Comparison group R2 (800–1,500 m) |
| R6 | Comparison group F only |
| R7 | Ring effects: R1 and R2 each as "treated" vs F. If R2's effect has p < 0.10 and is ≥ 1/3 of T's, R2 is reported as contaminated and R5 is discounted |
| R8 | Treated radius 300 m and 800 m instead of 500 m |
| R9 | Sun & Abraham (2021) estimator |
| R10 | Borusyak, Jaravel & Spiess (2024) imputation estimator |
| R11 | Plain two-way fixed effects, with Goodman-Bacon decomposition and negative-weight share (benchmark only) |
| R12 | Poisson DiD (Wooldridge 2023) on counts, log base-year population offset, small 村里 included |
| R13 | 村里 weighted by base-year population |
| R14 | Doubly robust C&S with two covariates: base-year population density and the mean outcome over the cohort's k = −20 to −17 |
| R15 | HonestDiD, M̄ = 0.5, 1, 2 |
| R16 | Small-cell imputation at both ends |
| R17 | Survivorship-corrected outcome, plus breakdown ratio r |
| R18 | Balanced post window k = 0–7 |
| R19 | **Replaced.** Every cohort's k = 0 recomputed from its fare-start date (section 2) |
| R20 | Wild cluster bootstrap p (check on inference) |
| R21 | Extensive margin: share of 村里-quarters with at least one registration |
| R22 | Drop the 機捷 and 綠山 cohorts (most exposed to a late or modelled denominator) |
| R23 | Population-weighted centroid instead of geometric |
| R24 | Exclude 村里 intersecting the four development zones (section 3) |
| R25 | Pool G + not-yet-treated T only (no F); identified cells only (section 5); point estimates and wild bootstrap |
| R26 | Exclude firms with any 遷址 record, if flagged |

R27 (added in v2.1): treated contributions clustered by district instead of by line; a check on inference only.

**Secondary outcomes** (no kill rules; Holm correction across them):

1. 公司 and 商業 registrations, separately.
2. Median residential price per m² by 村里-quarter (實價登錄 starts 2012Q3, so its window starts there).
3. Household-registered population growth.
4. Registrations by industry section, consumer-facing vs other, if the export carries the code.

**Exploratory.** Anything else, including suggestions from the red team or the economist, is labelled "exploratory" in every table and in the text.

## 10. Data, opening order, deviations, sign-off

**Fields the export must carry.** Aggregated counts only; no firm-level records or names.

| File | Must carry |
| --- | --- |
| Registrations | 村里 × quarter, 2011Q1 to at least 2026Q2; 公司 / 商業 split; branches excluded or flagged; quarter defined by 核准設立 date; suppression flag and rule; extraction date E; address at establishment if available, else a count of firms with any 遷址 record; industry section if allowed |
| Closures | 鄉鎮市區 × month, 2013 onward; 公司 / 商業 split; closure types counted; founding-date band of closed firms if available (section 8) |
| Prices | 村里 × quarter from 實價登錄, 2012Q3 onward; residential median per m² and count |
| Population | 村里 year-end 2011–2013 if obtainable; 鄉鎮市區 end-2012; 村里 series from the earliest year available |
| Stations | Study lines, 桃園綠線 planned stations, all rail stations open before 2011, all non-study stations opened 2011 to now; opening dates with sources |
| Boundaries | 村里界歷史圖資 114年; 村里 change records 2011 to now; the four development-zone 都市計畫 boundaries |
| Manifest | Source and licence per file (政府資料開放授權條款 v1 or equivalent) |

**Opening order**

1. Before any outcome file: stations, boundaries, development zones and the **base-year population cross-section only** (P\_i inputs). These build the groups, distances and Appendix A.
2. After the merge to `main` and the committed analysis code: registrations, closures, prices and the full population series (population growth is a secondary outcome).

**Appendix A (filled after signature and before any outcome file is opened, from step 1 files only; committed as a dated deviations.md entry).** T 村里 per line after exclusions; total T (K1); comparison clusters N₀ and the smallest attainable p; every post cell (cohort × k) with its comparison count; cells below 30 marked as not estimated; the denominator route taken.

**Deviations rule.** Any change after the merge is logged in `preregistration/deviations.md` with date, reason, and whether outcome data had been seen. Results under the registered plan are still reported.

**Stage 7 note.** The Delhi study (Kovvuri 2025) must be read in full before the working paper cites it.

**Out of scope.** Niko runs the manual ndltd search for an earlier thesis.

**Sign-off** (repo `nikolasdoan/tw-econ-research`, branch `prereg-v1`, file `preregistration/mrt-pilot-v2.md`)

- [ ] Referee's confirmation of v2.1
- [ ] Niko (段皇方), author — signs
- [ ] Reviewer — signs
- [ ] Merged to `main` (merge commit hash and date recorded here)
- [ ] Before any registration, closure, price or population-series file is opened, two dated entries are committed to `preregistration/deviations.md`:
  - Appendix A (per-line T counts, N₀, the post cells with comparison counts, the denominator route), with SHA-256 hashes of its input files. If it shows N₀ < 19 or a line dropped, the rules above apply as written, with no redesign.
  - The 機捷 public-opening source, from a page published on or after 2017-02-16 or the data.gov.tw 96918 row.
