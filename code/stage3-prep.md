# MRT pilot: stage-3 prep files

Oct 31, 2026 · @Niko

## What is here

Everything for stage 3 that needs no outcome data, ready to commit to `prereg-v1`. No outcome file was opened or requested. Code v2 and the D2 gate results are in [MRT pilot: analysis code v2 and D2 gate](https://claude.ai/artifact/5YSmCcVsHGToM157GBecu2).

| Piece | Goes to | Status |
| --- | --- | --- |
| D3 機捷 source entry | `preregistration/deviations.md` | Ready; commit with Appendix A (D4) |
| Literature corrections | `notes/` (and the paper) | Delhi now read in full; three stage-1 details corrected |
| `appendixA.R` + `synth_pre.R` | `code/` | Tested on a synthetic bundle; waits for `data/pre` |
| `renv.lock` | `code/` | R 4.3.3, 70 packages pinned; an R 4.5 lock follows for HonestDiD |
| Red-team brief | `redteam/` | Ready; data folder and D2 pointer to add at stage 5 |
| Working-paper draft | `paper/` | Fixed parts drafted, in its own doc |

## D3 (draft for `preregistration/deviations.md`): 機捷 opening-date source

Numbered D3 because D2 is the referee's inference ruling (255eb68). Commit this together with Appendix A (D4), before any outcome file is opened. Text:

```markdown
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

## Literature corrections from full-text reads

The Delhi study was read in full. Three of our stage-1 descriptions of it were wrong, and its planned-station result is weaker than the blog suggested. Credit and Schuetz et al. were also read in full; Feng, Ma and the Kaohsiung paper were not reachable beyond the abstract.

| Study | Read | What changes |
| --- | --- | --- |
| [Kovvuri & Sharma (2025)](https://www.akhilakovvuri.com/JMP.pdf), "Moving Opportunity Closer: How Public Transit Transforms Firm Composition and Employment", job market paper, 26 Nov 2025 | **Full text** | Co-authored with Karmini Sharma. Callaway & Sant'Anna on Delhi registrations 2011–2024, 1,895 H3 hexagons (\~500 m). Headline **+8.91 new firms per hexagon per 6 months (SE 2.09), +143.5%** over 6.21; pre-trend p = 0.22. The 485 comparison hexagons are beyond 1 km of any station, **not planned-but-not-built**. The planned-but-not-built comparison gives **+6.61 (SE 3.54), +67%, significant only at 10%**: about half. B2C +6.66; B2B and high-skill none. Firm-entry SEs clustered by neighbourhood (Conley 5 km only for census regressions). Distance decay is descriptive; no firm-entry ring estimates. Treatment coded from 2 years before opening. |
| [Credit (2018)](https://mural.maynoothuniversity.ie/id/eprint/14606/1/KC-Transit-Oriented-2018.pdf), *Urban Studies* 55(15) | **Full text** (author version) | Numbers confirmed (+88/+40/+28% at opening, fading 8/6/7% a year). They are relative to a control area, for a 1-mile network buffer, Poisson AITS on starts per acre. |
| [Schuetz, Giuliano & Shin (2016)](https://www.federalreserve.gov/econresdata/feds/2016/files/2016004pap.pdf), FEDS 2016-004 | **Full text** | Outcome is employment density and housing (NETS), not business starts. 23 stations; controls are major-road intersections. |
| Feng, Wang & Huang (2025), *JTG* 123 | Abstract only | +53.8% stays abstract-level; cite as such. |
| Ma (2026?), DOI 10.1108/cr-05-2026-0264 | Abstract only | No effect size on the page; journal, year and volume unconfirmed. Cite without a number. |
| 汪志忠、王俞翔 (2013) | Abstract only (3-page PDF) | Unchanged: descriptive, "not significant". |

**What it means for us.** Delhi's planned-station comparison halves the effect, so our R25 (G + T only) and the 綠線 controls matter more than we assumed. Delhi's B2C split supports our secondary outcome 4. The stage-1 literature review doc still shows the old Delhi details; this table supersedes them, and the paper draft has been told.

## code/appendixA.R

Ready to run the moment `data/pre` lands: `LANG=C.UTF-8 Rscript appendixA.R <data/pre> <out> 2026Q3`. It reads stations, 村里 boundaries/centroids and base-year population only, and **refuses to run if any outcome-like file (registrations, closures, prices, sales, series) is in the folder**. SHA-256 `6ac59908da72c86239f2f6de4229b9460adcd5f008fcb148545aeefd860ed6ec`.

What it does, in v2.1 order: hashes every input; classifies stations (study / planned 綠線 / pre-2011 / non-study since 2011 / unknown); gives study stations v2.1's dates and logs any disagreement; stops if any unknown-dated station lies within 2 km of a study-area 村里; projects lon/lat to TWD97 TM2 with its own formula (no GDAL); picks the denominator route; builds T/R1/R2/buffer/F/G and exclusions 1–3; counts T per line (drop rule < 5) and K1; counts N₀ and every post cell's comparison 村里. It writes `appendixA.md` (the deviations entry text), `appendixA.json` and `groups.csv` (the frozen distances, §3 rule 3).

**Synthetic test** (`synth_pre.R`, SHA-256 `a8eeb23b28630421f4d77bbddf4ae4b527395c0f04a0f5c0711b48281d31bea2`), built to the bundle's described shape: lon/lat, Chinese line names, NLSC 1150817 vintage, 機捷 A1–A21 with no dates, 10 臺中 stations with no dates, 6 三鶯線 stations, end-2015 村里 and end-2012 district population. Result:

- Boundary vintage NLSC 1150817 flagged as a deviation from v2.1's 114年.
- 21 機捷 stations dated from v2.1.
- 10 unknown-dated (臺中) stations, none within 2 km of the study area, so it proceeds.
- Denominator: fallback, end-2012 district × end-2015 share (R22 applies).
- Exclusion 2 picks up all 6 三鶯線 stations.
- K1 passes (81 T); lines with fewer than 5 T are dropped and listed; N₀ and 48 identified cells are written.

When the real bundle arrives, only the `SCHEMA` block (column names) may need editing; any edit is logged in the output.

```r
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
```

## code/renv.lock

renv-format lockfile: R 4.3.3 and all 70 packages in the dependency tree, every version pinned, one dated Posit snapshot as the repository. SHA-256 of the file as written: `d6b4b51360f2ebcf3319045ebbd49dac8db1768b4ed0e7b3c1a723eb31318f1c`. The compact JSON below is the same content, valid as-is.

**This lock is for the synthetic stage only.** HonestDiD (R15) needs R ≥ 4.4. Before the real run, R 4.5 gets installed with a new snapshot pin and a second lock, logged as a deviations entry (D2 item 8).

```json
{"R":{"Version":"4.3.3","Repositories":[{"Name":"CRAN","URL":"https://packagemanager.posit.co/cran/__linux__/noble/2026-10-30"}]},
"Packages":{"bacondecomp":{"Package":"bacondecomp","Version":"0.1.1","Source":"Repository","Repository":"CRAN"},
"BH":{"Package":"BH","Version":"1.90.0-1","Source":"Repository","Repository":"CRAN"},
"bigmemory":{"Package":"bigmemory","Version":"4.6.6","Source":"Repository","Repository":"CRAN"},
"bigmemory.sri":{"Package":"bigmemory.sri","Version":"0.1.8","Source":"Repository","Repository":"CRAN"},
"bit":{"Package":"bit","Version":"4.6.0","Source":"Repository","Repository":"CRAN"},
"bit64":{"Package":"bit64","Version":"4.8.6","Source":"Repository","Repository":"CRAN"},
"BMisc":{"Package":"BMisc","Version":"1.4.10","Source":"Repository","Repository":"CRAN"},
"cli":{"Package":"cli","Version":"3.6.6","Source":"Repository","Repository":"CRAN"},
"clipr":{"Package":"clipr","Version":"0.8.1","Source":"Repository","Repository":"CRAN"},
"cpp11":{"Package":"cpp11","Version":"0.5.5","Source":"Repository","Repository":"CRAN"},
"crayon":{"Package":"crayon","Version":"1.5.3","Source":"Repository","Repository":"CRAN"},
"data.table":{"Package":"data.table","Version":"1.18.6.1","Source":"Repository","Repository":"CRAN"},
"did":{"Package":"did","Version":"2.5.1","Source":"Repository","Repository":"CRAN"},
"didimputation":{"Package":"didimputation","Version":"0.5.1","Source":"Repository","Repository":"CRAN"},
"digest":{"Package":"digest","Version":"0.6.39","Source":"Repository","Repository":"CRAN"},
"dplyr":{"Package":"dplyr","Version":"1.2.1","Source":"Repository","Repository":"CRAN"},
"DRDID":{"Package":"DRDID","Version":"1.4.0","Source":"Repository","Repository":"CRAN"},
"dreamerr":{"Package":"dreamerr","Version":"1.5.0","Source":"Repository","Repository":"CRAN"},
"farver":{"Package":"farver","Version":"2.1.2","Source":"Repository","Repository":"CRAN"},
"fastglm":{"Package":"fastglm","Version":"0.1.2","Source":"Repository","Repository":"CRAN"},
"fixest":{"Package":"fixest","Version":"0.14.2","Source":"Repository","Repository":"CRAN"},
"forcats":{"Package":"forcats","Version":"1.0.1","Source":"Repository","Repository":"CRAN"},
"Formula":{"Package":"Formula","Version":"1.2-6","Source":"Repository","Repository":"CRAN"},
"generics":{"Package":"generics","Version":"0.1.4","Source":"Repository","Repository":"CRAN"},
"ggplot2":{"Package":"ggplot2","Version":"4.0.3","Source":"Repository","Repository":"CRAN"},
"glue":{"Package":"glue","Version":"1.8.1","Source":"Repository","Repository":"CRAN"},
"gtable":{"Package":"gtable","Version":"0.3.6","Source":"Repository","Repository":"CRAN"},
"haven":{"Package":"haven","Version":"2.5.5","Source":"Repository","Repository":"CRAN"},
"hms":{"Package":"hms","Version":"1.1.4","Source":"Repository","Repository":"CRAN"},
"isoband":{"Package":"isoband","Version":"0.3.0","Source":"Repository","Repository":"CRAN"},
"jsonlite":{"Package":"jsonlite","Version":"2.0.0","Source":"Repository","Repository":"CRAN"},
"labeling":{"Package":"labeling","Version":"0.4.3","Source":"Repository","Repository":"CRAN"},
"lattice":{"Package":"lattice","Version":"0.22-5","Source":"Repository","Repository":"CRAN"},
"lifecycle":{"Package":"lifecycle","Version":"1.0.5","Source":"Repository","Repository":"CRAN"},
"magrittr":{"Package":"magrittr","Version":"2.0.5","Source":"Repository","Repository":"CRAN"},
"Matrix":{"Package":"Matrix","Version":"1.6-5","Source":"Repository","Repository":"CRAN"},
"nlme":{"Package":"nlme","Version":"3.1-164","Source":"Repository","Repository":"CRAN"},
"numDeriv":{"Package":"numDeriv","Version":"2016.8-1.1","Source":"Repository","Repository":"CRAN"},
"pbapply":{"Package":"pbapply","Version":"1.7-5","Source":"Repository","Repository":"CRAN"},
"pillar":{"Package":"pillar","Version":"1.11.1","Source":"Repository","Repository":"CRAN"},
"pkgconfig":{"Package":"pkgconfig","Version":"2.0.3","Source":"Repository","Repository":"CRAN"},
"prettyunits":{"Package":"prettyunits","Version":"1.2.0","Source":"Repository","Repository":"CRAN"},
"progress":{"Package":"progress","Version":"1.2.3","Source":"Repository","Repository":"CRAN"},
"purrr":{"Package":"purrr","Version":"1.2.2","Source":"Repository","Repository":"CRAN"},
"R6":{"Package":"R6","Version":"2.6.1","Source":"Repository","Repository":"CRAN"},
"RColorBrewer":{"Package":"RColorBrewer","Version":"1.1-3","Source":"Repository","Repository":"CRAN"},
"Rcpp":{"Package":"Rcpp","Version":"1.1.2","Source":"Repository","Repository":"CRAN"},
"RcppArmadillo":{"Package":"RcppArmadillo","Version":"15.6.2-1","Source":"Repository","Repository":"CRAN"},
"RcppEigen":{"Package":"RcppEigen","Version":"0.3.4.0.2","Source":"Repository","Repository":"CRAN"},
"readr":{"Package":"readr","Version":"2.2.0","Source":"Repository","Repository":"CRAN"},
"rlang":{"Package":"rlang","Version":"1.3.0","Source":"Repository","Repository":"CRAN"},
"S7":{"Package":"S7","Version":"0.2.2","Source":"Repository","Repository":"CRAN"},
"sandwich":{"Package":"sandwich","Version":"3.1-3","Source":"Repository","Repository":"CRAN"},
"scales":{"Package":"scales","Version":"1.4.0","Source":"Repository","Repository":"CRAN"},
"stringi":{"Package":"stringi","Version":"1.8.9","Source":"Repository","Repository":"CRAN"},
"stringmagic":{"Package":"stringmagic","Version":"1.3.0","Source":"Repository","Repository":"CRAN"},
"stringr":{"Package":"stringr","Version":"1.6.0","Source":"Repository","Repository":"CRAN"},
"tibble":{"Package":"tibble","Version":"3.3.1","Source":"Repository","Repository":"CRAN"},
"tidyr":{"Package":"tidyr","Version":"1.3.2","Source":"Repository","Repository":"CRAN"},
"tidyselect":{"Package":"tidyselect","Version":"1.2.1","Source":"Repository","Repository":"CRAN"},
"trust":{"Package":"trust","Version":"0.1-9","Source":"Repository","Repository":"CRAN"},
"TwoWayFEWeights":{"Package":"TwoWayFEWeights","Version":"2.1.0","Source":"Repository","Repository":"CRAN"},
"tzdb":{"Package":"tzdb","Version":"0.5.0","Source":"Repository","Repository":"CRAN"},
"utf8":{"Package":"utf8","Version":"1.2.6","Source":"Repository","Repository":"CRAN"},
"uuid":{"Package":"uuid","Version":"1.2-2","Source":"Repository","Repository":"CRAN"},
"vctrs":{"Package":"vctrs","Version":"0.7.3","Source":"Repository","Repository":"CRAN"},
"viridisLite":{"Package":"viridisLite","Version":"0.4.3","Source":"Repository","Repository":"CRAN"},
"vroom":{"Package":"vroom","Version":"1.7.1","Source":"Repository","Repository":"CRAN"},
"withr":{"Package":"withr","Version":"3.0.3","Source":"Repository","Repository":"CRAN"},
"zoo":{"Package":"zoo","Version":"1.9-1","Source":"Repository","Repository":"CRAN"}}}
```

## redteam/redteam-brief.md

Written by an Opus agent that never opened `code/` or any output. SHA-256 `99a3ca1fadaed62915394b9f2871c07267044146f5c7d426363f97a5e147f5e0`, 1,469 words. Two updates are needed when the red team starts: name the real data folder, and point §4 at the D2 inference, which replaced v2.1's FP steps 1–4 after the brief was written.

```markdown
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
```

## Working-paper draft

The fixed parts are in their own doc: [MRT pilot: working paper draft v0](https://claude.ai/artifact/G1EXKzn2qVqVP2wwPAgzau). It mirrors `paper/working-paper-draft.md` (SHA-256 b745f3ca1f59a49bcdba7da5b9450427c15679fe8350aaa31f1a11a3844535bb, about 7,200 words). It was drafted by an Opus agent that never opened `code/` or any output, then updated to D2 (§6 inference, K2b, r\*, R28) and the full-text corrections.

Open items in it: results; Appendix A values; dataset ids for the registry, 實價登錄 and 村里 change records; the station and development-zone sources; full titles for several abstract-only references; and two `[GATE PENDING]` marks tied to the D2 gate.
