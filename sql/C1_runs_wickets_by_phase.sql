-- C1: How do run scoring and wicket-taking change across the three phases of an innings?
SELECT
    CASE
        WHEN over_number <= 5  THEN 'Powerplay (overs 1-6)'
        WHEN over_number <= 14 THEN 'Middle Overs (overs 7-15)'
        ELSE 'Death (overs 16-20)'
    END AS phase,
    SUM(total_runs) AS total_runs,
    COUNT(*) AS balls_bowled,
    SUM(is_wicket) AS wickets,
    ROUND(SUM(total_runs) * 6.0 / COUNT(*), 2) AS runs_per_over,
    ROUND(100.0 * SUM(is_wicket) / COUNT(*), 2) AS wickets_per_100_balls
FROM deliveries
GROUP BY phase;
