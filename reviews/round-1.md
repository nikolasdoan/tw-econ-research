# MRT pilot (D280): review round 1

- Document reviewed: `paper/mrt-pilot-design-note.pdf` ("MRT pilot: a design and power note"), with `paper/working-paper-draft-doc.md` where it bears on the note.
- Repository: nikolasdoan/tw-econ-research, commit `fba3289` on main, plus the pre-outcome bundle on branch `data-pre` (`5869460`).
- Date: 2026-10-31.
- Panel: six independent referees. Each saw only the paper, the pre-registration, the code and the data, and its own brief. None saw `notes/`, `reviews/`, `CLAUDE.md`, the claude.ai docs or another referee's report. Referees ran one at a time, to keep to the project's two-agent limit.

## Decision

**Major revision** of the design note.

On H1 itself there is nothing to accept or reject. The study stopped under its own rule. The D5 rerun of the simulation gate failed one hard limit (D6), so no outcome file may be opened for H1. Referees 1 and 4 checked this independently. Referee 4 reran all 2,600 D5 gate seeds and all D2 gate seeds from a clean checkout and matched every seed exactly. The verdict follows D5 as written. It was not bent either way. That stop stands. Any paper that estimates H1 on this design would be rejected.

The note is the product the protocol requires after that stop. Its account of the simulations is accurate: every number in every table reproduces from the committed files. But its main design claims do not hold as written:

1. The "full decision rule" leaves out the registered sign and r* ≥ 1.25 conditions. With them, the claim rate at +17% is 1%, not 57.5%.
2. The power numbers describe a synthetic layout with about 1.2 to 1.7 times as many treated 村里 as the real stations give. The real-layout facts (Appendix A) were required by D6. The bundle that holds them was committed an hour before the note.
3. The note leaves out D5's any-kill limit, which passed at exactly 25.0%. It misstates the other D5 limits.

None of these is fatal, because the note's central statement survives all of them: H1 was not tested, and the note is not evidence for or against it. Everything that must change can be fixed without opening any outcome file.

## Findings by severity

- Fatal: 0. (One referee rated M1 fatal; see Disagreements.)
- Major: 17 merged findings (M1–M17).
- Minor: 22 merged findings (m1–m22).

## Required changes, ranked

Each row names the referees who raised the point. Full wording, evidence and code lines are in the appendix.

### Major

| # | Finding | Where | Raised by | Fix | Check that shows it fixed |
|---|---|---|---|---|---|
| M1 | Appendix A is missing. The note says the pre-outcome bundle "has not arrived", but `data-pre` (5869460) was committed at 01:59 UTC, 67 minutes before the note (03:07). D6 item 5 requires design facts from pre-outcome files. Rough passes over the bundle find about 58–81 treated 村里 against a synthetic median of 96–99. 淡海 may fall below 5 per line, and 環狀 may carry about 60% of the weight. `appendixA.R` does not run on the bundle (schema mismatch), and it would stop on the 112 undated stations. So the MDE and claim rates do not describe this study. | §5, §6, Table 1 (D4) | R2 (fatal), R4 (major), R1 (minor) | Fix the schema, run Appendix A on `data/pre`, commit it as D4 with input hashes, and restate the §5 power numbers on the real layout, or say plainly that they do not apply to it. | `appendixA.R` runs to completion on 5869460. D4 exists. The note reports T per line, K1, N₀ and the cells. |
| M2 | The "full decision rule" is not the registered rule. It uses p < 0.05 and no kill rule only. It leaves out a positive estimate, r* ≥ 1.25 (D2 change 6), R1 > 0 and R17 > 0. With sign and r* added, claim rates at τ = 0.1–0.5 are 0.0 / 1.0 / 17.0 / 42.5 / 67.0%, against the note's 18.0 / 57.5 / 75.5 / 73.0 / 75.0%. Under the null the rate is 0.0%, not 2.2%. In this DGP r* ≈ 1 + τ/1.2, so the registered rule cannot call an effect below about +25% real. Three referees got the same numbers independently. | Abstract; §4 Result A; Table 4; Figure 1; §5 MDE; `note_tables.py` `claim` | R1, R2, R4 | Relabel the current column "partial rule". Add a column with the registered rule. State that R1 and R17 were not simulated, so the rates are upper bounds. Rewrite the abstract and Result A. | Table 4 has the new column with the numbers above, reproducible from the committed CSVs, and the abstract matches it. |
| M3 | The power and MDE claims lack the conditions that matter. The test over-rejects (7.0% at nominal 5%). The power DGP has no line × quarter shocks; with the stress-run shocks, the 80% point moves to about +24–29%. The +20% is relative to an assumed base of 1.2 with no source. It is not size-adjusted, it is interpolated from two 200-seed points, and it has no range. | Abstract; §5; Table 4 | R1, R3, R6 | Give the MDE as a range, say it is not size-adjusted, and state the base-rate, Poisson and no-line-shock conditions in the abstract. Add the stress-world figure. | The abstract carries the same caveats as §6, and every p1 number has an SE or range. |
| M4 | The note misstates the D5 limits. It says round 4 "used the same limits". D5 dropped the stress rejection floor and the per-rule stress limits, and added effect any-kill ≤ 25%. That limit passed at exactly 25.0% (50 of 200 seeds), and the note does not report it. Under the limits the note states, round-4 stress rejection of 2.0% would fail, yet it is not bolded. | §3 "Limits"; Table 3 | R1, R4, R6 | Copy the D5 limit table verbatim (limit × scenario), flag the boundary pass, and bold Table 3 by the limits actually in force. | The limits text matches `deviations.md` D5 row for row, and every bold cell, and only those, breaks a listed limit. |
| M5 | Finding 2 is called a "probable mechanism for the D5 failure". The note's own paired power runs contradict it. Half-width/SD is 1.93–1.98 at τ = 0.1–0.4, above the null's 1.90. The mean half-width is flat across τ. Coverage is 94.5% at τ = 0.1–0.3. The null itself under-covers (1.87–1.90). The abstract states the finding more firmly than the body. | Abstract; §4 Finding 2 | R1, R6, R3 | Report the τ = 0.1–0.4 ratios and the null under-coverage. Call Finding 2 a conjecture, as Finding 1 is, and remove "probable" from p1. | Finding 2 cites the 1.93–1.98 ratios, and p1 and §4 use the same hedge. |
| M6 | The pre-trend checks are incompletely described. The pre-trend scenario's slope (0.04 per quarter) gives a spurious effect of +0.72, 1.4 times the τ = 0.5 effect. Detection is shown only at that size. Under it the rule still claims an effect in 11.0% of seeds (2.0% in round 2). K2a fires 8.2% and K3a 17.2% under the null, at nominal 5% and 10%. Only K2b's mis-sizing is disclosed. Tightening K2a and K2b in D5 cut detection from 98% to 89% and raised false claims from 2% to 11%; the note shows the first change but not the second. Result A partly measures this miscalibration. | §3 Table 3 pre-trend rows; Glossary | R1, R3 | State the slope and the bias it produces, the claim rate under pre-trend, the K2a and K3a sizes, and the trade-off. | Table 3 pre-trend rows show bias 0.72 and claim 11%, and the text names the K2a and K3a sizes. |
| M7 | Survivorship is not bounded and not mentioned. The named source (data.gov.tw 9400) says it covers operating firms only, so it cannot supply closures or the founding dates of closed firms. Table 2's "registrations and closures" from 9400 is wrong. The draft names a different publisher. In the R17 code, A counts only firms registered since 2011 while C counts all closures, so early quarters are over-corrected. The DGP has no survivorship, so no simulation shows its effect. | Table 2; v2.1 §8; `analysis_v3.R` 216–241 | R2, R5 (minor) | Name a source that holds closed firms with founding dates. Correct Table 2. Add survivorship to §6. Build A from all firms alive at m. | The dataset page lists closure records, and a synthetic test with known survival thinning recovers τ under R17. |
| M8 | COVID is neither modelled nor disclosed. The DGP applies the same 0.85 shock to every 村里, which the DiD removes exactly. 環狀 opened in 2020Q1 and is the largest real cohort. R1, a condition for calling an effect real, would rest on about 19 treated 村里, below K1's 30. Its power was never computed. | §6; `synth.R` 64; `sim_gate_v3.R` 36 | R2 | Say in §6 that COVID coincides with the largest cohort and that the gates did not test an area-specific shock. Give the R1 treated count from Appendix A. | §6 names COVID, and Appendix A reports the R1 counts. |
| M9 | The record cannot show that real data did not shape the base rate. The note and D1a say 1.2 was written into `synth.R` at 01:27 UTC, before the totals reached the team at 01:51. In git, 1.2 first appears at f56e15b (02:04), and the session log is not committed. D1's total gives 1.23–1.25 per 1,000 per quarter over the 臺北 + 新北 + 桃園 population, within about 3% of 1.2, if the export covers those three cities. The base rate drives the percentages and r*. | §2; D1a | R2, R4, R6 | Commit a timestamped extract that a third party can verify, or say 1.2 may have been informed by D1. Report results at other base rates (e.g. 0.8 and 1.6), and state the export's geographic scope. | There is a checkable artefact dated before 01:51, or the note discloses the risk and shows the sensitivity. |
| M10 | The data described differ from the data used, and the changes are not logged. Boundaries come from NLSC 115年 (data.gov.tw 7438), not the registered 114年 (130549), and there is no crosswalk. The population files force the fallback 2015-share route. 227 村里 have no 2015 population, including five within 500 m in new towns; exclusion 3 drops them, so treated units are removed in step with growth. Opening dates come from Wikidata, not the cited sources. 112 stations are undated, including 機捷 A11–A22. Only 13 綠線 stations are present, which risks misclassing G as F. TDX and the MOI district table are used but not named, and their licences are unverified. | Table 2; `data/pre/MANIFEST.md`; `deviations.md` | R2, R4, R5 | Log the vintage and denominator-route deviations. Build the crosswalk. Handle blanks by crosswalk, not exclusion. Date the 112 stations and complete 綠線 from an official source. List every source actually used, with its dataset id and a quoted licence. | Every file in `MANIFEST.md` maps to a row in the note's table. D-entries exist. Appendix A reports zero treated units dropped for missing population. |
| M11 | Unlogged deviation in the gated code: the G group leaves the pool one quarter early. `gv = G_CUTOFF + ant − 1` makes G valid only to 2023Q1. v2.1 §3 registers 2023Q2. Every gated simulation used this. Under R25, the registered identified cells 藍海 k = 10 and 安坑 k = 1 would have no comparison. The `did` cross-check leaves G out, so it could not catch this. | `lib_v3.R` 162; `analysis_v3.R` 104, 177; `lib_v2.R` 134 | R4 | Set gv to `G_CUTOFF + ant`, or log a deviation and say whether the gate result depends on it. | G is valid at 2023Q2 and not at 2023Q3, and the R25 cells match v2.1 §5. |
| M12 | The note claims findings that are not new, and it has no reference list. Finding 2 is a known limit of placebo inference built from untreated controls (Conley–Taber 2011; Ferman–Pinto 2019; Alvarez–Ferman 2023). Finding 1 restates the requirement that the placebo statistic be built exactly like the treated one. Result A follows from four oversized pre-tests. | Abstract; §4; whole note | R3 | Add a related-work paragraph and a reference list. Present the findings as applications of known limits. | Each finding cites its prior work, with one line on what the note adds. |
| M13 | The draft has citation errors. Three author names are wrong: 廖庭誼 should be 廖倉淯, 翁君宜 should be 翁嘉駿, and 張耀庭 should be 張芸端. The 廖 thesis's link to COVID is overstated. Giuliano, Schuetz and Shin (2016), listed under the wrong first author, also find later employment gains, which the draft leaves out. Credit's "per acre" and "1-mile network buffer" could not be verified. | `paper/working-paper-draft-doc.md` §2 and references | R3 | Correct the names against the library records, and restate each claim as its source gives it. | Each name matches its record, and each claim has a page reference. |
| M14 | Method text crosses the "sources, never methods" rule. The draft (lines 253, 423), the pre-registration (v2 lines 156, 256–262, 331) and `code/stage3-prep.md` line 392 describe which address field places a firm and how relocations are assigned. The note itself is clean. | Draft §5, §9; pre-registration; `stage3-prep.md` | R5 | Cut the address-timing and relocation text from the draft, or reduce it to one neutral limitation line. Flag, but do not edit, the committed pre-registration. | A search of the draft and note for "address", "地址", "遷址" and "current address" finds nothing that describes placing firms. |
| M15 | The note has no AI-use statement and no named responsible author. The byline is "@Niko" only. Nowhere does it say that AI wrote the note, the plan and the code, or that the pre-registration's signing reviewer was an AI session. The draft's AI paragraph cites an unnamed "human economist". The draft's exposure paragraph contradicts D1a. | p1; §6–7; draft line 437, 441 | R5, R6 | Add an AI-use paragraph on p1: Niko (段皇方) as the responsible author, who or what wrote each part, and that the signing reviewer was AI. Correct the draft's exposure paragraph. | The note has the statement, and the "human economist" is named or removed. |
| M16 | Internal references reveal infrastructure. "bizmap #205" (another project's ticket), "M1 machine", "cloud manager" and "data builder" appear, along with claude.ai asset IDs in the PDF. | Note §2, p14; `deviations.md` D1 | R5 | Remove "bizmap #205" and the asset IDs, and describe the export neutrally. | A search for "bizmap" and "#205" finds nothing outside git history. |
| M17 | A policy reader cannot follow p1. It uses "D2 gate", "kill rules", "K2a", "r*" and "MC SE" before defining them, and "D2" for two different things. It has no plain-language takeaway. The primary estimand (12 quarters, or k = 0–3?) is never stated. | p1; §1; Glossary | R6 | Add a two-sentence plain lead: "we do not know whether MRT openings changed business formation; this note says how a later study should be built". Gloss each term at first use, and state the estimand once. | A reader with only p1 can say what was and was not learned, and every symbol is defined on or before its first page. |

### Minor

| # | Finding | Raised by | Fix |
|---|---|---|---|
| m1 | Result B's 3.9% is correct (−0.0194, SE 0.0016) but is the increment at τ = 0.5 in one synthetic world. Total bias is 5.3%, and 5.0–7.5% in the power runs. | R1, R3 (major) | State the scope and both numbers. |
| m2 | Result A's range "73.0–76.0%" includes a run not in Table 4. The range is 73.0–75.5%. "22–27%" is not traceable to any table. | R1, R6 | Use 73.0–75.5%, and add any-kill by τ to Table 4. |
| m3 | "80% power is never reached" goes beyond the runs, which stop at τ = 0.5. | R1 | Say "not reached for τ ≤ 0.5". |
| m4 | The gate tests homogeneous, constant effects only: no anticipation, no spillover, no heterogeneous dynamics. | R1 | Add this to §6. |
| m5 | A valid method fails some of about 20 limits by chance. "Bias ≤ 0" fails about half the time for an unbiased estimator. | R1 | State the whole-gate false-fail chance, and note the defect. |
| m6 | `note_tables.py` reads uncommitted paths and does not run from a clean checkout. pandas reads "null" as NaN unless `keep_default_na=False`. | R1, R4 | Read the committed combined files. |
| m7 | `sim_power.R`, the round-3 diagnostic and the Figure 1 script are not committed. Referee 4 rebuilt the first two to matching hashes. | R1, R4 | Commit them. |
| m8 | Round 1 can be recomputed from `analysis-code-v1.md` lines 97–103. | R4 | Cite it. |
| m9 | The D2 gate was run twice on the same seeds to store p-values, and the note does not say so. | R4 | Disclose it. |
| m10 | Git shows the D5 seeds only at 8962b74, after D6. Their prior fixing rests on a claude.ai doc. | R4 | Say so in the note. |
| m11 | §7 quotes the referee's rulings word for word, but `deviations.md` holds paraphrases. | R4 | Commit the rulings verbatim, or drop the claim. |
| m12 | The primary statistic uses the authors' own engine, not the registered `did::aggte`, and this is not logged. The 11–12-digit match excludes G. | R4 | Log it, and include G in the cross-check. |
| m13 | "Clusters floored" counts comparison districts. | R4 | Fix the label. |
| m14 | There is no registered rule for missing months or quarters. The code fills closures with 0 and h with a 2013 mean. | R2 | Register a rule before any opening, and disclose it. |
| m15 | All six opening dates match public pages. Only 機捷 has a government open-data row, and it gives the fare-start date. | R2 | Say which dates rest on news or operator pages. |
| m16 | `.gitignore` excludes `*.tgz`, so git cannot rule out local access to the export. §2 says "requested" where v2.1 §10 did request a population series. | R2, R5 | Correct the wording, and state where the export was kept. |
| m17 | Foreign effect sizes (Delhi 143.5%, Beijing 53.8%) appear without their design caveats. The smallest attainable p needs a citation. | R3 | Keep them out of any abstract, and cite Conley–Taber or Hagemann. |
| m18 | Table 3's round-1 row puts counts and text in rate columns. Ranges are not labelled by scenario. "σ²_j" appears as "sigma2_j" in Figure 1. The table breaks mid-round. | R6 | Move round 1 to a note, give one scenario per row, and use one notation. |
| m19 | Figure 1 has no legend, no error bars on the claim line, and no MDE marker. | R6 | Add line labels, bars and a mark at 0.24. |
| m20 | Captions are orphaned (Tables 1 and 5), and p9 is two-thirds blank. | R6 | Keep each caption with its table. |
| m21 | Table 1 has no commit times, and D1a (the latest entry) appears second. File paths and asset IDs cannot be followed from the repo. | R6 | Add times and repo paths, and put the hashes in one appendix table. |
| m22 | Repetition: "untested" is said 4 times, Result A 4 times and MC imprecision 4 times. §7's quotes repeat Table 5. | R6 | Say each once. Move process history to an appendix. |

The editor also noted one point: `deviations.md` has no D4 entry. The note says D4 is reserved for Appendix A, which matches M1.

## Disagreements between referees

1. **How severe is the missing Appendix A (M1)?** R2 rated it fatal, R4 major and R1 minor. **Settled: major, ranked first.** The note's central claim, that H1 is untested, does not depend on it. The simulation results it reports are accurate. But its design numbers describe a layout the real stations do not give, and D6 required the real facts. The fix needs no outcome data. That makes it a major revision, not a reject.
2. **How severe is Result B's 3.9% (m1)?** R3 rated it major, R1 minor. **Settled: minor.** R1 and R4 both reproduce the number exactly. Only its scope wording is at fault, and M3 already covers the base-rate dependence.
3. **Is Finding 2 a wording problem or an evidence problem (M5)?** R6 and R3 treat it as wording. R1 shows the paired power runs point against the mechanism. **Settled with R1:** the evidence does not support "probable".
4. **Are the methodological findings new (M12)?** Only R3 assessed novelty. R3 read the abstracts of Conley–Taber, Ferman–Pinto and Alvarez–Ferman, but not Hagemann or Canay–Romano–Shaikh. **Partly open.** The note must cite this literature in any case. Whether any part of Findings 1 and 2 is new is left for the authors to argue, with citations.
5. **Was the gate verdict right?** No disagreement. R1 and R4 agree that it follows D5 as written. R1 (m5) and D6 itself note that the gate's design made a narrow miss partly luck. That does not change the verdict.

## What would end round 2

- M1, M2, M4 and M11 are resolved with checks a referee can run from the repo.
- The abstract matches the body (M3, M5, M17).
- The rules points are fixed (M14, M15, M16).
- No outcome file is opened at any point. Any revision that opens one breaks D6.

## Spend

Each figure is computed from that referee session's token counts at list prices: input, output, cache reads and 1-hour cache writes. The editor's own session is not included, because its cost could not be measured from inside the session.

| Referee | Model tier | Output tokens | Cache-read tokens | Cost (US$) |
|---|---|---|---|---|
| 1 Identification | larger | 40,740 | 2,511,382 | 2.47 |
| 2 Data | larger | 28,828 | 3,964,628 | 2.23 |
| 3 Literature | smaller | 15,381 | 984,583 | 0.80 |
| 4 Replication | larger | 48,993 | 6,756,990 | 3.40 |
| 5 Rules | smaller | 9,476 | 1,014,529 | 0.73 |
| 6 Writing | smaller | 12,800 | 685,017 | 0.42 |
| **Total** | | | | **10.06** |

That is well under the US$200 cap for the round.

---

# Appendix: full referee reports

The reports below are as each referee returned them, unedited.


## Referee 1

REFEREE 1 REPORT: identification and econometrics
Document: paper/mrt-pilot-design-note.pdf (rev 20, commit fba3289)

Checks run before the findings:
- The SHA-256 hashes of note_tables.csv, note_tables.py, note_d2_power_seeds.csv, power_summary.csv and gate_v3_all_seeds.csv all match the note.
- I recomputed every round 2–4 and power figure from the per-seed CSVs. My script is /tmp/claude-0/-home-user-tw-econ-research/15c9aa58-7fc5-50ac-8a34-af445421a637/scratchpad/r1/rec.py. All of the note's figures reproduce.
- No registration, closure or price file appears anywhere in the repo history (git log --all --name-only). Whether anyone opened such a file outside the repo: could not verify.
- I checked every D5 hard limit against the recomputed numbers. The gate fails by the rules as written, and only on unsuppressed effect coverage: 91.5% with σ²_j on, against a limit of 92.5%. The verdict was not bent.
- Actual pre-trends, the real comparison group and real staggered timing: not applicable, because no outcome data was opened. The note makes no claim about real data that would need these checks.

---

R1-1. MAJOR. The "full decision rule" is not the registered decision rule. Its omission changes the meaning of Result A and of the MDE. (Abstract; §4 Result A; §5 Table 4, Figure 1 and the MDE paragraph; note_tables.py, the `claim` line.)
- **What the note does.** The abstract and §5 call "p < 0.05 and no kill rule" the "full decision rule".
- **What the registered rule says.** v2.1 §1 has five conditions:
  - a positive estimate;
  - no kill rule;
  - R1 positive;
  - R17 positive;
  - the breakdown ratio condition. D2 Change 6 replaced it with r* ≥ 1.25, and the note's own glossary states that rule.
- **How the code scores a claim.** note_tables.py counts `claim = (p<0.05) & ~any_kill`. It counts negative significant estimates as claims too: 0.8 of the 2.2 points under the null.
- **Recomputed with the positive-sign and r* ≥ 1.25 conditions added** (R1 and R17 are not simulated, so these are upper bounds). Seeds: 91001–91200 for τ = 0.1–0.4; D5 effect run with σ²_j on for τ = 0.5.

  | τ | Note's claim rate | With sign and r* ≥ 1.25 | MC SE (points) |
  |---|---|---|---|
  | 0.1 | 18.0% | 0.0% | — |
  | 0.2 | 57.5% | 1.0% | 0.7 |
  | 0.3 | 75.5% | 17.0% | 2.7 |
  | 0.4 | 73.0% | 42.5% | 3.5 |
  | 0.5 | 75.0% | 67.0% | 3.3 |

- **The r* condition fails often.**
  - Share of seeds with r* < 1.25: 100%, 97%, 77%, 43% and 13.5% for τ = 0.1 to 0.5.
  - In this data-generating process (DGP), r* ≈ 1 + τ/1.2. So the rule cannot call an effect below about +25% real.
- **Why it matters.**
  - For τ ≤ 0.4 the binding cap on a claim is r*, not the kill rules.
  - The primary-test MDE of "+20%" sits below the size the decision rule can ever call real. At τ = 0.2 the claim rate is 1%.
  - Result A ("the kill rules jointly cap the chance of a claim at about 75%") describes the kill rules alone. The abstract presents it as "the chance of a claim".
- **Fix.**
  - Score claims under every condition that can be simulated: sign, kill rules and r*.
  - Say that R1 and R17 were not simulated, so the rates are upper bounds.
  - State the r* floor in the abstract and in §5.
  - Relabel the current column "p < 0.05 and no kill rule (partial rule)".
- **Check.** Table 4 gains a column reading 0.0 / 1.0 / 17.0 / 42.5 / 67.0%, and the abstract wording matches it.

R1-2. MAJOR. Finding 2 is called a "probable mechanism for the D5 failure". The note's own power runs, which it does not cite here, contradict that rating. (Abstract; §4 Finding 2.)
- **The note's evidence.** It compares only the null (half-width/SD 1.90) with τ = 0.5 (1.71).
- **The power runs say otherwise.** These are paired: the same seeds 91001–91200 at every τ.
  - Half-width/SD is 1.98, 1.96, 1.94 and 1.93 at τ = 0.1–0.4. All are above the null's 1.90.
  - Coverage is 94.5% at τ = 0.1–0.3.
  - The mean half-width is flat at 0.149–0.150 at every τ, null included.
  - The ratio falls at τ = 0.5 only because the estimate's SD is higher on the two τ = 0.5 seed sets: 0.083–0.087, against 0.0755–0.0775 at τ = 0.1–0.4.
- **The size is far below what D6 asserts.** Within the paired runs the ratio falls only about 2.5% from τ = 0.1 to 0.4 (+8% to +33%). D6 asserts "about 10% narrow under a 40% effect".
- **Under-coverage exists with no treatment at all.**
  - Under the null, half-width/SD is 1.87–1.90 (below 1.96).
  - Null coverage is 93.0% with σ²_j on and 92.4% with it off.
- **The failure is unlikely to be pure seed luck.** Pool the unsuppressed τ = 0.5 runs: 186/200 on the D2 seeds and 181/200 on the D5 seeds with σ²_j off. That gives 91.75% (MC SE about 1.4). This pooling assumes the v2 and v3 primary intervals coincide when σ²_j is off; I could not verify that from code alone.
- **Fix.**
  - Report the τ = 0.1–0.4 half-width/SD ratios and the null under-coverage in Finding 2.
  - Rate the mechanism a conjecture, as Finding 1 is.
  - Remove "probable" from the abstract.
- **Check.** Finding 2 cites the 1.93–1.98 ratios, and the abstract calls both findings conjectures.

R1-3. MAJOR. The +20% MDE in the abstract holds only in a world with no line-wide shocks and an inference that failed the gate. The abstract states neither condition. (Abstract; §5.)
- **The test is oversized.** The primary test rejects 7.0% (MC SE 1.1) under the null with σ²_j on, and 7.6% with it off.
  - Size adjustment changes little. With the null's 5% critical p (0.035), power is 20.5%, 64.5%, 93.5% and 100%. 80% is reached at about τ = 0.25 (+21%).
- **The bigger problem is line shocks.** The power DGP has no line × quarter shocks, and five line clusters is exactly where those matter.
  - The stress run (line shocks with SD 10%) raises the estimate's SD from 0.079 to 0.104. It raises the σ²_j-on half-width from 0.150 to 0.240.
  - Rough 80%-power effect under that DGP: about 0.29 (+24%) for a correctly sized test, and about 0.34 (+29%) with the σ²_j-on intervals actually used.
- **Fix.** Qualify the abstract: "+20% in a world without line-wide shocks; roughly +24–29% with the stress scenario's shocks". Say that the test is the D5 inference, which failed the gate and over-rejects at 7%.
- **Check.** The abstract and §5 carry both conditions and the stress-world figure.

R1-4. MAJOR. The note misdescribes the D5 limits, and it hides a pass that sits exactly on a limit. (§3, the "Limits" paragraph after Table 3.)
- **The note says** round 4 "used the same limits" as round 2, plus two for the effect scenario.
- **D5 as written differs in three ways.**
  - Stress becomes "rejection ≤ 7.5% and coverage ≥ 92.5% with σ²_j on". There is no 3.0% floor and no per-rule kill limits for stress.
  - A new limit is added: effect any-kill ≤ 25%.
  - Effect coverage is tested on the unsuppressed run.
- **Consequences.**
  - Under the limits as the note states them, round-4 stress rejection of 2.0% fails the 3.0% floor. Table 3 does not bold it, so the table contradicts the text.
  - "Round 4 failed only on that last limit" is true only under D5 as written.
  - Effect any-kill is 25.0% (σ²_j on), exactly on the undisclosed ≤ 25% limit. It is 24.5% with σ²_j off.
- **Fix.** Reproduce the D5 limit table verbatim. Flag the 25.0% boundary pass.
- **Check.** The limits text matches deviations.md D5 row for row, and the bolding in Table 3 follows it.

R1-5. MAJOR. The pre-trend machinery is described incompletely. Its demonstrated power is for a violation far larger than any effect at issue. (§3 Table 3, pre-trend rows; Glossary K2a, K2b, K3a.)
- **The scenario's size is never stated.** sim_gate_v3.R uses a slope of 0.04 per quarter. That produces a spurious effect of +0.72 (60% of base; 1.4 times the τ = 0.5 effect). The 89% any-kill shows detection only at that size. Nothing shows detection of a pre-trend near the MDE.
- **Claims under that pre-trend are not reported.** Even with a +60% spurious effect, the rule as scored claims an effect in 11.0% (MC SE 2.2) of D5 pre-trend seeds. The figure was 2.0% in round 2.
- **The tests are oversized, and only K2b's problem is disclosed.**
  - K2a fires 8.2% (MC SE 1.2) under the null at nominal 5%.
  - The K2b tail fires 7.2% at nominal 5%.
  - The K3a placebo p-value is below 0.10 in 17.2% of null seeds at nominal 10% (D2: 17.4%). The note mentions only K2b's mis-sizing.
- **The 89% includes baseline false fires.** The null any-kill rate is 24%. K2a-or-K2b alone detects 87%.
- **D5's threshold change has a cost the note does not state.** Tightening K2a and K2b to 0.05 after the D2 gate cut pre-trend detection from 98% to 89% and raised pre-trend claims from 2% to 11%. The note shows the 98% → 89% drop but not the trade-off.
- **Fix.** State the slope and the bias it produces. Report the claim rate under the pre-trend scenario. Disclose the K2a and K3a sizes. State the 98% → 89% trade-off.
- **Check.** Table 3's pre-trend rows show bias 0.72 and claim 11%. The text names the size of K2a and K3a.

R1-6. MINOR. "The small-cell rule biases the estimate down by 3.9% of the effect" overstates how general the number is. (Abstract; §4 Result B.)
- **The number itself is correct.** Recomputed: the paired suppression effect is −0.0194 (SE 0.0016) on the D5 seeds and −0.0195 (0.0017) on the D2 seeds, which is 3.9% of τ.
- **But 3.9% is the increment, not the total bias.** The total bias under suppression is 5.3% of τ.
- **In the power runs the total suppressed bias is larger.** It is −0.0065, −0.0116, −0.0151 and −0.0298, which is 5.0–7.5% of τ. No unsuppressed counterpart exists for those runs.
- **It is one value of τ in one synthetic world.** The share of cells with counts of 1–2 depends on the assumed base rate of 1.2 and on the population distribution.
- **Fix.** "In this synthetic world at τ = 0.5, suppression lowers the estimate by 3.9% of τ; total bias with suppression is 5.3%."
- **Check.** The abstract carries the condition and both numbers.

R1-7. MINOR. "80% power is never reached" and "the decision-rule MDE does not exist for this design" go beyond the runs. (Abstract; §5.)
- The runs stop at τ = 0.5. The peak of 75.5% (MC SE 3.0) is 1.5 SE below 80%.
- K2b, K3a and K3b have conditions scaled to the estimate's size, so their fire rates need not stay flat at larger τ.
- Result A's range "73.0–76.0%" includes the unsuppressed run (76.0%). Table 4's range is 73.0–75.5%.
- (With r* included, R1-1, the conclusion holds up to τ = 0.5 even more strongly.)
- **Fix.** "Not reached for τ ≤ 0.5 (+42%)". Use 73.0–75.5%.
- **Check.** The wording and range match Table 4.

R1-8. MINOR. The gate never tests the staggered-timing problems that Callaway & Sant'Anna exists to solve. (§6 Limits; sim_gate_v3.R.)
- The effect is homogeneous across cohorts and constant in event time.
- There is no anticipation effect.
- The 500–800 m ring is dropped, so there is no spillover into the comparison pool.
- Bias from forbidden comparisons, heterogeneous dynamics and not-yet-treated units in their anticipation window therefore cannot appear. The coverage and power numbers hold only for homogeneous effects.
- §6 lists Poisson counts, independence and the shocks, but not this.
- **Fix.** Add this to §6.
- **Check.** The sentence is present.

R1-9. MINOR. The gate as a test: the note discusses luck for a single limit only.
- **The single-limit figures are correct.** Binomial failure probabilities of 4.4%, 14.9% and 32.7% verified.
- **But the gate has about 20 limits.**
  - A valid method also fails the null rejection band with roughly 2–3% probability.
  - It fails the stress coverage limit with about 4% probability.
- **"Bias ≤ 0" is a defective limit.** An unbiased estimator fails it about half the time from MC noise alone. D2's unsuppressed bias of +0.0003 would have failed it. The note reports the limit without comment.
- **Fix.** State the probability that a valid method fails the whole gate by chance. Note the defect in "bias ≤ 0".
- **Check.** One sentence in §6.

R1-10. MINOR. Recomputation needs undocumented steps. (§3 "Attached files"; code/note_tables.py.)
- note_tables.py reads gate/*.csv, gate_v3/*.csv and power/*.csv. None of these is in the repo. Only the combined CSVs are committed.
- Reading gate_v3_all_seeds.csv with pandas defaults turns the scenario value "null" into NaN. That silently drops 1,000 null rows. I used keep_default_na=False.
- sim_power.R is cited by hash only and is not committed.
- **Fix.** Commit a version that reads the committed files, and commit sim_power.R.
- **Check.** `python3 -I code/note_tables.py` reproduces note_tables.csv byte for byte from a clean checkout.

R1-11. MINOR. §5 says the data/pre bundle "has not arrived". The repo record does not support that.
- Branch data-pre (5869460) is timestamped 01:59:46 UTC, 67 minutes before the note's commit (03:07 UTC). When the team received it: could not verify.
- **A rough layout check from that bundle** (geometric centroids, no exclusions, approximate) finds about 81 村里 within 500 m of the four lines: 機捷 25, 淡海 6, 環狀 46, 安坑 8.
  - The synthetic world's median is 96–99.
  - 淡海's roughly 6 村里 are split across 綠山 and 藍海. That risks the minimum of 5 per line.
- So the synthetic layout may be optimistic, and R1-3's MDE more so.
- **Fix.** Correct the "not arrived" sentence, or date the bundle's receipt.
- **Check.** The §5 text agrees with the git record.

Not faulted:
- The gate-fail verdict (D6) follows D5 as written. Every other hard limit passes with σ²_j on.
- Finding 1 is properly rated a conjecture.
- The note's numbers for K2b's mis-sizing (25.0/23.0/26.5% tails; 7.2% at 5%) are correct.

Count: 0 fatal, 5 major (R1-1 to R1-5), 6 minor (R1-6 to R1-11).

## Referee 2

Referee 2 report: data and measurement. Pilot D280, "MRT pilot: a design and power note", fba3289.

What I checked: the note (PDF text), preregistration v2.1, deviations.md D1 to D6 and D1a, code (synth.R, sim_gate_v3.R, lib_v3.R, analysis_v3.R, appendixA.R), results/, paper/*.csv, the git history of all three branches, the data-pre bundle (5869460), and public sources (data.gov.tw 9400 and 96918, news pages for each opening date). I did not read notes/, reviews/ or CLAUDE.md.

Hashes: all four data files in the bundle match both SHA256SUMS and the SHA-256 table in MANIFEST.md. Each also matches the blob in commit 5869460. MANIFEST's row counts (370 / 3,542 / 3,542 / 121) and station groups (70 / 13 / 175 / 112) match the files.

**R2-1. FATAL. Section 5 (Appendix A) and section 6 say the pre-outcome bundle "has not arrived". It had: it was committed 66 minutes before the note.**
- Where: note section 5 ("the pre-outcome bundle (data/pre) has not arrived"); Table 1, D4 "not yet committed"; deviations.md D6, required item 5.
- Facts: commit 5869460 (branch data-pre) was committed at 2026-10-31T01:59:46Z ("Appendix A pre-data: stations, 村里 centroids, the population base"). The note commit fba3289 is 03:07:06Z. I could not verify when the branch was pushed.
- D6 item 5 requires "design facts from pre-outcome files only: Appendix A, power and the MDE". The note gives none of them. Every power number uses a synthetic layout with 67–129 treated 村里 (median 96–99), 6 balanced cohorts and N₀ of 38–39.
- My rough pass over the real bundle (centroid distances, exclusions 1–3 of §3, development zones not applied) gives a very different layout:
  - About 58 treated 村里 in total: 環狀 34, 機捷 7, A22 6, 安坑 6, 綠山 4, 藍海 1.
  - So 綠山 and 藍海 fall below the 5-per-line rule. The 淡海 cluster drops from the primary.
  - 環狀 carries about 60% of the treated weight.
  - About 33 F districts.
- So the MDE (about +20%) and the claim rates in Table 4 are not "design numbers" for this study. They describe a world with roughly 1.7 times as many treated units, spread evenly across cohorts.
- Fix: run Appendix A on data/pre and commit it as D4 with the input hashes. Restate the section 5 power numbers on the real layout, or say plainly that they do not apply to it.
- Check that would show it fixed: Appendix A is committed with these hashes: stations 72973d8c…, villages 82de71ae…, pop2015 7fd1a96a…, pop2012 931be7cc…. The note reports T per line, K1, N₀ and the cell counts from it.

**R2-2. MAJOR. The "full decision rule" in the note is not the registered rule, so the decision-rule MDE is overstated.**
- Where: abstract, section 5 ("Under the full decision rule (p < 0.05 and no kill rule)"), Table 4's last column, Result A.
- v2.1 §1 has three more conditions: R1 (no COVID quarters) stays positive, R17 (survivorship-corrected) stays positive, and r* ≥ 1.25 (D2 change 6).
- r* is computed for every seed in note_d2_power_seeds.csv and gate_v3_all_seeds.csv. Adding r* ≥ 1.25 to "p < 0.05, positive, no kill" changes the claim rates:
  - τ = 0.1: 0% (note: 18%).
  - τ = 0.2: 1% (note: 57.5%).
  - τ = 0.3: 17% (note: 75.5%).
  - τ = 0.4: 42.5% (note: 73%).
  - τ = 0.5 (D5, σ on): 67% (note: 75%).
- r* is a ratio of levels, so it depends directly on the assumed base rate of 1.2 (see R2-5).
- R1 was never simulated. Under R1, 環狀 contributes no post quarters (v2.1 §8). See R2-4.
- Fix: say that the claim rate covers only p and the kill rules. Report the rate with r* included. State that R1 and R17 were not simulated.
- Check: a Table 4 column computed with r* ≥ 1.25, reproducible from the attached CSVs.

**R2-3. MAJOR. Survivorship: the stated source cannot show closed firms. The bias is not bounded. The note never mentions it.**
- Where: note Table 2 (registrations and closures from 財政部財政資訊中心, data.gov.tw 9400); v2.1 §8; analysis_v3.R lines 216–241; the note has no survivorship section.
- Facts:
  - The 9400 page (fetched today) says its file covers only operating businesses: "所開放檔案僅涵蓋營業中資料" (the released file covers only businesses still operating; past suspensions and closures are left out because the data is too large).
  - Its fields are tax-registration fields (設立日期, 組織別名稱 and so on). There is no 核准設立 date, no closure record and no founding date for closed firms.
  - So 9400 cannot supply the §8 closure counts that the correction needs. Table 2's "registrations and closures" from 9400 is wrong.
  - The earlier draft (working-paper-draft-doc.md line 132) names a different source: the 經濟部商業發展署 registry, with "[TO VERIFY: dataset ids]". The sources disagree and neither has been resolved.
- The "bound" is not a bound. r* ≥ 1.25 is a breakdown threshold. Nothing in the plan estimates how much survival differs between treated and comparison firms.
- The synthetic DGP has no survivorship at all: registrations are never thinned. So no simulation shows how the bias acts or how big it is.
- Code defect in R17: A (surviving stock) is built from the export's registrations only, which start in 2011Q1. C (closures) includes closures of firms founded before 2011. So K is too small and h too large in the early years. The correction over-corrects early quarters and depends on the export's start date. The plan says A is all surviving registry firms.
- Fix:
  - Name a source that contains closed or deregistered firms, with founding dates.
  - Correct Table 2.
  - Add survivorship to the note's limits.
  - Build A from all firms alive at m, not just those registered since 2011.
- Check: the named dataset page lists closure records. In a synthetic test with known survival thinning, R17 recovers τ.

**R2-4. MAJOR. COVID is neither modelled nor disclosed. 環狀 opened at 2020Q1 and is about 60% of the real treated set.**
- Where: synth.R line 64 and sim_gate_v3.R line 36 (covid = 0.85 for every unit); note section 6 (limits); v2.1 §8, R1.
- The word "COVID" never appears in the note.
- The simulated COVID shock multiplies every 村里 by the same 0.85. A difference-in-differences removes that exactly. So the gates say nothing about a COVID shock that differs between station areas and far controls.
- The 0.85 shock is not interacted with τ, but the treated rate is 1.2×0.85 + τ. The ratio r* is therefore shifted in COVID quarters too.
- Under R1 (a condition of "real"), 環狀 contributes nothing and 綠山 and 藍海 are likely dropped (R2-1). R1 then rests on roughly 19 村里 from 機捷, 安坑 and A22, below K1's 30. Its power was never computed.
- Fix: add to section 6 that COVID coincides with the largest cohort. Give the expected R1 treated count from Appendix A. Say the gates did not test a COVID shock that differs by area.
- Check: the note's limits name COVID. Appendix A reports the R1 cohort counts.

**R2-5. MAJOR. Whether real data shaped the base rate of 1.2 cannot be verified from the record. The value is consistent with D1's total.**
- Where: note section 2; deviations.md D1a.
- The claim that 1.2 was written at 01:27 UTC rests on "the session log", which is not in the repository. 1.2 first appears in git in synth.R and analysis-code-v1.md at f56e15b, 02:04:47Z. That is 13 minutes after the totals reached the research team (01:51).
- The cloud manager saw the totals before the merge and coordinates the team.
- D1's total, 680,654 registrations over 2011Q1–2026Q3 (63 quarters), is 10,804 per quarter. Over the 臺北 + 新北 + 桃園 population in the bundle (8.64 M at end-2012; 8.76 M at end-2015) that is 1.23–1.25 per 1,000 per quarter. Over the bundle's five cities it is 0.77.
- I could not verify which area the export covers. If it is the three cities, the "round assumption" equals the outcome-implied base rate to within about 3%.
- The base rate drives the "+20%/+42%" percentages and r* (R2-2).
- Fix: commit the session-log extract with its timestamp, or treat 1.2 as possibly informed by D1 and say so. Report how the results change with the base rate (e.g. 0.8 and 1.6).
- Check: an artifact with a 1.2 timestamp before 01:51 that a third party can verify.

**R2-6. MAJOR. Denominator and boundaries in the bundle depart from the plan. The note's Table 2 describes the plan, not the data.**
- Boundaries:
  - Table 2 says 內政部地政司 村里界歷史圖資 114年 (data.gov.tw 130549). The bundle uses NLSC VILLAGE_NLSC_1150817 (115年, data.gov.tw 7438).
  - This is not logged in deviations.md.
  - MANIFEST says "No crosswalk". v2.1 §4 requires aggregation to a unit stable from 2011, using 戶政司 change records. That cannot be done with this bundle.
- Population year:
  - There is no 村里 end-2012 file. Only the end-2015 村里 file (data.gov.tw 32973, 104/12) and the end-2012 district file are present.
  - So the fallback route applies, using a 2015 share. 2015 falls inside the 機捷 anticipation window and near the 綠山 one, so R22 becomes relevant. The note does not say which route.
- Blank population:
  - 227 of 3,542 村里 have no 2015 population (高雄 176, 桃園 34, 新北 13, 臺中 3, 臺北 1).
  - Five of them lie within 500 m of study stations, in fast-growth new towns:
    - 林口區新林里 (林口站, 428 m)
    - 淡水區新市里 (濱海義山, 247 m)
    - 中壢區青航里 (高鐵桃園站, 269 m)
    - 大園區青峰里 (領航站, 339 m)
    - 龜山區文樂里 (體育大學站, 347 m)
  - appendixA.R and analysis_v3.R drop them under exclusion 3 ("P < 500 or missing"). So treated units are removed according to population growth, which is related to treatment.
  - A 村里 that was split keeps its whole 2015 population on a smaller 2026 polygon. That overstates its denominator. Without change records this cannot be detected.
  - All 86 blanks in 三民區 and all 75 in 鳳山區 look like a join failure, not renames. They are outside F's cities, so they do not matter here.
- Licence: the district 2012 table is under the MOI website licence, not 政府資料開放授權條款. Table 2 does not list it.
- Fix:
  - Log the boundary-vintage deviation.
  - Obtain the 戶政司 change records and build the crosswalk.
  - Handle the blanks by crosswalk, not by exclusion.
  - Correct Table 2.
- Check: Appendix A reports the number of 村里 excluded for missing population, by group, and the treated count drops to zero.

**R2-7. MAJOR. Station dates in the bundle come from Wikidata, not from the cited sources. Key study and control stations are undated or missing.**
- Table 2 cites 鐵道局 96918 plus news pages. MANIFEST says open_date comes from Wikidata (CC0, "not an official source").
- 112 stations are "unknown". They include 機捷 A11–A22 (12 stations, so all of the A22 cohort and half of 機捷), 台北海洋大學 (藍海), 雙城 and 十四張 (安坑), and 台北大學 (三鶯).
- appendixA.R line 97 stops if any unknown-dated station lies within 2 km of a study-area 村里. It would stop on this bundle.
- Its SCHEMA (station_id, category, town_code, county, population_village.csv) also does not match the bundle's column names. The code was never run on real data.
- The bundle has only 13 桃園綠線 stations, those "inside Wikidata's coverage". The north section alone has more stations than that. 村里 near the missing stations can be classed F (they need to be ≥ 2 km from every 綠線 station) when they belong in G. That contaminates the primary comparison group.
- Fix: commit the dated mapping for the 112 stations that D2 promised; complete the 綠線 list from an official source; update the schema map.
- Check: appendixA.R runs to completion on data/pre with no stop.

**R2-8. MINOR. Opening dates: all six match public sources, but only one has a licensed government source. The bundle's dates differ from the plan's.**
- I checked these against news pages found in a web search:
  - 機捷: group rides from 02-02; free public rides from 2017-02-16, with queue tickets (號碼牌), capped at about 20,000 a day; formal opening 2017-03-02. (風傳媒 223925)
  - 綠山: 2018-12-24; fares from 2019-02-01. (TVBS 1070300)
  - 環狀: 2020-01-31; free to 02-29; fares from 03-01. (TVBS 1266087)
  - 藍海: 2020-11-15; fares from 12-15. (Taiwan News 4054224)
  - 安坑: 2023-02-10; fares from 03-13. (CNA 202303120213)
  - A22: not checked independently.
- Only 機捷 has a dated government open-data row, 96918 (D3). That row gives 2017-03-02, the fare-start date, not the plan's public-opening date. I could not open the 96918 CSV myself: an Incapsula block was returned, and the page preview shows "No data". 環狀, 淡海 and 安坑 are local-government projects, and I could not verify that 96918 contains them.
- The bundle has 綠山 = 2018-12-23 (ceremony day) and 機捷 = 2017-03-02. Neither changes k = 0.
- Fix: in Table 2, say that dates for 綠山, 環狀, 藍海, 安坑 and A22 rest on news and operator pages, not on 96918.

**R2-9. MINOR. Missing months and quarters: there is no registered rule, and the code imputes silently.**
- The plan does not say how a missing 村里-quarter or district-month is treated.
- analysis_v3.R line 226 counts a missing closure month as 0 in Csum. Line 228 then sets a missing h to the district's 2013 mean.
- C&S runs on whatever panel arrives. The synthetic panels are always complete.
- Fix: register a rule before any outcome file is opened (balanced panel, or drop and report), and disclose it in the note.

**R2-10. MINOR. Outcome-file record: no outcome file is committed anywhere, but git cannot prove none was opened.**
- On all branches (main, prereg-v1, data-pre; 17 commits), no registration, closure, price or population-series file was ever added. The only data files are the four pre-outcome files in 5869460, committed after the merge (01:59:46Z versus a743f88 at 01:34:00Z).
- But .gitignore excludes *.tgz, the format of the export tarball. So git history can neither show nor rule out local access to the export.
- The merge commit's timestamp is exactly 01:34:00, 2 seconds after its parent. That is consistent with a scripted merge, and I could not verify it independently.
- Section 2 says no population-series file was "requested". v2.1 §10 requested the 村里 population series from the export. This is a wording error.
- Fix: correct the wording; state that the export tarball's location and access were not logged in git.

Count: 1 fatal, 6 major, 3 minor.

## Referee 3

REFEREE 3: CONTRIBUTION AND LITERATURE. Pilot D280, note `paper/mrt-pilot-design-note.pdf`, commit fba3289.

Scope. I read the note text and the literature section and reference list of `paper/working-paper-draft-doc.md` (lines 43-92, 443-521). I opened each source page. Where a page gave only a summary, I say so. I did not read `notes/`, `reviews/`, `CLAUDE.md` or other referees' reports.

Outcome-data check: not applicable, no outcome data opened. The note does make claims that stand in for such a check (power, bias, MDE). I treat them in R3-4 to R3-6.

## A. Novelty

R3-1 (MAJOR). Neither methodological finding is new. The note presents them as its contribution but cites no prior work.
- Where: note section 4, Findings 1 and 2, and the opening bullets.
- Finding 2 (treatment adds variance that untreated placebos cannot see) is a known limit of Conley-Taber (2011) and Ferman-Pinto (2019) inference.
  - Conley-Taber build the null from the control groups' error distribution (verified on the RePEc abstract: it relies on "a large sample of nonchanging groups").
  - Ferman-Pinto (verified) fix only the heteroskedasticity that comes from group size. They estimate it from the controls.
  - Heterogeneous treatment effects and event-study bands for this setting are the subject of Alvarez & Ferman (2023), "Extensions for Inference in DiD with Few Treated Clusters", arXiv 2302.03131 (abstract opened).
  - Placebo/randomization inference with few clusters is also covered by Hagemann (2019, J Econometrics 213(1): 190-209) and Canay-Romano-Shaikh (2017, Econometrica 85(3): 1013-1030). I confirmed these exist from search results only. I did not read them and cannot say what they claim on this point.
- Finding 1 (one shared base quarter makes the treated side's noise correlated across event times) is how a universal base period works in Callaway-Sant'Anna. Callaway's own post on universal vs. varying base periods (bcallaway11.github.io) and Roth (arXiv 2401.12309) discuss the asymmetry between pre and post coefficients.
  - The D2 fix is the Conley-Taber requirement that the placebo statistic be built exactly like the treated statistic. The note says as much in section 4.
  - So Finding 1 is a restatement of that requirement, not a conjecture about few-cluster inference.
- Result A (kill rules cap the claim rate near 75%) is arithmetic.
  - It is 1 minus the kill rules' joint false-fire rate. Four rules at about 5% each give about 18-27% (the note's Table 3 shows 22-27%).
  - Conditioning on pre-tests is a known issue (Roth 2022, "Pretest with caution", AER: Insights 4(3), cited in the draft).
  - The 24% null fire rate (Table 3, round 4) is partly a mis-sized-tail artefact (K2a 8.2% and K2b 7.2% at a nominal 5%). So Result A mostly measures that miscalibration. It is not a property of the design.
- Fix: add a related-work paragraph and reference list to the note. Say plainly that both items are applications of known limits, not discoveries. Reword the "Two measured results" and "Two explanations" bullets.
- Check: the note cites Conley-Taber, Ferman-Pinto, Alvarez-Ferman, Hagemann, Roth 2022 and Roth 2024 next to Findings 1, 2 and Result A, with one line on what each adds.

R3-2 (MAJOR). The note has no reference list and no literature section.
- Where: whole note. It names only Callaway and Sant'Anna 2021, Ferman-Pinto and "did 2.5.1". The extraction ends at the glossary, and I saw no references page.
- I checked the three items it does name:
  - Callaway & Sant'Anna 2021: exists (arXiv 1803.09015, abstract opened). The journal line (JoE 225(2): 200-230) is in the draft's reference list but the arXiv page I opened does not give it. I did not independently verify it.
  - Ferman & Pinto 2019: exists. RES 101(3): 452-467. Abstract matches the draft's use.
  - `did` 2.5.1: CRAN page shows 2.5.1, published 2026-07-08, matching the note and the draft.
- The note therefore gives readers nothing to judge novelty against. On the original question, I found no prior MRT and business-entry study for Taiwan with a comparison group. That is a weak negative: one Chinese-language web search returned only news and city-government pages. I cannot confirm absence. The draft's own claim is hedged "as far as we can find".
- Fix: add a one-paragraph, one-page reference list. Check: every citation in the note appears in it, and each was opened.

## B. Citation check (draft working-paper-draft-doc.md)

Wrong or unsupported:

R3-3 (MAJOR as a group, 3 wrong author names). Name errors in the draft's reference list and text, with Chinese names that fail against the library record:
- 廖庭誼 (2023): the NCCU thesis record gives the author as 廖倉淯 (Liao Tsang-Yu). Title: 捷運開通對於沿線住宅租金之影響-以新北環狀線為例.
  - The draft's claim "no rent premium near 環狀線, some negative rents attributed to COVID" is only partly right. The abstract says no premium. It attributes the negative whole-unit rent to residents using buses or cars and to tenants prioritising industrial workplaces. COVID is linked only to the six-month post-opening decline in suite/room rents, as a speculative explanation. The DiD compares one month before and six months after opening.
- 翁君宜 (2016): the Airiti record gives 翁嘉駿 (Chia-Chun Wong). The counts match (12,637 stores, 500 m, 2015, 30 chain industries). But the draft's "stores favour central stations with parking" is imprecise: the thesis treats proximity to Taipei Main Station and parking as separate factors, with parking pulling stores closer.
- 張耀庭 (2021): the Airiti record gives 張芸端 (Yun-Tuan Chang). The title is 捷運、經濟弱勢與工作可及性－排除性的長期分析. The draft already flags the name "[TO VERIFY]". The 里-level 1996-2016 panel claim is correct.
- Also: the draft cites "Schuetz, Giuliano and Shin (2016)". The FEDS page lists the authors as Genevieve Giuliano, Jenny Schuetz and Eun Jin Shin (FEDS 2016-4, "Is Los Angeles Becoming Transit Oriented?"). The abstract also says a subset of stations saw higher employment density five to ten years after opening. The draft reports only "no change within five years". It leaves out the later increase. The "23 stations" and "major-road intersections as controls" details are not on the page I opened. Could not verify them.
- The Credit (2018) outcome is described in the draft as "new business starts per acre". The publisher-side abstract does not say per acre. It says block groups and quarter-mile and one-mile bands. Could not verify "per acre" or "1-mile network buffer". Issue number on the page is inconsistent (15 vs 13).
- Fix: correct the names against the library records, restate the claims as the abstracts give them, and drop "per acre" unless the full text says it. Check: each name matches its thesis record and each claim has a page-and-line source.

Verified as stated (exists; claims match what I read):
- Feng, Wang & Huang (2025), J Transport Geography 123: 104082. Exists. Title: "Measuring the impacts of subway openings on location choice: Systematic evidence from service enterprises, Beijing". 16,571 1 km cells, 2007-2018, multi-period DiD, 53.8% rise in new service firm registrations. The draft says it read only the abstract, which is honest.
- Kovvuri & Sharma (2025), job market paper, 26 Nov 2025. I read the PDF.
  - Table 1 Panel A: ATT 8.91 (SE 2.09), 143.5% on a baseline of 6.21, pre-trend p 0.221, 148 treated of 633 (so 485 comparison), 1,895 hexagons. B2C 6.66 (1.53).
  - Panel B: 6.61 (3.54), 67.2%, 68 of 193.
  - Callaway-Sant'Anna, SE clustered by neighbourhood, 4 anticipation periods, Phase 3 (2011-2024).
  - Note: Panel B's own pre-trend p is 0.179. The paper's data run 2011-2024.
- Chatman, Noland & Klein (2016), TRR 2598: 1-10. Title: "Firm Births, Access to Transit, and Agglomeration in Portland, Oregon, and Dallas, Texas". Matches. Data 1991-2008.
- Saeed & Iseki (2023), JTLU 16(1): 389-408. Title: "Does rail transit access affect firm dynamics? Analysis of firm births and closures in Maryland, USA". Higher birth rates near rail regardless of station maturity: matches.
- Canales, Nilsson & Delmelle (2019), Regional Science Policy & Practice 11(1): 189-202. Title: "Do light rail transit investments increase employment opportunities? The case of Charlotte, North Carolina". No significant relative rise: matches.
- Tornabene & Nilsson (2021), J Transport Geography 94: 103087. Title: "Rail transit investments and economic development: Challenges for small businesses". Matches.
- Champagne, Dubé & Legros (2024), Transportation Research Part A 181: 103994. Title: "Standing strong? The causal impact of metro stations on service firms' survival". Montreal, unbuilt stations as controls, 250-1,250 m: matches.
- Lee, Lee & Cheng (2023), Prague Economic Papers 32(1): 84-106 (the page gives 2023(1)). Title: "Are the Effects of Opening New Mass Rapid Transit Segments in Taiwan on Nearby Housing Prices Positive?" It covers Tucheng and Xinzhuang segments, with no effect on one and a fall on the other. The paper offers the delay as a possible explanation only.
- Liou et al. (2016), PRRES Journal 22(1): 3-16. Authors Liou, Yang, Chen, Hsieh. Distance to MRT has no significant effect: matches. The page says nothing about "mature" stations, so that qualifier could not be verified.
- 周家右 (2013): NTU thesis, 台中市捷運、巴士快捷對房價影響的預期效果. Prices fall with distance (NT$14,309 per ping per km from MRT). Matches.
- 劉永祥 (2020): NCCU thesis. Before-after comparison with no control group mentioned; industry effects mixed (各有消長). Matches.
- 汪志忠 & 王俞翔 (2013): 國家與社會 14: 223-262. 2007-2010 data. The abstract says "very slight" stimulation after opening. The draft says "visible but not significant". The abstract has no significance test, so "not significant" is the draft's own gloss. The opening year (2008) is inferred, not stated.
- 楊舒涵 (2017): NTU thesis. Five Neihu Wenhu-line stations, street imagery 2009/2012/2015, nearer stations more gentrification: matches.
- 鄭智翔 (2024): NTU thesis. A21 Huanbei, opening 2 March 2017. NT$3,460 per m² within 500 m vs NT$2,915 at 500-800 m: matches "larger within 500 m". Distance itself had no effect.
- Cameron, Gelbach & Miller (2008), RES 90(3): 414-427: "five to thirty" clusters, matches.
- MacKinnon & Webb 2017, JAE 32(2): 233-254; 2018, Econometrics Journal 21(2): 114-135. Both exist and the claims match.
- Conley & Taber (2011), RES 93(1): 113-125. Exists. Not in the note itself, but listed above for completeness.

Not opened: the full text of any paywalled paper (Ferman-Pinto, Conley-Taber, MacKinnon-Webb, CGM). For these I read abstracts only. Whether Ferman-Pinto's method is "placebo-based" was not on its abstract page, so I cannot confirm how the draft or note describes its mechanics.

## C. Overclaim

R3-4 (MAJOR). Power and MDE are stated without the caveats that matter.
- Where: note abstract bullet 4; section 5 and Table 4.
- "80% power at +20%" comes from one synthetic world: Poisson counts, independent village effects, district- and line-wide shocks of 10%, an assumed base of 1.2 (no source, section 2).
- The test's size in that world is 7.0% (SE 1.1) at a nominal 5%, and the D5 coverage is 91.5-93%. Table 4's powers (69.0% at 0.2, 94.5% at 0.3) are therefore not size-adjusted. A size-adjusted MDE is above the 0.24 quoted.
- The note's own section 6 says real data may have overdispersion and spatial correlation. The headline still gives a point MDE.
- The MDE interpolates between only two points (0.2 and 0.3). The estimate's SD (about 0.08) is assumed constant, and real rates may be far from 1.2.
- Fix: state the MDE as a range, say it is not size-adjusted, and say it is conditional on the assumed base rate of 1.2 and a Poisson world. Check: the abstract carries the same caveats as section 6.

R3-5 (MAJOR). Result B ("small-cell rule biases the estimate down 3.9% of the effect") is stated as a general measured result. It holds only for this DGP.
- Where: abstract bullet 1; section 4.
- The size of the effect depends on how many cells fall in the 1-2 band. That depends on the assumed base rate (1.2 per 1,000) and the village populations, none of which come from data.
- The mechanism ("the treatment moves counts out of the 1-2 band") is labelled "a plausible reason" and was not tested. Yet the number is listed under "measured results".
- Fix: label it "bias in this synthetic world" and give the sensitivity to the base rate. Check: the bias is reported at two or more base rates, or the abstract is restricted to this world.

R3-6 (MINOR). "Findings" labelling.
- The note rates Findings 1 and 2 "conjecture" and "probable mechanism". But the framing "This note reports what was learned" and "Two measured results" still gives them more weight than five seeds (Finding 1, not recomputable) and an effect-vs-null gap of 2.0 combined SEs (Finding 2) can carry. The note is candid in the body. The abstract bullets are firmer than the body.
- Fix: put "unproven" in the abstract itself next to each finding, and drop "probable" for Finding 2, or give the 2 SE gap there. Check: the abstract and section 4 use the same hedge.

R3-7 (MINOR). Implication about MRT and business entry.
- The note says "H1 is therefore untested. This note is not evidence for or against it." That is correct, and I found no sentence in the note implying MRT does or does not affect business entry. The draft's literature section, though, says "studies that count new firms near new stations mostly find large, local, positive effects" and cites 143.5% (Delhi) and 53.8% (Beijing). Those are priors from different cities, with comparison groups the draft itself calls weak (the Delhi estimate halves against a planned-not-built control). Readers should not take them as evidence for Taiwan.
- Fix: keep the Delhi and Beijing numbers out of any abstract. Check: no foreign effect size appears without its design caveat.

R3-8 (MINOR). The draft labels the Ferman-Pinto "no p < 0.05 with 3-5 control groups" point as the referee's. It is a known property of permutation tests with few controls: with N0 placebo draws the smallest attainable p is about 1/(N0+1). It is not in the note as a finding, so I make no claim against the note. Only the draft's Table 363 column "Smallest attainable p" needs a citation to Conley-Taber or Hagemann. Could not verify it is cited there.

Count by severity: 0 fatal, 4 major (R3-1, R3-2, R3-3, R3-4 and R3-5 counted as majors: 5 in total), 3 minor. Exact: fatal 0, major 5 (R3-1, R3-2, R3-3, R3-4, R3-5), minor 3 (R3-6, R3-7, R3-8).

## Referee 4

REFEREE 4 (replication) — "MRT pilot: a design and power note" (paper/mrt-pilot-design-note.pdf), repo nikolasdoan/tw-econ-research at fba3289

Where I worked: a clean clone at /tmp/claude-0/-home-user-tw-econ-research/15c9aa58-7fc5-50ac-8a34-af445421a637/scratchpad/r4/repo (detached at fba3289). I changed nothing in the repo.

What I could rerun, and what matched
- R: I installed R 4.3.3 from Ubuntu noble apt. That is the version renv.lock pins. I installed data.table 1.18.6.1 from the posit snapshot the lockfile names (2026-10-30), which is also the pinned version. The gate code needs only data.table.
- D5 gate (round 4), in full: all 2,600 seeds, both σ²_j on and off, with the committed seed blocks (null 50001–50500, effect and effect_nosupp 60001–60200, pre-trend 70001–70200, stress 80001–80200). Every seed matches results/gate-v3/gate_v3_all_seeds.csv exactly, with a maximum absolute difference of 0.0 on every numeric column. All flags and integer columns match too. All 10 per-scenario output files have the same SHA-256 as the list in code/analysis-code-v3.md (lines 313–324). Each scenario took about 0.3–0.7 minutes on 4 cores.
- D2 gate (round 2), in full, using the committed sim_gate.R and lib_v2.R: seeds 1001–1500, 2001–2200, 3001–3200 and 4001–4200. All match paper/note_d2_power_seeds.csv exactly.
- Round 3 diagnostic (no suppression, seeds 2001–2200): its script is not committed. A two-line edit of sim_gate.R reproduces it exactly.
- Power runs at τ = 0.1–0.4 (seeds 91001–91200): sim_power.R is not committed. A one-line edit of sim_gate_v3.R gives a file whose SHA-256 is d3c7673f…fb57, the hash the note quotes, and its output matches all 800 rows exactly.
- Hashes the note quotes: all match. note_tables.csv 5908a1a5…; note_tables.py d4c99de7…; note_d2_power_seeds.csv 0f937682…; power_summary.csv 45577eeb…; gate_v3_all_seeds.csv 61e28daf…; sim_power.R d3c7673f… (reconstructed); PDF e522fc42… (as in the commit message); mrt-pilot-v2.md 020f849f…, 33,044 bytes, as in signoff.md.
- Table 3 (rounds 1–4), Table 4, Result A, Result B, Finding 2, the §3 layout counts (67–129 treated, medians 96–99, N0 38–39), the binomial figures in §7 (4.4%, 14.9%, 32.7%) and the MDE interpolation (0.243, +20%): I recomputed every number from the committed per-seed files. No number in any table differs from the committed files. The plotted values in Figure 1 match Table 4. I cannot regenerate the figure itself, because its plotting script is not committed.
- No outcome file exists on any branch (main, prereg-v1, data-pre). Whether anyone opened an outcome file outside git: could not verify.
- Pre-trends in actual data: not applicable, because no outcome data was opened. The note makes no claim that would need that check.

FINDINGS

R4-1 (major). The "full decision rule" claim rate leaves out a registered condition, so Result A, Table 4, Figure 1, the MDE paragraph and the abstract all overstate it.
- Where: abstract ("Under the full decision rule (p < 0.05 and no kill rule), 80% power is never reached"); §4 Result A; Table 4, last column; Figure 1, dotted line; §5 MDE paragraph; code/note_tables.py, the `claim` field.
- The problem: D2 Change 6 makes r* ≥ 1.25 binding ("the effect is not called real if r* < 1.25"). analysis_v3.R line 351 enforces it (`!r_fragile`). v2.1 §1 also requires a positive estimate, R1 > 0 and R17 > 0. The note's claim rate uses only p < 0.05 and no kill rule. It does not even require est > 0.
- Recomputed from the committed per-seed files, with est > 0 and r* ≥ 1.25 added:

  | τ | Note's claim rate | Recomputed |
  |---|---|---|
  | 0 | 2.2% | 0.0% |
  | 0.1 | 18.0% | 0.0% |
  | 0.2 | 57.5% | 1.0% |
  | 0.3 | 75.5% | 17.0% |
  | 0.4 | 73.0% | 42.5% |
  | 0.5 | 75.0% | 67.0% |

- Why it matters: the r* rule, not the kill rules, is what binds through τ = 0.4, and it still removes 8 points at 0.5. r* ≈ 1 + τ/1.2 by construction, so the registered rule cannot claim an effect much below about +25%. The note never says this. The glossary weakens the rule to "not reported as real in absolute terms".
- Fix: relabel the column as "p < 0.05 and no kill rule (partial decision rule)". Add a column with the registered rule (est > 0, p < 0.05, no kill rule, r* ≥ 1.25), and state that R1 and R17 were not simulated. Rewrite the abstract and Result A.
- Check: note_tables.py outputs the new column and it equals the figures above.

R4-2 (major, unlogged deviation in the gated code). The G comparison group leaves the pool one quarter earlier than v2.1 registers.
- Where: code/lib_v3.R line 162 (cfg_primary); code/analysis_v3.R lines 104 and 177; the same in lib_v2.R line 134 and analysis.R line 103.
- The problem: `gv = G_CUTOFF + ant − 1` combined with the validity test `gv > max(t,b) + ant` makes G valid only up to 2023Q1. I confirmed this in R: G is valid at 2023Q1 and not valid at 2023Q2. v2.1 §3 says G "serve up to 2023Q2", and §6 says G rows are dropped "from 2023Q3". The code comment says "valid while t + ant < cutoff + ant", which contradicts the formula.
- Consequences: the primary loses G controls at 2023Q2, and so did every gated simulation. Under R25 (no F), the cells the §5 table registers as identified, 藍海 k = 10 and 安坑 k = 1 (both 2023Q2), would have no comparison at all. The did 2.5.1 cross-check (analysis_v3.R lines 201–207) leaves G out, so it could not catch this. This is not in deviations.md and not in the note.
- Fix: set gv for G to G_CUTOFF + ant, or log a deviation.
- Check: in cfg_primary, G is valid at qi(2023,2) and not at qi(2023,3). The R25 identified cells match the v2.1 §5 table.

R4-3 (major). The note leaves out Appendix A, and the reason it gives is contradicted by the repo.
- Where: §5 ("the pre-outcome bundle (data/pre) has not arrived"); §6; Table 1, D4 row.
- What D6 requires: D6 item 5 requires "Design facts from pre-outcome files only: Appendix A".
- The record:
  - Branch data-pre, commit 5869460, is dated 2026-10-31T01:59:46Z. That is over an hour before the note's commit (03:07). It holds stations, 村里 centroids and base-year population.
  - code/analysis-code-v1.md line 634 (committed at 02:04) says "The real station file has 112 'unknown' stations". D2 (02:06) also cites "the 112 stations with no opening date". So the team had the real station file before the D2 gate.
  - When I ran code/appendixA.R on the bundle, it stopped at once: "object 'station_id' not found" (the bundle uses `id`). So the Appendix A code does not run on the real bundle.
- Fix: run Appendix A on data/pre (after fixing the schema), commit it as D4 with input hashes, and add it to §5. Or state exactly when the bundle reached the authors and why it was not used.
- Check: appendixA.R runs on 5869460's data/pre. A D4 entry exists. The note reports T per line, N0 and the cells.

R4-4 (major). §3 "Limits" understates D5's hard limits.
- What is missing: D5's effect scenario also has "any-kill ≤ 25%" (deviations.md line 86). The note lists only "plus two" limits (bias and unsuppressed coverage).
- Why it matters: the suppressed effect run's any-kill rate is 25.0% (MC SE 3.1), which is 50 of 200 seeds, exactly at the limit. So a second hard limit passed with no slack at all. D6 item 3 requires "every limit".
- Fix: list the any-kill limit and its rate, and mark it as at the boundary.
- Check: the Limits paragraph lists all six D5 limits for the effect scenario.

R4-5 (minor). code/note_tables.py does not run from a clean checkout.
- What fails: it reads gate/*.csv, gate_v3/*.csv and power/*.csv, none of which are committed ("FileNotFoundError: gate/null.csv"). The note says the figures are recomputed "from the per-seed files by note_tables.py".
- What I did: I split the two committed combined files by `source`, `scenario` and `sigma`. One trap: "null" must be read with keep_default_na=False, or pandas turns the scenario name into NaN. After that, the script reproduces paper/note_tables.csv exactly, except two cells: K2b_tail_lt_0.20 and K2b_tail_lt_0.05 on the round-3 effect_nosupp row read 0 in my output and are blank in the committed file. Neither is used in the note.
- Fix: make the script read the committed combined files.
- Check: `python3 -I code/note_tables.py` in a fresh clone writes a file byte-identical to paper/note_tables.csv.

R4-6 (minor). Scripts behind the note are not committed: sim_power.R (the note quotes its hash), the round-3 no-suppression diagnostic, and the Figure 1 plot script. I reconstructed the first two (see above). Fix: commit them. Check: they are in the tree with matching hashes.

R4-7 (minor). §3 says round 1 "cannot be recomputed". It can, from committed text.
- code/analysis-code-v1.md lines 97–103 lists all 5 seeds. From that table: mean 0.527 (bias +0.027), SD 0.108, K2a fired 3 of 5, K2b 2 of 5, any kill 4 of 5. All agree with Table 3.
- Fix: cite that table.

R4-8 (minor). The D2 gate was run twice, and the note does not say so.
- analysis-code-v2.md lines 14 and 35: a second pass on the same seeds stored the rules' p-values, with fire flags "identical". Round 3's re-scoring depends on that pass. The note says only "none was rerun to change its outcome".
- Fix: disclose the second pass.

R4-9 (minor). Git does not show the D5 seeds were fixed before the run.
- Order in git: the limits come first (D5, 6c9c970, 02:36:37) and the result entry later (D6, e1e151c, 02:47:40). But the seed numbers, code v3 and the results first appear in git together at 8962b74 (02:56:53), after D6.
- The only record of seed timing is a claude.ai doc I may not open: could not verify.
- What reduces the concern: the seeds are contiguous blocks, my rerun shows the committed code produced the committed results, and the gate failed, so seed-shopping is unlikely.
- Fix: say in the note that git shows seed timing only through the doc.

R4-10 (minor). §7 quotes the referee rulings word for word and says they are "committed at the listed commits". deviations.md holds paraphrases, not those words. Example: the note quotes "my 20% tail fires at least 20% of the time by construction. That was my error."; D5 in deviations.md reads "The referee's earlier 20% tail fired at least 20% of the time by construction." I could not verify the quotes, because the source (reviews/ or the referee docs) is off-limits to me. Fix: commit the rulings verbatim or drop the claim.

R4-11 (minor). The note's statement that real data did not shape the design rests on a timing I cannot verify.
- §2 and D1a say the base rate 1.2 was written into synth.R at 01:27. In git, synth.R first appears at f56e15b (02:04:47), after the totals reached the team (01:51). The session log is not committed: could not verify.
- This matters because the arithmetic is close. 680,654 registrations ÷ 63 quarters ÷ 8.64 m residents (Taipei + New Taipei + Taoyuan, end-2012) gives about 1.25 per 1,000. With all five cities in data-pre (14.1 m), it gives 0.77.
- Fix: commit the timestamped log, or state the export's geographic scope.

R4-12 (minor). Data source not as registered, and not logged.
- data-pre uses the 115年 boundary file (data.gov.tw 7438; MANIFEST.md line 51 says so). v2.1 §4 registers 114年 (130549), and the note's Table 2 still lists 114年.
- The population files mean the fallback denominator route (2015 村里 shares). v2.1 §4 requires that route to be logged.
- Neither is in deviations.md. No outcome file has opened, so the deadline has not passed, but the note's description of the data is out of date.

R4-13 (minor). The primary statistic comes from the authors' own engine (lib_v3.R decompose), not `did::aggte`, which v2.1 §1 and §6 register. This is not logged as a deviation. The note says the engine matches did 2.5.1 to 11–12 digits "where both apply". I could not verify that: did and its dependencies were not installed. Also, the check leaves out G (see R4-2).

R4-14 (minor). D2 Change 4 says to report "the number of clusters floored". lib_v3.R line 129 counts comparison districts, summed over clusters (up to 83 per seed in the gate file). analysis-code-v2.md calls these "clusters". The note does not report the count, so only the label is wrong.

Does the gated code implement D2 and D5? Apart from R4-2, R4-13 and R4-14, yes:
- placebo contributions per (j, c), with j's cells, base and weights, and the pool minus c;
- residuals centred across c, and NNLS a + b/n with the 0.25 × mean r² floor;
- K2a at p < 0.05, and K2b with a one-sided tail < 0.05 plus the sign and ≥ 50% conditions;
- K3a and K3b as in v2.1 §7;
- σ²_j from the R2 ring over k = −20 to −1, net of sampling variance, floored at 0, added through the quarter weights. It is approximate for the K2b slope, which the note discloses.
- the stress line shock on every village within 1,500 m, B = 999, and a new layout for every seed.

The deviations log is append-only (no committed entry was edited). Every amendment in the note (D2, D5, D6) is labelled. The note correctly says the inference that failed the gates was the amended one.

Count: 0 fatal, 4 major (R4-1 to R4-4), 10 minor (R4-5 to R4-14).

Working files are in /tmp/claude-0/-home-user-tw-econ-research/15c9aa58-7fc5-50ac-8a34-af445421a637/scratchpad/r4/:
- rerun/: the D5 gate rerun
- rerun2/: the D2 gate rerun
- pw/: the power runs and sim_power_mine.R
- d3/: the round-3 diagnostic
- work/: the rebuilt note_tables.csv
- split.py: the splitter that feeds note_tables.py

## Referee 5

REFEREE 5 REPORT: rules and disclosure

Scope: note PDF (text via pdftotext, plus the extraction), paper/working-paper-draft-doc.md, the data-pre bundle (MANIFEST.md, stations.csv and the other CSVs), preregistration/, code/, results/ and the git log. I did not read notes/, reviews/ or CLAUDE.md. Web checks ran through the proxy on 2026-10-31.

Not applicable: no outcome data opened (pre-trends, estimated effects). The note makes no claim about real-data pre-trends. I checked: it says "H1 is therefore untested".

Verified without a finding:
- I opened the data.gov.tw pages for 9400, 8411, 32973, 130549, 25119, 96918, 73233, 73226, 73225 and 7438. Each states 授權方式 "政府資料開放授權條款-第1版". The note's claim for 9400, 25119 and 96918 holds.
- No 統一編號, business name, address or owner appears in the note text, the CSVs under paper/, results/ or data-pre, or the deviations log. I grepped for 8-digit strings and for company, partnership and sole-proprietor words. The only hit is a rule against naming 獨資/合夥 (code/stage3-prep.md:353).
- stations.csv holds public stations only.
- Cells under 3 are never displayed. "<3" appears only in the draft (line 437), as a description of suppression. The paper has no firm-level table, so "<3" display is not applicable.

Findings

R5-1 (major) Licences: the note's source table is incomplete. Several sources used are not named in it, and some named ones differ from what was used.
- The note's Table 2 (p.3) names 9400, 8411/32973, 130549, 25119 and 96918 only. Appendix A is "not written" (note §6).
- The data-pre bundle (MANIFEST.md) actually uses these sources, none of them named in the note:
  - NLSC 村里界 7438, file VILLAGE_NLSC_1150817 (115年). The note names 130549 (114年). MANIFEST.md says "It is not the 114年 vintage … that v2.1 names". The note does not say the vintage changed. v2.1 §4 and the draft §4 also name 地政司 as publisher; the file used is from 國土測繪中心.
  - NLSC station points 73233, 73226 and 73225 (named only in MANIFEST.md).
  - TDX station data for 臺中, 高雄, 機場線 and other lines (stations.csv has 166 TDX rows).
  - Wikidata, used for all open dates and for 13 桃園綠線 positions.
  - MOI table m1-10.ods (內政統計月報).
- The note says 96918 "Nothing from the cited pages is reused", but the bundle's open_date comes from Wikidata. MANIFEST.md itself says Wikidata "is not an official source".
- Draft §4 (line 132) names the registrations publisher as 經濟部商業發展署. The note names 財政部財政資訊中心 (9400). The 9400 page I opened says it covers 營業中 data only, and the draft table is marked "[TO VERIFY: dataset ids]". The registry source is unresolved and the two documents disagree.
- The draft's Stations row reads "[TO VERIFY]" for licence, and the Closures row has no dataset id.
Fix: one table in the note listing every source actually used, with its dataset id and the licence quoted from its page. Flag each non-OGDL source explicitly. State the 114→115 vintage change.
Check: every file in MANIFEST.md maps to a table row, and every row's licence text matches the page.

R5-2 (major) Non-OGDL sources.
- Wikidata: its Licensing page says main-namespace data is CC0. It is open, but it is not a 政府資料開放授權條款 licence and not a government source. The v2.1 wording was "v1 or equivalent". MANIFEST.md applies "equivalent" without argument. CC0 is arguably more permissive, but the note never says the dates are crowd-sourced. They are also the only opening dates for most study stations. This is a licence-and-provenance gap, not a clear breach.
- TDX: MANIFEST.md says only "資料來源：交通部運輸資料流通服務平臺(TDX)". It gives no licence. I could not retrieve TDX's terms (the fetch returned an empty page). Could not verify that TDX's licence is OGDL v1 or equivalent. The bundle has 166 TDX rows.
- MOI m1-10.ods: MANIFEST.md relies on the MOI site's "政府網站資料開放宣告" ("free, non-exclusive and sublicensable, with the source named"). I could not open that declaration's text (the page I fetched showed only the link). Could not verify the quoted wording. MANIFEST.md itself says the table is not on data.gov.tw. This falls under "equivalent" only if the declaration says what MANIFEST.md quotes.
- News and operator pages: the note cites "dated operator and news pages … for dates only" (Table 2, p.3). They carry no open licence. Facts cited with attribution are low risk, but the note does not say so.
- Fix: for each of these, either quote the licence text and say why it is "equivalent", or drop the source. Check: a licence column with a verbatim quote and URL for every row.

R5-3 (major) The note describes how the data were built, beyond "registry records linked by 統一編號". The linking phrase itself is allowed (note Table 2, p.3; draft line 132). The passages below go further:
- Draft §5 (line 253): "Address. N uses the address at establishment if the source carries it. Otherwise it uses the current address (Section 9)." This is about which address field places a firm.
- Draft §9 (line 423): "Current-address relocation. The registry may hold each firm's current address… A firm founded elsewhere that later moved near a station is counted as a birth there… We report the share of firms with any 遷址 record…". This describes how firm records are assigned to places.
- preregistration/mrt-pilot-v2.md lines 156, 256-262 and 331 (the table row requests "address at establishment if available, else a count of firms with any 遷址 record"), and v1 line 201. Line 156 reads: "Address. N uses the address at establishment if the export has it".
- code/stage3-prep.md line 392: "6.4 Relocation bias. The registry uses current address."
- The draft line 237ff area gives the placement rule only as nearest-station assignment of 村里 (public geography). Draft line 182, v2 line 114 and v1 line 61 say "A 村里 is assigned by its nearest station". This is about public geography and is acceptable.
- The note PDF itself has no passage on geocoding, address matching or spatial joins of firm records. The note PDF is clean on this point. The problem is in the draft and in the preregistration/code files the note points to.
- The word "geocode" appears nowhere in paper/, preregistration/, code/, results/ or MANIFEST.md.
- MANIFEST.md contains no description of firm placement. Its "geometric centroid of the 村里 polygon" refers to public geography only.
- deviations.md: no geocoding text. It mentions the export, "the M1" and "bizmap #205" (see R5-5).
Fix: remove address-timing and relocation-assignment text from the draft, or reduce it to one neutral limitation line that does not say which address field places a firm. Preregistration files are committed history, so flag them rather than editing. Check: grep for "address", "地址", "遷址", "current address" and "establishment" returns nothing in the draft or note.

R5-4 (major) AI disclosure and responsible author are missing from the note.
- The note's byline is only "Oct 31, 2026 · @Niko" (p.1). It has no AI-use statement.
- AI appears only in passing: "An independent AI referee" (§7) and "One agent wrote all the estimation and simulation code" (§6). It never says an AI wrote the note, the preregistration or the paper text. It never names Niko (段皇方) as the responsible author.
- The draft has a short "AI use" section (line 441): "done with Claude (Anthropic) agents under the author's direction. The author and a human economist are responsible for the content. An independent AI referee reviewed the pre-registration." Problems:
  - The "human economist" is not identified anywhere I may read.
  - preregistration/signoff.md line 14 says the reviewer was "an AI reviewer session". Table 1 of the note (p.2) says the plan was "signed by Niko and a reviewer". The note never says that reviewer was an AI.
  - The draft says the referee reviewed only the pre-registration. The note says it reviewed "the plan and each gate".
  - The note says "four referee rounds"-style spend (US$6/14/18/20). The referee's rounds are described accurately in Table 5, but the note does not say AI also wrote the referee-ruling summaries ("Main points (our summary)").
- Draft Disclosure (line 437): "Only the project's coordinating agent saw them; the research team and the referee did not." The note's §2 and D1a say the research team did see the totals at 01:51 UTC. The draft is now wrong.
Fix: add an AI-use paragraph to the note. It should name Niko (段皇方) as the responsible author, say who wrote what, say the sign-off reviewer was AI, and correct the draft's exposure paragraph. Check: the note has an AI-use statement; "human economist" is either identified or deleted.

R5-5 (major) Internal product and process references that reveal methods and infrastructure.
- Note §2 (p.4): "the project's M1 machine", "the data builder", "the cloud manager", "the coordinating agent".
- deviations.md line 10 (D1): "the M1 posted three whole-window totals, on bizmap #205 and in the export tarball's MANIFEST". "bizmap #205" is an internal ticket in another project's tracker. Deviations lines 15 and 124-126 also mention "the cloud manager" and "the research manager".
- preregistration/signoff.md lines 3-4 and deviations line 97: claude.ai artifact URLs for the doc and the rerun doc. code/stage3-prep.md line 7 links more artifacts.
- note p.14: asset IDs and the "Claude Docs doc" workflow appear in the attached-files list (fcf1273e…, 815f234…, f2eab44…, 9bd1c26…).
- The note does not name another repository or issue numbers. It does name "nikolasdoan/tw-econ-research" and commit hashes, which is fine.
Fix: delete "bizmap #205" and describe the export neutrally ("the data builder"). Remove asset IDs from the PDF. Check: grep for "bizmap" and "#205" returns nothing outside git history.

R5-6 (minor) "Open licence" claim on the 9400 page is mixed up. The note says page 9400 "also links the licence text at data.gov.tw/license" (p.3). I confirmed that. The page also says it holds 營業中 data only, which does not match the note's use ("new registrations and closures"). That is a data-fitness point, not a licence one.

R5-7 (minor) The note says the data are "described by source and licence only" (p.3), but MANIFEST.md and the note record that the export was built by a private route. MANIFEST.md says "All of it comes from public records". For registrations this cannot be verified: no registry file is in data/ and no registry manifest is readable. Could not verify.

Count by severity: 0 fatal, 5 major (R5-1 to R5-5), 2 minor.

## Referee 6

REFEREE 6 REPORT: writing, figures, consistency
Document: paper/mrt-pilot-design-note.pdf (14 pp), read page by page as rendered. Repo at fba3289.
Not applicable: no outcome data opened (pre-trends, estimated effects). The note makes no claim that needs that check. Its pre-trend rows are synthetic.
Verified: H1 is stated as untested on p1 and in section 2, and this matches deviations.md (D2, D5, D6 present). Commit dates in Table 1 match git, except where noted below. The 4.4/14.9/32.7% figures in section 7 item 3 recompute exactly (binomial, n=200, limit 92.5%). The MDE interpolation (0.24; +20%) and the % of base column in Table 4 recompute.

R6-1 (major) Abstract: headline numbers have no interval or range.
- Where: p1, summary bullets.
- "About 75%", "3.9% of the effect" and "+20%" are given bare. The body has MC SE about 3 points for the 75%. It has a paired SE of 0.0016 for the 3.9% (about 0.3 points of τ). It gives no uncertainty at all for the 0.24 / +20% MDE, which is interpolated between two 200-seed points with SEs of 3.3 and 1.6.
- The abstract also never says that "+20%" is relative to an assumed base of 1.2 per 1,000 per quarter. Section 2 says that base is a round number with no source.
- Fix: write each number with its SE or range, and give an MDE range. State the 1.2 assumption in the abstract.
- Check: every number on p1 is followed by an SE/range that matches Tables 3 and 4.

R6-2 (major) Abstract: no plain takeaway for a policy reader, and it uses undefined jargon.
- Where: p1. "D2 gate", "D5 gate", "D6", "kill rules", "small-cell rule", "Finding 1/2" and "primary test" are all used before any definition.
- "Amended inference (D2) failed ... in the D2 gate and the D5 gate" uses "D2" for two things. It means the amendment in one place and the gate in another.
- Nowhere on p1 does it say what a Taiwan reader should conclude. The honest answer is "we do not know whether MRT openings changed business formation; this note says how a later study should be built". That sentence is missing.
- p1 does not say the authors, code and referee are AI agents. That only comes out in section 6 ("one agent wrote all the code") and section 7 ("an independent AI referee"). It matters for how a reader weighs "referee ruling" and "signed by Niko and a reviewer".
- Fix: add a 2-sentence plain-language lead before the bullets. Give each of the two measured results one clause of plain explanation. State AI authorship and AI refereeing on p1. Rename the amended inference "placebo-district inference" and keep D2 for the ruling.
- Check: a reader with no code access can say what was and was not learned, using only p1.

R6-3 (major) Jargon is used before it is explained, and the glossary does not cover it.
- Used with no definition anywhere:
  - seed, scenario names ("Stress", "Pre-trend", "Effect, suppressed"), "half-width ratio", Ferman–Pinto, "placebo-district inference", "cohort", "comparison district", "base quarter" (before section 4), "primary test", "primary estimate".
  - R2 (the ring) in the σ²_j glossary entry, N₀ (section 6), "stage 3" and "stage 5", "M1 machine", "cloud manager", "data builder", "Result A/B" (fine once, but not in the glossary), and "τ".
- Defined only on p14 but needed from p1: kill rules (K1–K3b), r*, k, MC SE. Table 3 uses K2a to K3b and MC SE on p5. Section 3 says "Monte Carlo (MC) SEs" inline, but K2a is only explained on p14.
- Fix: move the glossary to follow the summary, or add a one-line gloss at first use. Add the missing terms. Add a 4-line "how to read Table 3" box.
- Check: every symbol or code in a table or figure is defined before or on the same page as its first use.

R6-4 (major) The primary estimand is unclear.
- Where: section 1 vs the glossary (K3b).
- H1 says "the 12 quarters after opening". K3b says it is tested "against the k = 0–3 estimate", and section 7 says "keeps k = 0–3". The note never says which estimate is the "primary test" that power refers to.
- Fix: state the estimand once in section 1 (event window and aggregation).
- Check: sections 1, 5 and the glossary all name the same window.

R6-5 (major) Bolding in Table 3 does not follow the stated rule for round 4.
- Where: Table 3, p5–6, and the "Limits" paragraph.
- The rule says bold means "outside the limit in force". Round 2 limit is rejection 3.0–7.5%, and the stress row's rejection of 8.0% is bold.
- Round 4 "used the same limits", yet the round 4 stress row shows rejection 2.0% (1.0), which is below 3.0, and it is not bold.
- The text never says which limits apply to which scenarios, so the reader cannot tell whether this is a bolding error or a rule that applies only in some rows.
- Fix: add a table (limit × scenario) or state that the rejection floor applies to null and stress in round 2 only. Correct the bold if needed.
- Check: every bold cell, and no unbolded cell, violates a limit listed per scenario.

R6-6 (minor) The Result A range disagrees with Table 4.
- Where: Result A says "73.0–76.0%". Table 4 gives claim rates of 75.5, 73.0 and 75.0 for τ = 0.3–0.5, so the range is 73.0–75.5. Section 5 says "73–76%" and "highest 75.5%".
- "Together they fire in 22–27% of seeds" is not traceable to a table. Table 3 gives 25.0% (D5, τ = 0.5), and 1 − Table 4's claim rate gives about 24.5–27%.
- Fix: use 73.0–75.5% and add the any-kill rates by τ to Table 4.
- Check: all ranges are reproducible from a printed table.

R6-7 (minor) Table 3, round 1 row is mislabelled.
- The coverage cell holds "Spread ±0.1 vs half-width ±0.07", which is not a coverage rate.
- Bias is "+0.027" with no SE (5 seeds).
- The K2a and K2b cells are counts ("3 of 5") in rate columns.
- Fix: move round 1 out of the table into a note, or give it its own mini-table with labelled columns.
- Check: every column holds one kind of quantity.

R6-8 (minor) Table 3 mixes units and layout.
- The round 3 row "Round-2 runs re-scored" shows ranges ("5.0–8.0%", "16.5–23.8%; pre-trend 92.0%") with no label of which scenario each end belongs to.
- "σ²_j on" in the round 4 label is plain-text notation, and Figure 1 shows the raw code name "sigma2_j".
- The table breaks across pp5–6 in the middle of round 4. The header repeats, but the round label does not.
- Fix: one scenario per row, and use σ²ⱼ consistently or one plain name ("line-shock variance term").
- Check: no row in the table is split by a page break.

R6-9 (minor) Figure 1 is hard to read at a glance.
- Where: p10.
- No legend. The solid line is power and the dotted line is claim rate, but this is only in the title and caption.
- The dashed reference lines (5%, 80%) are labelled only in tiny 6-pt footnote text. The footnote also holds "B = 999" and "σ²_j on" and is not defined.
- The dotted claim-rate line has no error bars, although its SE is about 3 points, so the gap between the lines (the whole point) cannot be judged.
- The y-axis says "seeds" and the x-axis is in "registrations per 1,000 residents per quarter". Units are fine, but the figure does not mark the MDE of 0.24.
- Fonts are smaller than the body text. Chinese characters render properly everywhere in the PDF (Tables 1–2, section 1).
- Fix: add a direct legend or line labels, label the 5% and 80% lines on the plot, add bars to the dotted line, and mark 0.24. The figure repeats Table 4 exactly.
- Check: a reader can state both curves and the MDE without reading the caption.

R6-10 (minor) Layout: orphaned captions and blank pages.
- "Table 1" caption sits alone at the bottom of p1, and the table starts on p2. "Table 5" caption sits at the bottom of p11, with the table on p12.
- p9 is about two-thirds blank. p1–2 and p11–12 have large gaps.
- Fix: keep captions with their tables.
- Check: no caption is the last item on a page.

R6-11 (minor) Dates, commits and labels.
- Mostly consistent with git. These need attention:
  - Table 1 lists D1a (b5bcdaf, committed 03:01, the latest of all) before D2 in a row order that looks chronological. D1a is after D6 (02:47). The table has no timestamps for any row except the merge.
  - D3 and D5 share 6c9c970 (the note says so).
  - Section 2 says the 1.2 base rate was "written into the synthetic-data code at 01:27 UTC", before the totals (01:51). But the first commit containing the code is f56e15b at 02:04, after 01:51. The 01:27 time is not in git. Could not verify the 01:27 claim, and "no design value was changed after 01:51" from the repo alone.
  - "D4 not yet committed" and "pre-outcome bundle has not arrived" are true at fba3289, but a data-pre bundle (5869460) now exists. Date the statement.
  - The "Labelling" paragraph (section 1) and the Table 5 row for D2 both explain the D1/D2 naming clash. The renaming is confusing and shows up again in section 7.
- Fix: add commit times to Table 1, and say where the 01:27 time comes from (file mtime? log?). Add "as at fba3289" to the D4 line.
- Check: each time in the text appears in git or is flagged as author-reported.

R6-12 (minor) Attached-file references cannot all be followed.
- "gate_v3_all_seeds.csv ... attached to the 'analysis code v3 and D5 gate' doc" and the uploaded "assets" (SHA-256 strings of 64 characters, five of them) point to a place outside the repo. results/gate-v3 exists in the repo but the note does not give its path.
- power_summary.csv is cited as an attached file but lives in results/, not paper/.
- sim_power.R and sim_gate_v3.R have no repo paths.
- Could not verify the "asset" ids (outside what I may read).
- Fix: give repo paths, and put all hashes in one table in an appendix.
- Check: each named file opens from the commit by path alone.

R6-13 (minor) Said more than once, or not needed. These can be cut without loss.
- "Untested" is stated on p1, in section 2 (twice, including "This note is not evidence for or against it"), and again in section 7 quoting D6. Keep p1 and one line in section 2.
- Result A appears in section 4, the MDE bullet (section 5: "(Result A)"), the Figure 1 caption, and p1. Keep the first and refer to it.
- MC imprecision is repeated 4 times: section 3 "Limits", Finding 2 (coverage gap within noise), section 6 ("monitoring limits are coarse" and "MC imprecision ... partly luck"), and section 7 item 3. Say it once, with the 4.4/14.9/32.7% numbers.
- Section 7 "Key passages from the rulings" repeats the Table 5 verdicts, Table 1 and section 1 "Labelling". Cut to the D2 diagnosis quote plus D6's "does not bend" line.
- The referee's spend ("US$6, US$14, US$18 and US$20") is not needed for a policy reader. It also gives four numbers for five rounds.
- Section 7 "Errors in the referee's work" items 1 and 3 are process history, not findings about the design. They could go to an appendix.
- Section 6 "Our own errors" (4 bullets) is fine, but the "locale fault merged 5 clusters into 2" is not explained.
- Section 3 SHA list and the "Attached files" block interrupt the results (pp6–7). Move to an appendix.

R6-14 (minor) Finding 2 text is hard to follow.
- Where: p8. "σ²_j on, D5 seeds, no suppression for the effect" is the condition for the evidence bullets, but Table 4's τ = 0.5 row uses the suppressed scenario. Both rows show 91.5% (2.0) coverage, which looks like a copy error to a reader.
- The paragraph concludes "does not claim that this mechanism caused the D5 failure", yet the heading says "probable mechanism" and p1 repeats "probable mechanism for the D5 failure". The summary overstates relative to the body.
- Fix: change the p1 wording to "a possible mechanism, not shown to cause the failure". Say in one clause why the two 91.5% figures coincide.
- Check: p1 and section 4 use the same strength of claim.

Count: fatal 0, major 5 (R6-1, R6-2, R6-3, R6-4, R6-5), minor 9 (R6-6 to R6-14).
