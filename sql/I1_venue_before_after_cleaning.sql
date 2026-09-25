-- I1: The raw venue column splits the same ground into several spellings.
-- "Before" -- raw venue as stored (top grounds by raw match count)
SELECT venue AS venue_raw, COUNT(*) AS matches
FROM matches
GROUP BY venue
ORDER BY matches DESC
LIMIT 8;

-- "After" -- cleaned venue. Cleaning rule: drop everything after the first comma
-- (city/suburb tags such as ", Chennai" or ", Bengaluru"), turn "." into a space
-- (fixes "M.Chinnaswamy" vs "M Chinnaswamy"), and collapse repeated whitespace.
-- Validated against the dataset README, which states this project version has
-- 41 distinct cleaned venues.
-- venue_clean is computed in pandas (see notebook) since SQLite has no regex/replace
-- chain built in for this; the equivalent logic is:
--   venue_clean = venue.split(',')[0].replace('.', ' ').split() joined by single spaces
