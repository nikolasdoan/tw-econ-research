# Deviations from the pre-registration

Every change or disclosure after the pre-registration merge (a743f88, 2026-10-31T01:34:00Z) is logged here, with its
date, its reason and whether any outcome data had been seen. Results under the original plan are still reported.

---
## D1. Pre-commit exposure of whole-window export totals (disclosed)

- Entry written: 2026-10-31. Event: before the pre-registration merge (a743f88, 2026-10-31T01:34:00Z).
- What was exposed: while building the one-off export, the M1 posted three whole-window totals, on bizmap #205 and in the export tarball's MANIFEST:
  1. 1,732,175 sales in prices.csv;
  2. 680,654 registrations, 2011Q1–2026Q3;
  3. the number of cells marked <3 in each file.
- Not exposed: no figure by 村里, quarter, station, line, district or distance ring.
- Who saw it: the cloud manager. The research manager, its subagents and the referee did not see these totals before the merge. The research manager learned of them on 2026-10-31 from this disclosure, after the merge.
- Effect on the registered plan: none. The totals are sums over all places and all quarters, so they carry no information about the difference between treated and comparison 村里 or about timing around any opening. No choice in v2.1 was made or changed after they existed. The share of <3 cells bears only on the small-cell rule, and that rule (§4: 1.5 or 1, with both ends in R16) was fixed in v2.1 before any count was known.
- Action: none to the plan. The disclosure is recorded here and will be stated in the working paper's data section.
