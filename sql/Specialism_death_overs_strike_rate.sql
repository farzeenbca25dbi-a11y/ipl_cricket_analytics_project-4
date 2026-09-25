-- Specialism (Batting): Who actually finishes an innings? Strike rate in the death
-- overs (16-20), restricted to batters with a real sample (>= 60 legal balls faced)
-- so a two-innings hot streak can't outrank a genuine finisher.
SELECT
    batter,
    COUNT(*) AS balls_faced,
    SUM(batter_runs) AS runs,
    ROUND(100.0 * SUM(batter_runs) / COUNT(*), 1) AS strike_rate
FROM deliveries
WHERE over_number >= 15
  AND is_wide_ball = 0
GROUP BY batter
HAVING COUNT(*) >= 60
ORDER BY strike_rate DESC
LIMIT 10;
