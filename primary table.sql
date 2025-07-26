DROP TABLE IF EXISTS t_filip_krikava_project_SQL_primary_final;

CREATE TABLE t_filip_krikava_project_SQL_primary_final AS
WITH salaries AS (
   SELECT 
       payroll_year AS year,
       industry_branch_code,
       AVG(value) AS avg_salary
   FROM czechia_payroll
   WHERE calculation_code = 200 
       AND value_type_code = 5958 
       AND payroll_year BETWEEN 2000 AND 2020
   GROUP BY payroll_year, industry_branch_code
),
prices AS (
   SELECT 
       EXTRACT(YEAR FROM date_from) AS year,
       category_code,
       AVG(value) AS avg_price
   FROM czechia_price
   WHERE EXTRACT(YEAR FROM date_from) BETWEEN 2006 AND 2018
   GROUP BY EXTRACT(YEAR FROM date_from), category_code
)
SELECT
    s.year,
    s.industry_branch_code,
    s.avg_salary,
    p.category_code,
    p.avg_price
FROM salaries s
LEFT JOIN prices p
    ON s.year = p.year;