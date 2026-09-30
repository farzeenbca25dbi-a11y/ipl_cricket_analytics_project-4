# IPL Cricket Analytics — Statistical Report

**Step 4.15 deliverable** — the three findings I was least confident about in `report_analysis.md`,
each turned into a precise statistical question, tested, and given a plain-English verdict.
Source basis: `Step 4.15 — Test Your Three Findings` student guide.

All tests run against the real dataset (1,212 matches, 288,226 deliveries) using `ipl.db`.

Of the three findings tested, **two survived** (toss decision, and AB de Villiers' death-overs
strike rate) and **one did not** (venue affecting chase outcome).

---

### Test 1: Toss decision and win rate

**Finding:** Toss winners who chose to field won more often (54.6%) than toss winners who chose to
bat (45.8%).

**Statistical question:** Is there a significant association between the toss winner's decision
(bat vs. field) and whether the toss winner went on to win the match?

**Null hypothesis:** H₀ — The toss winner's win/loss outcome is independent of their toss decision
(bat vs. field); there is no association between the two.

**Test:** Chi-square test of independence (2×2 contingency table: decision × outcome).

```python
import pandas as pd
from scipy.stats import chi2_contingency

table = pd.crosstab(mt["toss_decision"], mt["toss_winner_won"])
chi2, p, dof, expected = chi2_contingency(table)
n = table.values.sum()
phi = (chi2 / n) ** 0.5   # effect size for a 2x2 table
```

**Sample size:** n = 1,187 decisive matches (402 chose bat, 785 chose field).

**p-value:** 0.0046

**Effect size:** φ (phi coefficient) = 0.082 — below Cohen's "small" threshold (0.10).

**Verdict:** The test provides evidence of a real association between the toss decision and the
outcome (p = 0.0046), but the effect size (φ = 0.082) is very small — the toss decision moves the
odds of winning only slightly. The pattern is statistically real but should not be oversold as a
strong lever; a captain who fields first is not dramatically favoured, just marginally so, once
1,187 matches' worth of noise is accounted for.

---

### Test 2: Venue and chase outcome

**Finding:** *(Reframed from the original venue-cleaning doubt.)* The H2 chase-win-rate-by-target
finding pools every venue together — the underlying worry was that some grounds might make chasing
systematically easier or harder, which would mean the pooled H2 trend is partly a venue effect
rather than a pure "bigger target = harder chase" effect.

**Statistical question:** Is there a significant association between venue and whether the chasing
team won the match?

**Null hypothesis:** H₀ — The chase win/loss outcome is independent of venue; chase win rate does
not differ meaningfully across grounds.

**Test:** Chi-square test of independence (venue × chase outcome), restricted to the 13 cleaned
venues with at least 30 matches, so no cell is built on a handful of games.

```python
import pandas as pd
from scipy.stats import chi2_contingency

table = pd.crosstab(m2f["venue_clean"], m2f["chase_won"])
chi2, p, dof, expected = chi2_contingency(table)
n = table.values.sum()
k = min(table.shape)
cramers_v = ((chi2 / n) / (k - 1)) ** 0.5
```

**Sample size:** n = 860 matches across 13 venues (each with ≥30 matches).

**p-value:** 0.7955

**Effect size:** Cramér's V = 0.096 — negligible.

**Verdict:** The test did not provide enough evidence of a difference in chase win rate across
venues (p = 0.7955), and the observed effect was negligible (Cramér's V = 0.096) based on
n = 860. This is a useful negative result: it means the H2 "chasing gets harder as the target
rises" finding is **not** simply an artifact of a few chase-friendly grounds dominating the pooled
sample — venue does not appear to be a meaningful confounder here. It does not resolve the separate,
narrower doubt about whether a couple of venue names still need manual merging (e.g. Punjab Cricket
Association Stadium naming) — that remains a data-cleaning question, not a statistical one.

---

### Test 3: AB de Villiers' death-overs strike rate vs. the rest of the qualifying pool

**Finding:** Among batters with at least 60 balls faced in the death overs (16–20), AB de Villiers
ranked 2nd by strike rate (222.9) — but on a genuinely large sample (838 balls), unlike most names
near the top of that list, which qualify on only just over the 60-ball minimum.

**Statistical question:** Is the runs-per-ball AB de Villiers scores in the death overs
significantly different from the runs-per-ball scored by the rest of the qualifying pool?

**Null hypothesis:** H₀ — The distribution of runs scored per ball in the death overs is the same
for AB de Villiers as for the rest of the qualifying batters (no difference in central tendency).

**Test:** Mann–Whitney U test (non-parametric — appropriate here because per-ball runs are a
heavily skewed, discrete outcome: mostly 0s and 1s with occasional 4s and 6es, not a normal
distribution).

```python
from scipy.stats import mannwhitneyu

U, p = mannwhitneyu(abd_runs_per_ball, rest_runs_per_ball, alternative="two-sided")
n1, n2 = len(abd_runs_per_ball), len(rest_runs_per_ball)
rank_biserial = 1 - (2 * U) / (n1 * n2)
```

**Sample size:** n₁ = 838 balls (AB de Villiers), n₂ = 53,877 balls (rest of the qualifying pool).

**p-value:** 6.69 × 10⁻¹⁹ (Python initially printed `0.0` — reran with scientific notation per the
guide's warning that a printed zero is usually just a very small rounded number.)

**Effect size:** rank-biserial r ≈ 0.17 in magnitude — a small-to-moderate effect by Cohen's
conventions (0.1 small, 0.3 medium). Concretely: AB de Villiers averaged 2.23 runs per ball faced
in the death overs vs. 1.61 for the rest of the qualifying pool — about 38% higher.

**Verdict:** The test provides strong evidence that AB de Villiers' death-overs scoring rate is
different from the rest of the qualifying pool (p ≈ 6.7 × 10⁻¹⁹), with a small-to-moderate effect
size (rank-biserial r ≈ 0.17) based on n₁ = 838 and n₂ = 53,877. The extremely small p-value is a
function of the very large sample, not proof of a huge effect — the effect size is the number that
actually tells us how much better he was. This addresses the original doubt directly: at least for
AB de Villiers specifically, the finding survives testing and is not just a small-sample fluke. The
same cannot automatically be claimed for the other batters on that top-8 list (e.g. R Shepherd,
n = 75), whose smaller samples were not individually tested here.

**Alternative explanation:** AB de Villiers played the bulk of his IPL career for Royal Challengers
Bangalore, whose home ground (M Chinnaswamy Stadium) is one of the highest-scoring venues in the
dataset. Some of this effect could be venue-assisted scoring rather than pure individual skill —
Test 2 above suggests venue doesn't move chase outcomes much, but it doesn't rule out venue moving
raw scoring rate, which is a different question this report doesn't test.

---

## Six-move worksheet summary

| Item | Test 1 — Toss decision | Test 2 — Venue vs chase | Test 3 — AB de Villiers SR |
|---|---|---|---|
| Finding | Fielding first wins more (54.6% vs 45.8%) | H2 pools all venues together | AB de Villiers ranks 2nd in death-overs SR |
| Statistical question | Is decision associated with win/loss? | Is venue associated with chase outcome? | Is his runs/ball different from the pool? |
| Null hypothesis | No association | No association | No difference in distribution |
| Test selected | Chi-square (2×2) | Chi-square (13×2) | Mann–Whitney U |
| p-value | 0.0046 | 0.7955 | 6.69 × 10⁻¹⁹ |
| Effect size | φ = 0.082 | Cramér's V = 0.096 | rank-biserial r ≈ 0.17 |
| Sample size (n) | 1,187 | 860 | 838 vs 53,877 |
| Verdict | Real but very small effect | **Did not survive** — no evidence | Real, small-moderate effect |
| Alternative explanation | — | — | Home-venue scoring conditions |

---

*Of the findings I tested, these survived: Test 1 (toss decision) and Test 3 (AB de Villiers'
death-overs strike rate). This one did not: Test 2 (venue as a driver of chase outcome) — which is
good news for H2's validity, since it means venue isn't secretly driving that pooled result.*
