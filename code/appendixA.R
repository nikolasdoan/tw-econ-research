# appendixA.R -- Appendix A of pre-registration v2.1 (§10), from the pre-data bundle ONLY.
# Reads stations, 村里 boundaries/centroids and base-year population. Opens no outcome file.
# Usage: Rscript appendixA.R <data/pre dir> <out dir> [data_end_quarter, default 2026Q3]
# Output: appendixA.md (text for a dated deviations.md entry), appendixA.json, groups.csv (frozen distances, §3 rule 3).
suppressPackageStartupMessages({ library(data.table); library(digest); library(jsonlite) })
args <- commandArgs(TRUE)
IN  <- if (length(args) >= 1) args[1] else "../synth_pre"
OUT <- if (length(args) >= 2) args[2] else "../out_appendixA"
END <- if (length(args) >= 3) args[3] else "2026Q3"
dir.create(OUT, showWarnings = FALSE, recursive = TRUE)
qi <- function(y, q) y * 4L + (q - 1L); q_of <- function(s) qi(as.integer(substr(s, 1, 4)), as.integer(substr(s, 6, 6)))
yq <- function(q) sprintf("%dQ%d", q %/% 4L, q %% 4L + 1L)
END_Q <- q_of(END)
log_ <- character(0); note <- function(...) { m <- sprintf(...); log_ <<- c(log_, m); message(m) }

## ---------- 0. schema map: the ONLY part edited when the real bundle arrives (each edit is logged) ----------
SCHEMA <- list(
  stations   = list(file = "stations.csv", id = "station_id", name = "name", line = "line", lon = "lon", lat = "lat",
                    open = "open_date", category = "category"),
  villages   = list(file = "villages.csv", id = "village_code", district = "town_code", city = "county",
                    lon = "lon", lat = "lat", area = "area_km2", lon_pw = NA, lat_pw = NA, vintage = "vintage"),
  pop_vil    = list(file = "population_village.csv", id = "village_code", year = "year", pop = "population"),
  pop_dist   = list(file = "population_district_2012.csv", district = "town_code", pop = "population"),
  zones      = list(file = "zones.csv", district = NA)          # optional: development-zone membership by 村里
)
STUDY_CITIES <- c("臺北市", "新北市", "桃園市", "台北市")

## ---------- 1. registered constants (v2.1) ----------
ANT <- 12L; EMIN <- 0L; EMAX <- 11L; MIN_CTRL <- 30L; G_CUTOFF <- qi(2023, 3)
## v2.1 §2 opening dates; these win over the bundle's dates (differences are logged)
V21 <- data.table(
  event = c("機捷", "綠山", "環狀", "藍海", "安坑", "A22"),
  open_public = as.IDate(c("2017-02-16", "2018-12-24", "2020-01-31", "2020-11-15", "2023-02-10", "2023-07-31")),
  cluster = c("機捷", "淡海", "環狀", "淡海", "安坑", "A22"))
BLUE_SEA <- c("台北海洋大學", "臺北海洋大學", "沙崙", "淡水漁人碼頭")       # 藍海線 phase 1 new stations
k0 <- function(d) { d <- as.IDate(d); y <- year(d); q <- quarter(d)
  qend <- as.IDate(sprintf("%d-%02d-01", y + (q == 4), ifelse(q == 4, 1, q * 3 + 1))) - 1L
  qi(y, q) + as.integer((as.integer(qend - d) + 1L) < 45L) }
V21[, g := sapply(open_public, k0)]

## ---------- 2. TWD97 TM2 (EPSG:3826) projection, GRS80, central meridian 121E, k0 0.9999, FE 250 km ----------
tm2 <- function(lon, lat) {
  a <- 6378137; f <- 1 / 298.257222101; k0 <- 0.9999; lon0 <- 121 * pi / 180; FE <- 250000
  e2 <- f * (2 - f); ep2 <- e2 / (1 - e2); phi <- lat * pi / 180; lam <- lon * pi / 180
  N <- a / sqrt(1 - e2 * sin(phi)^2); T <- tan(phi)^2; C <- ep2 * cos(phi)^2; A <- (lam - lon0) * cos(phi)
  M <- a * ((1 - e2/4 - 3*e2^2/64 - 5*e2^3/256) * phi - (3*e2/8 + 3*e2^2/32 + 45*e2^3/1024) * sin(2*phi) +
            (15*e2^2/256 + 45*e2^3/1024) * sin(4*phi) - (35*e2^3/3072) * sin(6*phi))
  x <- FE + k0 * N * (A + (1 - T + C) * A^3 / 6 + (5 - 18*T + T^2 + 72*C - 58*ep2) * A^5 / 120)
  y <- k0 * (M + N * tan(phi) * (A^2/2 + (5 - T + 9*C + 4*C^2) * A^4/24 + (61 - 58*T + T^2 + 600*C - 330*ep2) * A^6/720))
  list(x = x, y = y) }

## ---------- 3. read the bundle; SHA-256 of every input ----------
rd <- function(s) { f <- file.path(IN, s$file); if (!file.exists(f)) stop("missing input: ", f); fread(f, encoding = "UTF-8", colClasses = "character") }
files <- unlist(lapply(SCHEMA, `[[`, "file")); files <- files[file.exists(file.path(IN, files))]
sha <- sapply(files, function(f) digest(file = file.path(IN, f), algo = "sha256"))
outcome_like <- list.files(IN, pattern = "regist|closure|price|sales|series", ignore.case = TRUE)
if (length(outcome_like)) stop("outcome-like files present in the pre-data folder; refusing to run: ", paste(outcome_like, collapse = ", "))

S <- rd(SCHEMA$stations); s <- SCHEMA$stations
S <- S[, .(station_id = get(s$id), name = get(s$name), line = get(s$line), lon = as.numeric(get(s$lon)), lat = as.numeric(get(s$lat)),
           open = as.IDate(get(s$open)), category = get(s$category))]
V <- rd(SCHEMA$villages); v <- SCHEMA$villages
V <- V[, .(village_id = as.character(get(v$id)), district_id = as.character(get(v$district)), city = get(v$city),
           lon = as.numeric(get(v$lon)), lat = as.numeric(get(v$lat)), area_km2 = as.numeric(get(v$area)),
           vintage = if (!is.na(v$vintage) && v$vintage %in% names(V)) get(v$vintage) else NA_character_)]
vintage <- unique(na.omit(V$vintage))
if (!length(vintage) || !any(grepl("114", vintage))) note("DEVIATION: boundary vintage is '%s', not v2.1's 內政部地政司 114年 (data.gov.tw 130549).", paste(vintage, collapse = "; "))

## ---------- 4. classify stations (§3): study / planned 綠線 / pre-2011 / non-study since 2011 / unknown ----------
S[, line_n := gsub("\\s", "", line)]
S[, event := fcase(grepl("A22|老街溪", name) & grepl("機場", line_n), "A22",
                   grepl("機場", line_n), "機捷",
                   grepl("環狀", line_n), "環狀",
                   grepl("淡海", line_n) & name %in% BLUE_SEA, "藍海",
                   grepl("淡海|綠山|藍海", line_n), "綠山",
                   grepl("安坑", line_n), "安坑", default = NA_character_)]
S[grepl("綠線", line_n) & grepl("桃園", line_n) | category %in% c("planned", "規劃", "施工中"), status := "planned"]
S[!is.na(event), status := "study"]
S[is.na(status) & !is.na(open) & open < as.IDate("2011-01-01"), status := "pre2011"]
S[is.na(status) & !is.na(open) & open >= as.IDate("2011-01-01"), status := "nonstudy"]
S[is.na(status), status := "unknown"]
## study stations take v2.1's dates; log disagreements with the bundle
S <- merge(S, V21[, .(event, v21_open = open_public, g, cluster)], by = "event", all.x = TRUE)
dis <- S[status == "study" & !is.na(open) & open != v21_open]
if (nrow(dis)) note("Station dates differing from v2.1 (v2.1 used): %s", paste(sprintf("%s %s bundle=%s v2.1=%s", dis$line, dis$name, dis$open, dis$v21_open), collapse = "; "))
nd <- S[status == "study" & is.na(open)]
if (nrow(nd)) note("Study stations with no bundle date, dated from v2.1: %d (%s)", nrow(nd), paste(unique(nd$event), collapse = ", "))
xy <- tm2(S$lon, S$lat); S[, `:=`(x = xy$x, y = xy$y)]
xy <- tm2(V$lon, V$lat); V[, `:=`(x = xy$x, y = xy$y)]
## unknown-dated stations: harmless only if no study-area 村里 lies within 2 km of one
unk <- S[status == "unknown"]
if (nrow(unk)) {
  dmin <- sapply(seq_len(nrow(unk)), function(i) min(sqrt((V[city %in% STUDY_CITIES]$x - unk$x[i])^2 + (V[city %in% STUDY_CITIES]$y - unk$y[i])^2)))
  near <- unk[dmin <= 2000]
  note("Unknown-dated stations: %d; within 2 km of a study-area 村里: %d", nrow(unk), nrow(near))
  if (nrow(near)) { fwrite(near, file.path(OUT, "unknown_stations_near_study_area.csv"))
    stop("Unknown-dated stations near the study area; each needs a dated decision before Appendix A (see unknown_stations_near_study_area.csv)") }
}

## ---------- 5. denominator route (§4) ----------
PV <- rd(SCHEMA$pop_vil)[, .(village_id = as.character(get(SCHEMA$pop_vil$id)), year = as.integer(get(SCHEMA$pop_vil$year)), pop = as.numeric(get(SCHEMA$pop_vil$pop)))]
if (2012L %in% PV$year) {
  P <- PV[year == 2012L, .(village_id, P = pop)]; route <- "村里 end-2012 (first choice)"
} else {
  PD <- rd(SCHEMA$pop_dist)[, .(district_id = as.character(get(SCHEMA$pop_dist$district)), pop12 = as.numeric(get(SCHEMA$pop_dist$pop)))]
  y0 <- min(PV$year); sh <- merge(PV[year == y0], V[, .(village_id, district_id)], by = "village_id")
  sh[, share := pop / sum(pop), by = district_id]
  P <- merge(sh, PD, by = "district_id")[, .(village_id, P = pop12 * share)]
  route <- sprintf("fallback: 鄉鎮市區 end-2012 x 村里 share at end-%d (R22 applies)", y0)
}
note("Denominator route: %s", route)

## ---------- 6. groups, exclusions (§3) ----------
V <- V[city %in% STUDY_CITIES]
dist_to <- function(sel) { s <- S[sel]; if (!nrow(s)) return(list(d = rep(Inf, nrow(V)), j = rep(NA_integer_, nrow(V))))
  m <- sqrt(outer(V$x, s$x, "-")^2 + outer(V$y, s$y, "-")^2); list(d = apply(m, 1, min), j = apply(m, 1, which.min), m = m) }
st <- which(S$status == "study"); ds <- dist_to(st)
V[, d_study := ds$d]
V[, `:=`(g = apply(ds$m, 1, function(r) { w <- which(r <= 500); if (length(w)) min(S$g[st][w]) else S$g[st][which.min(r)] }),
         cluster = apply(ds$m, 1, function(r) { w <- which(r <= 500); if (length(w)) S$cluster[st][w][which.min(S$g[st][w])] else S$cluster[st][which.min(r)] }))]
V[, d_green := dist_to(which(S$status == "planned"))$d]
V[, d_pre := dist_to(which(S$status == "pre2011"))$d]
V[, d_non := dist_to(which(S$status == "nonstudy"))$d]
V <- merge(V, P, by = "village_id", all.x = TRUE)
V[, grp := fcase(d_study <= 500, "T", d_study <= 800, "R1", d_study <= 1500, "R2", d_study < 2000, "buffer",
                 d_green <= 500, "G", d_study <= 5000 & d_green >= 2000, "F", default = "other")]
V[, excl := fcase(d_pre <= 500, "1 pre-2011 station within 500 m", d_non <= 800, "2 non-study station (opened since 2011) within 800 m",
                  is.na(P) | P < 500, "3 base population < 500 or missing", default = NA_character_)]
non_lines <- S[status == "nonstudy", .N, by = line][order(-N)]
sanying <- S[status == "nonstudy" & grepl("三鶯", line)]
note("Exclusion 2 uses %d non-study stations on: %s. 三鶯線 stations included: %d", nrow(S[status == "nonstudy"]),
     paste(non_lines$line, collapse = ", "), nrow(sanying))
if (!nrow(sanying)) note("WARNING: no 三鶯線 station found among non-study stations; check line names")
fwrite(V[, .(village_id, district_id, city, x, y, d_study, d_green, d_pre, d_non, g = yq(g), cluster, grp, excl, P)], file.path(OUT, "groups.csv"))

## ---------- 7. K1, per-line counts, comparison clusters, identified cells (§3, §5, §6) ----------
K <- V[is.na(excl)]
T_line <- K[grp == "T", .N, by = .(cluster)][order(cluster)]
T_total <- sum(T_line$N); dropped <- T_line[N < 5, cluster]
K1 <- if (T_total < 30) "FIRES (fewer than 30 T 村里)" else "passes"
## comparison validity: F never treated; G valid up to 2023Q2; T of cohort g valid while g > t + 12 (and > base + 12)
K[, gv := fcase(grp == "F", Inf, grp == "G", as.numeric(G_CUTOFF + ANT - 1L), grp == "T", as.numeric(g), default = NA_real_)]
pool <- K[grp %in% c("G", "T", "F")]
cohorts <- K[grp == "T" & !(cluster %in% dropped), .(nT = .N), by = g][order(g)]
cells <- rbindlist(lapply(seq_len(nrow(cohorts)), function(i) { gc <- cohorts$g[i]
  rbindlist(lapply(EMIN:EMAX, function(e) { t <- gc + e; b <- gc - 13L
    C <- pool[gv > max(t, b) + ANT]
    data.table(cohort = yq(gc), e = e, quarter = yq(t), in_data = t <= END_Q, T_villages = cohorts$nT[i],
               comparison_villages = nrow(C), comparison_no_F = nrow(C[grp != "F"]),
               estimated = t <= END_Q && nrow(C) >= MIN_CTRL) })) }))
N0 <- uniqueN(pool$district_id)
N0_noF <- uniqueN(pool[grp != "F", district_id])

## ---------- 8. write Appendix A ----------
fmt_tab <- function(d) paste(c(paste("|", paste(names(d), collapse = " | "), "|"), paste("|", paste(rep("---", ncol(d)), collapse = " | "), "|"),
                             apply(d, 1, function(r) paste("|", paste(r, collapse = " | "), "|"))), collapse = "\n")
md <- c(sprintf("## Appendix A (pre-registration v2.1 §10) — written %s, before any outcome file was opened", format(Sys.time(), "%Y-%m-%d %H:%M UTC", tz = "UTC")),
  "", "Inputs (data/pre only), SHA-256:", "", fmt_tab(data.table(file = names(sha), sha256 = sha)), "",
  sprintf("- Data end assumed for cell identification: %s.", END),
  sprintf("- Denominator route: %s.", route),
  sprintf("- Boundary vintage: %s.", if (length(vintage)) paste(vintage, collapse = "; ") else "not stated in bundle"),
  sprintf("- K1: %d T 村里 after exclusions — %s. Lines below 5 (dropped from primary): %s.", T_total, K1, if (length(dropped)) paste(dropped, collapse = ", ") else "none"),
  sprintf("- Comparison clusters (鄉鎮市區) in pool G + T + F: N0 = %d; smallest attainable p ≈ 1/(N0+1) = %.3f. Without F: %d.", N0, 1 / (N0 + 1), N0_noF),
  if (N0 < 19) "- N0 < 19: H1 cannot be confirmed; the rules apply as written, with no redesign." else NULL,
  "", "T 村里 per line cluster:", "", fmt_tab(T_line), "",
  "Group sizes before exclusions, and exclusions:", "", fmt_tab(V[, .N, by = .(grp)][order(grp)]), "", fmt_tab(V[!is.na(excl), .N, by = excl]), "",
  "Post cells (cohort × k), comparison 村里 and whether estimated:", "", fmt_tab(cells[, .(cohort, e, quarter, T_villages, comparison_villages, comparison_no_F, estimated)]), "",
  "Log:", "", paste("-", log_))
writeLines(md, file.path(OUT, "appendixA.md"))
writeLines(toJSON(list(inputs_sha256 = as.list(sha), data_end = END, denominator = route, vintage = vintage, T_per_line = T_line,
                       T_total = T_total, K1 = K1, lines_dropped = dropped, N0 = N0, N0_without_F = N0_noF, cells = cells, log = log_),
                  auto_unbox = TRUE, pretty = TRUE), file.path(OUT, "appendixA.json"))
cat("Appendix A written to", OUT, "\n")
