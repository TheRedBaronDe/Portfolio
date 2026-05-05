/* Project: COVID-19 Monthly Hospitalization Rates - Kaggle Dataset
Tools: pgAdmin 4
Author: Victoria Silva (TheRedBaronDe)
*/

-- Show first 20 rows
SELECT * FROM public."COVID19" LIMIT 20

-- Q1. What are the most affect groups?
WITH combined AS (

    -- Age
    SELECT 
        'age' AS dimension,
        age_category AS category,
        ROUND(AVG(monthly_rate::numeric), 2) AS avg_rate
    FROM public."COVID19"
    WHERE age_category != 'All'
      AND sex = 'All'
      AND race = 'All'
    GROUP BY age_category

    UNION ALL

    -- Sex
    SELECT 
        'sex' AS dimension,
        sex AS category,
        ROUND(AVG(monthly_rate::numeric), 2) AS avg_rate
    FROM public."COVID19"
    WHERE sex != 'All'
      AND age_category = 'All'
      AND race = 'All'
    GROUP BY sex

    UNION ALL

    -- Race
    SELECT 
        'race' AS dimension,
        race AS category,
        ROUND(AVG(monthly_rate::numeric), 2) AS avg_rate
    FROM public."COVID19"
    WHERE race != 'All'
      AND age_category = 'All'
      AND sex = 'All'
    GROUP BY race
)

SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY dimension ORDER BY avg_rate DESC) AS rank
    FROM combined
) ranked
WHERE rank <= 3

-- Q2. Which states are the most affected?
SELECT "state", ROUND(AVG(monthly_rate::numeric), 2) as avg_rate
FROM public."COVID19"
WHERE "state" != 'All'
GROUP BY "state"
ORDER BY avg_rate DESC

-- Q3. Which seasons have the highest positive rates?
SELECT season, ROUND(AVG(monthly_rate::numeric), 2 ) as avg_rate
FROM public."COVID19"
WHERE season != 'All'
GROUP BY season
ORDER BY avg_rate DESC
