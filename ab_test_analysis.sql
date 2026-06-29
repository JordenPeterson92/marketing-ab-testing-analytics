-- Table creation
CREATE TABLE marketing_ab_test (
    user_id INT PRIMARY KEY,
    test_group VARCHAR(10),
    converted INT,
    total_ads INT,
    most_ads_day VARCHAR(15),
    most_ads_hour INT
);

-- Data cleaning and exploration
-- Check for duplicate user IDs
SELECT user_id, COUNT(*) 
FROM marketing_ab_test
GROUP BY user_id
HAVING COUNT(*) > 1;

-- Check for NULL values across all columns
SELECT 
    COUNT(CASE WHEN user_id IS NULL THEN 1 END) AS null_users,
    COUNT(CASE WHEN test_group IS NULL THEN 1 END) AS null_groups,
    COUNT(CASE WHEN converted IS NULL THEN 1 END) AS null_conversions,
    COUNT(CASE WHEN total_ads IS NULL THEN 1 END) AS null_ads,
    COUNT(CASE WHEN most_ads_day IS NULL THEN 1 END) AS null_days,
    COUNT(CASE WHEN most_ads_hour IS NULL THEN 1 END) AS null_hours
FROM marketing_ab_test;

-- Check for group overlap or data leakage
SELECT COUNT(*) AS contaminated_users
FROM (
    SELECT user_id
    FROM marketing_ab_test
    GROUP BY user_id
    HAVING COUNT(DISTINCT test_group) > 1
) sub;

-- Check for logical anomalies or impossible data values
SELECT 
    COUNT(CASE WHEN total_ads <= 0 THEN 1 END) AS zero_or_negative_ads,
    COUNT(CASE WHEN converted = 1 AND total_ads = 0 THEN 1 END) AS converted_with_zero_ads,
    COUNT(CASE WHEN most_ads_hour < 0 OR most_ads_hour > 23 THEN 1 END) AS invalid_hours
FROM marketing_ab_test;

-- Audit categorical values and check data distributions
SELECT 
    'test_group' AS column_checked, 
    test_group AS distinct_value, 
    COUNT(*) AS row_count
FROM marketing_ab_test
GROUP BY test_group
UNION ALL
SELECT 
    'converted' AS column_checked, 
    converted::TEXT AS distinct_value, 
    COUNT(*) AS row_count
FROM marketing_ab_test
GROUP BY converted;

-- Check row counts by hour to inspect daily distribution
SELECT 
    most_ads_hour, 
    COUNT(*) AS user_count
FROM marketing_ab_test
GROUP BY most_ads_hour
ORDER BY most_ads_hour ASC;

-- Business metrics analysis
-- Overall A/B test baseline conversion rates
SELECT 
    test_group,
    COUNT(user_id) AS total_users,
    SUM(converted) AS total_conversions,
    ROUND((SUM(converted)::NUMERIC / COUNT(user_id)) * 100, 2) AS conversion_rate_pct
FROM marketing_ab_test
GROUP BY test_group;

-- Ad frequency volume versus conversion rates
SELECT 
    CASE 
        WHEN total_ads BETWEEN 1 AND 5 THEN '1-5 Ads (Low)'
        WHEN total_ads BETWEEN 6 AND 15 THEN '6-15 Ads (Medium)'
        WHEN total_ads BETWEEN 16 AND 30 THEN '16-30 Ads (High)'
        ELSE '31+ Ads (Extreme)'
    END AS exposure_bucket,
    COUNT(user_id) AS total_users,
    ROUND((SUM(converted)::NUMERIC / COUNT(user_id)) * 100, 2) AS conversion_rate_pct
FROM marketing_ab_test
GROUP BY 1
ORDER BY MIN(total_ads);

-- Conversion rates by day of the week
SELECT 
    most_ads_day,
    COUNT(user_id) AS total_users,
    ROUND((SUM(converted)::NUMERIC / COUNT(user_id)) * 100, 2) AS conversion_rate_pct
FROM marketing_ab_test
GROUP BY most_ads_day
ORDER BY conversion_rate_pct DESC;

