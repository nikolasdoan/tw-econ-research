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
