-- G3: Does winning the toss win the match -- and does the toss DECISION matter more than the toss itself?
SELECT
    'All toss winners' AS group_label,
    COUNT(*) AS n_matches,
    ROUND(100.0 * SUM(CASE WHEN toss_winner = match_winner THEN 1 ELSE 0 END) / COUNT(*), 1) AS win_rate_pct
FROM matches WHERE result = 'win'
UNION ALL
SELECT
    'Toss winner chose to BAT' AS group_label,
    COUNT(*) AS n_matches,
    ROUND(100.0 * SUM(CASE WHEN toss_winner = match_winner THEN 1 ELSE 0 END) / COUNT(*), 1) AS win_rate_pct
FROM matches WHERE result = 'win' AND toss_decision = 'bat'
UNION ALL
SELECT
    'Toss winner chose to FIELD' AS group_label,
    COUNT(*) AS n_matches,
    ROUND(100.0 * SUM(CASE WHEN toss_winner = match_winner THEN 1 ELSE 0 END) / COUNT(*), 1) AS win_rate_pct
FROM matches WHERE result = 'win' AND toss_decision = 'field';
