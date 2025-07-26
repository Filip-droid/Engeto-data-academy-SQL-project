WITH wage_growth AS (
    SELECT
        payroll_year AS year,
        AVG(value) AS avg_salary,
        LAG(AVG(value)) OVER (ORDER BY payroll_year) AS prev_salary,
        ROUND(CAST((AVG(value) - LAG(AVG(value)) OVER (ORDER BY payroll_year)) /
             LAG(AVG(value)) OVER (ORDER BY payroll_year) * 100 AS numeric), 1
        ) AS wage_growth_pct
    FROM czechia_payroll
    WHERE value_type_code = 5958
        AND calculation_code = 200
        AND industry_branch_code IS NULL
        AND payroll_year BETWEEN 2006 AND 2018
    GROUP BY payroll_year
),
price_growth AS (
    SELECT
        year,
        AVG(avg_price) AS avg_price_index,
        LAG(AVG(avg_price)) OVER (ORDER BY year) AS prev_price_index,
        ROUND(CAST((AVG(avg_price) - LAG(AVG(avg_price)) OVER (ORDER BY year)) /
             LAG(AVG(avg_price)) OVER (ORDER BY year) * 100 AS numeric), 1
        ) AS price_growth_pct
    FROM (
        SELECT
            year,
            category_code,
            avg_price
        FROM t_filip_krikava_project_SQL_primary_final
        WHERE avg_price IS NOT NULL
    ) AS category_prices
    GROUP BY year
)
SELECT
    wg.year,
    wg.wage_growth_pct,
    pg.price_growth_pct,
    ROUND(CAST(pg.price_growth_pct - wg.wage_growth_pct AS numeric), 1) AS differential
FROM wage_growth wg
JOIN price_growth pg
    ON wg.year = pg.year
WHERE pg.price_growth_pct - wg.wage_growth_pct > 10;