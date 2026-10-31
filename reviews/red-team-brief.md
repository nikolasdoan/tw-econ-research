# MRT pilot: stage-5 red-team brief

Date: 2026-10-31. Binding plan: pre-registration v2.1 ("MRT pilot: pre-registration v2", rev 24). Background: "MRT pilot: literature review".

## 1. Your job

Try to break the primary result. Work alone, as a sceptical expert referee who also writes code. A clean "holds" is a valid outcome. So is "breaks". Do not aim for either.

The study asks: did new MRT and light-rail stations (機捷 A1–A21, 淡海 綠山, 環狀 phase 1, 淡海 藍海, 安坑, and the 機捷 A22 infill) raise new business registrations per 1,000 residents in 村里 within 500 m, against 村里 with no station?

## 2. Independence rules (non-negotiable)

- Write all code from scratch, in your own folder. Use R or Python.
- Never open, request or read the project's analysis code (`/home/user/mrt-code/code/`).
- Never open its outputs (`/home/user/mrt-code/out_*`, `run_*.log`, or any results table, figure or log) until you have submitted your report.
- Do not ask the project team what number they got. You may ask about the data or the plan's wording.
- After submission you may compare. Any change made after seeing their numbers goes in a separate, dated addendum.

## 3. Data rules

- Use only the delivered data files: aggregated 村里 × quarter counts and the other files listed in the manifest, under open licences (政府資料開放授權條款 v1 or equivalent). The manager will name the folder.
- Never fetch the company or business registry yourself.
- Never fetch anything from twse.com.tw or tpex.org.tw.
- Never name a sole proprietorship (獨資) or partnership (合夥), even if a small cell seems to reveal one. Report counts, not firms.
- Optional known-answer test: `/home/user/mrt-code/synth_effect/` and `/home/user/mrt-code/synth_pretrend/` are synthetic sets with a `truth.json`. You may use them to check your code recovers a known effect. They are not the real data.

## 4. What is pre-registered (your reference spec)

- Unit: 村里 on the 114年 boundary vintage, aggregated to units stable since 2011. Geometric centroid. Straight-line distance to nearest station.
- Groups: T = within 500 m of a study station. F = 2,000–5,000 m from every study and 綠線 station. G = within 500 m of a 桃園綠線 planned station. Exclusions as in plan §3.
- Outcome: registrations (公司 + 商業, branches excluded) per 1,000 residents per quarter, in levels. Denominator: 村里 end-2012 population, or the district fallback (§4).
- Estimator: Callaway & Sant'Anna, not-yet-treated control with F and G coded never-treated. G rows dropped from 2023Q3. Anticipation 12. Universal base k = −13. No covariates. Outcome regression. Equal 村里 weights.
- Primary statistic: dynamic aggregation over identified post cells, e = 0 to 11. Cells need ≥ 30 comparison 村里.
- Inference: Ferman–Pinto. 5 treated line clusters (A22 separate). District comparison clusters. Variance a + b/n_c. 9,999 draws. Two-sided.
- "Effect is real" needs: p < 0.05; no kill rule (K1, K2a, K2b, K3a, K3b); positive without 2020–22 (R1); positive with survivorship correction (R17); breakdown ratio r outside 0.8–1.25.

## 5. Required checks (plan stage 5)

Run each. Report the number, an interval or p where it makes sense, and a verdict.

**5.1 Placebo stations.** Re-run K3a as written (G with fake k = 0 at 2020Q1, F as comparison, anticipation 0). Then go further: draw at least 500 sets of fake stations at random points along non-rail arterial roads in the three cities. Match the real station count per city. Keep each fake station ≥ 2 km from any real or planned station. Give them the real cohorts' dates. Build the primary statistic for each set.

**5.2 Placebo dates.** Re-run K3b as written (fake k = 0 at real k = −16). Then assign many fake dates: every feasible pre-period quarter shift that keeps the fake post window inside real pre-opening data. Also give G fake dates across 2014–2020.

**5.3 Rings.** Treat 300 m, 500 m and 800 m as the treated radius (R8). Also estimate 500–800 m and 800–1,500 m rings against F (R7). Look for a sensible decay. A ring effect larger than the core is a warning.

**5.4 Without 2020–22.** Drop 2020Q1–2022Q4 for all units (R1). A22 uses 2019Q4 as base. Report the cohorts left in each event time. Also R2a (drop 環狀) and R2b.

**5.5 Survivorship bound.** Build the district survival correction from the closure file yourself (R17). Compute the breakdown ratio r. Then do a harsher bound: let treated-firm survival differ from comparison survival by 10%, 20% and 30%, with age-dependent hazards (young firms close more). Say where the sign flips.

## 6. Additional adversarial checks

**6.1 Independent re-implementation.** Rebuild the primary estimate from raw files: distances, groups, exclusions, denominator, cells, C&S. Report your point estimate, the identified cell list and N₀. If you can, check with a second estimator coded by hand (2×2 averages per cohort and event time). A gap of more than 10% of the estimate, or a different set of identified cells, is a finding.

**6.2 Permutation distribution.** From 5.1 and 5.2, plot the distribution of the primary statistic across fake openings. Report where the real estimate sits (rank-based p). This is an inference check that does not use Ferman–Pinto.

**6.3 Inference calibration.** Background: a synthetic test suggested the pre-registered Ferman–Pinto implementation may under-cover, because treated cohorts share a single universal base quarter (k = −13) and so share base-period noise. Test this yourself. Use the real comparison data. Assign fake cohorts to comparison districts, with the real cohort timing and cluster sizes, so the true effect is zero. Run at least 1,000 replications. Report:
- false-rejection rate of the primary test at 5% (target 5%; worry above 7.5%);
- false-kill rate of K2a at 10% and of K2b (how often each fires under no effect and no pre-trend);
- the same for the wild bootstrap check (R20) and district-level treated clustering (R27).
If you can, add a version with a modest true effect to report power.

**6.4 Relocation bias.** The registry uses current address. Compare pre-period counts in T with F. Use the 遷址 flag if delivered (R26). Show the share of firms with any 遷址 record by group and cohort. A pre-period that is high in T, falling toward opening, fits back-dated movers.

**6.5 Development zones.** Exclude 村里 touching 林口特定區, 淡海新市鎮, 高鐵桃園站特定區 and 桃園航空城 (R24). Report line by line.

**6.6 Leave one line out.** Drop each line in turn (R3). Report point estimates. If one line drives the sign, say which.

**6.7 A22 infill.** Report A22 alone. Then the primary without A22.

**6.8 Fare start vs public opening.** Recompute k = 0 from fare-start dates (R19). It moves 環狀, 藍海 and 安坑 by one quarter.

**6.9 Denominator.** Run with the first-choice denominator and the district fallback, if both can be built. Also with R22 (drop 機捷 and 綠山).

**6.10 Small cells.** If counts of 1–2 are suppressed, impute at both ends (R16), and also at 0 and 2. Impute 公司 and 商業 separately.

**6.11 Anything else you think matters.** Examples: R4 (anticipation 8), Poisson on counts, population-weighted centroid, Sun–Abraham, imputation estimator, HonestDiD bounds.

## 7. Your pass/fail criteria (set before you look at results)

Write your own criteria in your report's first section, dated, before you run anything on outcome data. Use these as defaults unless you justify a change:

- **Holds:** same sign as the primary, at least 50% of its size, and the check's own test (if any) passes.
- **Weakens:** same sign but below 50% of the size; or the interval now includes zero; or a placebo statistic exceeds the real one in more than 5% (but at most 10%) of draws.
- **Breaks:** opposite sign; or a placebo test fires by the plan's K3 rule; or the real estimate sits below the 90th percentile of the placebo distribution; or the primary test's false-rejection rate under no effect exceeds 10%; or your independent primary estimate differs in sign or by more than 25%; or r falls inside 0.8–1.25.

A "breaks" on 6.3 is about inference, not the estimate. Say so plainly.

## 8. Reporting rules

- Plain English. Short sentences. Define every symbol once.
- Anything not in the pre-registration is labelled **exploratory**, in every table and in the text. Checks in §5 that repeat the plan (K3a, K3b, R1, R7, R8, R17) are confirmatory; their extensions are exploratory.
- Report every check you ran, including failed or abandoned ones. No selective reporting.
- Report your spend: tokens or API cost, compute time, and wall-clock time.

## 9. Deliverables

1. `/home/user/mrt-code/redteam/report.md`: your criteria (§7), then a table with one row per check: check, number (with interval or p), interpretation (one or two sentences), verdict (holds / weakens / breaks). Then a short overall verdict. Then spend.
2. `/home/user/mrt-code/redteam/code/`: all your code, a README saying how to run it, and package versions. Code must run end to end from the delivered data folder.
3. Figures in `/home/user/mrt-code/redteam/figures/`: at least the permutation distribution (6.2) and the calibration rejection rates (6.3).

Do not publish anything. Hand the report to the project manager only.
