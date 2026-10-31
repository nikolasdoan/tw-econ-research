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
