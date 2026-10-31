# MRT pilot: analysis code v3 and D5 gate

Oct 31, 2026 · @Niko

## Fresh seeds, fixed before any v3 run

Written 2026-10-31 before the v3 code ran on any seed. None of these seeds were used in the D2 gate (which used 1001–1500, 2001–2200, 3001–3200, 4001–4200). Each seed redraws the layout; B = 999. Every scenario runs twice on the same seeds: line variance σ²\_j off and on.

| Scenario | Seeds | Count |
| --- | --- | --- |
| Null (τ = 0) | 50001–50500 | 500 |
| Effect (τ = 0.5), with suppression | 60001–60200 | 200 |
| Effect (τ = 0.5), no suppression (coverage check) | 60001–60200 (same seeds, paired) | 200 |
| Pre-trend (slope 0.04) | 70001–70200 | 200 |
| Stress (district and line × quarter shocks, SD 10%) | 80001–80200 | 200 |

## Short note: one hard limit fails; nothing opens

The D5 gate ran once, on the seeds above, with code `lib_v3.R` be84d272… and `sim_gate_v3.R` a767c310…. Every limit passes with σ²\_j on except one:

**Effect scenario without suppression: 95% coverage is 91.5% with σ²\_j on (90.5% off), against a limit of 92.5%.** The Monte Carlo SE is 2.0 points, so the true coverage could be anywhere from about 87.6% to 95.4%. Under D5 that still counts as a failure, so nothing opens and this goes back to the referee.

**Likely cause, not acted on.** Under no effect, the interval half-width is 1.90 times the estimate's SD (coverage 93.0%). Under the effect it is only 1.71 times (coverage 91.5%). The treatment raises treated counts by about 40%, so it also raises their Poisson noise. The placebo residuals come from untreated districts and cannot see that extra noise. Possible remedies for the referee:

- scale each line's placebo variance by the ratio of its post-period to pre-period mean level;
- test at the null but build the interval with treated-side variance;
- accept a size-correct test whose interval is mildly narrow under large effects, and say so in the paper.

The gate was not rerun or tuned after these results. No outcome data was opened.

## Gate results against each D5 limit

Monte Carlo SEs in brackets. σ = line × quarter variance σ²\_j off / on, on the same seeds. No seed failed to run.

| D5 limit | σ²\_j off | σ²\_j on | Pass (σ on) |
| --- | --- | --- | --- |
| Null: rejection at 5% within 3.0–7.5% | 7.6% (1.2) | 7.0% (1.1) | yes |
| Null: 95% coverage ≥ 92.5% | 92.4% (1.2) | 93.0% (1.1) | yes |
| Null: K2a / K2b / K3a / K3b ≤ 12.5% each | 8.6 / 6.8 / 8.0 / 4.6% | 8.2 / 7.2 / 8.0 / 4.2% | yes |
| Effect, suppressed: bias ≤ 0 | −0.027 (0.006) | −0.027 (0.006) | yes |
| Effect, suppressed: abs bias ≤ 10% of truth (0.05) | 0.027 | 0.027 | yes |
| Effect: K2a / K2b / K3a / K3b ≤ 12.5% each | 8.0 / 7.0 / 9.0 / 4.5% | 7.5 / 7.5 / 9.0 / 4.5% | yes |
| Effect: any kill ≤ 25% | 24.5% (3.0) | 25.0% (3.1) | yes (at the limit) |
| Effect: power | 100% | 100% | reported |
| **Effect, unsuppressed: coverage ≥ 92.5%** | **90.5% (2.1)** | **91.5% (2.0)** | **no** |
| Pre-trend: any kill ≥ 80% | 89.0% (2.2) | 89.0% (2.2) | yes |
| Stress: rejection ≤ 7.5% | 4.5% (1.5) | 2.0% (1.0) | yes |
| Stress: coverage ≥ 92.5% | 95.0% (1.5) | 98.0% (1.0) | yes |

Supporting numbers (σ on):

| Scenario | Mean bias | SD of estimate | Mean CI half-width | Mean σ²\_j |
| --- | --- | --- | --- | --- |
| Null | +0.004 | 0.079 | 0.150 | 0.0014 |
| Effect, suppressed | −0.027 | 0.083 | 0.147 | 0.0015 |
| Effect, unsuppressed | −0.007 | 0.087 | 0.148 | 0.0015 |
| Pre-trend | +0.719 | 0.085 | 0.151 | 0.0016 |
| Stress | −0.009 | 0.104 | 0.240 | 0.0178 |

Without line shocks, σ²\_j stays near zero (0.0015), so it changes little. Under stress it rises twelvefold, and stress coverage goes from 95.0% to 98.0%. In the pre-trend scenario K2a fires 47.5% and K2b 72.0%, now at 0.05.

**Fixed synthetic exports (`analysis_v3.R`, B = 999):**

- Effect export (true +0.50): 0.538 (0.384–0.691), no kill rule fires, r\* = 1.42, "effect is real" = TRUE.
- Pre-trend export (true 0): K2a fires (p = 0.002) and K3b fires; K2b no longer fires at 0.05 (tail p = 0.066). "Effect is real" = FALSE.

## What v3 implements from D5

| D5 item | Implementation | Where |
| --- | --- | --- |
| K2a at p < 0.05, no calibrated widening | `fires = iK$p < 0.05` | `lib_v3.R` `run_rules()` |
| K2b at placebo tail < 0.05; its "large but not significant" role goes to R15's disclosure line | `ptail < 0.05` in `k2b()`; sign and ≥ 50% conditions unchanged | `lib_v3.R` |
| Keep the 1.5 imputation; coarse unsuppressed bias check if the export allows | Unchanged rule. New section 9b reads `registrations_coarse.csv` (group × line × quarter unsuppressed sums) if present and reports the implied bias; reported only | `analysis_v3.R` |
| σ²\_j from each line's 800–1,500 m ring, k = −20 to −1 only | `sigma2_lines()`: D\_t = ring mean − F mean per quarter; σ²\_j = var\_t(D\_t) − mean sampling variance, floored at 0 | `lib_v3.R` |
| Added through the quarter weights | `qweight_var()`: c\_q = net statistic weight on quarter q (+ at t, − at base); line j's draws get N(0, σ²\_j Σ c\_q²) added | `lib_v3.R` `infer()` |
| Stress DGP shocks every 村里 within 1,500 m of the line | `near <- V$d <= 1500`, stated in the header | `sim_gate_v3.R` |
| Monte Carlo SEs; every scenario with σ²\_j off and on | Binomial SE for rates, SD/√n for bias | gate summary |

**Two implementation notes for the referee.**

1. The 800– 1,500 m ring 村里 enter the data only to estimate σ²\_j. They are not treated, not in the pool, and not in any cell.
2. In the pre-window (K2a, K2b) the line shock is spread across event times in proportion to the line's weights. This is exact for the K2a mean and an approximation for the K2b slope extrapolation.

## Code v3

Three new files for `code/`, each given as a diff against its committed v2 file (ba06c4e). Apply with `patch -o code/lib_v3.R code/lib_v2.R < lib.diff`, and likewise for the others; then check the SHA-256s.

| File | SHA-256 | Base |
| --- | --- | --- |
| `lib_v3.R` | be84d272a5af31ad34b26c13992a95f2aa3bee1d1c2add8f944f3e0cfd7f4c38 | `lib_v2.R` |
| `sim_gate_v3.R` | a767c31014565f3ffa17223572a97f37a4736436c75e1dda4c233965d6368452 | `sim_gate.R` |
| `analysis_v3.R` | 4349d10c903dd646b93a20f855e80e01f6c86b1828210f5ac4d7df131f468920 | `analysis_v2.R` |

Gate run, as executed: `for sg in off on; do for s in "null 500 50001" "effect 200 60001" "effect_nosupp 200 60001" "pretrend 200 70001" "stress 200 80001"; do set -- $s; Rscript sim_gate_v3.R $1 $2 ../gate_v3/${1}_sigma${sg}.csv $sg 4 $3; done; done` (about 6 minutes on 4 cores).

```diff
--- a/code/lib_v2.R
+++ b/code/lib_v3.R
@@ -1,4 +1,6 @@
-# lib_v2.R -- estimator and inference for pre-registration v2.1 as amended by deviations.md D2 (referee ruling).
+# lib_v3.R -- estimator and inference for pre-registration v2.1 as amended by deviations.md D2 and D5 (referee rulings).
+# D5: K2a at p < 0.05; K2b at placebo tail < 0.05; line x quarter variance sigma2_j from each line's 800-1,500 m ring,
+#     added to the placebo draws through the quarter weights.
 # D2: placebo-district inference (each comparison district gets each treated line's own cohorts, base and weights);
 #     K2b with a placebo percentile; NNLS variance model with floor; r* breakdown; R28 four-quarter base.
 suppressPackageStartupMessages(library(data.table))
@@ -88,9 +90,32 @@
   list(v = function(m) pmax(best$beta[1] + best$beta[2] / m, fl), floor = fl, beta = best$beta)
 }
 
+## ---- 4b. D5: line x quarter variance sigma2_j from each line's 800-1,500 m ring (k = -20..-1 only) ----
+## For line j: D_t = mean over j's ring villages of y_t minus mean over F of y_t, for quarters t with k = t - g in -20..-1
+## (g = the ring village's nearest cohort). sigma2_j = var_t(D_t) - mean_t(sampling variance of D_t), floored at 0.
+sigma2_lines <- function(ring_cl, ring_g, Yr, YF) {
+  qs <- as.integer(colnames(Yr)); out <- c()
+  for (j in sort(unique(ring_cl))) {
+    rj <- which(ring_cl == j); if (length(rj) < 2) { out[j] <- 0; next }
+    K <- outer(rep(1, length(rj)), qs) - ring_g[rj]; M <- Yr[rj, , drop = FALSE]; M[K < -20 | K > -1] <- NA
+    nq <- colSums(!is.na(M)); use <- which(nq >= 2)
+    if (length(use) < 3) { out[j] <- 0; next }
+    mr <- colMeans(M[, use, drop = FALSE], na.rm = TRUE); vr <- apply(M[, use, drop = FALSE], 2, var, na.rm = TRUE) / nq[use]
+    mf <- colMeans(YF[, use, drop = FALSE]); vf <- apply(YF[, use, drop = FALSE], 2, var) / nrow(YF)
+    Dt <- mr - mf; out[j] <- max(0, var(Dt) - mean(vr + vf)) }
+  out }
+## variance added to line j's contribution: sigma2_j * sum_q c_q^2, c_q = net statistic weight on quarter q (t minus base)
+qweight_var <- function(cells, dec, U, j) {
+  w <- numeric(0); add <- function(q, v) { if (!(q %in% names(w))) w[q] <<- 0; w[q] <<- w[q] + v }
+  for (k in seq_along(cells)) { nj <- sum(U$cl[cells[[k]]$tr] == j); if (!nj) next
+    a <- dec$info$pg[k] * nj / dec$info$nT[k] / dec$E
+    for (q in as.character(cells[[k]]$t)) add(q, a)
+    for (q in as.character(cells[[k]]$b)) add(q, -a / length(cells[[k]]$b)) }
+  sum(w^2, na.rm = TRUE) }
+
 ## ---- 5. inference: draws for each j from j's own placebo residuals ----
 ## returns stat, p, CI (test inversion), placebo draws of the statistic and of att_e, and diagnostics
-infer <- function(U, cells, B = 999L, alpha = 0.05, seed = 1L) {
+infer <- function(U, cells, B = 999L, alpha = 0.05, seed = 1L, sigma2 = NULL) {
   dec <- decompose(U, cells); if (is.null(dec)) return(NULL)
   pl <- placebo(U, cells, dec)
   nT <- sapply(dec$cls, function(j) sum(U$treated & U$cl == j))
@@ -105,6 +130,9 @@
     sc <- sqrt(vm$v(nT[j]) / vm$v(n))
     pick <- sample.int(nrow(P), B, replace = TRUE)
     draws_e <- draws_e + sweep(R[pick, , drop = FALSE] * sc[pick], 2, wj, "*")
+    if (!is.null(sigma2) && !is.na(sigma2[j]) && sigma2[j] > 0) {          # D5: line x quarter shocks, spread over e
+      sd_j <- sqrt(sigma2[j] * qweight_var(cells, dec, U, j)); z <- rnorm(B, 0, sd_j)
+      draws_e <- draws_e + outer(z, wj / sum(wj)) * E }                      # adds z to the row mean of draws_e
   }
   draws <- rowMeans(draws_e)
   pfun <- function(null) mean(abs(draws) >= abs(dec$stat - null))
@@ -118,7 +146,7 @@
   e <- inf_pre$att_e$e; fit <- lm(inf_pre$att_e$att ~ e); pred <- unname(predict(fit, data.frame(e = 5.5)))
   X <- cbind(1, e); H <- solve(crossprod(X), t(X)); pd <- as.vector(cbind(1, 5.5) %*% (H %*% t(inf_pre$draws_e)))
   s <- sign(primary_stat); ptail <- mean(s * pd >= s * pred)
-  list(pred = pred, ptail = ptail, fires = sign(pred) == s && abs(pred) >= 0.5 * abs(primary_stat) && ptail < 0.20)
+  list(pred = pred, ptail = ptail, fires = sign(pred) == s && abs(pred) >= 0.5 * abs(primary_stat) && ptail < 0.05)   # D5: tail < 0.05
 }
 ## r*: T changes in post cells with T levels at t divided by r; base quarters unchanged (D2 item 6)
 r_star <- function(U, Y, cells, dec) {
@@ -130,12 +158,14 @@
 
 ## ---- 6. the registered configurations ----
 cfg_primary <- function(V, G_CUTOFF, ant = 12L) {
-  data.table(treated = V$grp == "T", g = V$g, cl = V$cl, pool = V$grp %in% c("G", "T", "F"), dist = V$dist,
+  data.table(treated = V$grp == "T", g = V$g, cl = V$cl, pool = V$grp %in% c("G", "T", "F"), dist = V$dist,   # R2 rows: neither
              gv = fcase(V$grp == "F", Inf, V$grp == "G", as.numeric(G_CUTOFF + ant - 1L), V$grp == "T", as.numeric(V$g), default = -Inf)) }
-run_rules <- function(V, Y, G_CUTOFF, B = 999L, seed = 1L) {
+run_rules <- function(V, Y, G_CUTOFF, B = 999L, seed = 1L, use_sigma = TRUE) {
   U <- cfg_primary(V, G_CUTOFF)
-  cP <- cells_of(U, Y, 12L, -13L, 0:11); iP <- infer(U, cP, B, seed = seed)
-  cK <- cells_of(U, Y, 12L, -13L, -20:-14); iK <- infer(U, cK, B, seed = seed + 1L)
+  s2 <- if (use_sigma && any(V$grp == "R2")) sigma2_lines(V$cl[V$grp == "R2"], V$g[V$grp == "R2"], Y[V$grp == "R2", , drop = FALSE],
+                                                        Y[V$grp == "F", , drop = FALSE]) else NULL
+  cP <- cells_of(U, Y, 12L, -13L, 0:11); iP <- infer(U, cP, B, seed = seed, sigma2 = s2)
+  cK <- cells_of(U, Y, 12L, -13L, -20:-14); iK <- infer(U, cK, B, seed = seed + 1L, sigma2 = s2)
   kb <- k2b(iK, iP$stat)
   ## K3a: G with a fake k = 0 at 2020Q1 against F only, anticipation 0, base -1, data up to the G cutoff
   qs <- as.integer(colnames(Y)); Ya <- Y[, qs < G_CUTOFF, drop = FALSE]
@@ -145,14 +175,14 @@
   ## K3b: fake k = 0 at real k = -16, only quarters <= real k = -13 for treated, anticipation 0, base -1, e = 0..3
   Ub <- copy(U); Ub[treated == TRUE, `:=`(g = g - 16L, gv = gv - 16)]
   Yb <- Y; for (gc in unique(U$g[U$treated])) { r <- which(U$treated & U$g == gc); Yb[r, qs > gc - 13L] <- NA }
-  iB <- infer(Ub, cells_of(Ub, Yb, 0L, -1L, 0:3), B, seed = seed + 3L)
+  iB <- infer(Ub, cells_of(Ub, Yb, 0L, -1L, 0:3), B, seed = seed + 3L, sigma2 = s2)
   p03 <- decompose(U, cells_of(U, Y, 12L, -13L, 0:3))$stat
   s <- sign(iP$stat)
   list(primary = iP, pre = iK,
        rules = data.table(rule = c("K2a", "K2b", "K3a", "K3b"),
          value = c(iK$stat, kb$pred, iA$stat, iB$stat), p = c(iK$p, kb$ptail, iA$p, iB$p),
-         fires = c(iK$p < 0.10, kb$fires,
+         fires = c(iK$p < 0.05, kb$fires,                                   # D5: K2a at p < 0.05
                    sign(iA$stat) == s && iA$p < 0.10 && abs(iA$stat) >= abs(iP$stat) / 3,
                    sign(iB$stat) == s && iB$p < 0.10 && abs(iB$stat) >= abs(p03) / 3)),
-       r_star = r_star(U, Y, cP, iP$dec), floored = iP$floored, N0_min = iP$N0_min)
+       r_star = r_star(U, Y, cP, iP$dec), floored = iP$floored, N0_min = iP$N0_min, sigma2 = s2)
 }
--- a/code/sim_gate.R
+++ b/code/sim_gate_v3.R
@@ -1,9 +1,11 @@
-# sim_gate.R -- the D2 simulation gate. Each seed redraws the layout; B = 999.
-# Usage: Rscript sim_gate.R <scenario: null|effect|pretrend|stress> <n_seeds> <out.csv> [cores] [first_seed]
+# sim_gate_v3.R -- the D5 simulation gate. Each seed redraws the layout; B = 999.
+# Usage: Rscript sim_gate_v3.R <scenario: null|effect|effect_nosupp|pretrend|stress> <n_seeds> <out.csv> <sigma: on|off> [cores] [first_seed]
+# Stress DGP (D5): district x quarter shocks (SD 10%) for every village, and line x quarter shocks (SD 10%) for every
+# village within 1,500 m of a study line (T, R1 and R2), by nearest line.
 suppressPackageStartupMessages({ library(data.table); library(parallel) })
-source("lib_v2.R")
-a <- commandArgs(TRUE); SC <- a[1]; NS <- as.integer(a[2]); OUTF <- a[3]
-CORES <- if (length(a) >= 4) as.integer(a[4]) else 4L; S0 <- if (length(a) >= 5) as.integer(a[5]) else 1L
+source("lib_v3.R")
+a <- commandArgs(TRUE); SC <- a[1]; NS <- as.integer(a[2]); OUTF <- a[3]; SIG <- a[4] == "on"
+CORES <- if (length(a) >= 5) as.integer(a[5]) else 4L; S0 <- if (length(a) >= 6) as.integer(a[6]) else 1L
 G_CUTOFF <- qi(2023, 3)
 k0 <- function(d) { d <- as.IDate(d); y <- year(d); q <- quarter(d)
   qend <- as.IDate(sprintf("%d-%02d-01", y + (q == 4), ifelse(q == 4, 1, q * 3 + 1))) - 1L
@@ -18,7 +20,7 @@
 
 gen <- function(seed, scenario) {
   set.seed(seed)
-  tau <- if (scenario == "effect") 0.5 else 0; slope <- if (scenario == "pretrend") 0.04 else 0
+  tau <- if (grepl("effect", scenario)) 0.5 else 0; slope <- if (scenario == "pretrend") 0.04 else 0
   PRE <- data.table(x = runif(25, 24000, 40000), y = runif(25, 22000, 40000))
   NV <- 5000; V <- data.table(x = runif(NV, 0, 40000), y = runif(NV, 0, 40000))
   V[, dist := floor(x / 5000) * 8 + floor(y / 5000)]
@@ -36,24 +38,25 @@
   if (scenario == "stress") {
     R <- R * exp(matrix(rnorm(64 * Q, 0, 0.1), 64, Q)[V$dist + 1, ])                       # district x quarter
     lines <- unique(ST$cl); LS <- exp(matrix(rnorm(length(lines) * Q, 0, 0.1), length(lines), Q))
-    near <- V$d < 2000; R[near, ] <- R[near, ] * LS[match(ST$cl[jn[near]], lines), ] }     # line x quarter, within 2 km
+    near <- V$d <= 1500; R[near, ] <- R[near, ] * LS[match(ST$cl[jn[near]], lines), ] }    # line x quarter, within 1,500 m (D5)
   K <- outer(rep(1, N), qs) - V$g
   R <- R + tau * (V$d <= 500 & K >= 0) + slope * (V$d <= 500) * (K + 20)
   mu <- pmax(R, 0) * V$P / 1000
   Nc <- matrix(rpois(N * Q, 0.6 * mu), N); Nb <- matrix(rpois(N * Q, 0.4 * mu), N)
   imp <- function(M) { M[M %in% 1:2] <- 1.5; M }                                             # suppressed 1-2 -> 1.5
-  Y <- 1000 * (imp(Nc) + imp(Nb)) / V$P; colnames(Y) <- qs
-  keep <- V$dPre > 500 & V$dNon > 800 & V$P >= 500 & V$grp %in% c("T", "G", "F")
+  Y <- 1000 * (if (grepl("nosupp", scenario)) Nc + Nb else imp(Nc) + imp(Nb)) / V$P; colnames(Y) <- qs
+  keep <- V$dPre > 500 & V$dNon > 800 & V$P >= 500 & V$grp %in% c("T", "G", "F", "R2")   # R2 rings feed sigma2_j
   list(V = V[keep], Y = Y[keep, , drop = FALSE])
 }
 
 one <- function(s) {
-  d <- gen(s, SC); r <- tryCatch(run_rules(d$V, d$Y, G_CUTOFF, B = 999L, seed = s), error = function(e) NULL)
+  d <- gen(s, SC); r <- tryCatch(run_rules(d$V, d$Y, G_CUTOFF, B = 999L, seed = s, use_sigma = SIG), error = function(e) NULL)
   if (is.null(r)) return(data.table(seed = s, ok = FALSE))
   w <- dcast(r$rules, . ~ rule, value.var = "fires"); pv <- setNames(r$rules$p, paste0("p_", r$rules$rule))
   data.table(seed = s, ok = TRUE, est = r$primary$stat, p = r$primary$p, lo = r$primary$ci[1], hi = r$primary$ci[2],
              K2a = w$K2a, K2b = w$K2b, K3a = w$K3a, K3b = w$K3b, r_star = r$r_star, floored = r$floored, N0_min = r$N0_min,
-             nT = sum(d$V$grp == "T"), p_K2a = pv[["p_K2a"]], p_K2b = pv[["p_K2b"]], v_K2b = r$rules$value[2], p_K3a = pv[["p_K3a"]], p_K3b = pv[["p_K3b"]])
+             nT = sum(d$V$grp == "T"), p_K2a = pv[["p_K2a"]], p_K2b = pv[["p_K2b"]], v_K2b = r$rules$value[2], p_K3a = pv[["p_K3a"]], p_K3b = pv[["p_K3b"]],
+             sigma2_mean = if (is.null(r$sigma2)) NA_real_ else mean(r$sigma2))
 }
 t0 <- Sys.time()
 res <- rbindlist(mclapply(S0:(S0 + NS - 1L), one, mc.cores = CORES), fill = TRUE)
--- a/code/analysis_v2.R
+++ b/code/analysis_v3.R
@@ -1,10 +1,10 @@
-# analysis_v2.R -- MRT pilot, analysis as pre-registration v2.1 amended by deviations.md D2 (referee ruling on inference).
+# analysis_v3.R -- MRT pilot, analysis as pre-registration v2.1 amended by deviations.md D2 and D5 (referee rulings).
 # Usage: Rscript analysis.R <export_dir> <out_dir> [B]
 # Section numbers (§) refer to preregistration/mrt-pilot-v2.md (v2.1).
 suppressPackageStartupMessages({
   library(data.table); library(did); library(fixest); library(didimputation)
   library(bacondecomp); library(ggplot2); library(digest); library(jsonlite) })
-source("lib_v2.R")
+source("lib_v3.R")
 args <- commandArgs(TRUE)
 IN  <- if (length(args) >= 1) args[1] else "../synth_effect"
 OUT <- if (length(args) >= 2) args[2] else "../out_effect"
@@ -192,9 +192,9 @@
 tick("5. primary estimate (§1, §6)")
 P0 <- make_panel(V0)
 L0 <- cs_long(P0)                                   # engine table, kept for Appendix A cell counts and r*
-uy0 <- to_UY(P0[grp %in% c("G", "T", "F")])
+uy0 <- to_UY(P0[grp %in% c("G", "T", "F", "R2")])                 # R2 rings feed sigma2_j (D5); they are not in the pool
 Vx <- data.table(grp = uy0$grp, g = uy0$U$g, cl = uy0$U$cl, dist = uy0$U$dist)
-RR <- run_rules(Vx, uy0$Y, G_CUTOFF, B = B, seed = 20261031L)
+RR <- run_rules(Vx, uy0$Y, G_CUTOFF, B = B, seed = 20261031L, use_sigma = TRUE)
 FP0 <- list(stat = RR$primary$stat, p = RR$primary$p, ci = RR$primary$ci, N0 = RR$primary$N0_min,
             n_treated_clusters = length(RR$primary$dec$cls), p_min = 1 / (RR$primary$N0_min + 1))
 att_e0 <- RR$primary$att_e
@@ -336,12 +336,22 @@
   run("S4", "Consumer-facing registrations", make_panel(V0, outcome = "consumer"))), fill = TRUE)
 sec[, p_holm := p.adjust(p, "holm")]
 
+## ============ 9b. D5: coarse unsuppressed bias check for the 1.5 imputation (only if the export carries coarse sums) ============
+## registrations_coarse.csv: group (T/F/G) x line x quarter, unsuppressed sums of 公司 + 商業. Compares them with the sums of
+## imputed village counts; reports the implied bias in registrations per 1,000 residents. Reported only; the rule is unchanged.
+coarse_check <- NULL
+if (file.exists(file.path(IN, "registrations_coarse.csv"))) {
+  CO <- rd("registrations_coarse.csv")[, q := q_of(quarter)]
+  IMP <- make_panel(V0)[, .(imputed = sum(y * P / 1000), P = sum(P)), by = .(grp, line, q)]
+  coarse_check <- merge(CO, IMP, by = c("grp", "line", "q"))[, .(bias_per_1000 = mean(1000 * (imputed - n_total) / P)), by = grp]
+  fwrite(coarse_check, file.path(OUT, "coarse_bias_check.csv")) }
+
 ## ============ 10. outputs ============
 tick("10. outputs")
 real <- FP0$stat > 0 && FP0$p < 0.05 && !any(kill$fires) && rob[id == "R1", est] > 0 && r17 > 0 && !r_fragile
 primary <- data.table(estimate = FP0$stat, p_FP = FP0$p, ci_lo = FP0$ci[1], ci_hi = FP0$ci[2], N0 = FP0$N0,
                       treated_clusters = FP0$n_treated_clusters, p_min = FP0$p_min, wild_p = rob[id == "R20", p],
-                      r_star = r_break, floored_clusters = RR$floored, effect_is_real = real, denominator = denom_route)
+                      r_star = r_break, floored_clusters = RR$floored, sigma2_lines = paste(sprintf("%s=%.4f", names(RR$sigma2), RR$sigma2), collapse = "; "), effect_is_real = real, denominator = denom_route)
 appendixA <- list(input_sha256 = as.list(input_hash), denominator = denom_route, T_per_line = k1_tab, T_total = K1_total,
                   lines_below_5 = lines_dropped, N0 = FP0$N0, p_min = FP0$p_min,
                   cells = L0[role == "C", .(comparison_villages = uniqueN(village_id)), by = .(cohort = yq(g), e)][order(cohort, e)])
```

## Rerun results files

All 2,600 seed results (5 scenarios × σ off/on) in one CSV, attached to this doc as blob `772067ea1c1958b66d48c8e4fa4d9ccb` (`gate_v3_all_seeds.csv`, SHA-256 61e28dafdab4d174b5e9daac971b83839ee4882f5f048c6f7a0d4f16c85b483b; columns `scenario`, `sigma`, then one row per seed). The per-scenario files and their SHA-256s:

| File | SHA-256 |
| --- | --- |
| null\_sigmaoff.csv | a062b02f9c4910ee10ad0ede1a4e2a9ea5ac1e544909348ba05bf52b0b1ef5cd |
| null\_sigmaon.csv | 26eff674203fdd0ab7f208fae2dfe284ec87156d2a6c85b016d8573119a81cda |
| effect\_sigmaoff.csv | 0203fabbff843857b567a25e819b320e4687918a2c4a07ed62f9857c894f2832 |
| effect\_sigmaon.csv | 59ce979c574f8f1fb643f11a1c570f4862de6a17bce97598cc13adef69cb6dac |
| effect\_nosupp\_sigmaoff.csv | c2324ce5c392c595ccc322910fe581522c42eeba1778dfa22aced962028fc20a |
| effect\_nosupp\_sigmaon.csv | bd819bab3577829cf2ee6be10c9f48a0f8df5f2188ebbdb48fb4458fe4507c17 |
| pretrend\_sigmaoff.csv | 1b0a83b6c0f0d6934a9111477f3cb132a55832d9127a3bf9be9f364778df8eac |
| pretrend\_sigmaon.csv | a0983991b7d183d5f42cac2653c74ac862609853fca334621a46dfcba7fb7de2 |
| stress\_sigmaoff.csv | f35909cc2b74fc510b6c01211799870ebef7bcb8436fba475ca1e4db4f4b255c |
| stress\_sigmaon.csv | 0d829a653b6a1e6053f347627fffcda7d6cfb77f841d49a14abe2f9fc3bb698e |
| gate\_v3\_summary.csv | 2a0a8c14e6223b0d7aaabf94444e2740cda065b5ea2fe8efd583f3c710fbddde |
| code\_sha256.txt (hashes of lib\_v3.R and sim\_gate\_v3.R as run) | 151fb3e675ef8051913965b3308ea3c8c60054547e64e1af3314a5a519ef1d2a |

Power-curve run for the design note (not a gate): `sim_power.R` d3c7673f82bf03fba719dee5abb44ea7caad0b81d7420990d2c438d78e6cfb57 (= `sim_gate_v3.R` with τ read from the scenario name), seeds 91001–91200 at τ = 0.1, 0.2, 0.3, 0.4; summary `power_summary.csv` 45577eeb….

## Spend and open items

**Spend.** This session's `cost_usd` reads **US$36.50** (02:46 UTC, all stages). Subagents add about US$23–32 (US$8–12 at stage 1, US$15–20 for the full-speed phase); none were used for v3. Estimated project total: **about US$60–70**. The v3 gate ran locally, in about 6 minutes on 4 cores.

**Still blocking before any outcome file:**

1. The referee rules on the unsuppressed effect coverage (91.5% vs 92.5%). Per D5 the gate is not rerun or tuned without a ruling.
2. R ≥ 4.4 for HonestDiD (R15), with a new pin and lock.
3. `data/pre`, then Appendix A (D4).
