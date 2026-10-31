# MRT pilot: analysis code v1

Oct 31, 2026 · @Niko

## Summary

The v2.1 analysis is written in full and runs end to end on synthetic data in about 90 seconds. It recovers a known effect, 0.538 against a true +0.50, and its estimator equals did 2.5.1 to 11 digits. But a 5-seed check shows the pre-registered inference is too narrow and the pre-trend kill rules fire falsely in most runs. That needs a referee-approved fix before any real outcome file is opened.

- **Built:** groups and K1; the C&S engine; Ferman–Pinto steps 1–6 with 5 line clusters; kill rules K1–K3b; R1–R27 (R15 not run); secondary outcomes with Holm; tables, an event-study figure and a forest plot.
- **Shown:** the effect scenario recovers the truth, the ring spillover (0.136 vs 0.15) and the price effect. The pre-trend scenario triggers K2a, K2b and K3b, so its spurious estimate (0.52 with a true 0) would not be claimed.
- **Not yet right:** FP coverage, and the false-kill rate of K2a/K2b (limits, item 1). HonestDiD needs R ≥ 4.4.
- **No real outcome data was opened or requested.** Code SHA-256s are in the code section.

## Environment and pinned versions

R 4.3.3 (Ubuntu 24.04 package). All R packages come from one dated snapshot, so the snapshot date pins every version, dependencies included: `https://packagemanager.posit.co/cran/__linux__/noble/2026-10-30`.

| Package | Version | Used for |
| --- | --- | --- |
| did | 2.5.1 | Cross-check of the C&S engine; R14 doubly robust |
| BMisc | 1.4.10 | did dependency |
| data.table | 1.18.6.1 | Data handling |
| fixest | 0.14.2 | R9 Sun & Abraham; R11 TWFE; R12 Poisson |
| didimputation | 0.5.1 | R10 Borusyak–Jaravel–Spiess |
| bacondecomp | 0.1.1 | R11 Goodman-Bacon decomposition |
| TwoWayFEWeights | 2.1.0 | R11 negative-weight share |
| ggplot2 | 4.0.3 | Figures |
| digest | 0.6.39 | SHA-256 hashes of Appendix A inputs |
| jsonlite | 2.0.0 | Output files |
| HonestDiD | **not installed** | R15. It needs Matrix ≥ 1.7, which needs R ≥ 4.4. See limits. |

Setup, as run:

```bash
apt-get install -y r-base-core r-base-dev        # R 4.3.3
cat > ~/.Rprofile <<'EOF'
options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/noble/2026-10-30"),
        HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), paste(getRversion(), R.version["platform"], R.version["arch"], R.version["os"])))
EOF
Rscript -e 'install.packages(c("did","data.table","ggplot2","fixest","didimputation","bacondecomp","TwoWayFEWeights","digest","jsonlite"))'
export LANG=C.UTF-8 LC_ALL=C.UTF-8              # required: line names are Chinese
Rscript synth.R effect ../synth_effect 20261031
Rscript synth.R pretrend ../synth_pretrend 20261101
Rscript analysis.R ../synth_effect ../out_effect 1999
Rscript analysis.R ../synth_pretrend ../out_pretrend 1999
```

The UTF-8 locale is required. Without it, the Chinese line names do not match the cluster map, and the treated clusters silently collapse from 5 to 2. This happened in the first run.

## Synthetic data

`synth.R` writes files with the same names and fields as the v2.1 data table (§10), so the analysis script runs on the real export unchanged. Nothing in it comes from real data.

**Layout.** A 40 × 40 km plane cut into 64 districts of 5 × 5 km, with 5,000 村里 at random points. Stations are placed for each study line, with the real k = 0 dates of §2: 機捷 (12 stations), A22 (1), 綠山 (8), 藍海 (3), 環狀 (10) and 安坑 (6). There are also 8 planned 綠線 stations, 25 pre-2011 stations and one non-study line opened in 2014. Each 村里 has a base-year population (log-normal, median 3,000), so some fall under 500. Two rectangles stand in for the development zones.

**Outcome model.** Registrations are Poisson counts with mean rate × population / 1,000, split 60/40 into 公司 and 商業. The rate includes village and district effects, a trend, seasonality and a 15% COVID dip in 2020Q1–2022Q4 for everyone. Counts of 1–2 are suppressed and flagged, as the export may do. Movers (5%), consumer-facing firms (50%), closures, prices and a population series are also generated.

| Scenario | True ATT in T (per 1,000 per quarter) | 500–800 m ring | Pre-trend in T | Expected result |
| --- | --- | --- | --- | --- |
| **effect** (seed 20261031) | **+0.50** from k = 0 | +0.15 | none | Primary ≈ 0.50; no kill rule fires; R7 shows the ring effect |
| **pretrend** (seed 20261101) | 0 | 0 | +0.04 per quarter from k = −20, all periods | K2a and/or K2b fire |

The base rate is about 1.2 per 1,000 per quarter, so the true effect is roughly +40%.

## Synthetic results

The point estimate recovers the true effect, and the pre-trend scenario triggers the kill rules as designed. But the inference is too narrow, and the pre-trend kill rules fire falsely about half the time when there is no pre-trend. That must be fixed, by a deviation the referee approves, before any outcome data is opened (see limits).

**1. The engine equals did 2.5.1.** On the pool where both apply (T + F), my C&S engine and `did::att_gt` + `aggte(dynamic, 0, 11)` both give **0.53635326464**, identical to 11 digits. The engine is needed because did cannot apply 綠線's 2023Q3 cutoff.

**2. Effect scenario (true ATT = +0.50 per 1,000 per quarter)**

| Quantity | Result |
| --- | --- |
| Primary estimate | **0.538** (95% FP interval 0.467–0.608), p < 1/1999 |
| Comparison clusters N₀ / treated clusters | 43 / 5; smallest attainable p ≈ 1/44 = 0.023 |
| T 村里 per line | 機捷 27, 環狀 26, 綠山 17, 安坑 13, 藍海 8, A22 5 (total 96; K1 passes) |
| Ring 500–800 m vs F (R7), true +0.15 | 0.136 (0.089–0.183) |
| Wild bootstrap check (R20) | p < 1/1999 |
| K1 / K2a / K2b / K3a / K3b | pass / **fires (false)** / pass / pass / pass |
| "Effect is real" | FALSE, only because K2a fired falsely |

**3. Pre-trend scenario (true ATT = 0; T trends +0.04 per quarter)**

| Quantity | Result |
| --- | --- |
| Primary estimate | 0.524 (0.433–0.614): spurious, created by the trend |
| K2a | **fires**: pre-window mean −0.327, p < 1/1999 |
| K2b | **fires**: extended trend at k = +5.5 is 0.525, ≥ 50% of the primary |
| K3b (placebo date) | **fires**: 0.153, p < 1/1999 |
| K3a | passes |

So the kill rules stop a false claim here.

**4. Calibration check across 5 effect-scenario seeds** (true ATT 0.50 throughout)

| Seed | Primary | K2a mean (p) | K2b |
| --- | --- | --- | --- |
| 20261031 | 0.538 | 0.080 (0.011) fires | pass |
| 11 | 0.428 | −0.012 (0.69) | **fires** |
| 12 | 0.699 | 0.166 (< 0.001) **fires** | pass |
| 13 | 0.531 | 0.081 (0.025) **fires** | **fires** |
| 14 | 0.441 | −0.052 (0.10) | pass |

The estimate is centred on the truth (mean 0.527), but it varies by about ±0.1 across seeds while each FP interval is only about ±0.07 wide. A kill rule fires falsely in 4 of 5 seeds. The likely cause: treated 村里 in a cohort all share one base quarter (k = −13), so noise in that one quarter moves every event-time estimate together. Comparison clusters enter many cells with different base quarters, so their noise averages out. Their residuals therefore understate the treated clusters' noise, and FP under-covers.

**5. Robustness, effect scenario** (estimates in registrations per 1,000 per quarter; FP p and 95% interval where computed)

| Test | Estimate | Test | Estimate |
| --- | --- | --- | --- |
| R1 no 2020–22 | 0.591 (0.459–0.723) | R14 doubly robust | 0.538 |
| R2a drop 環狀 | 0.584 | R16 cells at 1 / 2 | 0.567 / 0.508 |
| R2b drop 2019–20 cohorts | 0.556 | R17 survivorship-corrected | 0.635 (r = 20.1) |
| R3 leave one out | 0.503–0.584 | R18 balanced k = 0–7 | 0.537 |
| R4 anticipation 8 | 0.539 | R19 fare-start dates | 0.480 |
| R5 ring control | 0.578 | R21 extensive margin | +0.033 share |
| R6 F only | 0.536 | R22 drop 機捷, 綠山 | 0.564 |
| R8 300 m / 800 m | 0.457 / 0.283 | R23 pop-weighted centroid | 0.422 |
| R9 Sun & Abraham | 0.536 | R24 no development zones | 0.532 |
| R10 BJS imputation | 0.491 | R25 no F | 0.537 |
| R11 TWFE | 0.505 | R26 no movers | 0.520 |
| R12 Poisson | +21% | R27 district clusters | 0.538 (0.449–0.626) |
| R13 population-weighted | 0.595 | R15 HonestDiD | not run |

Secondary outcomes behave as built: 公司 +0.273, 商業 +0.265, consumer-facing +0.212, price +NT$6,160 per m², population growth −0.001% (p = 0.48; none was built in).

Figures written by the script: `fig1_event_study.png` (event study, axes labelled in registrations per 1,000 residents per quarter) and `fig2_forest.png` (all tests in one forest plot).

## Code

Two files for `code/` on `prereg-v1`, as run. SHA-256: `analysis.R` 6c05234e90d3687076bb6d5226689d42a783d92311cc37cc8740b64b4d2d596f; `synth.R` f4904a9bdc7188b6446cb66793cba30bf319c04f959a79c1e9618cce84b9b6de.

### code/synth.R

```r
# synth.R -- synthetic export built to the v2.1 data table, with a known true effect.
# Usage: Rscript synth.R <scenario: effect|pretrend> <outdir> [seed]
suppressPackageStartupMessages(library(data.table))
args <- commandArgs(TRUE)
scenario <- if (length(args) >= 1) args[1] else "effect"
outdir   <- if (length(args) >= 2) args[2] else "synth_effect"
seed     <- if (length(args) >= 3) as.integer(args[3]) else 20261031L
set.seed(seed)
dir.create(outdir, showWarnings = FALSE, recursive = TRUE)

qi  <- function(y, q) y * 4L + (q - 1L)            # quarter index
Q0  <- qi(2011, 1); Q1 <- qi(2026, 2)              # export window
TAU_T  <- if (scenario == "effect") 0.50 else 0    # true ATT, registrations per 1,000 per quarter
TAU_R1 <- if (scenario == "effect") 0.15 else 0    # spillover into the 500-800 m ring
PRE_SLOPE <- if (scenario == "pretrend") 0.04 else 0  # differential trend in T, per quarter

## ---- stations (metres on a 40 x 40 km plane) ----
st <- function(line, x, y, open_pub, open_fare, status = "study")
  data.table(line, x, y, open_pub, open_fare, status)
stations <- rbindlist(list(
  st("機捷",  seq(2000, 24000, 2000), 20000, "2017-02-16", "2017-03-02"),
  st("A22",   1000, 20000,                   "2023-07-31", "2023-07-31"),
  st("綠山",  30000, seq(2000, 16000, 2000), "2018-12-24", "2019-02-01"),
  st("藍海",  34000, seq(2000, 6000, 2000),  "2020-11-15", "2020-12-15"),
  st("環狀",  seq(14000, 32000, 2000), 30000, "2020-01-31", "2020-03-01"),
  st("安坑",  20000, seq(33000, 38000, 1000), "2023-02-10", "2023-03-13"),
  st("綠線",  seq(2000, 16000, 2000), 8000, NA, NA, "planned"),
  st("nonstudy2014", 38000, seq(20000, 26000, 2000), "2014-11-15", "2014-11-15", "nonstudy"),
  st("pre2011", runif(25, 24000, 40000), runif(25, 22000, 40000), "2000-01-01", "2000-01-01", "pre2011")
))
stations[, station_id := sprintf("S%03d", .I)]
stations[line == "綠線", expected_open := "2026-12-31"]   # north section target (official, 2025-06-05)
stations[, source := "synthetic"]

## ---- 村里 (villages) and districts ----
NV <- 5000
vil <- data.table(village_id = sprintf("V%04d", 1:NV), x = runif(NV, 0, 40000), y = runif(NV, 0, 40000))
vil[, district_id := sprintf("D%02d", floor(x / 5000) * 8 + floor(y / 5000))]
vil[, x_pw := x + rnorm(NV, 0, 80)][, y_pw := y + rnorm(NV, 0, 80)]   # population-weighted centroid
vil[, area_km2 := rlnorm(NV, log(0.3), 0.5)]
vil[, pop2012 := round(rlnorm(NV, log(3000), 0.6))]
## development zones (R24): two rectangles
zones <- data.table(zone = c("林口特定區", "淡海新市鎮特定區"),
                    xmin = c(4000, 28000), xmax = c(10000, 33000), ymin = c(18000, 0), ymax = c(23000, 9000))

## ---- truth needed for the outcome: nearest study station, cohort ----
pub_q <- function(d) { d <- as.IDate(d); y <- year(d); q <- quarter(d)
  qend <- as.IDate(sprintf("%d-%02d-01", y + (q == 4), ifelse(q == 4, 1, q * 3 + 1))) - 1L
  qi(y, q) + as.integer((as.integer(qend - d) + 1L) < 45L) }
study <- stations[status == "study"]
study[, g := sapply(open_pub, pub_q)]
dmat <- sqrt(outer(vil$x, study$x, "-")^2 + outer(vil$y, study$y, "-")^2)
vil[, `:=`(d_true = apply(dmat, 1, min), g_true = study$g[apply(dmat, 1, which.min)])]

## ---- registrations: village x quarter ----
quarters <- Q0:Q1
pan <- CJ(village_id = vil$village_id, q = quarters)
pan <- merge(pan, vil[, .(village_id, district_id, pop2012, d_true, g_true)], by = "village_id")
vfx <- vil[, .(village_id, a_i = exp(rnorm(.N, 0, 0.3)))]
dfx <- unique(vil[, .(district_id)])[, b_d := exp(rnorm(.N, 0, 0.2))]
pan <- merge(merge(pan, vfx, by = "village_id"), dfx, by = "district_id")
pan[, lam := 1 + 0.004 * (q - Q0) + 0.05 * sin(2 * pi * (q %% 4) / 4)]
pan[, covid := ifelse(q >= qi(2020, 1) & q <= qi(2022, 4), 0.85, 1)]
pan[, k := q - g_true]
pan[, rate := 1.2 * a_i * b_d * lam * covid +
        TAU_T  * (d_true <= 500 & k >= 0) +
        TAU_R1 * (d_true > 500 & d_true <= 800 & k >= 0) +
        PRE_SLOPE * (d_true <= 500) * (k + 20)]
pan[, mu := pmax(rate, 0) * pop2012 / 1000]
pan[, `:=`(n_company = rpois(.N, 0.6 * mu), n_business = rpois(.N, 0.4 * mu))]
pan[, n_moved := rbinom(.N, n_company + n_business, 0.05)]
pan[, n_consumer := rbinom(.N, n_company + n_business, 0.5)]
## suppression of 1-2 counts (0 shown as 0), flagged per cell
for (v in c("n_company", "n_business")) {
  f <- paste0(v, "_suppressed"); pan[, (f) := get(v) %in% 1:2]; pan[get(f) == TRUE, (v) := NA_integer_] }
yq <- function(q) sprintf("%dQ%d", q %/% 4L, q %% 4L + 1L)
reg <- pan[, .(village_id, quarter = yq(q), n_company, n_company_suppressed, n_business, n_business_suppressed,
               n_moved, n_consumer)]
reg[, `:=`(branches = "excluded", date_basis = "核准設立", extraction_date = "2026-10-15")]
fwrite(reg, file.path(outdir, "registrations.csv"))

## ---- closures: district x month, 2013 onward ----
months <- seq(as.IDate("2013-01-01"), as.IDate("2026-06-01"), by = "month")
clo <- CJ(district_id = unique(vil$district_id), month = format(months, "%Y-%m"))
clo[, `:=`(c_company = rpois(.N, 25), c_business = rpois(.N, 18))]
fwrite(clo, file.path(outdir, "closures.csv"))

## ---- prices: village x quarter from 2012Q3 ----
pr <- pan[q >= qi(2012, 3), .(village_id, quarter = yq(q),
  median_price_m2 = round(150000 * a_i * (1 + 0.01 * (q - Q0)) * (1 + 0.03 * (d_true <= 500 & k >= 0))),
  n_trans = rpois(.N, 3))]
fwrite(pr, file.path(outdir, "prices.csv"))

## ---- population: village year-end 2011-2025, district end-2012 ----
popy <- CJ(village_id = vil$village_id, year = 2011:2025)
popy <- merge(popy, vil[, .(village_id, pop2012)], by = "village_id")
popy[, population := round(pop2012 * (1 + 0.005 * (year - 2012)))][, pop2012 := NULL]
fwrite(popy, file.path(outdir, "population_village.csv"))
fwrite(vil[, .(population_2012 = sum(pop2012)), by = district_id], file.path(outdir, "population_district_2012.csv"))

## ---- stations, boundaries, zones, manifest ----
fwrite(stations[, .(station_id, line, x, y, open_public = open_pub, open_fare = open_fare, status, expected_open, source)],
       file.path(outdir, "stations.csv"))
fwrite(vil[, .(village_id, district_id, x_geo = x, y_geo = y, x_pw, y_pw, area_km2)], file.path(outdir, "villages.csv"))
fwrite(zones, file.path(outdir, "zones.csv"))
fwrite(data.table(file = c("registrations.csv", "closures.csv", "prices.csv", "population_village.csv",
                           "population_district_2012.csv", "stations.csv", "villages.csv", "zones.csv"),
                  source = "synthetic", licence = "n/a (synthetic)"), file.path(outdir, "manifest.csv"))
writeLines(jsonlite::toJSON(list(scenario = scenario, seed = seed, tau_T = TAU_T, tau_R1 = TAU_R1,
                                 pre_slope = PRE_SLOPE), auto_unbox = TRUE), file.path(outdir, "truth.json"))
cat("synthetic export written:", outdir, " scenario =", scenario, " true ATT =", TAU_T, "\n")
```

### code/analysis.R

```r
# analysis.R -- MRT pilot, analysis exactly as pre-registration v2.1.
# Usage: Rscript analysis.R <export_dir> <out_dir> [B]
# Section numbers (§) refer to preregistration/mrt-pilot-v2.md (v2.1).
suppressPackageStartupMessages({
  library(data.table); library(did); library(fixest); library(didimputation)
  library(bacondecomp); library(ggplot2); library(digest); library(jsonlite) })
args <- commandArgs(TRUE)
IN  <- if (length(args) >= 1) args[1] else "../synth_effect"
OUT <- if (length(args) >= 2) args[2] else "../out_effect"
B   <- if (length(args) >= 3) as.integer(args[3]) else 9999L
dir.create(OUT, showWarnings = FALSE, recursive = TRUE)
T0 <- Sys.time(); tick <- function(x) message(sprintf("[%6.1fs] %s", as.numeric(difftime(Sys.time(), T0, units = "secs")), x))
set.seed(20261031)
rd <- function(f) fread(file.path(IN, f), encoding = "UTF-8")
qi <- function(y, q) y * 4L + (q - 1L)
q_of <- function(s) qi(as.integer(substr(s, 1, 4)), as.integer(substr(s, 6, 6)))
yq <- function(q) sprintf("%dQ%d", q %/% 4L, q %% 4L + 1L)

## ============ 0. constants fixed by the pre-registration ============
tick("0. constants fixed by the pre-registration")
ANT <- 12L; BASE_K <- -13L; EMIN <- 0L; EMAX <- 11L; MIN_CTRL <- 30L
G_CUTOFF <- qi(2023, 3)                 # §3: G leaves the pool from 2023Q3
COVID <- qi(2020, 1):qi(2022, 4)
LINE_CLUSTER <- c("機捷" = "機捷", "A22" = "A22", "綠山" = "淡海", "藍海" = "淡海", "環狀" = "環狀", "安坑" = "安坑")
## k = 0 rule (§2): first quarter with >= 45 days of service from the date used
k0 <- function(d) { d <- as.IDate(d); y <- year(d); q <- quarter(d)
  qend <- as.IDate(sprintf("%d-%02d-01", y + (q == 4), ifelse(q == 4, 1, q * 3 + 1))) - 1L
  qi(y, q) + as.integer((as.integer(qend - d) + 1L) < 45L) }

## ============ 1. groups, exclusions, K1 (§3) -- station, boundary, base-year population only ============
tick("1. groups, exclusions, K1 (§3) -- station, ")
stations <- rd("stations.csv"); vil <- rd("villages.csv"); zones <- rd("zones.csv")
pop_v <- rd("population_village.csv"); pop_d <- rd("population_district_2012.csv")
input_hash <- sapply(c("stations.csv", "villages.csv", "zones.csv", "population_village.csv", "population_district_2012.csv"),
                     function(f) digest(file = file.path(IN, f), algo = "sha256"))

build_groups <- function(radius = 500, centroid = c("geo", "pw"), date_col = "open_public") {
  centroid <- match.arg(centroid)
  V <- copy(vil); V[, `:=`(cx = if (centroid == "geo") x_geo else x_pw, cy = if (centroid == "geo") y_geo else y_pw)]
  S <- copy(stations); S[status == "study", g := sapply(get(date_col), k0)]
  dist_to <- function(sel) { s <- S[sel]; if (!nrow(s)) return(list(d = rep(Inf, nrow(V)), j = rep(NA_integer_, nrow(V))))
    m <- sqrt(outer(V$cx, s$x, "-")^2 + outer(V$cy, s$y, "-")^2); list(d = apply(m, 1, min), j = apply(m, 1, which.min)) }
  st_i <- which(S$status == "study"); ds <- dist_to(st_i)
  V[, d_study := ds$d]; V[, line := S$line[st_i][ds$j]]; V[, g_near := S$g[st_i][ds$j]]
  ## rule 1: earliest cohort among stations within the radius
  m <- sqrt(outer(V$cx, S$x[st_i], "-")^2 + outer(V$cy, S$y[st_i], "-")^2)
  V[, g_earliest := apply(m, 1, function(r) { w <- which(r <= radius); if (length(w)) min(S$g[st_i][w]) else NA_integer_ })]
  V[, line_earliest := apply(m, 1, function(r) { w <- which(r <= radius); if (length(w)) S$line[st_i][w][which.min(S$g[st_i][w])] else NA_character_ })]
  V[, d_green := dist_to(which(S$status == "planned"))$d]
  V[, d_pre := dist_to(which(S$status == "pre2011"))$d]
  V[, d_non := dist_to(which(S$status == "nonstudy"))$d]
  V <- merge(V, base_pop, by = "village_id", all.x = TRUE)
  V[, grp := fcase(d_study <= radius, "T", d_study <= 800, "R1", d_study <= 1500, "R2", d_study < 2000, "buffer",
                   d_green <= 500, "G", d_study <= 5000 & d_green >= 2000, "F", default = "other")]
  V[grp == "T", `:=`(g = g_earliest, line = line_earliest)]
  V[grp %in% c("R1", "R2"), g := g_near]
  V[, excl := fcase(d_pre <= 500, "1_pre2011_station", d_non <= 800, "2_nonstudy_station",
                    is.na(P) | P < 500, "3_small_population", default = NA_character_)]
  V[, tclus := LINE_CLUSTER[line]]
  V[, in_zone := FALSE]
  for (z in seq_len(nrow(zones))) V[cx >= zones$xmin[z] & cx <= zones$xmax[z] & cy >= zones$ymin[z] & cy <= zones$ymax[z], in_zone := TRUE]
  V[]
}
## denominator (§4): village end-2012 if present, else district end-2012 x earliest village share
if (2012 %in% pop_v$year) {
  base_pop <- pop_v[year == 2012, .(village_id, P = population)]; denom_route <- "village end-2012"
} else {
  y0 <- min(pop_v$year); s <- merge(pop_v[year == y0], vil[, .(village_id, district_id)], by = "village_id")
  s[, share := population / sum(population), by = district_id]
  base_pop <- merge(s, pop_d, by = "district_id")[, .(village_id, P = population_2012 * share)]
  denom_route <- sprintf("district end-2012 x village share at end-%d", y0)
}
V0 <- build_groups()
if (V0[grp == "T" & is.na(excl), anyNA(tclus)]) stop("treated village without a line cluster: check UTF-8 locale")
keep <- function(V) V[is.na(excl)]
k1_tab <- keep(V0)[grp == "T", .N, by = .(line)][order(line)]
K1_total <- sum(k1_tab$N); lines_dropped <- k1_tab[N < 5, line]
K1_fires <- K1_total < 30

## ============ 2. outcome (§4) -- opened only after the above ============
tick("2. outcome (§4) -- opened only after the ab")
reg <- rd("registrations.csv"); reg[, q := q_of(quarter)]
impute <- function(x, flag, lo_hi = "mid") { v <- fifelse(flag, switch(lo_hi, mid = 1.5, lo = 1, hi = 2), as.numeric(x)); v }
make_panel <- function(V, cell = "mid", outcome = c("total", "company", "business", "consumer", "any", "nomove")) {
  outcome <- match.arg(outcome)
  R <- copy(reg)
  R[, nc := impute(n_company, n_company_suppressed, cell)][, nb := impute(n_business, n_business_suppressed, cell)]
  R[, N := switch(outcome, total = nc + nb, company = nc, business = nb, consumer = as.numeric(n_consumer),
                  any = as.numeric((nc + nb) > 0), nomove = nc + nb - n_moved)]
  P <- merge(R[, .(village_id, q, N)], keep(V)[, .(village_id, grp, g, line, tclus, district_id, P, in_zone)], by = "village_id")
  P[, y := if (outcome == "any") N else 1000 * N / P]
  P[]
}

## ============ 3. C&S engine (unconditional ATT(g,t), universal base, anticipation) ============
tick("3. C&S engine (unconditional ATT(g,t), univ")
## Returns the long table of (unit, cell, role, delta, weight); the statistic is sum_T w*delta - sum_C w*delta.
cs_long <- function(P, treat = "T", pool = c("G", "T", "F"), ant = ANT, base_k = BASE_K, emin = EMIN, emax = EMAX,
                    drop_q = integer(0), wvar = NULL, g_override = NULL, qmax_use = Inf, min_ctrl = MIN_CTRL) {
  D <- copy(P)
  if (!is.null(g_override)) D <- g_override(D)
  D[, gv := fcase(grp %in% c("F", "R1", "R2") & !(grp %in% treat), Inf,
                  grp == "G" & !("G" %in% treat), as.numeric(G_CUTOFF + ant - 1L),   # valid while t + ant < cutoff + ant
                  default = as.numeric(g))]
  D <- D[q <= qmax_use]
  W <- dcast(D, village_id + grp + gv + g + tclus + district_id + P ~ q, value.var = "y")
  qs <- as.integer(setdiff(names(W), c("village_id", "grp", "gv", "g", "tclus", "district_id", "P")))
  tr <- W[grp %in% treat]; cohorts <- sort(unique(tr$g))
  ctrl_pool <- W[grp %in% pool]
  out <- list()
  for (gc in cohorts) for (e in emin:emax) {
    t <- gc + e; b <- gc + base_k
    if (t %in% drop_q) next
    if (b %in% drop_q) { cand <- setdiff(qs[qs < b], drop_q); if (!length(cand)) next; b <- max(cand) }
    if (!(t %in% qs) || !(b %in% qs)) next
    Tm <- tr[tr$g == gc]; Cm <- ctrl_pool[gv > max(t, b) + ant & !(village_id %in% Tm$village_id)]
    if (nrow(Cm) < min_ctrl || !nrow(Tm)) next
    dT <- Tm[[as.character(t)]] - Tm[[as.character(b)]]; dC <- Cm[[as.character(t)]] - Cm[[as.character(b)]]
    wT <- if (is.null(wvar)) rep(1, nrow(Tm)) else Tm[[wvar]]; wC <- if (is.null(wvar)) rep(1, nrow(Cm)) else Cm[[wvar]]
    out[[length(out) + 1]] <- rbind(
      data.table(village_id = Tm$village_id, role = "T", clusT = Tm$tclus, dist = Tm$district_id, g = gc, e, delta = dT, w0 = wT / sum(wT)),
      data.table(village_id = Cm$village_id, role = "C", clusT = NA, dist = Cm$district_id, g = gc, e, delta = dC, w0 = wC / sum(wC)))
  }
  L <- rbindlist(out); if (!nrow(L)) return(NULL)
  ## dynamic aggregation: equal weight per e; within e, cohorts weighted by number of T units
  nT <- L[role == "T", .(nT = sum(w0 > 0)), by = .(g, e)]
  nT[, pg := nT / sum(nT), by = e]; ne <- uniqueN(nT$e)
  L <- merge(L, nT[, .(g, e, pg)], by = c("g", "e"))
  L[, w := w0 * pg / ne]
  attr(L, "att_e") <- L[, .(att = sum(w0 * delta * (role == "T")) - sum(w0 * delta * (role == "C"))), by = .(g, e)][
    nT, on = .(g, e)][, .(att = sum(att * pg)), by = e][order(e)]
  L
}
stat_of <- function(L) L[role == "T", sum(w * delta)] - L[role == "C", sum(w * delta)]

## ============ 4. Ferman-Pinto inference, steps 1-6 (§6) ============
tick("4. Ferman-Pinto inference, steps 1-6 (§6)")
fp_test <- function(L, tcl = "line", B_ = B, alpha = 0.05) {
  Tt <- copy(L[role == "T"]); Cc <- L[role == "C"]
  Tt[, cl := if (tcl == "line") clusT else dist]
  M <- Cc[, sum(w * delta)] / Cc[, sum(w)]
  tc <- Tt[, .(W = sum(w), D = sum(w * delta) / sum(w), n = uniqueN(village_id)), by = cl]
  cc <- Cc[, .(V = sum(w), E = sum(w * delta) / sum(w), n = uniqueN(village_id)), by = dist]
  tc[, pi := W / sum(W)]; stat <- tc[, sum(pi * D)] - M
  cc[, r := E - M]
  fit <- lm(I(r^2) ~ I(1 / n), data = cc); fl <- 0.25 * mean(cc$r^2)   # floor: a fitted variance below 1/4 of the mean is set to it
  vf <- function(n) pmax(predict(fit, data.frame(n = n)), fl)
  N0 <- nrow(cc)
  draws <- replicate(B_, { j <- sample.int(N0, nrow(tc), replace = TRUE)
    sum(tc$pi * cc$r[j] * sqrt(vf(tc$n) / vf(cc$n[j]))) })
  pfun <- function(null) mean(abs(draws) >= abs(stat - null))
  grid <- seq(stat - 6 * sd(draws), stat + 6 * sd(draws), length.out = 401)
  acc <- grid[sapply(grid, pfun) > alpha]
  list(stat = stat, p = pfun(0), ci = if (length(acc)) range(acc) else c(NA, NA), N0 = N0,
       n_treated_clusters = nrow(tc), p_min = 1 / (N0 + 1), draws = draws)
}
## Wild cluster bootstrap check (R20): null imposed, Webb six-point weights, same clusters
webb <- c(-sqrt(3/2), -1, -sqrt(1/2), sqrt(1/2), 1, sqrt(3/2))
wild_test <- function(L, B_ = B) {
  Tt <- L[role == "T"]; Cc <- L[role == "C"]; M <- Cc[, sum(w * delta)] / Cc[, sum(w)]
  tc <- Tt[, .(W = sum(w), D = sum(w * delta) / sum(w)), by = clusT][, pi := W / sum(W)]
  cc <- Cc[, .(V = sum(w), E = sum(w * delta) / sum(w)), by = dist][, s := V / sum(V)]
  stat <- tc[, sum(pi * D)] - M
  eT <- tc$D - tc[, sum(pi * D)]; eC <- cc$E - M
  d <- replicate(B_, sum(tc$pi * eT * sample(webb, nrow(tc), TRUE)) - sum(cc$s * eC * sample(webb, nrow(cc), TRUE)))
  list(stat = stat, p = mean(abs(d) >= abs(stat)))
}

## ============ 5. primary estimate (§1, §6) ============
tick("5. primary estimate (§1, §6)")
P0 <- make_panel(V0)
L0 <- cs_long(P0)
FP0 <- fp_test(L0)
att_e0 <- attr(L0, "att_e")
## cross-check against did 2.5.1 on the pool where both definitions coincide (T + F; G's cutoff needs the engine)
Pd <- P0[grp %in% c("T", "F")][, gname := fifelse(grp == "F", 0L, as.integer(g))][, id := as.integer(factor(village_id))]
cs <- att_gt(yname = "y", tname = "q", idname = "id", gname = "gname", data = as.data.frame(Pd),
             control_group = "notyettreated", anticipation = ANT, base_period = "universal",
             est_method = "reg", bstrap = FALSE, cband = FALSE)
agg <- aggte(cs, type = "dynamic", min_e = EMIN, max_e = EMAX, na.rm = TRUE, bstrap = FALSE)
Lchk <- cs_long(P0, pool = c("T", "F"), min_ctrl = 1)
did_check <- c(did_2.5.1 = agg$overall.att, engine = stat_of(Lchk))

## ============ 6. kill rules (§7) ============
tick("6. kill rules (§7)")
Lpre <- cs_long(P0, emin = -20L, emax = -14L)
FPpre <- fp_test(Lpre)
pre_e <- attr(Lpre, "att_e")
K2a_fires <- FPpre$p < 0.10
fitpre <- lm(att ~ e, data = pre_e); pred55 <- unname(predict(fitpre, data.frame(e = 5.5)))
K2b_fires <- sign(pred55) == sign(FP0$stat) && abs(pred55) >= 0.5 * abs(FP0$stat)
## K3a: G given a fake k = 0 at 2020Q1, F only, anticipation 0, G as one treated cluster
P3a <- copy(P0)[grp %in% c("G", "F")][grp == "G", `:=`(g = qi(2020, 1), tclus = "綠線")]
L3a <- cs_long(P3a, treat = "G", pool = "F", ant = 0L, base_k = -1L, qmax_use = G_CUTOFF - 1L)
FP3a <- fp_test(L3a)
K3a_fires <- sign(FP3a$stat) == sign(FP0$stat) && FP3a$p < 0.10 && abs(FP3a$stat) >= abs(FP0$stat) / 3
## K3b: fake k = 0 at real k = -16; only quarters <= real k = -13; compared with primary k = 0..3
fake <- function(D) { D[grp == "T", `:=`(g_real = g, g = g - 16L)]; D[grp == "T", y := fifelse(q <= g_real - 13L, y, NA_real_)]; D[!is.na(y)] }
L3b <- cs_long(P0, ant = 0L, base_k = -1L, emin = 0L, emax = 3L, g_override = function(D) {
  D <- fake(D); D[grp %in% c("G", "T", "F")] })
## controls must be outside their own real anticipation: re-check validity with the real cohorts
FP3b <- fp_test(L3b)
L03 <- cs_long(P0, emin = 0L, emax = 3L); prim03 <- stat_of(L03)
K3b_fires <- sign(FP3b$stat) == sign(prim03) && FP3b$p < 0.10 && abs(FP3b$stat) >= abs(prim03) / 3
kill <- data.table(rule = c("K1", "K2a", "K2b", "K3a", "K3b"),
  value = c(K1_total, FPpre$stat, pred55, FP3a$stat, FP3b$stat),
  p = c(NA, FPpre$p, NA, FP3a$p, FP3b$p),
  fires = c(K1_fires, K2a_fires, K2b_fires, K3a_fires, K3b_fires))

## ============ 7. survivorship (§8, R17) ============
tick("7. survivorship (§8, R17)")
clo <- rd("closures.csv"); clo[, q := qi(as.integer(substr(month, 1, 4)), (as.integer(substr(month, 6, 7)) - 1L) %/% 3L + 1L)]
E_q <- q_of(paste0(substr(reg$extraction_date[1], 1, 4), "Q", (as.integer(substr(reg$extraction_date[1], 6, 7)) - 1) %/% 3 + 1))
regd <- merge(reg, vil[, .(village_id, district_id)], by = "village_id")[
  , .(Ac = sum(impute(n_company, n_company_suppressed)), Ab = sum(impute(n_business, n_business_suppressed))), by = .(district_id, q)]
surv <- function(type) {
  A <- regd[, .(district_id, q, A = if (type == "c") Ac else Ab)][order(district_id, q)][, A := cumsum(A) - A, by = district_id]
  C <- clo[, .(C = sum(if (type == "c") c_company else c_business) / 3), by = .(district_id, q)]   # monthly mean within quarter
  X <- merge(A, C, by = c("district_id", "q"), all.x = TRUE)[order(district_id, -q)]
  X[, Csum := cumsum(fifelse(is.na(C), 0, C)), by = district_id][, K := A + Csum]   # no founding dates: last term dropped (under-corrects)
  X[, h := C / K]; h13 <- X[q >= qi(2013, 1) & q <= qi(2013, 4), .(h13 = mean(h, na.rm = TRUE)), by = district_id]
  X <- merge(X, h13, by = "district_id"); X[is.na(h), h := h13]
  X <- X[order(district_id, -q)][, S := cumprod((1 - h)^3), by = district_id]      # 3 months per quarter, from E back to t
  X[, .(district_id, q, S)]
}
Sc <- surv("c"); Sb <- surv("b")
P17 <- {
  R <- merge(reg[, .(village_id, q, nc = impute(n_company, n_company_suppressed), nb = impute(n_business, n_business_suppressed))],
             keep(V0)[, .(village_id, grp, g, line, tclus, district_id, P, in_zone)], by = "village_id")
  R <- merge(merge(R, Sc[, .(district_id, q, Sc = S)], by = c("district_id", "q")), Sb[, .(district_id, q, Sb = S)], by = c("district_id", "q"))
  R[, y := 1000 * (nc / Sc + nb / Sb) / P][, .(village_id, q, y, grp, g, line, tclus, district_id, P, in_zone)] }
L17 <- cs_long(P17); r17 <- stat_of(L17)
## breakdown ratio r: scale T contributions by r until the estimate is zero (y_T / r)
Tsum <- L0[role == "T", sum(w * delta)]; Csum <- L0[role == "C", sum(w * delta)]
r_break <- if (Csum != 0) Tsum / Csum else NA_real_
r_fragile <- is.na(r_break) || (r_break > 0.8 && r_break < 1.25)

## ============ 8. robustness R1-R27 (§9) ============
tick("8. robustness R1-R27 (§9)")
run <- function(id, label, L, fp = TRUE, tcl = "line") {
  if (is.null(L)) return(data.table(id, label, est = NA_real_, p = NA_real_, lo = NA_real_, hi = NA_real_))
  if (fp) { f <- fp_test(L, tcl = tcl, B_ = min(B, 1999L)); data.table(id, label, est = f$stat, p = f$p, lo = f$ci[1], hi = f$ci[2]) }
  else data.table(id, label, est = stat_of(L), p = NA_real_, lo = NA_real_, hi = NA_real_) }
R <- list()
R[[1]]  <- run("R1", "Drop 2020Q1-2022Q4", cs_long(P0, drop_q = COVID))
R[[2]]  <- run("R2a", "Drop 環狀", cs_long(P0[line != "環狀" | grp != "T"]))
R[[3]]  <- run("R2b", "Drop cohorts opening 2019Q1-2020Q4", cs_long(P0[!(grp == "T" & g >= qi(2019, 1) & g <= qi(2020, 4))]))
for (l in unique(na.omit(P0[grp == "T", tclus])))
  R[[length(R) + 1]] <- run("R3", paste("Leave out", l), cs_long(P0[!(grp == "T" & tclus == l)]), fp = FALSE)
R[[length(R) + 1]] <- run("R4", "Anticipation 8, base k = -9", cs_long(P0, ant = 8L, base_k = -9L))
P_R <- make_panel(V0)[grp %in% c("T", "R2")][grp == "R2", grp := "F"]
R[[length(R) + 1]] <- run("R5", "Comparison R2 (800-1,500 m)", cs_long(P_R, pool = "F"))
R[[length(R) + 1]] <- run("R6", "Comparison F only", cs_long(P0, pool = "F"))
for (rg in c("R1", "R2")) {
  Pr <- copy(P0)[grp %in% c(rg, "F")][grp == rg, tclus := LINE_CLUSTER[line]]
  R[[length(R) + 1]] <- run("R7", paste("Ring", rg, "vs F"), cs_long(Pr, treat = rg, pool = "F")) }
for (rad in c(300, 800)) { Vr <- build_groups(radius = rad)
  R[[length(R) + 1]] <- run("R8", paste0("Treated radius ", rad, " m"), cs_long(make_panel(Vr))) }
## R9 Sun & Abraham (fixest), R10 BJS imputation, R11 TWFE + Goodman-Bacon: benchmarks on T + F, point estimates
Pf <- P0[grp %in% c("T", "F")][, `:=`(gg = fifelse(grp == "F", 10000L, as.integer(g)), id = as.integer(factor(village_id)))]
Pf[, rel := fifelse(grp == "F", -1000L, as.integer(q - gg))]
sa <- feols(y ~ sunab(gg, q, ref.p = c(-13, -1000)) | id + q, data = Pf[rel >= -20 | grp == "F"], cluster = ~district_id)
sa_agg <- tryCatch({ a <- aggregate(sa, agg = "(ATT)") ; a[1, 1] }, error = function(e) NA_real_)
sa_e <- tryCatch({ cf <- coef(sa); ee <- as.integer(sub(".*::", "", names(cf))); mean(cf[ee >= 0 & ee <= 11]) }, error = function(e) NA_real_)
R[[length(R) + 1]] <- data.table(id = "R9", label = "Sun & Abraham (mean of k = 0..11)", est = sa_e, p = NA, lo = NA, hi = NA)
bjs <- tryCatch(did_imputation(data = Pf[, .(y, id, q, gi = fifelse(grp == "F", 0L, as.integer(g - ANT)))], yname = "y",
                               gname = "gi", tname = "q", idname = "id", horizon = TRUE, pretrends = FALSE), error = function(e) NULL)
bjs_e <- if (is.null(bjs)) NA_real_ else { h <- as.integer(bjs$term); mean(bjs$estimate[h >= ANT & h <= ANT + 11]) }
R[[length(R) + 1]] <- data.table(id = "R10", label = "BJS imputation (mean of k = 0..11)", est = bjs_e, p = NA, lo = NA, hi = NA)
Pf[, D := as.integer(grp == "T" & q >= g)]
twfe <- feols(y ~ D | id + q, data = Pf, cluster = ~district_id)
tick("R9-R10 done"); ## R11 diagnostics on the cohort x quarter mean panel (unit-level bacon() is too slow at ~2,400 units)
Pcm <- Pf[, .(y = mean(y), D = max(D)), by = .(coh = fifelse(grp == "F", 0L, as.integer(g)), q)]
bacon_w <- tryCatch({ bd <- bacon(y ~ D, data = as.data.frame(Pcm), id_var = "coh", time_var = "q", quietly = TRUE)
  sum(bd$weight[bd$type == "Later vs Earlier Treated"]) }, error = function(e) NA_real_)
tick("bacon done"); negw <- tryCatch({ suppressMessages(library(TwoWayFEWeights))
  tw <- twowayfeweights(as.data.frame(Pcm), "y", "coh", "q", "D", type = "feTR")
  tw$nr_minus / (tw$nr_plus + tw$nr_minus) }, error = function(e) NA_real_)
tick("R11 done"); R[[length(R) + 1]] <- data.table(id = "R11", label = sprintf("TWFE (cohort-mean panel: later-vs-earlier weight %.2f; negative-weight share %.2f)", bacon_w, negw),
                                 est = unname(coef(twfe)["D"]), p = NA, lo = NA, hi = NA)
## R12 Poisson (Wooldridge): cohort x post-period interactions, log P offset, small villages kept
Vall <- copy(V0)[excl == "3_small_population" | is.na(excl)]
Pp <- merge(reg[, .(village_id, q, N = impute(n_company, n_company_suppressed) + impute(n_business, n_business_suppressed))],
            Vall[grp %in% c("T", "F") & !is.na(P), .(village_id, grp, g, P)], by = "village_id")
Pp[, cell := fifelse(grp == "T" & q >= g & q <= g + 11, paste0("g", g, "_e", q - g), "0")]
pois <- fepois(N ~ i(cell, ref = "0") | village_id + q, offset = ~log(P), data = Pp[!(grp == "T" & (q < g - 13 | (q >= g - 12 & q < g)))])
pe <- coef(pois); R[[length(R) + 1]] <- data.table(id = "R12", label = "Poisson DiD, mean proportional effect (exp(b) - 1)", est = mean(exp(pe) - 1), p = NA, lo = NA, hi = NA)
R[[length(R) + 1]] <- run("R13", "Weighted by base-year population", cs_long(P0, wvar = "P"))
## R14 doubly robust with covariates, did 2.5.1 on T + F
Pd2 <- merge(Pd, vil[, .(village_id, area_km2)], by = "village_id")
Pd2[, dens := P / area_km2]; Pd2[, ybar := mean(y[q >= qi(2011, 1) & q <= qi(2011, 4)]), by = id]
cs14 <- tryCatch(att_gt(yname = "y", tname = "q", idname = "id", gname = "gname", xformla = ~ log(dens) + ybar,
                        data = as.data.frame(Pd2), control_group = "notyettreated", anticipation = ANT, base_period = "universal",
                        est_method = "dr", bstrap = FALSE, cband = FALSE), error = function(e) NULL)
R[[length(R) + 1]] <- data.table(id = "R14", label = "Doubly robust, 2 covariates (T + F)",
  est = if (is.null(cs14)) NA_real_ else aggte(cs14, type = "dynamic", min_e = 0, max_e = 11, na.rm = TRUE, bstrap = FALSE)$overall.att, p = NA, lo = NA, hi = NA)
R[[length(R) + 1]] <- data.table(id = "R15", label = "HonestDiD M-bar 0.5/1/2: NOT RUN (package needs R >= 4.4)", est = NA, p = NA, lo = NA, hi = NA)
for (ce in c("lo", "hi")) R[[length(R) + 1]] <- run("R16", paste("Small cells imputed at", ce), cs_long(make_panel(V0, cell = ce)))
R[[length(R) + 1]] <- data.table(id = "R17", label = sprintf("Survivorship-corrected (breakdown r = %.2f)", r_break), est = r17, p = NA, lo = NA, hi = NA)
R[[length(R) + 1]] <- run("R18", "Balanced k = 0..7", cs_long(P0, emax = 7L))
V19 <- build_groups(date_col = "open_fare")
R[[length(R) + 1]] <- run("R19", "k = 0 from fare-start dates", cs_long(make_panel(V19)))
R[[length(R) + 1]] <- data.table(id = "R20", label = "Wild cluster bootstrap p (check)", est = FP0$stat, p = wild_test(L0, min(B, 1999L))$p, lo = NA, hi = NA)
R[[length(R) + 1]] <- run("R21", "Extensive margin (any registration)", cs_long(make_panel(V0, outcome = "any")))
R[[length(R) + 1]] <- run("R22", "Drop 機捷 and 綠山 cohorts", cs_long(P0[!(grp == "T" & line %in% c("機捷", "綠山"))]))
R[[length(R) + 1]] <- run("R23", "Population-weighted centroid", cs_long(make_panel(build_groups(centroid = "pw"))))
R[[length(R) + 1]] <- run("R24", "Exclude development zones", cs_long(P0[in_zone == FALSE]))
R[[length(R) + 1]] <- run("R25", "Pool G + T only (no F)", cs_long(P0, pool = c("G", "T")), fp = FALSE)
R[[length(R) + 1]] <- run("R26", "Exclude firms with a 遷址 record", cs_long(make_panel(V0, outcome = "nomove")))
R[[length(R) + 1]] <- run("R27", "Treated clusters = districts", L0, tcl = "district")
rob <- rbindlist(R, fill = TRUE)

## ============ 9. secondary outcomes (§9), Holm across them ============
tick("9. secondary outcomes (§9), Holm across the")
sec <- rbindlist(list(
  run("S1a", "公司 registrations", cs_long(make_panel(V0, outcome = "company"))),
  run("S1b", "商業 registrations", cs_long(make_panel(V0, outcome = "business"))),
  { pr <- rd("prices.csv")[, q := q_of(quarter)]
    Pq <- merge(pr[, .(village_id, q, y = median_price_m2)], keep(V0)[, .(village_id, grp, g, line, tclus, district_id, P, in_zone)], by = "village_id")
    run("S2", "Median residential price per m2 (NT$)", cs_long(Pq[q >= qi(2012, 3)], emin = 0L)) },
  { Py <- merge(pop_v, keep(V0)[, .(village_id, grp, g, line, tclus, district_id, P, in_zone)], by = "village_id")
    Py <- Py[, .(village_id, q = qi(year, 4), y = 100 * (population / P - 1), grp, g, line, tclus, district_id, P, in_zone)]
    Py <- Py[, .SD[CJ(q = qi(2011, 4):qi(2025, 4)), on = "q", roll = TRUE], by = village_id]
    run("S3", "Population growth vs base (%)", cs_long(Py[!is.na(y)], min_ctrl = MIN_CTRL)) },
  run("S4", "Consumer-facing registrations", cs_long(make_panel(V0, outcome = "consumer")))), fill = TRUE)
sec[, p_holm := p.adjust(p, "holm")]

## ============ 10. outputs ============
tick("10. outputs")
real <- FP0$stat > 0 && FP0$p < 0.05 && !any(kill$fires) && rob[id == "R1", est] > 0 && r17 > 0 && !r_fragile
primary <- data.table(estimate = FP0$stat, p_FP = FP0$p, ci_lo = FP0$ci[1], ci_hi = FP0$ci[2], N0 = FP0$N0,
                      treated_clusters = FP0$n_treated_clusters, p_min = FP0$p_min, wild_p = rob[id == "R20", p],
                      r_breakdown = r_break, effect_is_real = real, denominator = denom_route)
appendixA <- list(input_sha256 = as.list(input_hash), denominator = denom_route, T_per_line = k1_tab, T_total = K1_total,
                  lines_below_5 = lines_dropped, N0 = FP0$N0, p_min = FP0$p_min,
                  cells = L0[role == "C", .(comparison_villages = uniqueN(village_id)), by = .(cohort = yq(g), e)][order(cohort, e)])
fwrite(primary, file.path(OUT, "primary.csv")); fwrite(kill, file.path(OUT, "kill_rules.csv"))
fwrite(rob, file.path(OUT, "robustness.csv")); fwrite(sec, file.path(OUT, "secondary.csv"))
fwrite(rbind(pre_e, att_e0), file.path(OUT, "event_study.csv"))
writeLines(toJSON(appendixA, auto_unbox = TRUE, pretty = TRUE), file.path(OUT, "appendixA.json"))
writeLines(toJSON(as.list(did_check), auto_unbox = TRUE, digits = 10), file.path(OUT, "did_check.json"))

## Figure 1: event study; Figure 2: forest plot of all tests
es <- rbind(pre_e, att_e0)
g1 <- ggplot(es, aes(e, att)) + geom_hline(yintercept = 0, colour = "grey50") +
  geom_vline(xintercept = c(-12.5, -0.5), linetype = 2, colour = "grey60") + geom_point() + geom_line() +
  labs(x = "Quarters relative to opening (k; base k = -13; anticipation k = -12..-1 not estimated)",
       y = "ATT: new registrations per 1,000 residents per quarter", title = "Event study, primary specification") + theme_minimal()
ggsave(file.path(OUT, "fig1_event_study.png"), g1, width = 8, height = 4.5, dpi = 120)
fp_tab <- rbind(data.table(id = "Primary", label = "Primary", est = FP0$stat, lo = FP0$ci[1], hi = FP0$ci[2]), rob[, .(id, label, est, lo, hi)], fill = TRUE)
fp_tab[, lab := factor(paste(id, label), levels = rev(paste(id, label)))]
g2 <- ggplot(fp_tab[!is.na(est) & !id %in% c("R12", "R21")], aes(est, lab)) + geom_vline(xintercept = 0, colour = "grey50") +
  geom_errorbarh(aes(xmin = lo, xmax = hi), height = 0, na.rm = TRUE) + geom_point() +
  labs(x = "Estimate: new registrations per 1,000 residents per quarter (95% FP interval where computed)", y = NULL,
       title = "All pre-registered tests (R12 and R21 are on other scales; see table)") + theme_minimal(base_size = 8)
ggsave(file.path(OUT, "fig2_forest.png"), g2, width = 9, height = 8, dpi = 120)
cat("done:", OUT, "\n")
```

## Limits and open items before real data

**Blocking (needs a referee-approved deviation before any outcome file is opened):**

1. **The inference under-covers, and K2a/K2b fire falsely.** See results §4: in 5 effect-scenario seeds, a kill rule fired falsely 4 times, and the estimate's spread (about ±0.1) exceeds the FP interval (about ±0.07). This is a property of v2.1 §6 as written (residuals from comparison districts, with one single-quarter base per cohort), not only of this code. Options for the referee, none applied here:
   - Build each comparison district's residual the same way as a treated cluster: give it a treated cohort's dates as a placebo and use its own single base quarter. Its noise then matches the treated noise.
   - Use a multi-quarter base (the mean of k = −16 to −13) instead of the single quarter k = −13, which cuts the shared base noise about fourfold.
   - Recalibrate by simulation: run 200+ seeds of the no-pre-trend scenario and set K2a/K2b so that the false-kill rate is at most 10%.
2. **R15 HonestDiD did not run.** The package needs R ≥ 4.4. The real run needs R 4.4+ (e.g. CRAN's Ubuntu R 4.5) and a fresh snapshot pin.

**Implementation choices to confirm (not stated in v2.1):**

- **FP variance floor.** A fitted variance a + b/n below a quarter of the mean squared residual is set to that value. Without it the fit went near zero and the draws exploded (SD 121).
- **Engine, not did, for the primary.** did cannot apply 綠線's 2023Q3 cutoff. The engine equals did to 11 digits where both apply; the primary uses the engine.
- **R11 diagnostics** (Goodman-Bacon weight, negative-weight share) run on a cohort × quarter mean panel. At \~2,400 units, unit-level `bacon()` did not finish in 10 minutes.
- **R9–R12 and R14** are benchmarks on T + F, point estimates only.
- **Breakdown ratio r** is approximated as Σ(treated weighted changes) / Σ(comparison weighted changes). It needs a sharper definition before it gates "effect is real".
- **Survivorship** uses the formula without the founding-date term, because the export has no founding dates for closures (under-corrects, as v2.1 states).

**Data-shape items for the real run:**

- **Locale.** Set `LANG=C.UTF-8`. The script now stops if any treated 村里 lacks a line cluster.
- **Denominator.** The script switches to the fallback route automatically when no end-2012 村里 population exists, as expected for the real files (end-2015 shares).
- **Stations.** The real station file has 112 "unknown" stations and uses status labels the script does not yet read. A mapping step is needed: the 12 機場線 stations get v2.1's dates; 三鶯線 goes under exclusion 2.
- **Coordinates.** The script assumes metres; real centroids are probably degrees (TWD97 or WGS84). Project to TWD97 TM2 before distances.
- **Real data was not opened or requested.**
