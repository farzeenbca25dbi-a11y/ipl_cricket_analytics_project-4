# IPL Cricket Analytics — Project 4

Part 4 deliverable: five decision-focused charts and a complete Analysis Report, built from the
real IPL ball-by-ball dataset (2008–2026, 1,212 matches, 288,226 deliveries).

## Structure

```
notebooks/03_analysis.ipynb     Executed notebook: SQL -> pandas -> matplotlib for all 5 charts
reports/analysis_report.md      Five-field write-up (Question/Number/Population/Decision/Doubt)
reports/figures/                The 5 saved chart PNGs
sql/                            The exact SQL query behind each finding
```

## Charts

| File | Scenario | Finding |
|---|---|---|
| `chase_win_rate_target_band.png` | H2 | Chase win rate falls from 81.0% (target <140) to 24.2% (target 200+) |
| `runs_wickets_by_phase.png` | C1 | Runs/over and wickets/100 balls both rise sharply in the death overs |
| `toss_split.png` | G3 | Toss winners who chose to field won 54.6% vs. 45.8% who chose to bat |
| `venue_before_after.png` | I1 | 59 raw venue spellings clean down to 41 true venues |
| `death_overs_strike_rate.png` | Specialism (Batting) | Death-overs strike-rate leaders, min. 60 balls faced |

## Running the notebook

The notebook expects `ipl.db` (the SQLite database) one level up from `notebooks/`, i.e. at the
project root. The database is not committed to this repo (kept out via `.gitignore` — see note
below); download it from the original dataset source and place it at the project root before
re-running the notebook.

## Data source

"IPL Dataset 2008 to 2026" (Kaggle, author Abhishek Marathe), compiled from Cricsheet
(https://cricsheet.org). Licence CC BY-SA 4.0.
