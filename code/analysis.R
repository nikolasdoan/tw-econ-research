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
