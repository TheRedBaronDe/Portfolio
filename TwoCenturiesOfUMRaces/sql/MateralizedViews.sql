CREATE MATERIALIZED VIEW mv_events_by_year AS
SELECT
    year_of_event,
    COUNT(*) AS total_events
FROM public."TwoCenturiesOfUMRaces"
GROUP BY year_of_event;

CREATE MATERIALIZED VIEW mv_events_by_country AS
SELECT
    athlete_country,
    COUNT(*) AS total_events
FROM public."TwoCenturiesOfUMRaces"
GROUP BY athlete_country;

CREATE MATERIALIZED VIEW mv_athletes_age_distribution AS
SELECT
    athlete_age_category,
    COUNT(*) AS total_athletes
FROM public."TwoCenturiesOfUMRaces"
WHERE athlete_age_category IS NOT NULL
GROUP BY athlete_age_category;

CREATE MATERIALIZED VIEW mv_distance_distribution AS
SELECT
     event_distance_length,
    COUNT(*) AS total_races
FROM public."TwoCenturiesOfUMRaces"
GROUP BY  event_distance_length;
