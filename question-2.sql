WITH salary_data AS (
    SELECT
        payroll_year,
        AVG(value) AS avg_salary
    FROM czechia_payroll
    WHERE value_type_code = 5958
        AND calculation_code = 200
        AND payroll_year IN (2006, 2018)
        AND industry_branch_code IS NULL
    GROUP BY payroll_year
),
food_prices AS (
    SELECT
        EXTRACT(YEAR FROM date_from) AS price_year,
        category_code,
        AVG(value) AS avg_price
    FROM czechia_price
    WHERE category_code IN (111301, 114201)
        AND EXTRACT(YEAR FROM date_from) IN (2006, 2018)
    GROUP BY price_year, category_code
)
SELECT
    s.payroll_year,
    ROUND(CAST(s.avg_salary / MAX(CASE WHEN f.category_code = 111301 THEN f.avg_price END) AS numeric), 1) AS bread_kg,
    ROUND(CAST(s.avg_salary / MAX(CASE WHEN f.category_code = 114201 THEN f.avg_price END) AS numeric), 1) AS milk_liters
FROM salary_data s
JOIN food_prices f ON s.payroll_year = f.price_year
GROUP BY s.payroll_year, s.avg_salary
ORDER BY s.payroll_year;