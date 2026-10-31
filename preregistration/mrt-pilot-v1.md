# MRT pilot: pre-registration v1

Oct 30, 2026 · @Niko

## Status and hypotheses

Draft v1, written before any outcome data has been seen or received. No registration, closure, price or population file has been opened by anyone on this project. It is committed as `preregistration/mrt-pilot-v1.md` on branch `prereg-v1` of `nikolasdoan/tw-econ-research`. It becomes binding when Niko and one reviewer sign and it is merged to `main`. The merge commit's date is the proof of timing.

**Question.** Did new MRT and light-rail stations change how many businesses open nearby, compared with similar 村里 that got no station?

- **H1.** In the 12 quarters after opening (k = 0 to 11), new business registrations per 1,000 residents in 村里 within 500 m of a new station rise relative to the comparison 村里.
- **H0.** No difference. H0 is a valid result and will be written up with its confidence interval and minimum detectable effect.

**The one primary estimate.** The average treatment effect on the treated (ATT) over event quarters k = 0 to 11, for 村里 within 500 m, against the primary comparison group, in registrations per 1,000 residents per quarter.

**The effect is real if** the primary estimate is positive with a two-sided p < 0.05 under the primary inference method, no kill rule fires, and the estimate stays positive both without 2020Q1–2022Q4 and with the survivorship-corrected outcome.

Anything not listed in this document is exploratory and will be labelled so.

## Lines, opening dates and treatment quarter

Six opening events on four lines. Each line is one cluster, so there are **4 treated clusters**. The opening date is the first day of regular public service. Where free public rides began earlier (機捷), both dates give the same k = 0.

**Treatment quarter rule.** Event quarter k = 0 is the first calendar quarter with at least 45 days of public service. If the opening quarter has fewer than 45 days left, k = 0 is the next quarter.

| Event | Cluster | Opening date | k = 0 | Source (opened) |
| --- | --- | --- | --- | --- |
| 機場捷運, A1–A21 | 機捷 | 2017-03-02 (fare service; public free trial from 2017-02-16) | 2017Q2 (either date) | [Newtalk, 2017-01-25](https://newtalk.tw/news/view/2017-01-25/81370); [data.gov.tw 96918](https://data.gov.tw/dataset/96918), 交通部鐵道局, 政府資料開放授權條款 v1 |
| 淡海輕軌 綠山線 | 淡海 | 2018-12-24 (ceremony 12-23, free rides from 12-24) | 2019Q1 | [TVBS, 2018-12-19](https://news.tvbs.com.tw/life/1050117) |
| 環狀線 phase 1 | 環狀 | 2020-01-31, 14:00 | 2020Q1 | [PTS, 2020-01-31](https://news.pts.org.tw/article/464655) |
| 淡海輕軌 藍海線 phase 1 (3 new stations) | 淡海 | 2020-11-15 | 2020Q4 | [Taiwan News, 2020-11-15](https://www.taiwannews.com.tw/ch/news/4054224) |
| 安坑輕軌 (9 stations) | 安坑 | 2023-02-10 | 2023Q1 | [自由時報, 2023-02-10](https://news.ltn.com.tw/amp/news/life/breakingnews/4207247) |
| 機捷 A22 老街溪 | 機捷 | 2023-07-31 | 2023Q3 | [行政院, 2023-07-31](https://www.ey.gov.tw/Page/9277F759E41CCD91/a1f8914c-3eae-4b6d-8c48-6f2ab0404e7c) |

Notes:

- The plan cited data.gov.tw 132590 for 環狀線. That page is a Taipei City budget-office table and shows no opening date, so the PTS report replaces it. The export's station file should carry the date from an open-licence source; if it differs from this table, this table wins and the difference is logged.
- The 96918 CSV could not be downloaded here (bot block). Its page lists an opening-date field. The export should include it.
- News pages are cited for dates only, as facts, not reused text.

**Planned control line.** 桃園捷運綠線, under construction and not open to passengers in the data window. Its 0–500 m 村里 serve as controls only up to 13 quarters before its earliest official expected opening listed in the station file; if no date is listed, up to 2023Q4.

## Units, treated and comparison groups

The unit is the 村里. Distance d is the straight-line distance from the 村里 centroid in the export to the nearest station. All groups are fixed from station and centroid files alone, before any outcome file is opened.

| Group | Definition | Role |
| --- | --- | --- |
| **T** (treated) | d ≤ 500 m to a study-line station | Primary treated group |
| **R1** | 500 < d ≤ 800 m | Ring estimate only |
| **R2** | 800 < d ≤ 1,500 m | Ring estimate; secondary comparison (the plan's control) |
| Buffer | 1,500 < d < 2,000 m | Excluded |
| **F** (far control) | 2,000 ≤ d ≤ 5,000 m from every study-line and 綠線 station, in Taipei, New Taipei or Taoyuan | Secondary comparison; reference for ring estimates |
| **G** (planned) | d ≤ 500 m to a 桃園綠線 planned station | Primary comparison (never treated in window) |

**Primary comparison group:** G plus not-yet-treated T 村里 of later cohorts. This uses places that were chosen for a station but did not have one yet, the design the best foreign studies use.

**Assignment rules**

1. A 村里 near stations of several cohorts belongs to the earliest cohort.
2. A 村里 is assigned by its nearest station; rings use the same distance.
3. Distances are computed once and frozen in a file committed before outcome data is opened.

**Exclusions (from every group)**

1. Any 村里 with d ≤ 500 m to a rail station (MRT, light rail, TRA, HSR) that opened before 2011. These already had a station; for them a new station is a different treatment. This drops most 環狀線 interchange areas.
2. Any 村里 with d ≤ 800 m to a station on a non-study line that opened or closed between 2011Q1 and the end of the data.
3. Any 村里 with fewer than 500 household-registered residents at end-2012 (rates are unstable). These stay in the Poisson count check.
4. Any 村里 whose boundary cannot be matched to the single boundary vintage used by the export.

The number of T 村里 left after exclusions is counted before outcome data is opened, for kill rule K1.

## Outcome, small cells, event window

**Primary outcome**, in levels, never log(1+y) or arcsinh:

```latex
y_{it} = 1000 \times \frac{N^{\text{公司}}_{it} + N^{\text{商業}}_{it}}{P_{i,2012}}
```

- N is the count of registry records for 村里 i with an establishment (核准設立) date in quarter t. 公司 and 商業 are summed. Branch offices are excluded if the export separates them.
- P is the household-registered population of 村里 i at end-2012. It is fixed so the denominator cannot respond to the station. End-2012 is before every cohort's anticipation window except part of 機捷's (see below).
- Unit: registrations per 1,000 residents per quarter.

**Cells below 3.** If the export suppresses counts of 1–2 and shows 0 as 0, a suppressed cell is set to 1.5. If it suppresses 0–2 together, the cell is set to 1. The primary estimate is rerun at both ends (1 and 2, or 0 and 2); if the sign flips across the ends, that is reported in the abstract. Suppression is applied to N^公司 and N^商業 separately if the export does so, and imputed before summing.

**Event window and anticipation.** Event quarters run from k = −20 to k = +11.

- **Anticipation window: k = −12 to −1 (12 quarters).** The 林口 thesis found prices moving about 3 years (12 quarters) before 機捷 opened. Montreal and Phoenix studies found effects during construction. These quarters are allowed to move and are reported as an anticipation estimate, not as a pre-trend.
- **Pre-trend test window: k = −20 to −13 (8 quarters).** Reference period: k = −13 ("universal" base period).
- **Post window: k = 0 to 11.** If the data end before a cohort reaches k = 11 (A22 needs data to 2026Q2), that cohort contributes the quarters it has; a balanced k = 0 to 7 version is a listed robustness test.
- **Data needed:** 2012Q2 (機捷 k = −20) to the latest quarter available. We ask the export to start at 2011Q1.

This lengthens the plan's 8-quarter look-back. The 8-quarter version (anticipation k = −8 to −1, reference k = −9) is run as robustness test R4.

## Estimator and primary inference

**Estimator.** Callaway & Sant'Anna (2021) group-time ATTs, cohorts as in the dates table, comparison group "not yet treated" (G plus later cohorts' T), anticipation = 12 quarters, universal base period, no covariates, each 村里 weighted equally. Implemented with the R package `did`, version pinned in the committed code. The model in the plan,

```latex
y_{it} = \alpha_i + \lambda_t + \sum_{k \neq -13} \beta_k \, 1[t - T_i = k] + \varepsilon_{it}
```

is the event-study view of the same estimand; the β\_k are reported from the C&S dynamic aggregation, not from this regression.

**Primary estimate.** The simple average of the event-time ATTs over k = 0 to 11.

**Primary inference: Ferman & Pinto (2019).** Few treated groups with heteroskedasticity from unequal group sizes.

- Groups: the 4 lines (their 村里 are treated in their cohort and serve as not-yet-treated controls before it), and 綠線 G split by 鄉鎮市區. Open point for the reviewer: G may give only 3–5 control groups, which is few for Ferman–Pinto. If the station file shows fewer than 8 control groups, the inference step adds F's 鄉鎮市區 as control groups, and this is decided before outcome data is opened.
- Heteroskedasticity is modelled as a function of each group's end-2012 population.
- p-value from their bootstrap; 95% confidence interval by test inversion.
- Reason: with 4 treated clusters, clustered errors over-reject and the wild cluster bootstrap fails when few clusters are treated (MacKinnon & Webb 2018). Ferman–Pinto is built for this case.

**Check only: wild cluster bootstrap.** Restricted wild cluster bootstrap-t, Webb six-point weights, 9,999 draws, same clusters. Reported next to the primary p-value. It cannot rescue or overturn the primary.

**One test.** H1 is tested once, two-sided, at 5%, on the primary estimate. Event-time coefficients are shown with pointwise intervals and are descriptive.

**Code before data.** The full analysis code is written and run on a synthetic file with the export's schema, and committed, before the real outcome files are opened.

## Kill rules

If a kill rule fires, H1 cannot be claimed. The project writes up what happened as a failed design, with all numbers. It does not change the design and try again.

| Rule | Fires when | Checked |
| --- | --- | --- |
| **K1** Too few treated | Fewer than **30** T 村里 after exclusions | Before outcome data is opened |
| **K2a** Pre-trend, joint | Joint test that all event-time ATTs for k = −20 to −14 are zero (relative to k = −13) gives **p < 0.10** under the primary inference method | First result looked at |
| **K2b** Pre-trend, size | A straight line fitted to the k = −20 to −13 ATTs, extended to k = +5.5 (the middle of the post window), exceeds **20%** of the T group's mean outcome over k = −20 to −13 | Same time as K2a |
| **K3a** Placebo station | G 村里 given a fake opening at 2020Q1, compared with F, give an ATT (k = 0 to 11) with the **same sign** as the primary, **p < 0.10**, and size **≥ 50%** of the primary | After the primary |
| **K3b** Placebo date | Each real cohort given a fake opening at k = −16, using only quarters up to k = −13, gives a pooled ATT with the same sign, p < 0.10, and size ≥ 50% of the primary | After the primary |

Why two pre-trend rules: with 4 lines, a joint test has low power (Roth 2022), so K2b also catches a trend that is large but not significant. HonestDiD bounds (R15) are reported either way.

The red team (stage 5) will run more placebos. Only K3a and K3b are kill rules; the others are reported.

## Survivorship bound and COVID check

**The problem.** The registry lists only firms that still exist at the extraction date E. A firm founded in quarter t and closed before E is missing. Older cohorts lose more firms, so observed registrations fall short of true births, more so in early quarters.

**Survival estimate** for district d (鄉鎮市區), separately for 公司 and 商業, from the monthly district closure counts:

```latex
h_{dm} = \frac{C_{dm}}{K_{dm}}, \qquad K_{dm} = A_{dm} + \sum_{m' \ge m} C_{dm'}, \qquad \hat S_d(t) = \prod_{m = t}^{E} \left(1 - h_{dm}\right)
```

- C = closures in district d, month m. A = registry firms in d founded before month m (survivors). K approximates firms active at the start of month m.
- Before 2013 there are no closure counts. For those months h is set to the district's 2013 average.
- Assumption: the closure hazard does not depend on firm age. Young firms close more often, so this understates the loss for recent cohorts. That is stated as a limit.

**Corrected outcome:** ỹ\_it = y\_it / Ŝ\_d(i)(t), with Ŝ applied to 公司 and 商業 separately before summing. The primary model is re-estimated on ỹ (test R17).

**Breakdown ratio.** If T 村里 firms survive at a different rate than comparison firms in the same district, the correction cannot see it. We report the ratio r = (survival of T firms) / (survival of comparison firms) at which the primary estimate would fall to zero. A ratio below 0.8 or above 1.25 is called fragile in the write-up.

**COVID check.** 環狀線 opened weeks before COVID; 藍海線 and 綠山線 post-periods also overlap it.

- **R1:** drop calendar quarters 2020Q1–2022Q4 for every unit, then re-estimate. This is part of "the effect is real".
- **R2a:** drop the 環狀線 cohort. **R2b:** drop every cohort with k = 0 in 2019Q1–2020Q4 (綠山, 環狀, 藍海), leaving 機捷, 安坑 and A22.

## Robustness tests, secondary outcomes, exploratory work

Every robustness test is listed here and every one is reported, whatever it shows. Only R1 and R17 enter the "effect is real" rule. No other test can rescue or overturn the primary.

| # | Test |
| --- | --- |
| R1 | Drop 2020Q1–2022Q4 (COVID) |
| R2a / R2b | Drop 環狀線 / drop all cohorts opening 2019Q1–2020Q4 |
| R3 | Leave one line out (4 runs) |
| R4 | Anticipation 8 quarters, reference k = −9 (the plan's original window) |
| R5 | Comparison group R2 (800–1,500 m, the plan's ring control) |
| R6 | Comparison group F (far control) |
| R7 | Ring effects: R1 and R2 each as "treated" vs F. If R2's effect has p < 0.10 and is ≥ 1/3 of T's, R2 is reported as contaminated and R5 is discounted |
| R8 | Treated radius 300 m and 800 m instead of 500 m |
| R9 | Sun & Abraham (2021) estimator |
| R10 | Borusyak, Jaravel & Spiess (2024) imputation estimator |
| R11 | Plain two-way fixed effects, with Goodman-Bacon decomposition and de Chaisemartin–D'Haultfœuille negative-weight share (benchmark only) |
| R12 | Poisson DiD (Wooldridge 2023) on counts, log end-2012 population as offset, small 村里 included |
| R13 | 村里 weighted by end-2012 population |
| R14 | Doubly robust C&S with two covariates: end-2012 population density and the 2012Q2–2013Q1 mean outcome |
| R15 | HonestDiD (Rambachan & Roth 2023), relative-magnitude bounds M̄ = 0.5, 1, 2 |
| R16 | Small-cell imputation at both ends |
| R17 | Survivorship-corrected outcome ỹ, plus breakdown ratio r |
| R18 | Balanced post window k = 0 to 7 |
| R19 | 機捷 k = 0 moved to 2017Q1 (trial service from 2017-02-02) |
| R20 | Wild cluster bootstrap p-value (check on inference) |
| R21 | Extensive margin: share of 村里-quarters with at least one registration |

**Secondary outcomes** (no kill rules; Holm correction across them):

1. 公司 and 商業 registrations, separately.
2. Median residential price per m² by 村里-quarter (實價登錄 begins 2012Q3, so its window starts there).
3. Household-registered population growth.
4. Registrations by industry section, split into consumer-facing and other, if the export carries an industry code.

**Exploratory.** Anything else, including anything suggested by the red team or the economist, is labelled "exploratory" in every table and in the text.

## Data we expect, and fields still needed

The export is aggregated counts only, with a manifest of sources and licences. Nothing below asks for firm-level records or names.

| File | Content we expect | Fields to add now, while the M1 can |
| --- | --- | --- |
| Registrations | 村里 × quarter counts, split 公司 / 商業 | Start 2011Q1; a suppression flag per cell and the rule used (1–2 or 0–2); which date defines the quarter (核准設立); branch offices separated or excluded; registry extraction date E; industry section (consumer-facing vs other), if allowed |
| Closures | District × month counts, 2013 onward | Split 公司 / 商業; the closure types counted (解散, 廢止, 歇業?) |
| Prices | 村里 × quarter, from 實價登錄 | Median price per m² and transaction count; residential only; 2012Q3 onward |
| Population | 村里 × period, household-registered | End-2012 value for every 村里; quarterly or year-end series from 2011 |
| Stations | Positions of stations | Line, station code, opening date with its source; **桃園綠線 planned stations and their official expected opening**; all rail stations (MRT, light rail, TRA, HSR) open before 2011; every non-study station opened 2011 to now (for exclusions) |
| 村里 centroids | One point per 村里 | 村里 code, 鄉鎮市區 code, area in km²; **one boundary vintage across all files**, with a crosswalk if 村里 were merged or split since 2011; centroid type (geometric or population-weighted) |
| Manifest | Source and licence per file | Licence must be 政府資料開放授權條款 v1 or equivalent |

**Order of opening.** Stations, centroids and population are opened first, to build groups and check K1. Registration, closure and price files are opened only after this document and the analysis code are committed.

## Changes from the approved plan, deviations, sign-off

**Changes Niko should approve at this gate**

1. **Longer look-back.** The plan had 8 pre-quarters. This draft uses 20: a 12-quarter anticipation window plus an 8-quarter pre-trend test window. The plan's version is kept as R4.
2. **Primary comparison group.** The plan named 綠線 村里 and the 800–1,500 m ring as controls. This draft makes 綠線 plus not-yet-treated 村里 primary. The ring becomes secondary (R5), because spillovers may reach it (Butts; Delhi). A far control F is added.
3. **Clusters.** 綠山線 and 藍海線 are one system (淡海); A22 belongs to 機捷. So there are 4 treated clusters, not 5.
4. **環狀線 date source.** data.gov.tw 132590 does not show the date; replaced (see dates table).
5. **Kill rules as numbers** (K1–K3b) and one primary inference method (Ferman–Pinto) are new.

**Deviations rule.** Any change after the commit is logged in `preregistration/deviations.md` with date, reason, and whether outcome data had been seen. Results under the original plan are still reported.

**Stage 7 note.** The Delhi study (Kovvuri 2025) must be read in full before the working paper cites it. So far it was read only through a blog summary.

**Out of scope for this document.** The manual ndltd search for an earlier thesis is run by Niko.

**Sign-off**

- [ ] Niko (段皇方), author
- [ ] Reviewer
- [ ] Committed to `preregistration/` (commit hash and date recorded here)
