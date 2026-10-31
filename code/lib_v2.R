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
