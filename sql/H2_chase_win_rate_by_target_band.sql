-- H2: Does chase success change by target band?
-- Step 1: first-innings total per match -> becomes the chase target (+1)
WITH inn1 AS (
    SELECT match_id, SUM(total_runs) AS inn1_runs
    FROM deliveries
    WHERE innings = 1
    GROUP BY match_id
),
decisive AS (
    -- only matches with a clear win (drop ties / no-result so "chase won" is unambiguous)
    SELECT m.match_id, m.win_by_wickets, inn1.inn1_runs + 1 AS target
    FROM matches m
    JOIN inn1 ON inn1.match_id = m.match_id
    WHERE m.result = 'win'
)
SELECT
    CASE
        WHEN target < 140 THEN '<140'
        WHEN target < 160 THEN '140-159'
        WHEN target < 180 THEN '160-179'
        WHEN target < 200 THEN '180-199'
        ELSE '200+'
    END AS target_band,
    COUNT(*) AS n_matches,
    ROUND(100.0 * SUM(CASE WHEN win_by_wickets > 0 THEN 1 ELSE 0 END) / COUNT(*), 1) AS chase_win_rate_pct
FROM decisive
GROUP BY target_band;
