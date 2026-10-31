# note_tables.py -- recompute every simulation figure in the design and power note from the per-seed files.
# Usage: python3 -I code/note_tables.py  (from the mrt-code root); writes paper/note_tables.csv
import pandas as pd, numpy as np
KR = ['K2a', 'K2b', 'K3a', 'K3b']
def row(rnd, scen, f, tau, rescore05=False):
    d = pd.read_csv(f); d = d[d.ok]; n = len(d)
    K = d[KR].astype(bool).copy()
    if rescore05:  # round 3: the D2 runs re-scored with K2a and K2b at 0.05 (sign and >= 50% conditions kept)
        K['K2a'] = d.p_K2a < 0.05
        K['K2b'] = (np.sign(d.v_K2b) == np.sign(d.est)) & (d.v_K2b.abs() >= 0.5 * d.est.abs()) & (d.p_K2b < 0.05)
    se = lambda p: np.sqrt(p * (1 - p) / n)
    r = dict(round=rnd, scenario=scen, file=f, seeds=f'{d.seed.min()}-{d.seed.max()}', n=n, tau=tau,
             bias=d.est.mean() - tau, bias_se=d.est.std() / np.sqrt(n), sd_est=d.est.std(),
             reject5=(d.p < 0.05).mean(), cover95=((d.lo <= tau) & (d.hi >= tau)).mean())
    r['reject5_se'] = se(r['reject5']); r['cover95_se'] = se(r['cover95'])
    for k in KR: r[k] = K[k].mean(); r[k + '_se'] = se(r[k])
    r['any_kill'] = K.any(axis=1).mean(); r['any_kill_se'] = se(r['any_kill'])
    r['claim'] = ((d.p < 0.05) & ~K.any(axis=1)).mean(); r['claim_se'] = se(r['claim'])
    if 'p_K2b' in d:
        r['K2b_tail_lt_0.20'] = (d.p_K2b < 0.20).mean(); r['K2b_tail_lt_0.05'] = (d.p_K2b < 0.05).mean()
    hw = (d.hi - d.lo) / 2; r['halfwidth_over_sd'] = hw.mean() / d.est.std()
    rng = np.random.default_rng(20261031); b = []
    for _ in range(2000):
        i = rng.integers(0, n, n); b.append(hw.values[i].mean() / d.est.values[i].std(ddof=1))
    r['halfwidth_over_sd_se'] = np.std(b)
    r['nT_min'], r['nT_max'], r['nT_median'] = d.nT.min(), d.nT.max(), d.nT.median()
    r['N0_min_lo'], r['N0_min_hi'] = d.N0_min.min(), d.N0_min.max()
    return r
R = [row(2, 'null', 'gate/null.csv', 0), row(2, 'effect', 'gate/effect.csv', .5),
     row(2, 'pretrend', 'gate/pretrend.csv', 0), row(2, 'stress', 'gate/stress.csv', 0),
     row(3, 'effect_nosupp', 'gate/diag_effect_nosupp.csv', .5)]
R += [row(3, s + '_rescored05', f'gate/{s}.csv', t, True) for s, t in [('null', 0), ('effect', .5), ('pretrend', 0), ('stress', 0)]]
for s, t in [('null', 0), ('effect', .5), ('effect_nosupp', .5), ('pretrend', 0), ('stress', 0)]:
    for o in ['sigmaon', 'sigmaoff']: R.append(row(4, f'{s}_{o}', f'gate_v3/{s}_{o}.csv', t))
R += [row('power', f'tau{t}', f'power/tau{t}.csv', t) for t in [0.1, 0.2, 0.3, 0.4]]
pd.DataFrame(R).to_csv('paper/note_tables.csv', index=False, float_format='%.6g')
