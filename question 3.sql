WITH price_history AS (
    SELECT
        category_code,
        year AS price_year, avg_price
    FROM t_filip_krikava_project_SQL_primary_final
    WHERE avg_price IS NOT NULL
),
annual_growth AS (
    SELECT
        category_code,
        price_year,
        avg_price,
        LAG(avg_price) OVER (PARTITION BY category_code ORDER BY price_year) AS prev_price,
        ROUND(CAST((avg_price - LAG(avg_price) OVER (PARTITION BY category_code ORDER BY price_year)) /
             LAG(avg_price) OVER (PARTITION BY category_code ORDER BY price_year) * 100 AS numeric), 1
        ) AS yoy_growth
    FROM price_history
),
category_stats AS (
    SELECT
        category_code,
        AVG(yoy_growth) AS avg_annual_growth
    FROM annual_growth
    WHERE yoy_growth IS NOT NULL
    GROUP BY category_code
)
SELECT
    cpc.name AS food_category,
    ROUND(CAST(cs.avg_annual_growth AS numeric), 2) AS avg_annual_growth
FROM category_stats cs
JOIN czechia_price_category cpc
    ON cs.category_code = cpc.code
ORDER BY cs.avg_annual_growth
LIMIT 1;