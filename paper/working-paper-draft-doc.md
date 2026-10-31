# MRT Openings and New Businesses in Taiwan

Oct 31, 2026 · @Niko

**段皇方 (Niko Doan)**

Working paper draft. Fixed parts only, written before any results exist. Not for circulation. Mirrors `paper/working-paper-draft.md` (SHA-256 b745f3ca…; the doc's byline line is the only difference).

Pre-registration: `preregistration/mrt-pilot-v2.md` (v2.1), repository nikolasdoan/tw-econ-research, merged to main on 2026-10-31T01:34:00Z, commit a743f88. Amended by deviation D2 (inference), commit 255eb68.

JEL codes: R40, R30, L26, C23. \[TO VERIFY: final JEL codes\]

Keywords: metro, light rail, business formation, staggered difference-in-differences, Taiwan.

## Abstract

&#91;RESULTS PENDING\]

The abstract will state the primary estimate, its 95% confidence interval, its p-value, the number of comparison clusters N₀ and the smallest attainable p. Under the pre-registration it must also say so if any of these hold: the R4 estimate and the primary differ in sign; the R16 estimate flips sign; the HonestDiD interval at M̄ = 1 includes zero.

## 1 Introduction

Cities build rail to move people. Many also expect new stations to bring shops, offices and new firms. This paper asks whether that happened in Taiwan.

The question is simple. Did new MRT and light-rail stations change how many businesses open within 500 m? We compare 村里 near new stations with similar 村里 that got no station.

The outcome is new business registrations per 1,000 residents per quarter. We study six opening events on four lines in Taipei, New Taipei and Taoyuan, opened from 2017 to 2023: 機場捷運 (A1–A21, and the later A22 station), 淡海輕軌 (綠山線 and 藍海線), 環狀線 and 安坑輕軌.

The design is a staggered difference-in-differences. We use the Callaway and Sant'Anna (2021) estimator. Our comparison pool has three parts. The first is 村里 near stations of 桃園捷運綠線, which was planned but not open in our window. The second is 村里 near study-line stations that had not yet opened. The third is far 村里, 2 to 5 km from any study station.

The number of treated lines is small. Standard clustered errors are unreliable with so few clusters (Cameron, Gelbach and Miller 2008; MacKinnon and Webb 2017, 2018). Our primary inference therefore uses the Ferman and Pinto (2019) method. A wild cluster bootstrap is a check only.

Everything in the design was fixed in a pre-registration before any outcome data was opened. That includes the one primary estimate, three sets of kill rules and 27 robustness tests. The pre-registration was reviewed by an independent AI referee and signed by the author and a reviewer.

As far as we can find, no earlier study measures this effect in Taiwan with a comparison group. The closest Taiwan study (汪志忠 and 王俞翔 2013) counts registered shops along the Kaohsiung MRT but has no control villages. Abroad, studies that count new firms near new stations mostly find large, local, positive effects (Feng, Wang and Huang 2025; Kovvuri and Sharma 2025; Credit 2018). Studies of total employment often find nothing for five years or more (Schuetz, Giuliano and Shin 2016; Canales, Nilsson and Delmelle 2019).

A null result is a valid result here. It is written up with its interval, the smallest attainable p-value and the minimum detectable effect.

&#91;RESULTS PENDING: one paragraph on the main finding.\]

The rest of the paper is set out as follows. Section 2 reviews the literature. Section 3 describes the lines. Section 4 lists the data sources. Sections 5 to 7 give the design, inference and pre-registered checks. Section 8 holds the results. Section 9 lists the limits we knew about in advance.

## 2 Literature

### 2.1 Transit and business entry abroad

Studies that count new firms near new stations mostly find positive local effects. The gains are concentrated in consumer services. Effect sizes are hard to compare: units, baselines and designs differ.

The closest designs to ours are recent.

- **Beijing.** Feng, Wang and Huang (2025) use registry counts of new service firms in 16,571 one-km grid cells from 2007 to 2018. With a multi-period DiD on line openings, their abstract reports a 53.8% rise in new service-firm registrations after a line opens. We have read only the abstract, so we cite the figure at that level. They do not use a per-capita outcome or a 500 m band.
- **Delhi.** Kovvuri and Sharma (2025) use Delhi Shops and Establishments registrations from 2011 to 2024. The units are 1,895 H3 hexagons of about 0.075 km² ("roughly 500 m"). The outcome is the count of new firms per hexagon per six months, not a per-capita rate. They use the Callaway and Sant'Anna estimator, with standard errors clustered by neighbourhood. Treatment is coded from two years before opening, when testing starts. The main sample compares 148 hexagons within 1 km of Phase 3 stations with 485 hexagons more than 1 km from any station; all are near major roads. The headline effect is +8.91 new firms per six months (SE 2.09), or +143.5% over a baseline of 6.21. The pre-trend test has p = 0.221. Consumer-facing (B2C) firms rise by 6.66 (SE 1.53); B2B and high-skill firms do not respond. Against a planned-but-not-built comparison (68 treated of 193 hexagons), the effect roughly halves: +6.61 (SE 3.54), or +67.2%, significant only at 10%. The paper says positive spillovers extend 1 to 2 km, but its distance decay is descriptive; it has no ring estimates for firm entry.
- **China, 38 cities.** Ma (2026) uses a staggered DiD with heterogeneity-robust estimators and placebo tests over 2006 to 2024. The outcome is new firm registrations per capita, the same as ours, but at district level. The opened page reports a significant rise but gives no effect size, so we attach no number to it. \[TO VERIFY: journal, year and volume; the ISSN 1059-5422 points to *Competitiveness Review*.\]

Other studies point the same way, with caveats.

- **Phoenix.** Credit (2018) uses a Poisson adjusted interrupted time series from 1990 to 2014. The outcome is new business starts per acre in block groups within a 1-mile network buffer of the light rail. At opening, new starts rose 88% for knowledge firms, 40% for services and 28% for retail, relative to a control area. The gains faded by 6 to 8% a year.
- **Portland and Dallas.** Chatman, Noland and Klein (2016) find a large positive link between rail and firm births in Portland and a smaller one in Dallas. Their panel has no opening design.
- **Maryland.** Saeed and Iseki (2023) find higher birth rates near rail, regardless of station age.
- **Los Angeles.** Schuetz, Giuliano and Shin (2016) study employment density and housing with NETS data, not business starts. Their employment analysis covers 23 stations, with major-road intersections as controls. Stations were sited where jobs were already dense. Employment density did not change within five years.
- **Charlotte.** Canales, Nilsson and Delmelle (2019) find no significant rise in employment near stations. Tornabene and Nilsson (2021) find that construction hurt nearby small businesses.
- **Montreal.** Champagne, Dubé and Legros (2024) use announced but unbuilt stations as controls. Firm survival was mostly higher within about 250 to 1,250 m, already during construction.

Four lessons shape our design. A positive effect is the prior, so a null would be notable. Effects may start during construction and fade after opening. Stations are not placed at random, and the choice of controls matters: in Delhi the effect roughly halves against planned-but-not-built locations. This supports our planned-line group G and the R25 check. Construction can depress the pre-period and make a post-opening rise look larger.

### 2.2 Transit and business in Taiwan

Taiwan work on rail and commerce is thin. It is mostly master's theses. All of it is descriptive or cross-sectional. None uses a control group for business entry.

- **Kaohsiung MRT.** 汪志忠 and 王俞翔 (2013) count registered retail and food businesses by 里 along the corridor from 2007 to 2010. They find no change before the 2008 opening and a visible but not significant rise in 2008 to 2010. The unit and data type match ours. There are no control villages.
- **Taipei 文湖線.** 楊舒涵 (2017) codes shop types at five stations from street imagery in 2009, 2012 and 2015. Shops nearer stations were more likely to upgrade. The outcome is shop type, not entry.
- **Chain stores.** 翁君宜 (2016) studies 12,637 chain stores in Taipei and New Taipei in 2015, with 500 m station buffers. Stores favour central stations with parking.
- **機場捷運.** 劉永祥 (2020) compares land use, population and industry around stations before and after opening, without controls. Industry change is mixed.
- **Job access.** 張耀庭 (2021) uses a 里-level panel from 1996 to 2016 on Taipei MRT network growth and job access. \[TO VERIFY: author name.\]

We found no study of 環狀線, 淡海輕軌 or 安坑輕軌 with any business outcome.

### 2.3 Transit and prices in Taiwan (brief)

Price effects in Taiwan are mixed. Lee, Lee and Cheng (2023) find no effect on one New Taipei segment and a fall on another, linked to a delay. 廖庭誼 (2023) finds no rent premium near 環狀線, with some negative rents attributed to COVID. 鄭智翔 (2024) finds price gains near 機場捷運 A21, larger within 500 m. Liou et al. (2016) find no effect of distance at mature Taipei stations. 周家右 (2013) finds lower prices farther from planned Taichung stations.

One finding matters most for us. 藍聖杰 (2018) finds price gains near 機場捷運 in 林口 arriving about three years before opening. This is why our design allows a 12-quarter anticipation window (Section 5).

### 2.4 Methods

Two-way fixed effects DiD can be badly biased when treatment is staggered. It averages all two-by-two comparisons, including ones that use already-treated units as controls (Goodman-Bacon 2021). Its weights can be negative (de Chaisemartin and D'Haultfœuille 2020, 2023). Its leads and lags can show fake pre-trends (Sun and Abraham 2021). Callaway and Sant'Anna (2021) estimate group-time effects that avoid these problems. Borusyak, Jaravel and Spiess (2024) offer an imputation estimator. Roth, Sant'Anna, Bilinski and Poe (2023) give a synthesis.

Pre-trend tests have low power, and conditioning on them can bias results (Roth 2022). Rambachan and Roth (2023) give bounds when parallel trends may fail.

Inference is the hard part with few treated groups. Cluster-robust tests over-reject with 5 to 30 clusters (Cameron, Gelbach and Miller 2008). The wild cluster bootstrap fails when few clusters are treated or cluster sizes differ (MacKinnon and Webb 2017, 2018). Conley and Taber (2011) and Ferman and Pinto (2019) use many untreated groups to build the null distribution. Ferman and Pinto allow unequal group sizes.

Three further papers shape our choices. Butts (2023) shows that spillovers can contaminate nearby controls, which is why we estimate ring effects and keep a far control. Chen and Roth (2024) show that log(1+y) effects are not percentages, which is why our outcome is in levels. Wooldridge (2023) gives a Poisson DiD, which we use as a check on counts.

## 3 Setting

We study six opening events on four lines. All are in Taipei, New Taipei or Taoyuan.

**Opening date rule.** One rule applies to every line. The public-opening date is the first day the line carried the general public without invitation or booking, free or paid. The fare-start date, the first day regular fares were charged, is used only in check R19.

**The k = 0 rule.** Event time k = 0 is the first calendar quarter with at least 45 days of service from the date used. If fewer than 45 days remain in the opening quarter, k = 0 is the next quarter.

Every date and its dated source is listed in pre-registration §2. \[TO VERIFY: the date sources there are news and operator pages. Decide whether to cite them here as facts, or to cite the pre-registration only, given the open-licence rule.\]

**Table 1. Lines, opening dates and treated 村里**

| Event | Public opening | k = 0 | Fare start | k = 0 under R19 | T 村里 (after exclusions) |
| --- | --- | --- | --- | --- | --- |
| 機場捷運 A1–A21 | 2017-02-16 | 2017Q2 | 2017-03-02 | 2017Q2 |  |
| 淡海輕軌 綠山線 | 2018-12-24 | 2019Q1 | 2019-02-01 | 2019Q1 |  |
| 環狀線 phase 1 | 2020-01-31 | 2020Q1 | 2020-03-01 | 2020Q2 |  |
| 淡海輕軌 藍海線 phase 1 | 2020-11-15 | 2020Q4 | 2020-12-15 | 2021Q1 |  |
| 安坑輕軌 | 2023-02-10 | 2023Q1 | 2023-03-13 | 2023Q2 |  |
| 機場捷運 A22 老街溪 | 2023-07-31 | 2023Q3 | 2023-07-31 | 2023Q3 |  |
| **Total T** |  |  |  |  |  |

Notes. For 機場捷運 (A1–A21), the official data.gov.tw 96918 row gives the start of 機場捷運計畫 as 106.3.2 (2017-03-02). The 2017-02-16 start of free public rides rests on a page published before the event. Invitation-only group rides from 2017-02-02 do not count. Either date gives k = 0 = 2017Q2: from 2017-02-16 there are 44 days of public service in 2017Q1, one under the cut. For 綠山線, the opening ceremony was on 2018-12-23. For A22, only the A21–A22 segment was free until 2023-08-31. Under R19, k = 0 moves one quarter later for 環狀線, 藍海線 and 安坑輕軌 and stays the same for the other three. T counts come from Appendix A of the pre-registration and are filled in from that file.

**The A22 station** is a second dose. Its 村里 were already 0.8 to 1.5 km from 機場捷運 stations from 2017, with trains passing without stopping. We report its estimate separately and read it as an infill effect.

**Development zones.** 機場捷運 and 淡海輕軌 stations sit in new-town zones. Treatment there bundles land development with rail.

**Control line.** 桃園捷運綠線 was planned but not open in our window. Its official target for the north section is end-2026. Its 村里 serve as comparison units up to a fixed cutoff (Section 5).

**Why these lines.** Lines that opened before 2017, such as 信義線 (2013) and 松山線 (2014), lack 20 pre-opening quarters from 2011Q1. They cannot pass the pre-trend test window, so they are excluded.

## 4 Data

All data are from open government sources. Every input file carries its source and licence in a manifest. The paper uses aggregated counts only. No firm is named.

| Data | Source | Licence |
| --- | --- | --- |
| New business registrations (公司 and 商業) | 經濟部商業發展署 company and business registry; registry records linked by 統一編號 | 政府資料開放授權條款 v1 \[TO VERIFY: dataset ids\] |
| Business closures (for the survivorship check) | 經濟部商業發展署 company and business registry | 政府資料開放授權條款 v1 \[TO VERIFY: dataset ids\] |
| Household-registered population | 內政部戶政司 (data.gov.tw 8411, 32973) | 政府資料開放授權條款 v1 |
| Residential sale prices (secondary outcome) | 內政部 實價登錄 (不動產成交案件實際資訊) | 政府資料開放授權條款 v1 \[TO VERIFY: dataset id\] |
| Stations and opening dates | data.gov.tw 96918 (機場捷運 row); other lines \[TO VERIFY: station dataset\] | \[TO VERIFY\] |
| 村里 boundaries | 內政部地政司 村里界歷史圖資, version 114年 (data.gov.tw 130549) | 政府資料開放授權條款 v1 |
| 村里 change records | 內政部戶政司 | 政府資料開放授權條款 v1 \[TO VERIFY\] |
| Development-zone boundaries (R24) | Official 都市計畫 boundaries | \[TO VERIFY: source and licence\] |

**Coverage.** Registrations run from 2011Q1 to at least 2026Q2. Prices start in 2012Q3, when 實價登錄 begins. Closure counts start in 2013.

**Unit of time.** A registration is dated by its 核准設立 (establishment approval) date.

**Branches.** Branch offices (分公司 and 商業分支機構) are excluded.

**Small cells.** Counts below 3 may be suppressed in the source files. Section 5 gives the rule we use for them.

## 5 Design

This section matches pre-registration v2.1 §3 to §6, as amended by deviation D2. Nothing here was changed after outcome data was opened.

### 5.1 Estimand

There is one primary estimate. It is the overall dynamic average treatment effect on the treated (ATT) over event quarters k = 0 to 11. It is computed as `did::aggte(type = "dynamic", min_e = 0, max_e = 11)`, averaged over identified cells only, for 村里 within 500 m, against the primary comparison pool. Its unit is registrations per 1,000 residents per quarter.

H1: in the 12 quarters after opening, new registrations per 1,000 residents in 村里 within 500 m of a new station rise relative to the comparison 村里. H0: no difference.

The effect is called real only if all five conditions hold:

1. The primary estimate is positive with a two-sided p < 0.05 under the primary inference (Section 6).
2. No kill rule fires (Section 7).
3. It stays positive without 2020Q1–2022Q4 (R1).
4. It stays positive with the survivorship-corrected outcome (R17).
5. The survivorship break-even ratio r\* is at least 1.25 (D2; Section 9).

### 5.2 Units and groups

The unit is the 村里. 村里 merged or split since 2011-01-01 are combined into the smallest unit that is stable from 2011 to now. Distance d is the straight-line distance from the 村里's geometric centroid to the nearest station. All groups were fixed from station and boundary files alone, before any outcome file was opened.

| Group | Definition | Role |
| --- | --- | --- |
| T (treated) | d ≤ 500 m to a study-line station | Treated in its cohort; a not-yet-treated comparison before its own anticipation window |
| R1 (inner ring) | 500 < d ≤ 800 m | Ring estimate only (check R7) |
| R2 (outer ring) | 800 < d ≤ 1,500 m | Ring estimate (R7); secondary comparison (R5) |
| Buffer | 1,500 < d < 2,000 m | Excluded |
| F (far control) | 2,000 ≤ d ≤ 5,000 m from every study-line and 綠線 station, in Taipei, New Taipei or Taoyuan | Primary comparison, never treated |
| G (planned) | d ≤ 500 m to a planned 桃園捷運綠線 station | Primary comparison until its cutoff |

The ring groups R1 and R2 are not the same as checks R1 and R2 in Section 7.

**Assignment.** A 村里 near stations of several cohorts belongs to the earliest cohort. A 村里 is assigned by its nearest station. Rings use the same distance.

**Exclusions, from every group.**

- d ≤ 500 m to any rail station (MRT, light rail, TRA or HSR) open before 2011. A new station there is a different treatment. This drops most 環狀線 interchange areas.
- d ≤ 800 m to a station on a non-study line that opened or closed between 2011Q1 and the end of the data.
- Fewer than 500 household-registered residents in the base year. These 村里 are kept in the Poisson check R12.
- 村里 that cannot be placed on the named boundary vintage.

**Minimum sizes.** At least 30 T 村里 in total and at least 5 per line. A line below 5 is dropped from the primary.

### 5.3 Comparison pool

The primary comparison pool is **G + not-yet-treated T + F**. It was fixed in advance, not chosen from a count.

F is needed for inference. The primary test needs at least 19 comparison clusters to be able to reach p < 0.05. Without F, the pool has at most about 13 districts. F spans dozens. F enters both the estimator and the test.

F is less like the treated places than G. Two checks answer that: R25 (pool G + T only) and R14 (doubly robust with baseline covariates).

**The 綠線 cutoff.** The north section of 桃園捷運綠線 targets opening at end-2026 (2026Q4). G 村里 leave the comparison pool from 2023Q3, 13 quarters before that target. They serve up to 2023Q2. Later changes to the official target do not move this cutoff.

### 5.4 Event window and anticipation

Event quarters run from k = −20 to +11.

- **Base quarter:** k = −13 for every cohort.
- **Pre-trend test window:** k = −20 to −14, each measured against k = −13.
- **Anticipation window:** k = −12 to −1. Effects are allowed here and reported as an anticipation estimate. The 12-quarter length rests on one price study (藍聖杰 2018), so check R4 (8 quarters) is shown beside the primary.
- **Post window:** k = 0 to 11.

**Calendar quarters by cohort**

| Cohort | k = −20 | Base k = −13 | k = 0 | k = 11 | Primary: post cells identified | R25 (no F): post cells identified |
| --- | --- | --- | --- | --- | --- | --- |
| 機場捷運 | 2012Q2 | 2014Q1 | 2017Q2 | 2020Q1 | k = 0–11 | k = 0–11 |
| 綠山線 | 2014Q1 | 2015Q4 | 2019Q1 | 2021Q4 | k = 0–11 | k = 0–11 |
| 環狀線 | 2015Q1 | 2016Q4 | 2020Q1 | 2022Q4 | k = 0–11 | k = 0–11 (G only after 2020Q2) |
| 藍海線 | 2015Q4 | 2017Q3 | 2020Q4 | 2023Q3 | k = 0–11 | k = 0–10 |
| 安坑輕軌 | 2018Q1 | 2019Q4 | 2023Q1 | 2025Q4 | k = 0–11 | k = 0–1 |
| A22 | 2018Q3 | 2020Q2 | 2023Q3 | 2026Q2 | k = 0–11 if data reach 2026Q2 | none |

With anticipation set to 12, a comparison unit is valid at quarter t only if its own k = 0 is after t + 12. F is always valid. G is valid up to 2023Q2. A later cohort's T is valid for an earlier cohort only up to 13 quarters before its own k = 0.

**Cell rules.** A cell (cohort × event quarter) is estimated only if it has at least 30 comparison 村里. The primary averages over identified post cells only. Each event quarter gets equal weight. Within an event quarter, cohorts are weighted by their number of T 村里. If the data end before 2026Q2, A22 contributes only the quarters it has; R18 checks this.

### 5.5 Estimator

We use the Callaway and Sant'Anna (2021) group-time ATT estimator. The R package `did` (version 2.5.1, CRAN release of 2026-07-08) cannot apply the 綠線 cutoff, so the estimate is computed by our own code, which reproduces `did` 2.5.1 to 11 digits wherever both apply. Settings:

- `control_group = "notyettreated"`, with F and G coded as never treated (G rows dropped from 2023Q3);
- `anticipation = 12`;
- `base_period = "universal"`;
- no covariates; `est_method = "reg"`;
- each 村里 weighted equally.

### 5.6 Outcome

The outcome is in levels. We never use log(1+y) or arcsinh (Chen and Roth 2024).

```latex
y_{it} = 1000 \times \frac{N^{\text{公司}}_{it} + N^{\text{商業}}_{it}}{P_i}
```

N is the number of registry records for 村里 i with an establishment (核准設立) date in quarter t. 公司 and 商業 are summed.

**Fixed denominator.** P\_i does not change over time. It is the household-registered population of 村里 i at end-2012, from 內政部戶政司.

**Fallback route.** If 村里 population for end-2012 cannot be obtained before outcome data is opened, P\_i is the 鄉鎮市區's end-2012 population times the 村里's share of its 鄉鎮市區 at the earliest available year-end (December 2014 or 2015). That share year falls inside the 機場捷運 anticipation window and near the 綠山線 one. Check R22 drops both cohorts. The route taken is logged before outcome data is opened. \[ROUTE TAKEN: to be filled from Appendix A.\]

**Small cells.** If the source suppresses counts of 1–2 and shows 0 as 0, a suppressed cell is set to 1.5. If it suppresses 0–2 together, it is set to 1. This is done for 公司 and 商業 separately, then summed. R16 reruns the primary at both ends.

**Address.** N uses the address at establishment if the source carries it. Otherwise it uses the current address (Section 9).

## 6 Inference

**Clusters.** Treated contributions are combined to the line. A22 is kept separate from A1–A21. This gives 5 treated clusters. Comparison clusters are districts (鄉鎮市區). Line-level treated clusters keep shocks that hit a whole line inside one cluster.

**Primary inference: placebo-district Ferman–Pinto (pre-registration v2.1 as amended by deviation D2).** A simulation before any outcome data was opened showed that the registered version under-covered: treated 村里 in a cohort share one base quarter, while comparison districts mix many. The referee's ruling (D2) replaces steps 1–4 \[GATE PENDING: the D2 simulation gate must pass before this text is final\]:

1. Each treated line j contributes its weighted mean change from the base quarter k = −13, over the post cells it enters, minus the comparison mean (Callaway–Sant'Anna weights).
2. Each comparison district c gets a placebo contribution computed exactly like line j's: j's cohort dates, the same single base quarter, the same cells and weights, with c removed from the comparison pool.
3. Residuals are these placebo contributions minus their mean across districts. The variance of a contribution is modelled as a + b / n (a, b ≥ 0, fitted by non-negative least squares) and floored at a quarter of the mean squared residual; the number of floored clusters is reported.
4. Under H0, each line's contribution is replaced by a draw from that line's own placebo residuals, rescaled to the line's size. The statistic is recomputed. We take 9,999 draws.
5. The two-sided p-value is the share of draws with |statistic| ≥ |observed|.
6. The 95% interval comes from test inversion over a grid of null effects.

**N₀ and the minimum p.** The smallest attainable p depends on N₀, the number of comparison clusters. With 9,999 draws it is about 1 / (N₀ + 1). N₀ ≥ 19 is required for H1 to be confirmable. If N₀ < 19, H1 cannot be confirmed and the paper says so. N₀ = \[FROM APPENDIX A\]; smallest attainable p = \[FROM APPENDIX A\].

**Check: wild cluster bootstrap (R20).** Restricted wild cluster bootstrap-t, Webb six-point weights, 9,999 draws, same clusters as the primary. It is reported next to the primary p. It cannot rescue or overturn the primary.

**Check: district clusters (R27).** Treated contributions clustered by district instead of by line. A check on inference only.

**One test.** H1 is tested once, two-sided, at 5%. Event-time coefficients are shown with pointwise intervals and are descriptive only.

## 7 Pre-registered checks

### 7.1 Kill rules

If a kill rule fires, H1 cannot be claimed. We then write up what happened as a failed design, with all numbers. We do not change the design and try again. "Same sign" always means the same sign as the primary estimate.

- **K1 Too few treated.** Fires when there are fewer than 30 T 村里 in total after exclusions. A line with fewer than 5 is dropped from the primary; that is not a kill. Checked before outcome data is opened.
- **K2a Pre-trend level.** Fires when the mean of the event-time ATTs for k = −20 to −14 (one statistic, against base k = −13) has p < 0.10 under the Section 6 procedure. This is the first result looked at.
- **K2b Pre-trend slope.** Fires when a straight line fitted to the k = −20 to −14 ATTs, extended to k = +5.5, has the same sign as the primary, an absolute value at least 50% of the primary's, and lies beyond the 80th percentile of the placebo distribution of that extrapolation in the primary's direction (D2) \[GATE PENDING: threshold under review\].
- **K3a Placebo station.** Treated: G 村里, given a fake k = 0 at 2020Q1. Comparison: F only. Anticipation 0; base 2019Q4 (fake k = −1); post 2020Q1–2022Q4 (fake k = 0–11), all before G's cutoff. Statistic: `aggte(dynamic, min_e = 0, max_e = 11)`. Inference: the Section 6 procedure, with G as one treated cluster and F's districts as comparison clusters. Fires when the estimate has the same sign, p < 0.10 and size at least 33% of the primary.
- **K3b Placebo date.** Each real cohort's T 村里 get a fake k = 0 at their real k = −16. Only real quarters up to k = −13 are used. Anticipation 0; base at real k = −17; post at real k = −16 to −13 (fake k = 0–3). Comparison pool and inference as in the primary. The pooled `aggte(dynamic, min_e = 0, max_e = 3)` is compared with the primary's own `aggte(dynamic, min_e = 0, max_e = 3)`. Fires when it has the same sign, p < 0.10 and size at least 33% of that primary k = 0–3 ATT.

**Reported, not kill rules.** HonestDiD bounds (Rambachan and Roth 2023) at M̄ = 0.5, 1 and 2 (R15); if the 95% interval at M̄ = 1 includes 0, the abstract says so. A pre-trend opposite in sign to the primary is reported, not a kill. Red-team placebos beyond K3a and K3b are reported, not kills.

**Table 3. Kill rules**

| Rule | Statistic | p | Threshold | Fires? |
| --- | --- | --- | --- | --- |
| K1 Too few treated | Total T 村里 = | n/a | < 30 |  |
| K2a Pre-trend level |  |  | p < 0.10 |  |
| K2b Pre-trend slope | Fitted value at k = +5.5 = | n/a | same sign and ≥ 50% of primary |  |
| K3a Placebo station |  |  | same sign, p < 0.10, ≥ 33% of primary |  |
| K3b Placebo date |  |  | same sign, p < 0.10, ≥ 33% of primary k = 0–3 ATT |  |

### 7.2 Robustness tests

Every test is run and reported, all in one forest plot (Figure 2). Only R1 and R17 (and r from R17) enter the "effect is real" rule. No other test can rescue or overturn the primary. Line-level and cohort-level ATTs are reported for every result.

**Table 4. Robustness tests R1–R28**

| # | Test | Estimate | 95% CI | p |
| --- | --- | --- | --- | --- |
| R1 | Drop 2020Q1–2022Q4 (COVID); a cohort whose base falls in the window uses the latest earlier quarter (A22: 2019Q4) |  |  |  |
| R2a | Drop 環狀線 |  |  |  |
| R2b | Drop all cohorts with k = 0 in 2019Q1–2020Q4 |  |  |  |
| R3 | Leave one line out (4 runs); point estimates only |  | n/a | n/a |
| R4 | Anticipation 8 quarters, base k = −9 (shown beside the primary in Table 2) |  |  |  |
| R5 | Comparison group R2 (800–1,500 m) |  |  |  |
| R6 | Comparison group F only |  |  |  |
| R7 | Ring effects: R1 and R2 each as "treated" vs F; if R2's effect has p < 0.10 and is ≥ 1/3 of T's, R2 is reported as contaminated and R5 is discounted |  |  |  |
| R8 | Treated radius 300 m and 800 m instead of 500 m |  |  |  |
| R9 | Sun and Abraham (2021) estimator |  |  |  |
| R10 | Borusyak, Jaravel and Spiess (2024) imputation estimator |  |  |  |
| R11 | Plain two-way fixed effects, with Goodman-Bacon decomposition and negative-weight share (benchmark only) |  |  |  |
| R12 | Poisson DiD (Wooldridge 2023) on counts, log base-year population offset, small 村里 included |  |  |  |
| R13 | 村里 weighted by base-year population |  |  |  |
| R14 | Doubly robust C&S with base-year population density and the mean outcome over k = −20 to −17 |  |  |  |
| R15 | HonestDiD, M̄ = 0.5, 1, 2 |  |  |  |
| R16 | Small-cell imputation at both ends |  |  |  |
| R17 | Survivorship-corrected outcome, plus break-even ratio r\* |  |  |  |
| R18 | Balanced post window k = 0–7 |  |  |  |
| R19 | k = 0 from the fare-start date |  |  |  |
| R20 | Wild cluster bootstrap p (check on inference) |  |  |  |
| R21 | Extensive margin: share of 村里-quarters with at least one registration |  |  |  |
| R22 | Drop the 機場捷運 and 綠山線 cohorts |  |  |  |
| R23 | Population-weighted centroid instead of geometric |  |  |  |
| R24 | Exclude 村里 intersecting 林口特定區 (林口新市鎮), 淡海新市鎮特定區, 高速鐵路桃園車站特定區 and 桃園航空城特定區 |  |  |  |
| R25 | Pool G + not-yet-treated T only (no F); identified cells only; point estimates and wild bootstrap |  |  |  |
| R26 | Exclude firms with any 遷址 (relocation) record, if flagged |  |  |  |
| R27 | Treated contributions clustered by district instead of by line (inference check) |  |  |  |
| R28 | Base = mean of k = −16 to −13 (D2, reported only) |  |  |  |

**What each cohort contributes to R1.** 機場捷運: k = 0–10 (2017Q2–2019Q4). 綠山線: k = 0–3 (2019Q1–2019Q4). 環狀線: none. 藍海線: k = 9–11 (2023Q1–2023Q3). 安坑輕軌: k = 0–11. A22: k = 0–11, data permitting.

### 7.3 Secondary outcomes

There are no kill rules for these. A Holm correction is applied across them.

- 公司 and 商業 registrations, separately.
- Median residential price per m² by 村里-quarter, from 2012Q3.
- Household-registered population growth.
- Registrations by industry section, consumer-facing versus other, if the source carries the code.

Anything else is labelled "exploratory" in every table and in the text.

## 8 Results

&#91;RESULTS PENDING\]

### 8.1 Pre-registration outcomes before data (Appendix A)

&#91;RESULTS PENDING: T 村里 per line; total T; N₀; smallest attainable p; post cells with comparison counts; denominator route.\]

### 8.2 Primary estimate

**Table 2. Primary estimate**

| Specification | ATT (registrations per 1,000 residents per quarter) | 95% CI | p (Ferman–Pinto) | p (wild bootstrap, R20) | N₀ | Smallest attainable p |
| --- | --- | --- | --- | --- | --- | --- |
| Primary (anticipation 12, k = 0–11) |  |  |  |  |  |  |
| R4 (anticipation 8) |  |  |  |  |  |  |
| Anticipation estimate (k = −12 to −1) |  |  |  |  |  |  |

Line-level ATTs: \[RESULTS PENDING\]. A22 reported separately: \[RESULTS PENDING\].

### 8.3 Event study

**Figure 1. Event study (template).**

- x-axis: quarters relative to opening, k, from −20 to +11.
- y-axis: ATT in new registrations per 1,000 residents per quarter.
- Points with pointwise 95% intervals for each k. A horizontal line at zero.
- The base quarter k = −13 is marked (point fixed at zero, labelled "base").
- The anticipation window k = −12 to −1 is shaded and labelled.
- A vertical line between k = −1 and k = 0 marks opening.
- The pre-trend test window k = −20 to −14 is labelled.
- Note under the figure: coefficients are descriptive; the one test is the primary estimate in Table 2.

&#91;FIGURE PENDING\]

### 8.4 All tests

**Figure 2. Forest plot of all tests (template).**

- One row per estimate: the primary, R4, each kill-rule statistic, R1–R28 (with R2a/R2b, R3 runs and R8 radii as separate rows), and the secondary outcomes where in the same units.
- x-axis: ATT in new registrations per 1,000 residents per quarter.
- Point with 95% interval for each row; R3 rows show points only.
- A vertical line at zero and a dashed vertical line at the primary estimate.
- Rows that enter the "effect is real" rule (R1, R17) are marked.

&#91;FIGURE PENDING\]

### 8.5 Spillovers by distance

**Figure 3. Ring estimates by distance band (template).**

- x-axis: distance band in metres: 0–500 (T), 500–800 (R1), 800–1,500 (R2).
- y-axis: ATT in new registrations per 1,000 residents per quarter, each band against F.
- Point with 95% interval for each band. A horizontal line at zero.
- Note: if the 800–1,500 m effect has p < 0.10 and is at least 1/3 of the 0–500 m effect, that band is reported as contaminated (R7).

&#91;FIGURE PENDING\]

### 8.6 Survivorship, relocation and secondary outcomes

&#91;RESULTS PENDING: R17 estimate and break-even ratio r\*; share of firms with any 遷址 record by group and cohort; R26; secondary outcomes with Holm-adjusted p-values.\]

## 9 Limitations known in advance

**Survivorship.** The registry lists only firms that still exist at the extraction date E. A firm founded and closed before E is missing. Observed registrations therefore undercount births, most in early quarters. We correct with a district survival estimate, separately for 公司 and 商業:

```latex
h_{dm} = \frac{C_{dm}}{K_{dm}}, \quad K_{dm} = A_{dm} + \sum_{m' \ge m} C_{dm'} - \sum_{m' \ge m} C^{\,\text{founded} \ge m}_{dm'}, \quad \hat S_d(t) = \prod_{m=t}^{E} (1 - h_{dm})
```

C is closures in district d in month m. A is surviving registry firms in d founded before m. The last term removes later closures of firms founded at or after m. The corrected outcome is y divided by Ŝ for the 村里's district and quarter (R17). If closures do not carry founding dates, the last term is dropped and the correction under-corrects. Before 2013 there are no closure counts, so the hazard is set to the district's 2013 average. The hazard is assumed not to depend on firm age; since young firms close more often, this also under-corrects recent cohorts. A district correction cannot see a station changing the survival of new firms. We therefore report the break-even ratio r\* (D2): treated registrations in post-opening quarters are divided by r, with base quarters unchanged, and r\* is the value at which the primary estimate reaches zero. A positive primary is not called real if r\* < 1.25.

**Current-address relocation.** The registry may hold each firm's current address, not its address at founding. A firm founded elsewhere that later moved near a station is counted as a birth there, at its founding date. That back-dates movers into the pre-period. It inflates pre-opening counts, biases the effect toward zero and can create a fake pre-trend. Firms that moved away are lost. We report the share of firms with any 遷址 record by group and cohort, and run R26.

**Few clusters.** There are only 5 treated clusters. Intervals will be wide. The smallest attainable p is set by N₀. If N₀ < 19, H1 cannot be confirmed whatever the estimate.

**COVID.** 環狀線 opened in 2020Q1 and 藍海線 in 2020Q4, so their post windows overlap the pandemic. R1, R2a and R2b address this. Under R1, 環狀線 contributes nothing.

**Development zones.** 機場捷運 and 淡海輕軌 stations sit in new-town zones. There, rail and land development arrive together, and we cannot separate them. R24 drops 村里 in the four named zones. Line-level ATTs are reported for every result.

**Denominator fallback.** If end-2012 村里 population is not available, the denominator uses a 村里 share from December 2014 or 2015. That year falls inside the 機場捷運 anticipation window and near the 綠山線 one, where new towns grew fast. R22 drops both cohorts.

**Other limits.** Anticipation may begin more than 12 quarters before opening; R4 tests a shorter window, not a longer one. Stations are not placed at random; G is our best answer, but it serves only to 2023Q2. Comparison 村里 at 800–1,500 m may be partly treated (Butts 2023); this is why the primary uses F rather than R2.

## Disclosure of a pre-commit exposure

Before the pre-registration was merged (2026-10-31T01:34:00Z, commit a743f88), three whole-window export totals were posted by the data builder: 1,732,175 sales in the price file; 680,654 registrations for 2011Q1–2026Q3; and the number of suppressed (<3) cells per file. No figure by 村里, quarter, station, line, district or ring was posted. Only the project's coordinating agent saw them; the research team and the referee did not. They carry no information about any station effect, and no registered choice was made after them.

## AI use

The literature review, pre-registration drafting, code and drafting of this paper were done with Claude (Anthropic) agents under the author's direction. The author and a human economist are responsible for the content. An independent AI referee reviewed the pre-registration.

## References

Borusyak, K., Jaravel, X. and Spiess, J. (2024). Revisiting event-study designs: robust and efficient estimation. *Review of Economic Studies* 91(6): 3253–3285. https://arxiv.org/abs/2108.12419

Butts, K. (2023). Difference-in-differences estimation with spatial spillovers. arXiv 2105.03737. https://arxiv.org/abs/2105.03737

Callaway, B. and Sant'Anna, P. H. C. (2021). Difference-in-differences with multiple time periods. *Journal of Econometrics* 225(2): 200–230. https://arxiv.org/abs/1803.09015

Cameron, A. C., Gelbach, J. B. and Miller, D. L. (2008). Bootstrap-based improvements for inference with clustered errors. *Review of Economics and Statistics* 90(3): 414–427. https://ideas.repec.org/a/tpr/restat/v90y2008i3p414-427.html

Canales, K., Nilsson, I. and Delmelle, E. (2019). *Regional Science Policy & Practice* 11(1): 189–202. https://ideas.repec.org/a/bla/rgscpp/v11y2019i1p189-202.html \[TO VERIFY: title\]

Champagne, M., Dubé, J. and Legros, D. (2024). *Transportation Research Part A* 181: 103994. https://www.worldtransitresearch.info/research/10412 \[TO VERIFY: title\]

Chatman, D. G., Noland, R. B. and Klein, N. J. (2016). *Transportation Research Record* 2598. https://its.berkeley.edu/node/6347 \[TO VERIFY: title, pages\]

Chen, J. and Roth, J. (2024). Logs with zeros? Some problems and solutions. *Quarterly Journal of Economics* 139(2): 891–936. https://arxiv.org/abs/2212.06080

Conley, T. G. and Taber, C. R. (2011). Inference with "difference in differences" with a small number of policy changes. *Review of Economics and Statistics* 93(1): 113–125. https://ideas.repec.org/a/tpr/restat/v93y2011i1p113-125.html

Credit, K. (2018). Transit-oriented economic development: the impact of light rail on new business starts in the Phoenix, AZ region, USA. *Urban Studies* 55(15): 2838–2862. https://mural.maynoothuniversity.ie/id/eprint/14606/

de Chaisemartin, C. and D'Haultfœuille, X. (2020). Two-way fixed effects estimators with heterogeneous treatment effects. *American Economic Review* 110(9): 2964–2996. https://www.aeaweb.org/articles?id=10.1257/aer.20181169

de Chaisemartin, C. and D'Haultfœuille, X. (2023). Two-way fixed effects and differences-in-differences with heterogeneous treatment effects: a survey. *Econometrics Journal* 26(3). https://arxiv.org/abs/2112.04565

Feng, Wang and Huang (2025). *Journal of Transport Geography* 123: 104082. Abstract only. https://www.worldtransitresearch.info/research/11018 \[TO VERIFY: full author names and title\]

Ferman, B. and Pinto, C. (2019). Inference in differences-in-differences with few treated groups and heteroskedasticity. *Review of Economics and Statistics* 101(3): 452–467. https://ideas.repec.org/a/tpr/restat/v101y2019i3p452-467.html

Goodman-Bacon, A. (2021). Difference-in-differences with variation in treatment timing. *Journal of Econometrics* 225(2): 254–277. https://www.nber.org/papers/w25018

Kovvuri, A. and Sharma, K. (2025). Moving opportunity closer: how public transit transforms firm composition and employment. Job market paper, version of 26 November 2025. https://www.akhilakovvuri.com/JMP.pdf

Lee, Lee and Cheng (2023). *Prague Economic Papers* 32(1): 84–106. https://ideas.repec.org/a/prg/jnlpep/v2023y2023i1id823p84-106.html \[TO VERIFY: full author names and title\]

Liou et al. (2016). The effects of mass rapid transit station on the house prices in Taipei: the hierarchical linear model of individual growth. *Pacific Rim Property Research Journal* 22(1): 3–16. https://prres.org/volume22-2016/the-effects-of-mass-rapid-transit-station-on-the-house-prices-in-taipei-the-hierarchical-linear-model-of-individual-growth

Ma (2026). Riding to opportunity: subway opening and urban entrepreneurial activity in China. DOI 10.1108/cr-05-2026-0264. ISSN 1059-5422 (*Competitiveness Review*). https://www.citedrive.com/en/discovery/riding-to-opportunity-subway-opening-and-urban-entrepreneurial-activity-in-china/ \[TO VERIFY: author name, journal, year and volume\]

MacKinnon, J. G. and Webb, M. D. (2017). Wild bootstrap inference for wildly different cluster sizes. *Journal of Applied Econometrics* 32(2): 233–254. https://ideas.repec.org/a/wly/japmet/v32y2017i2p233-254.html

MacKinnon, J. G. and Webb, M. D. (2018). The wild bootstrap for few (treated) clusters. *Econometrics Journal* 21(2): 114–135. https://ideas.repec.org/a/wly/emjrnl/v21y2018i2p114-135.html

Rambachan, A. and Roth, J. (2023). A more credible approach to parallel trends. *Review of Economic Studies* 90(5): 2555–2591. https://ideas.repec.org/a/oup/restud/v90y2023i5p2555-2591..html

Roth, J. (2022). Pretest with caution: event-study estimates after testing for parallel trends. *American Economic Review: Insights* 4(3): 305–322. https://www.aeaweb.org/articles?id=10.1257/aeri.20210236

Roth, J., Sant'Anna, P. H. C., Bilinski, A. and Poe, J. (2023). What's trending in difference-in-differences? A synthesis of the recent econometrics literature. *Journal of Econometrics* 235(2): 2218–2244. https://arxiv.org/abs/2201.01194

Saeed, R. and Iseki, H. (2023). *Journal of Transport and Land Use* 16(1): 389–408. https://www.jtlu.org/index.php/jtlu/article/view/2343 \[TO VERIFY: title\]

Schuetz, J., Giuliano, G. and Shin, E. J. (2016). FEDS Working Paper 2016-004. https://fedinprint.org/item/fedgfe/34583/original \[TO VERIFY: title\]

Sun, L. and Abraham, S. (2021). Estimating dynamic treatment effects in event studies with heterogeneous treatment effects. *Journal of Econometrics* 225(2): 175–199. https://arxiv.org/abs/1804.05785

Tornabene, S. and Nilsson, I. (2021). *Journal of Transport Geography* 94: 103087. https://ideas.repec.org/a/eee/jotrge/v94y2021ics096669232100140x.html \[TO VERIFY: title\]

Wooldridge, J. M. (2023). Simple approaches to nonlinear difference-in-differences with panel data. *Econometrics Journal* 26(3): C31–C66. https://ideas.repec.org/a/oup/emjrnl/v26y2023i3pc31-c66..html

### Chinese-language sources

周家右 (2013). NTU master's thesis on planned Taichung MRT/BRT stations and house prices. https://tdr.lib.ntu.edu.tw/handle/123456789/16989?locale=en \[TO VERIFY: title\]

廖庭誼 (2023). NCCU master's thesis on 環狀線 and rents. https://thesis.lib.nccu.edu.tw/detail/d9a10990bde6b090cddf13bd9b8e9570/ \[TO VERIFY: title\]

劉永祥 (2020). 桃園機場捷運通車前後對場站周邊土地使用發展及旅運行為影響之研究. NCCU master's thesis. https://thesis.lib.nccu.edu.tw/detail/91df35a23d2dcb1ed0d846ded1d96018/

張耀庭 (2021). 捷運、經濟弱勢與工作可及性. NTU master's thesis. https://www.airitilibrary.com/Article/Detail/U0001-0407202121461000 \[TO VERIFY: author name\]

汪志忠、王俞翔 (2013). 高雄捷運通車前後捷運路線周邊餐飲零售業商店數目的變化. 國家與社會 14: 223–262. https://lawdata.com.tw/tw/detail.aspx?no=218919

翁君宜 (2016). 捷運對雙北市連鎖店區位選擇之影響. Tamkang University master's thesis. https://www.airitilibrary.com/Publication/Index/U0002-2706201602281400

楊舒涵 (2017). 捷運對商業縉紳化之影響. NTU master's thesis. https://tdr.lib.ntu.edu.tw/handle/123456789/67166?locale=en \[TO VERIFY: title characters\]

藍聖杰 (2018). NCCU master's thesis on 機場捷運 and 林口 house prices. https://thesis.lib.nccu.edu.tw/thesis/detail/283ad22d05370d3fea0412ae1a2d7c4e \[TO VERIFY: title\]

鄭智翔 (2024). 交通建設對附近房價的影響－以桃園機場捷運A21環北站為例. NTU master's thesis. https://tdr.lib.ntu.edu.tw/handle/123456789/92040?locale=en

### Data sources

內政部地政司. 村里界歷史圖資, 114年. data.gov.tw 130549. 政府資料開放授權條款 v1.

內政部戶政司. 村里 and 鄉鎮市區 household-registered population. data.gov.tw 8411, 32973. 政府資料開放授權條款 v1.

內政部. 實價登錄 (不動產成交案件實際資訊). 政府資料開放授權條款 v1. \[TO VERIFY: dataset id\]

經濟部商業發展署. Company and business registry. 政府資料開放授權條款 v1. \[TO VERIFY: dataset ids\]

Station data. \[TO VERIFY: source and licence\]

R package `did`, version 2.5.1, CRAN, 2026-07-08.
