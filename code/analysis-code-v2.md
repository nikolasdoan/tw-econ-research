# MRT pilot: analysis code v2 and D2 gate

Oct 31, 2026 · @Niko

## Verdict: the D2 gate fails. Nothing opens; this goes back to the referee.

The new placebo-district inference fixes the main problem. Under no effect it rejects 5.6% of the time at 5%, and 95% intervals cover 94.2%. Its intervals are now about twice as wide as v1's. But four limits fail:

1. **K2b false-fires 21.5–26.5%** in every no-pre-trend scenario (limit 12.5%). This is built into the ruling's definition: a one-sided placebo test at 20% fires about 20% of the time on its own.
2. **K2a false-fires 14.0% (null) and 15.0% (effect)** (limit 12.5%), against a nominal 10%: mild anti-conservatism in the pre-window.
3. **Effect coverage is 88.0%** (limit 92.5%). This comes from the registered small-cell rule, not the inference: imputing suppressed 1–2 counts as 1.5 biases the estimate down by 0.019. Without suppression, coverage is 93%.
4. **Stress: rejection 8.0% and coverage 92.0%** (limits 7.5% and 92.5%). Line × quarter shocks hit all of a line's treated 村里 together, and district placebos cannot see them.

The gate was run on the final code: `lib_v2.R` 8af1b824…, `sim_gate.R` e9961ba4… (the version that also stores each rule's p; fire flags are identical to the first pass), B = 999, a fresh layout every seed, 1,100 seeds, about 2 minutes on 4 cores. No real outcome data was opened or requested.

## Gate results against each D2 limit

All rates are shares of seeds. **Bold** marks a failed limit.

| Scenario (seeds) | Mean estimate (truth) | SD | Mean CI half-width | Rejection at 5% | 95% CI coverage | K2a | K2b | K3a | K3b | Any kill |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Null (500) | 0.002 (0) | 0.079 | 0.149 | 5.6% (limit 3.0–7.5%) | 94.2% | **14.0%** | **25.0%** | 8.4% | 5.0% | 41.2% |
| Effect (200) | 0.481 (0.5) | 0.086 | 0.147 | power 100% | **88.0%** | **15.0%** | **21.5%** | 7.0% | 3.5% | 41.0% |
| Pre-trend (200) | 0.704 (0) | 0.088 | 0.148 | — | — | 65.5% | 86.5% | 6.0% | 16.0% | **98.0%** (limit ≥ 80%) |
| Stress (200) | −0.006 (0) | 0.110 | 0.202 | **8.0%** | **92.0%** | 12.0% | **26.5%** | 1.5% | 4.5% | 39.0% |

Limits: false-fire ≤ 12.5% per rule; coverage ≥ 92.5%. The pre-trend scenario passes.

Other gate facts: the minimum number of comparison districts per treated line is 38. On average 2.5 clusters per seed hit the variance floor. The median r\* is 1.00 under no effect and 1.34 under the effect.

**Diagnostic run (not part of the gate):** the effect scenario with no small-cell suppression (200 seeds, the same seeds) gives a mean of 0.500, SD 0.086 and coverage 93%. The 0.019 bias in the gate's effect scenario comes from imputing suppressed 1–2 counts as 1.5.

## Diagnosis for the referee, with options

A second gate pass stored each rule's p-value (same seeds, same results; `sim_gate.R` e9961ba4… adds output columns only). That lets the rule thresholds be varied without re-running. None of the options below is applied; choosing among them is the referee's call.

| False-fire rate (no pre-trend) or detection rate (pre-trend) | Null | Effect | Stress | Pre-trend |
| --- | --- | --- | --- | --- |
| K2a as ruled (p < 0.10) | 14.0% | 15.0% | 12.0% | 65.5% |
| K2a at p < 0.05 | 6.2% | 8.0% | 5.0% | 58.5% |
| K2b placebo tail alone at 20% (no size condition) | 25.0% | 23.0% | 26.5% | 91.0% |
| K2b as ruled (tail < 0.20 + sign + ≥ 50%) | 25.0% | 21.5% | 26.5% | 86.5% |
| K2b with tail < 0.10 | 12.6% | 14.0% | 12.0% | 82.5% |
| K2b with tail < 0.05 | 7.4% | 6.5% | 5.5% | 70.0% |
| Any kill, with K2a and K2b both at 0.05 | 23.8% | 23.0% | 16.5% | **92.0%** |

**1. K2b, by design.** Under no effect the primary is near 0, so "≥ 50% of the primary" almost always holds. K2b then reduces to a one-sided placebo test at 20%, which fires at least 20% of the time by construction. The tail alone fires 23–26.5%, a little above 20%. That extra, like K2a's, says the pre-window placebo distribution is slightly too narrow. **Option:** tail < 0.05 (5.5–7.4%; pre-trend detection with K2a at 0.05: 92%).

**2. K2a, mild anti-conservatism.** p < 0.10 fires 12–15% instead of 10%. **Options:** p < 0.05 (5.0–8.0%); or keep 0.10 and widen the pre-window placebo draws by a small-sample factor calibrated on this simulation.

**3. Effect coverage, from the small-cell rule.** With suppression, the mean is 0.481 and coverage 88%. Without suppression it is 0.500 and 93%. The inference is fine; the registered imputation of 1.5 is biased when treatment raises counts out of the 1–2 band. **Options:** (a) ask the export for unsuppressed sums at a coarser level (cohort × ring × quarter) and check the 1.5 bias against them; (b) impute suppressed cells by the conditional Poisson mean given 1–2, using the 村里's own unsuppressed quarters; (c) accept the bias, since it works against H1, and report R16 as the bound. Note the real share of suppressed cells is known only as whole-window totals (D1), so the size of this bias on real data is unknown.

**4. Stress, line × quarter shocks.** District placebos carry district shocks but not line shocks, which hit a whole line's treated 村里 together. Rejection rises to 8.0% and coverage falls to 92.0%, just past the limits. **Options:** (a) add a line-level variance component estimated from each line's own 800–1,500 m ring (R2), which shares the line's shocks but is not treated; (b) treat 10% line × quarter shocks as an upper-end stress and set its limits at 10% and 90%; (c) accept that 5 lines cannot separate line shocks from the effect, and say so in the paper.

Recommendation to the referee: options 1 and 2 at 0.05, 3(a) together with 3(c), and 4(a). They are cheap to implement, and the gate can be rerun in about 2 minutes.

## What v2 implements, and the synthetic runs

| D2 item | Where | Status |
| --- | --- | --- |
| 1. Placebo-district inference: each comparison district c gets line j's cohorts, single base k = −13, cells and C&S weights; pool minus c; residuals centred across c; draws for j only from j's placebo residuals | `lib_v2.R` `placebo()`, `infer()` | Done; K2a, K3a and K3b use the same construction |
| 2. K2b with placebo percentile (one-sided < 0.20) | `k2b()` | Done; fails the gate (see diagnosis) |
| 3. R28, base = mean of k = −16 to −13 | `analysis_v2.R` | Done, reported only |
| 4. Variance a + b/n by NNLS (a, b ≥ 0), floor 0.25 × mean r², floored count reported | `nnls_var()` | Done; on average 2.5 clusters floored per seed |
| 5. R11 with cohort-size weights, labelled "unweighted cohort-mean diagnostic" | `analysis_v2.R` | Done. `weights=` in TwoWayFEWeights 2.1.0 errors even on a toy example, so cohort size enters as row frequency (equivalent) |
| 6. r\* = Σw\_T·y\_T,t / (Σw\_T·y\_T,b + Σw\_C·δ\_C); not real if r\* < 1.25 | `r_star()` | Done |
| 7. Simulation gate | `sim_gate.R` | Run; fails 4 limits |
| 8. R ≥ 4.4, mapping of the 112 unknown stations, TM2 projection | `appendixA.R` (mapping rule, TM2) | TM2 and the mapping rule are done; R 4.5 not yet installed (see open items) |

**Checks on the new engine.** `lib_v2.R` equals did 2.5.1 to 12 digits on a generated dataset (0.490811886188 both). On the two fixed synthetic exports, `analysis_v2.R` gives:

| Export | Primary (95% CI) | K2a / K2b / K3a / K3b | r\* | Effect is real |
| --- | --- | --- | --- | --- |
| Effect (true +0.50) | 0.538 (0.386–0.689) | pass / pass / pass / pass | 1.42 | TRUE |
| Pre-trend (true 0) | 0.524 (0.348–0.700) | **fires** / **fires** / pass / **fires** | 1.30 | FALSE |

v1 fired K2a falsely on the effect export (p = 0.011); v2 does not (p = 0.32). The intervals are about twice v1's width (±0.15 against ±0.07), matching the true spread across seeds. R1 now uses the D2 inference: 0.591 (0.349–0.833). R20 (wild bootstrap) and R27 (district clusters) still use v1's district-residual construction and are labelled as checks.

## Code

Files for `code/` on `prereg-v1`. SHA-256: `lib_v2.R` 8af1b8241e8d5b494a34ac97f465510bb86fe460123f1d08952a7dda8f320634; `sim_gate.R` e9961ba4634d9f9470981e42deb509c15932a33638f263eb847fdc13ae401d57; `analysis_v2.R` c57116354a04f316bb5ef9823bd84765956fc2957abfff67fcec6652b5841e4b (= committed `analysis.R` v1 + the diff below). Run with `LANG=C.UTF-8` from `code/`.

### code/lib\_v2.R

```r
# lib_v2.R -- estimator and inference for pre-registration v2.1 as amended by deviations.md D2 (referee ruling).
# D2: placebo-district inference (each comparison district gets each treated line's own cohorts, base and weights);
#     K2b with a placebo percentile; NNLS variance model with floor; r* breakdown; R28 four-quarter base.
suppressPackageStartupMessages(library(data.table))
qi <- function(y, q) y * 4L + (q - 1L)

## ---- 1. cells: village-level changes for every (cohort g, event time e) ----
## U: data.table, one row per village, in the row order of Y, with columns
##    treated (logical), g (cohort quarter for treated units), cl (treated cluster), gv (validity quarter: a unit is a
##    valid comparison at (t, b) if gv > max(t, b) + ant; Inf = never treated), pool (logical), dist (district).
## Y: villages x quarters matrix of the outcome; colnames are quarter indices.
cells_of <- function(U, Y, ant, base_k, es, min_ctrl = 30L) {
  qs <- as.integer(colnames(Y)); col <- function(q) match(q, qs)
  cohorts <- sort(unique(U$g[U$treated]))
  out <- list()
  for (gc in cohorts) for (e in es) {
    t <- gc + e; b <- gc + base_k; ct <- col(t); cb <- col(b)
    if (is.na(ct) || anyNA(cb)) next
    d <- Y[, ct] - (if (length(cb) == 1) Y[, cb] else rowMeans(Y[, cb, drop = FALSE]))
    tr <- which(U$treated & U$g == gc & !is.na(d))
    co <- which(U$pool & U$gv > max(t, b) + ant & !(U$treated & U$g == gc) & !is.na(d))
    if (length(co) < min_ctrl || !length(tr)) next
    out[[length(out) + 1]] <- list(g = gc, e = e, t = t, b = b, d = d, tr = tr, co = co)
  }
  out
}

## ---- 2. the statistic decomposed by treated cluster j and event time e ----
decompose <- function(U, cells) {
  if (!length(cells)) return(NULL)
  info <- rbindlist(lapply(seq_along(cells), function(k) data.table(k, g = cells[[k]]$g, e = cells[[k]]$e, nT = length(cells[[k]]$tr))))
  info[, pg := nT / sum(nT), by = e]; Es <- sort(unique(info$e)); E <- length(Es)
  cls <- sort(unique(U$cl[U$treated]))
  ## per cell: treated mean by cluster, comparison mean, district sums of comparison changes
  tj <- lapply(cells, function(c) { s <- tapply(c$d[c$tr], U$cl[c$tr], sum); n <- tapply(c$d[c$tr], U$cl[c$tr], length)
    list(s = s[cls], n = n[cls]) })
  cm <- sapply(cells, function(c) mean(c$d[c$co]))
  att_ge <- sapply(seq_along(cells), function(k) mean(cells[[k]]$d[cells[[k]]$tr]) - cm[k])
  info[, att := att_ge]
  att_e <- info[, .(att = sum(pg * att)), by = e][order(e)]
  ## omega_j(e) and D_j(e)
  W <- matrix(0, length(cls), E, dimnames = list(cls, Es)); D <- W
  for (k in seq_along(cells)) { ei <- match(info$e[k], Es); nj <- tj[[k]]$n; nj[is.na(nj)] <- 0
    w <- info$pg[k] * nj / info$nT[k]; Tm <- tj[[k]]$s / nj
    D[, ei] <- D[, ei] + ifelse(nj > 0, w * (Tm - cm[k]), 0); W[, ei] <- W[, ei] + w }
  D <- ifelse(W > 0, D / W, NA)
  stat <- mean(att_e$att)
  list(info = info, Es = Es, E = E, cls = cls, W = W, D = D, cm = cm, att_e = att_e, stat = stat)
}

## ---- 3. placebo contributions: district c given cluster j's cohorts, base and weights; pool minus c ----
placebo <- function(U, cells, dec) {
  dists <- sort(unique(U$dist[U$pool]))
  info <- dec$info; Es <- dec$Es; cls <- dec$cls
  ## per cell: district sums / counts of valid comparison changes, and totals
  SD <- lapply(cells, function(c) { s <- rowsum(c$d[c$co], U$dist[c$co]); n <- rowsum(rep(1, length(c$co)), U$dist[c$co])
    S <- setNames(rep(0, length(dists)), dists); N <- S; S[rownames(s)] <- s; N[rownames(n)] <- n
    list(S = S, N = N, St = sum(c$d[c$co]), Nt = length(c$co)) })
  res <- list()
  for (j in cls) {
    Pj <- matrix(NA_real_, length(dists), length(Es), dimnames = list(dists, Es)); Wsum <- Pj * 0
    num <- matrix(0, length(dists), length(Es)); den <- num
    for (k in seq_along(cells)) { ei <- match(info$e[k], Es)
      nj <- sum(U$cl[cells[[k]]$tr] == j); if (!nj) next
      w <- info$pg[k] * nj / info$nT[k]
      S <- SD[[k]]; ok <- S$N > 0 & (S$Nt - S$N) > 0
      pc <- ifelse(ok, S$S / S$N - (S$St - S$S) / (S$Nt - S$N), NA)
      num[, ei] <- num[, ei] + ifelse(ok, w * pc, 0); den[, ei] <- den[, ei] + ifelse(ok, w, 0) }
    Pj <- ifelse(den > 0, num / den, NA)
    need <- dec$W[j, ] > 0
    complete <- rowSums(is.na(Pj[, need, drop = FALSE])) == 0
    res[[j]] <- list(P = Pj[complete, , drop = FALSE], n = sapply(dists[complete], function(d) sum(U$pool & U$dist == d)))
  }
  res
}

## ---- 4. NNLS variance model a + b/n (a, b >= 0) with a floor at 0.25 * mean r^2 ----
nnls_var <- function(r2, n) {
  ok <- is.finite(r2) & is.finite(n); r2 <- r2[ok]; n <- n[ok]
  X <- cbind(1, 1 / n); best <- NULL
  for (S in list(1:2, 1, 2)) {                      # active-set search over the 3 non-empty supports
    co <- tryCatch(qr.solve(X[, S, drop = FALSE], r2), error = function(e) NULL)
    if (is.null(co) || any(co < 0)) next
    beta <- c(0, 0); beta[S] <- co; sse <- sum((r2 - X %*% beta)^2)
    if (is.null(best) || sse < best$sse) best <- list(beta = beta, sse = sse) }
  if (is.null(best)) best <- list(beta = c(mean(r2), 0))
  fl <- 0.25 * mean(r2)
  list(v = function(m) pmax(best$beta[1] + best$beta[2] / m, fl), floor = fl, beta = best$beta)
}

## ---- 5. inference: draws for each j from j's own placebo residuals ----
## returns stat, p, CI (test inversion), placebo draws of the statistic and of att_e, and diagnostics
infer <- function(U, cells, B = 999L, alpha = 0.05, seed = 1L) {
  dec <- decompose(U, cells); if (is.null(dec)) return(NULL)
  pl <- placebo(U, cells, dec)
  nT <- sapply(dec$cls, function(j) sum(U$treated & U$cl == j))
  Es <- dec$Es; E <- dec$E; set.seed(seed)
  draws_e <- matrix(0, B, E); floored <- 0L; N0 <- integer(0)
  for (j in dec$cls) {
    P <- pl[[j]]$P; n <- pl[[j]]$n; if (nrow(P) < 2 || sum(dec$W[j, ]) == 0) next   # a cluster with no identified cell adds nothing
    R <- sweep(P, 2, colMeans(P, na.rm = TRUE)); R[is.na(R)] <- 0
    wj <- dec$W[j, ]; Ra <- as.vector(R %*% wj) / sum(wj)
    vm <- nnls_var(Ra^2, n); vn <- vm$beta[1] + vm$beta[2] / n
    floored <- floored + sum(vn < vm$floor); N0 <- c(N0, nrow(P))
    sc <- sqrt(vm$v(nT[j]) / vm$v(n))
    pick <- sample.int(nrow(P), B, replace = TRUE)
    draws_e <- draws_e + sweep(R[pick, , drop = FALSE] * sc[pick], 2, wj, "*")
  }
  draws <- rowMeans(draws_e)
  pfun <- function(null) mean(abs(draws) >= abs(dec$stat - null))
  sdv <- sd(draws); grid <- seq(dec$stat - 6 * sdv, dec$stat + 6 * sdv, length.out = 601)
  acc <- grid[vapply(grid, pfun, 0) > alpha]
  list(stat = dec$stat, p = pfun(0), ci = if (length(acc)) range(acc) else c(NA, NA), att_e = dec$att_e,
       draws = draws, draws_e = draws_e, Es = Es, N0_min = if (length(N0)) min(N0) else 0L, floored = floored, dec = dec)
}
## K2b: extrapolate a straight line through the pre-window ATTs to k = +5.5, for the real data and for each draw
k2b <- function(inf_pre, primary_stat) {
  e <- inf_pre$att_e$e; fit <- lm(inf_pre$att_e$att ~ e); pred <- unname(predict(fit, data.frame(e = 5.5)))
  X <- cbind(1, e); H <- solve(crossprod(X), t(X)); pd <- as.vector(cbind(1, 5.5) %*% (H %*% t(inf_pre$draws_e)))
  s <- sign(primary_stat); ptail <- mean(s * pd >= s * pred)
  list(pred = pred, ptail = ptail, fires = sign(pred) == s && abs(pred) >= 0.5 * abs(primary_stat) && ptail < 0.20)
}
## r*: T changes in post cells with T levels at t divided by r; base quarters unchanged (D2 item 6)
r_star <- function(U, Y, cells, dec) {
  qs <- as.integer(colnames(Y)); num <- 0; den <- 0
  for (k in seq_along(cells)) { c <- cells[[k]]; w <- dec$info$pg[k] / dec$E
    num <- num + w * mean(Y[c$tr, match(c$t, qs)]); den <- den + w * (mean(Y[c$tr, match(c$b, qs)]) + mean(c$d[c$co])) }
  num / den
}

## ---- 6. the registered configurations ----
cfg_primary <- function(V, G_CUTOFF, ant = 12L) {
  data.table(treated = V$grp == "T", g = V$g, cl = V$cl, pool = V$grp %in% c("G", "T", "F"), dist = V$dist,
             gv = fcase(V$grp == "F", Inf, V$grp == "G", as.numeric(G_CUTOFF + ant - 1L), V$grp == "T", as.numeric(V$g), default = -Inf)) }
run_rules <- function(V, Y, G_CUTOFF, B = 999L, seed = 1L) {
  U <- cfg_primary(V, G_CUTOFF)
  cP <- cells_of(U, Y, 12L, -13L, 0:11); iP <- infer(U, cP, B, seed = seed)
  cK <- cells_of(U, Y, 12L, -13L, -20:-14); iK <- infer(U, cK, B, seed = seed + 1L)
  kb <- k2b(iK, iP$stat)
  ## K3a: G with a fake k = 0 at 2020Q1 against F only, anticipation 0, base -1, data up to the G cutoff
  qs <- as.integer(colnames(Y)); Ya <- Y[, qs < G_CUTOFF, drop = FALSE]
  Ua <- data.table(treated = V$grp == "G", g = ifelse(V$grp == "G", qi(2020, 1), NA), cl = ifelse(V$grp == "G", "G", NA),
                   pool = V$grp == "F", dist = V$dist, gv = ifelse(V$grp == "F", Inf, -Inf))
  iA <- infer(Ua, cells_of(Ua, Ya, 0L, -1L, 0:11), B, seed = seed + 2L)
  ## K3b: fake k = 0 at real k = -16, only quarters <= real k = -13 for treated, anticipation 0, base -1, e = 0..3
  Ub <- copy(U); Ub[treated == TRUE, `:=`(g = g - 16L, gv = gv - 16)]
  Yb <- Y; for (gc in unique(U$g[U$treated])) { r <- which(U$treated & U$g == gc); Yb[r, qs > gc - 13L] <- NA }
  iB <- infer(Ub, cells_of(Ub, Yb, 0L, -1L, 0:3), B, seed = seed + 3L)
  p03 <- decompose(U, cells_of(U, Y, 12L, -13L, 0:3))$stat
  s <- sign(iP$stat)
  list(primary = iP, pre = iK,
       rules = data.table(rule = c("K2a", "K2b", "K3a", "K3b"),
         value = c(iK$stat, kb$pred, iA$stat, iB$stat), p = c(iK$p, kb$ptail, iA$p, iB$p),
         fires = c(iK$p < 0.10, kb$fires,
                   sign(iA$stat) == s && iA$p < 0.10 && abs(iA$stat) >= abs(iP$stat) / 3,
                   sign(iB$stat) == s && iB$p < 0.10 && abs(iB$stat) >= abs(p03) / 3)),
       r_star = r_star(U, Y, cP, iP$dec), floored = iP$floored, N0_min = iP$N0_min)
}
```

### code/sim\_gate.R

Run: `for s in "null 500 1001" "effect 200 2001" "pretrend 200 3001" "stress 200 4001"; do set -- $s; Rscript sim_gate.R $1 $2 ../gate/$1.csv 4 $3; done`

```r
# sim_gate.R -- the D2 simulation gate. Each seed redraws the layout; B = 999.
# Usage: Rscript sim_gate.R <scenario: null|effect|pretrend|stress> <n_seeds> <out.csv> [cores] [first_seed]
suppressPackageStartupMessages({ library(data.table); library(parallel) })
source("lib_v2.R")
a <- commandArgs(TRUE); SC <- a[1]; NS <- as.integer(a[2]); OUTF <- a[3]
CORES <- if (length(a) >= 4) as.integer(a[4]) else 4L; S0 <- if (length(a) >= 5) as.integer(a[5]) else 1L
G_CUTOFF <- qi(2023, 3)
k0 <- function(d) { d <- as.IDate(d); y <- year(d); q <- quarter(d)
  qend <- as.IDate(sprintf("%d-%02d-01", y + (q == 4), ifelse(q == 4, 1, q * 3 + 1))) - 1L
  qi(y, q) + as.integer((as.integer(qend - d) + 1L) < 45L) }
LINES <- list(  # same geometry as synth.R
  list("機捷", "機捷", seq(2000, 24000, 2000), 20000, "2017-02-16"), list("A22", "A22", 1000, 20000, "2023-07-31"),
  list("綠山", "淡海", 30000, seq(2000, 16000, 2000), "2018-12-24"), list("藍海", "淡海", 34000, seq(2000, 6000, 2000), "2020-11-15"),
  list("環狀", "環狀", seq(14000, 32000, 2000), 30000, "2020-01-31"), list("安坑", "安坑", 20000, seq(33000, 38000, 1000), "2023-02-10"))
ST <- rbindlist(lapply(LINES, function(l) data.table(line = l[[1]], cl = l[[2]], x = l[[3]], y = l[[4]], g = k0(l[[5]]))))
GR <- data.table(x = seq(2000, 16000, 2000), y = 8000)
NON <- data.table(x = 38000, y = seq(20000, 26000, 2000))

gen <- function(seed, scenario) {
  set.seed(seed)
  tau <- if (scenario == "effect") 0.5 else 0; slope <- if (scenario == "pretrend") 0.04 else 0
  PRE <- data.table(x = runif(25, 24000, 40000), y = runif(25, 22000, 40000))
  NV <- 5000; V <- data.table(x = runif(NV, 0, 40000), y = runif(NV, 0, 40000))
  V[, dist := floor(x / 5000) * 8 + floor(y / 5000)]
  V[, P := round(rlnorm(NV, log(3000), 0.6))]
  dm <- function(S) apply(sqrt(outer(V$x, S$x, "-")^2 + outer(V$y, S$y, "-")^2), 1, min)
  m <- sqrt(outer(V$x, ST$x, "-")^2 + outer(V$y, ST$y, "-")^2); jn <- apply(m, 1, which.min)
  V[, `:=`(d = apply(m, 1, min), dG = dm(GR), dPre = dm(PRE), dNon = dm(NON))]
  V[, `:=`(g = apply(m, 1, function(r) { w <- which(r <= 500); if (length(w)) min(ST$g[w]) else ST$g[which.min(r)] }),
           cl = apply(m, 1, function(r) { w <- which(r <= 500); if (length(w)) ST$cl[w][which.min(ST$g[w])] else ST$cl[which.min(r)] }))]
  V[, grp := fcase(d <= 500, "T", d <= 800, "R1", d <= 1500, "R2", d < 2000, "buffer", dG <= 500, "G", d <= 5000 & dG >= 2000, "F", default = "other")]
  qs <- qi(2011, 1):qi(2026, 2); Q <- length(qs); N <- nrow(V)
  a_i <- exp(rnorm(N, 0, 0.3)); b_d <- exp(rnorm(64, 0, 0.2))[V$dist + 1]
  lam <- 1 + 0.004 * (qs - qs[1]) + 0.05 * sin(2 * pi * (qs %% 4) / 4); cov <- ifelse(qs >= qi(2020, 1) & qs <= qi(2022, 4), 0.85, 1)
  R <- outer(1.2 * a_i * b_d, lam * cov)
  if (scenario == "stress") {
    R <- R * exp(matrix(rnorm(64 * Q, 0, 0.1), 64, Q)[V$dist + 1, ])                       # district x quarter
    lines <- unique(ST$cl); LS <- exp(matrix(rnorm(length(lines) * Q, 0, 0.1), length(lines), Q))
    near <- V$d < 2000; R[near, ] <- R[near, ] * LS[match(ST$cl[jn[near]], lines), ] }     # line x quarter, within 2 km
  K <- outer(rep(1, N), qs) - V$g
  R <- R + tau * (V$d <= 500 & K >= 0) + slope * (V$d <= 500) * (K + 20)
  mu <- pmax(R, 0) * V$P / 1000
  Nc <- matrix(rpois(N * Q, 0.6 * mu), N); Nb <- matrix(rpois(N * Q, 0.4 * mu), N)
  imp <- function(M) { M[M %in% 1:2] <- 1.5; M }                                             # suppressed 1-2 -> 1.5
  Y <- 1000 * (imp(Nc) + imp(Nb)) / V$P; colnames(Y) <- qs
  keep <- V$dPre > 500 & V$dNon > 800 & V$P >= 500 & V$grp %in% c("T", "G", "F")
  list(V = V[keep], Y = Y[keep, , drop = FALSE])
}

one <- function(s) {
  d <- gen(s, SC); r <- tryCatch(run_rules(d$V, d$Y, G_CUTOFF, B = 999L, seed = s), error = function(e) NULL)
  if (is.null(r)) return(data.table(seed = s, ok = FALSE))
  w <- dcast(r$rules, . ~ rule, value.var = "fires"); pv <- setNames(r$rules$p, paste0("p_", r$rules$rule))
  data.table(seed = s, ok = TRUE, est = r$primary$stat, p = r$primary$p, lo = r$primary$ci[1], hi = r$primary$ci[2],
             K2a = w$K2a, K2b = w$K2b, K3a = w$K3a, K3b = w$K3b, r_star = r$r_star, floored = r$floored, N0_min = r$N0_min,
             nT = sum(d$V$grp == "T"), p_K2a = pv[["p_K2a"]], p_K2b = pv[["p_K2b"]], v_K2b = r$rules$value[2], p_K3a = pv[["p_K3a"]], p_K3b = pv[["p_K3b"]])
}
t0 <- Sys.time()
res <- rbindlist(mclapply(S0:(S0 + NS - 1L), one, mc.cores = CORES), fill = TRUE)
fwrite(res, OUTF)
cat(sprintf("%s: %d seeds in %.1f min\n", SC, nrow(res), as.numeric(difftime(Sys.time(), t0, units = "mins"))))
```

### code/analysis\_v2.R as a diff against committed code/analysis.R (v1)

Save the block as `v2.diff`, then `patch -o code/analysis_v2.R code/analysis.R < v2.diff`. Check the result's SHA-256 against c57116354a04… above. Every change is listed; nothing else differs.

```diff
--- a/code/analysis.R
+++ b/code/analysis_v2.R
@@ -1,9 +1,10 @@
-# analysis.R -- MRT pilot, analysis exactly as pre-registration v2.1.
+# analysis_v2.R -- MRT pilot, analysis as pre-registration v2.1 amended by deviations.md D2 (referee ruling on inference).
 # Usage: Rscript analysis.R <export_dir> <out_dir> [B]
 # Section numbers (§) refer to preregistration/mrt-pilot-v2.md (v2.1).
 suppressPackageStartupMessages({
   library(data.table); library(did); library(fixest); library(didimputation)
   library(bacondecomp); library(ggplot2); library(digest); library(jsonlite) })
+source("lib_v2.R")
 args <- commandArgs(TRUE)
 IN  <- if (length(args) >= 1) args[1] else "../synth_effect"
 OUT <- if (length(args) >= 2) args[2] else "../out_effect"
@@ -166,12 +167,37 @@
   list(stat = stat, p = mean(abs(d) >= abs(stat)))
 }
 
+
+## ============ 4b. D2 inference on a long panel (replaces v2.1 section 6 steps 1-4) ============
+to_UY <- function(P, treat = "T", pool = c("G", "T", "F"), ant = ANT, treat_g = NULL) {
+  W <- dcast(P, village_id + grp + g + tclus + district_id ~ q, value.var = "y")
+  Y <- as.matrix(W[, -(1:5)]); colnames(Y) <- names(W)[-(1:5)]
+  U <- data.table(treated = W$grp %in% treat, g = W$g, cl = W$tclus, pool = W$grp %in% pool, dist = W$district_id,
+                  gv = fcase(W$grp %in% c("F", "R1", "R2") & !(W$grp %in% treat), Inf,
+                             W$grp == "G" & !("G" %in% treat), as.numeric(G_CUTOFF + ant - 1L), default = as.numeric(W$g)))
+  list(U = U, Y = Y, ids = W$village_id, grp = W$grp) }
+inf_P <- function(P, treat = "T", pool = c("G", "T", "F"), ant = ANT, base_k = BASE_K, emin = EMIN, emax = EMAX,
+                  drop_q = integer(0), min_ctrl = MIN_CTRL, B_ = B, seed = 1L) {
+  uy <- to_UY(P, treat, pool, ant)
+  if (length(drop_q)) {                       # R1: dropped quarters are not used; a dropped base moves to the latest earlier quarter
+    qs <- as.integer(colnames(uy$Y)); keep <- !(qs %in% drop_q); Y <- uy$Y[, keep, drop = FALSE]
+    cells <- list(); for (gc in sort(unique(uy$U$g[uy$U$treated]))) {
+      b <- gc + base_k; if (b %in% drop_q) b <- max(setdiff(qs[qs < b], drop_q))
+      cc <- cells_of(uy$U[, .(treated = treated & g == gc, g, cl, pool, dist, gv)], Y, ant, b - gc, emin:emax, min_ctrl)
+      cells <- c(cells, cc) }
+    return(infer(uy$U, cells, B_, seed = seed)) }
+  infer(uy$U, cells_of(uy$U, uy$Y, ant, base_k, emin:emax, min_ctrl), B_, seed = seed) }
+
 ## ============ 5. primary estimate (§1, §6) ============
 tick("5. primary estimate (§1, §6)")
 P0 <- make_panel(V0)
-L0 <- cs_long(P0)
-FP0 <- fp_test(L0)
-att_e0 <- attr(L0, "att_e")
+L0 <- cs_long(P0)                                   # engine table, kept for Appendix A cell counts and r*
+uy0 <- to_UY(P0[grp %in% c("G", "T", "F")])
+Vx <- data.table(grp = uy0$grp, g = uy0$U$g, cl = uy0$U$cl, dist = uy0$U$dist)
+RR <- run_rules(Vx, uy0$Y, G_CUTOFF, B = B, seed = 20261031L)
+FP0 <- list(stat = RR$primary$stat, p = RR$primary$p, ci = RR$primary$ci, N0 = RR$primary$N0_min,
+            n_treated_clusters = length(RR$primary$dec$cls), p_min = 1 / (RR$primary$N0_min + 1))
+att_e0 <- RR$primary$att_e
 ## cross-check against did 2.5.1 on the pool where both definitions coincide (T + F; G's cutoff needs the engine)
 Pd <- P0[grp %in% c("T", "F")][, gname := fifelse(grp == "F", 0L, as.integer(g))][, id := as.integer(factor(village_id))]
 cs <- att_gt(yname = "y", tname = "q", idname = "id", gname = "gname", data = as.data.frame(Pd),
@@ -183,29 +209,9 @@
 
 ## ============ 6. kill rules (§7) ============
 tick("6. kill rules (§7)")
-Lpre <- cs_long(P0, emin = -20L, emax = -14L)
-FPpre <- fp_test(Lpre)
-pre_e <- attr(Lpre, "att_e")
-K2a_fires <- FPpre$p < 0.10
-fitpre <- lm(att ~ e, data = pre_e); pred55 <- unname(predict(fitpre, data.frame(e = 5.5)))
-K2b_fires <- sign(pred55) == sign(FP0$stat) && abs(pred55) >= 0.5 * abs(FP0$stat)
-## K3a: G given a fake k = 0 at 2020Q1, F only, anticipation 0, G as one treated cluster
-P3a <- copy(P0)[grp %in% c("G", "F")][grp == "G", `:=`(g = qi(2020, 1), tclus = "綠線")]
-L3a <- cs_long(P3a, treat = "G", pool = "F", ant = 0L, base_k = -1L, qmax_use = G_CUTOFF - 1L)
-FP3a <- fp_test(L3a)
-K3a_fires <- sign(FP3a$stat) == sign(FP0$stat) && FP3a$p < 0.10 && abs(FP3a$stat) >= abs(FP0$stat) / 3
-## K3b: fake k = 0 at real k = -16; only quarters <= real k = -13; compared with primary k = 0..3
-fake <- function(D) { D[grp == "T", `:=`(g_real = g, g = g - 16L)]; D[grp == "T", y := fifelse(q <= g_real - 13L, y, NA_real_)]; D[!is.na(y)] }
-L3b <- cs_long(P0, ant = 0L, base_k = -1L, emin = 0L, emax = 3L, g_override = function(D) {
-  D <- fake(D); D[grp %in% c("G", "T", "F")] })
-## controls must be outside their own real anticipation: re-check validity with the real cohorts
-FP3b <- fp_test(L3b)
-L03 <- cs_long(P0, emin = 0L, emax = 3L); prim03 <- stat_of(L03)
-K3b_fires <- sign(FP3b$stat) == sign(prim03) && FP3b$p < 0.10 && abs(FP3b$stat) >= abs(prim03) / 3
-kill <- data.table(rule = c("K1", "K2a", "K2b", "K3a", "K3b"),
-  value = c(K1_total, FPpre$stat, pred55, FP3a$stat, FP3b$stat),
-  p = c(NA, FPpre$p, NA, FP3a$p, FP3b$p),
-  fires = c(K1_fires, K2a_fires, K2b_fires, K3a_fires, K3b_fires))
+pre_e <- RR$pre$att_e
+K2 <- RR$rules
+kill <- rbind(data.table(rule = "K1", value = K1_total, p = NA_real_, fires = K1_fires), K2)
 
 ## ============ 7. survivorship (§8, R17) ============
 tick("7. survivorship (§8, R17)")
@@ -230,32 +236,36 @@
   R <- merge(merge(R, Sc[, .(district_id, q, Sc = S)], by = c("district_id", "q")), Sb[, .(district_id, q, Sb = S)], by = c("district_id", "q"))
   R[, y := 1000 * (nc / Sc + nb / Sb) / P][, .(village_id, q, y, grp, g, line, tclus, district_id, P, in_zone)] }
 L17 <- cs_long(P17); r17 <- stat_of(L17)
-## breakdown ratio r: scale T contributions by r until the estimate is zero (y_T / r)
-Tsum <- L0[role == "T", sum(w * delta)]; Csum <- L0[role == "C", sum(w * delta)]
-r_break <- if (Csum != 0) Tsum / Csum else NA_real_
-r_fragile <- is.na(r_break) || (r_break > 0.8 && r_break < 1.25)
+## r* (D2 item 6): T levels in post cells divided by r, bases unchanged; a positive primary is not real if r* < 1.25
+r_break <- RR$r_star
+r_fragile <- is.na(r_break) || r_break < 1.25
 
 ## ============ 8. robustness R1-R27 (§9) ============
 tick("8. robustness R1-R27 (§9)")
-run <- function(id, label, L, fp = TRUE, tcl = "line") {
-  if (is.null(L)) return(data.table(id, label, est = NA_real_, p = NA_real_, lo = NA_real_, hi = NA_real_))
-  if (fp) { f <- fp_test(L, tcl = tcl, B_ = min(B, 1999L)); data.table(id, label, est = f$stat, p = f$p, lo = f$ci[1], hi = f$ci[2]) }
-  else data.table(id, label, est = stat_of(L), p = NA_real_, lo = NA_real_, hi = NA_real_) }
+run <- function(id, label, P, ..., fp = TRUE, tcl = "line") {
+  a <- list(...)
+  if (!fp || !is.null(a$wvar) || !is.null(a$g_override) || tcl == "district") {      # point estimate (or old district FP for R27)
+    L <- do.call(cs_long, c(list(P), a)); if (is.null(L)) return(data.table(id, label, est = NA_real_, p = NA_real_, lo = NA_real_, hi = NA_real_))
+    if (tcl == "district") { f <- fp_test(L, tcl = "district", B_ = min(B, 999L)); return(data.table(id, label, est = f$stat, p = f$p, lo = f$ci[1], hi = f$ci[2])) }
+    return(data.table(id, label, est = stat_of(L), p = NA_real_, lo = NA_real_, hi = NA_real_)) }
+  f <- tryCatch(do.call(inf_P, c(list(P), a, list(B_ = min(B, 999L)))), error = function(e) NULL)
+  if (is.null(f)) return(data.table(id, label, est = NA_real_, p = NA_real_, lo = NA_real_, hi = NA_real_))
+  data.table(id, label, est = f$stat, p = f$p, lo = f$ci[1], hi = f$ci[2]) }
 R <- list()
-R[[1]]  <- run("R1", "Drop 2020Q1-2022Q4", cs_long(P0, drop_q = COVID))
-R[[2]]  <- run("R2a", "Drop 環狀", cs_long(P0[line != "環狀" | grp != "T"]))
-R[[3]]  <- run("R2b", "Drop cohorts opening 2019Q1-2020Q4", cs_long(P0[!(grp == "T" & g >= qi(2019, 1) & g <= qi(2020, 4))]))
+R[[1]]  <- run("R1", "Drop 2020Q1-2022Q4", P0, drop_q = COVID)
+R[[2]]  <- run("R2a", "Drop 環狀", P0[line != "環狀" | grp != "T"])
+R[[3]]  <- run("R2b", "Drop cohorts opening 2019Q1-2020Q4", P0[!(grp == "T" & g >= qi(2019, 1) & g <= qi(2020, 4))])
 for (l in unique(na.omit(P0[grp == "T", tclus])))
-  R[[length(R) + 1]] <- run("R3", paste("Leave out", l), cs_long(P0[!(grp == "T" & tclus == l)]), fp = FALSE)
-R[[length(R) + 1]] <- run("R4", "Anticipation 8, base k = -9", cs_long(P0, ant = 8L, base_k = -9L))
+  R[[length(R) + 1]] <- run("R3", paste("Leave out", l), P0[!(grp == "T" & tclus == l)], fp = FALSE)
+R[[length(R) + 1]] <- run("R4", "Anticipation 8, base k = -9", P0, ant = 8L, base_k = -9L)
 P_R <- make_panel(V0)[grp %in% c("T", "R2")][grp == "R2", grp := "F"]
-R[[length(R) + 1]] <- run("R5", "Comparison R2 (800-1,500 m)", cs_long(P_R, pool = "F"))
-R[[length(R) + 1]] <- run("R6", "Comparison F only", cs_long(P0, pool = "F"))
+R[[length(R) + 1]] <- run("R5", "Comparison R2 (800-1,500 m)", P_R, pool = "F")
+R[[length(R) + 1]] <- run("R6", "Comparison F only", P0, pool = "F")
 for (rg in c("R1", "R2")) {
   Pr <- copy(P0)[grp %in% c(rg, "F")][grp == rg, tclus := LINE_CLUSTER[line]]
-  R[[length(R) + 1]] <- run("R7", paste("Ring", rg, "vs F"), cs_long(Pr, treat = rg, pool = "F")) }
+  R[[length(R) + 1]] <- run("R7", paste("Ring", rg, "vs F"), Pr, treat = rg, pool = "F") }
 for (rad in c(300, 800)) { Vr <- build_groups(radius = rad)
-  R[[length(R) + 1]] <- run("R8", paste0("Treated radius ", rad, " m"), cs_long(make_panel(Vr))) }
+  R[[length(R) + 1]] <- run("R8", paste0("Treated radius ", rad, " m"), make_panel(Vr)) }
 ## R9 Sun & Abraham (fixest), R10 BJS imputation, R11 TWFE + Goodman-Bacon: benchmarks on T + F, point estimates
 Pf <- P0[grp %in% c("T", "F")][, `:=`(gg = fifelse(grp == "F", 10000L, as.integer(g)), id = as.integer(factor(village_id)))]
 Pf[, rel := fifelse(grp == "F", -1000L, as.integer(q - gg))]
@@ -270,13 +280,13 @@
 Pf[, D := as.integer(grp == "T" & q >= g)]
 twfe <- feols(y ~ D | id + q, data = Pf, cluster = ~district_id)
 tick("R9-R10 done"); ## R11 diagnostics on the cohort x quarter mean panel (unit-level bacon() is too slow at ~2,400 units)
-Pcm <- Pf[, .(y = mean(y), D = max(D)), by = .(coh = fifelse(grp == "F", 0L, as.integer(g)), q)]
+Pcm <- Pf[, .(y = mean(y), D = max(D), w = .N), by = .(coh = fifelse(grp == "F", 0L, as.integer(g)), q)]   # w = cohort size
 bacon_w <- tryCatch({ bd <- bacon(y ~ D, data = as.data.frame(Pcm), id_var = "coh", time_var = "q", quietly = TRUE)
   sum(bd$weight[bd$type == "Later vs Earlier Treated"]) }, error = function(e) NA_real_)
 tick("bacon done"); negw <- tryCatch({ suppressMessages(library(TwoWayFEWeights))
-  tw <- twowayfeweights(as.data.frame(Pcm), "y", "coh", "q", "D", type = "feTR")
+  tw <- twowayfeweights(as.data.frame(Pcm[rep(seq_len(.N), w)]), "y", "coh", "q", "D", type = "feTR")   # cohort-size weights as row frequency: the weights= argument of TwoWayFEWeights 2.1.0 errors
   tw$nr_minus / (tw$nr_plus + tw$nr_minus) }, error = function(e) NA_real_)
-tick("R11 done"); R[[length(R) + 1]] <- data.table(id = "R11", label = sprintf("TWFE (cohort-mean panel: later-vs-earlier weight %.2f; negative-weight share %.2f)", bacon_w, negw),
+tick("R11 done"); R[[length(R) + 1]] <- data.table(id = "R11", label = sprintf("TWFE, unweighted cohort-mean diagnostic (later-vs-earlier weight %.2f; negative-weight share %.2f)", bacon_w, negw),
                                  est = unname(coef(twfe)["D"]), p = NA, lo = NA, hi = NA)
 ## R12 Poisson (Wooldridge): cohort x post-period interactions, log P offset, small villages kept
 Vall <- copy(V0)[excl == "3_small_population" | is.na(excl)]
@@ -285,7 +295,7 @@
 Pp[, cell := fifelse(grp == "T" & q >= g & q <= g + 11, paste0("g", g, "_e", q - g), "0")]
 pois <- fepois(N ~ i(cell, ref = "0") | village_id + q, offset = ~log(P), data = Pp[!(grp == "T" & (q < g - 13 | (q >= g - 12 & q < g)))])
 pe <- coef(pois); R[[length(R) + 1]] <- data.table(id = "R12", label = "Poisson DiD, mean proportional effect (exp(b) - 1)", est = mean(exp(pe) - 1), p = NA, lo = NA, hi = NA)
-R[[length(R) + 1]] <- run("R13", "Weighted by base-year population", cs_long(P0, wvar = "P"))
+R[[length(R) + 1]] <- run("R13", "Weighted by base-year population", P0, wvar = "P")
 ## R14 doubly robust with covariates, did 2.5.1 on T + F
 Pd2 <- merge(Pd, vil[, .(village_id, area_km2)], by = "village_id")
 Pd2[, dens := P / area_km2]; Pd2[, ybar := mean(y[q >= qi(2011, 1) & q <= qi(2011, 4)]), by = id]
@@ -295,34 +305,35 @@
 R[[length(R) + 1]] <- data.table(id = "R14", label = "Doubly robust, 2 covariates (T + F)",
   est = if (is.null(cs14)) NA_real_ else aggte(cs14, type = "dynamic", min_e = 0, max_e = 11, na.rm = TRUE, bstrap = FALSE)$overall.att, p = NA, lo = NA, hi = NA)
 R[[length(R) + 1]] <- data.table(id = "R15", label = "HonestDiD M-bar 0.5/1/2: NOT RUN (package needs R >= 4.4)", est = NA, p = NA, lo = NA, hi = NA)
-for (ce in c("lo", "hi")) R[[length(R) + 1]] <- run("R16", paste("Small cells imputed at", ce), cs_long(make_panel(V0, cell = ce)))
-R[[length(R) + 1]] <- data.table(id = "R17", label = sprintf("Survivorship-corrected (breakdown r = %.2f)", r_break), est = r17, p = NA, lo = NA, hi = NA)
-R[[length(R) + 1]] <- run("R18", "Balanced k = 0..7", cs_long(P0, emax = 7L))
+for (ce in c("lo", "hi")) R[[length(R) + 1]] <- run("R16", paste("Small cells imputed at", ce), make_panel(V0, cell = ce))
+R[[length(R) + 1]] <- data.table(id = "R17", label = sprintf("Survivorship-corrected (r* = %.2f)", r_break), est = r17, p = NA, lo = NA, hi = NA)
+R[[length(R) + 1]] <- run("R18", "Balanced k = 0..7", P0, emax = 7L)
 V19 <- build_groups(date_col = "open_fare")
-R[[length(R) + 1]] <- run("R19", "k = 0 from fare-start dates", cs_long(make_panel(V19)))
+R[[length(R) + 1]] <- run("R19", "k = 0 from fare-start dates", make_panel(V19))
 R[[length(R) + 1]] <- data.table(id = "R20", label = "Wild cluster bootstrap p (check)", est = FP0$stat, p = wild_test(L0, min(B, 1999L))$p, lo = NA, hi = NA)
-R[[length(R) + 1]] <- run("R21", "Extensive margin (any registration)", cs_long(make_panel(V0, outcome = "any")))
-R[[length(R) + 1]] <- run("R22", "Drop 機捷 and 綠山 cohorts", cs_long(P0[!(grp == "T" & line %in% c("機捷", "綠山"))]))
-R[[length(R) + 1]] <- run("R23", "Population-weighted centroid", cs_long(make_panel(build_groups(centroid = "pw"))))
-R[[length(R) + 1]] <- run("R24", "Exclude development zones", cs_long(P0[in_zone == FALSE]))
-R[[length(R) + 1]] <- run("R25", "Pool G + T only (no F)", cs_long(P0, pool = c("G", "T")), fp = FALSE)
-R[[length(R) + 1]] <- run("R26", "Exclude firms with a 遷址 record", cs_long(make_panel(V0, outcome = "nomove")))
-R[[length(R) + 1]] <- run("R27", "Treated clusters = districts", L0, tcl = "district")
+R[[length(R) + 1]] <- run("R21", "Extensive margin (any registration)", make_panel(V0, outcome = "any"))
+R[[length(R) + 1]] <- run("R22", "Drop 機捷 and 綠山 cohorts", P0[!(grp == "T" & line %in% c("機捷", "綠山"))])
+R[[length(R) + 1]] <- run("R23", "Population-weighted centroid", make_panel(build_groups(centroid = "pw")))
+R[[length(R) + 1]] <- run("R24", "Exclude development zones", P0[in_zone == FALSE])
+R[[length(R) + 1]] <- run("R25", "Pool G + T only (no F)", P0, pool = c("G", "T"), fp = FALSE)
+R[[length(R) + 1]] <- run("R26", "Exclude firms with a 遷址 record", make_panel(V0, outcome = "nomove"))
+R[[length(R) + 1]] <- run("R27", "Treated clusters = districts (check)", P0, tcl = "district")
+R[[length(R) + 1]] <- run("R28", "Base = mean of k = -16..-13 (D2, reported only)", P0, base_k = -16:-13)
 rob <- rbindlist(R, fill = TRUE)
 
 ## ============ 9. secondary outcomes (§9), Holm across them ============
 tick("9. secondary outcomes (§9), Holm across the")
 sec <- rbindlist(list(
-  run("S1a", "公司 registrations", cs_long(make_panel(V0, outcome = "company"))),
-  run("S1b", "商業 registrations", cs_long(make_panel(V0, outcome = "business"))),
+  run("S1a", "公司 registrations", make_panel(V0, outcome = "company")),
+  run("S1b", "商業 registrations", make_panel(V0, outcome = "business")),
   { pr <- rd("prices.csv")[, q := q_of(quarter)]
     Pq <- merge(pr[, .(village_id, q, y = median_price_m2)], keep(V0)[, .(village_id, grp, g, line, tclus, district_id, P, in_zone)], by = "village_id")
-    run("S2", "Median residential price per m2 (NT$)", cs_long(Pq[q >= qi(2012, 3)], emin = 0L)) },
+    run("S2", "Median residential price per m2 (NT$)", Pq[q >= qi(2012, 3)], emin = 0L) },
   { Py <- merge(pop_v, keep(V0)[, .(village_id, grp, g, line, tclus, district_id, P, in_zone)], by = "village_id")
     Py <- Py[, .(village_id, q = qi(year, 4), y = 100 * (population / P - 1), grp, g, line, tclus, district_id, P, in_zone)]
     Py <- Py[, .SD[CJ(q = qi(2011, 4):qi(2025, 4)), on = "q", roll = TRUE], by = village_id]
-    run("S3", "Population growth vs base (%)", cs_long(Py[!is.na(y)], min_ctrl = MIN_CTRL)) },
-  run("S4", "Consumer-facing registrations", cs_long(make_panel(V0, outcome = "consumer")))), fill = TRUE)
+    run("S3", "Population growth vs base (%)", Py[!is.na(y)], min_ctrl = MIN_CTRL) },
+  run("S4", "Consumer-facing registrations", make_panel(V0, outcome = "consumer"))), fill = TRUE)
 sec[, p_holm := p.adjust(p, "holm")]
 
 ## ============ 10. outputs ============
@@ -330,7 +341,7 @@
 real <- FP0$stat > 0 && FP0$p < 0.05 && !any(kill$fires) && rob[id == "R1", est] > 0 && r17 > 0 && !r_fragile
 primary <- data.table(estimate = FP0$stat, p_FP = FP0$p, ci_lo = FP0$ci[1], ci_hi = FP0$ci[2], N0 = FP0$N0,
                       treated_clusters = FP0$n_treated_clusters, p_min = FP0$p_min, wild_p = rob[id == "R20", p],
-                      r_breakdown = r_break, effect_is_real = real, denominator = denom_route)
+                      r_star = r_break, floored_clusters = RR$floored, effect_is_real = real, denominator = denom_route)
 appendixA <- list(input_sha256 = as.list(input_hash), denominator = denom_route, T_per_line = k1_tab, T_total = K1_total,
                   lines_below_5 = lines_dropped, N0 = FP0$N0, p_min = FP0$p_min,
                   cells = L0[role == "C", .(comparison_villages = uniqueN(village_id)), by = .(cohort = yq(g), e)][order(cohort, e)])
```

## Open items and spend

**Before any outcome file opens (all still blocking):**

1. The referee rules on the four gate failures (diagnosis section). Then the gate is rerun on the amended code and passes.
2. R ≥ 4.4 for HonestDiD (R15), with a new snapshot pin and a second lockfile, logged as a deviation. Not yet done: installing R 4.5 here would replace the R 4.3.3 that produced every result above, so it waits until the gate is settled.
3. The `data/pre` bundle: `appendixA.R` maps the 112 unknown stations (study-line names get v2.1 dates; it stops if any undated station is within 2 km of a study-area 村里) and projects to TWD97 TM2. Then Appendix A (D4) and the 機捷 source (D3) are committed.

**Smaller items:**

- R20 (wild bootstrap) and R27 (district clusters) still use v1's district-residual construction. They are labelled as checks; the referee may want them on the D2 construction.
- R13 (population-weighted) and the R3 and R25 point estimates still use the v1 engine, which equals did. They have no p-value.

**Spend.** This session's `cost_usd` reads **US$27.35** (session total so far, all stages). The subagents of the full-speed phase add an estimated US$15–20: two Opus agents (paper draft, red-team brief) and two Sonnet (機捷 source, full-text reading). Together with the earlier subagents (US$8–12), the estimated project total is **about US$50–60**. The gate itself ran locally (about 4 minutes of CPU across all passes) and added no API cost.
