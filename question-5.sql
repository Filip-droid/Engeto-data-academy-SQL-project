WITH gdp AS (
    SELECT 
        year,
        ROUND(CAST((GDP - LAG(GDP) OVER (ORDER BY year)) / 
             LAG(GDP) OVER (ORDER BY year) * 100 AS NUMERIC), 2) AS gdp_growth
    FROM economies
    WHERE country = 'Czech Republic' AND year BETWEEN 2006 AND 2018
),
wages AS (
    SELECT
        payroll_year AS year,
        ROUND(CAST((AVG(value) - LAG(AVG(value)) OVER (ORDER BY payroll_year)) / 
             LAG(AVG(value)) OVER (ORDER BY payroll_year) * 100 AS NUMERIC), 2) AS wage_growth
    FROM czechia_payroll
    WHERE value_type_code = 5958
        AND calculation_code = 200
        AND industry_branch_code IS NULL
        AND payroll_year BETWEEN 2006 AND 2018
    GROUP BY payroll_year
),
prices AS (
    SELECT
        year,
        ROUND(CAST((avg_price - LAG(avg_price) OVER (ORDER BY year)) / 
             LAG(avg_price) OVER (ORDER BY year) * 100 AS NUMERIC), 2) AS price_growth
    FROM (
        SELECT
            EXTRACT(YEAR FROM date_from) AS year,
            AVG(value) AS avg_price
        FROM czechia_price
        WHERE EXTRACT(YEAR FROM date_from) BETWEEN 2006 AND 2018
        GROUP BY EXTRACT(YEAR FROM date_from)
    ) sub
)
SELECT
    g.year,
    g.gdp_growth,
    w.wage_growth AS same_year_wage,
    p.price_growth AS same_year_price,
    w_next.wage_growth AS next_year_wage,
    p_next.price_growth AS next_year_price
FROM gdp g
JOIN wages w ON g.year = w.year
JOIN prices p ON g.year = p.year
LEFT JOIN wages w_next ON g.year = w_next.year - 1
LEFT JOIN prices p_next ON g.year = p_next.year - 1;