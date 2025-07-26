WITH salaries_2000 AS (
   SELECT industry_branch_code, AVG(avg_salary) AS avg_salary_2000
   FROM t_filip_krikava_project_SQL_primary_final
   WHERE year = 2000
   GROUP BY industry_branch_code
),
salaries_2020 AS (
   SELECT industry_branch_code, AVG(avg_salary) AS avg_salary_2020
   FROM t_filip_krikava_project_SQL_primary_final
   WHERE year = 2020
   GROUP BY industry_branch_code
)
SELECT 
    s00.industry_branch_code,
    cpib.name AS industry_name,
    s00.avg_salary_2000,
    s20.avg_salary_2020,
    ROUND(CAST((s20.avg_salary_2020 - s00.avg_salary_2000) / s00.avg_salary_2000 * 100 AS numeric), 1) AS growth_percent
FROM salaries_2000 s00
JOIN salaries_2020 s20 ON s00.industry_branch_code = s20.industry_branch_code
LEFT JOIN czechia_payroll_industry_branch cpib 
    ON cpib.code = s00.industry_branch_code
ORDER BY growth_percent DESC;


WITH AnnualSalaryChanges AS (
    SELECT
        tpf.industry_branch_code,
        cpib.name AS industry_name,
        tpf.year,
        tpf.avg_salary,
        LAG(tpf.avg_salary) OVER (PARTITION BY tpf.industry_branch_code ORDER BY tpf.year) AS prev_year_salary,
        ROUND(CAST((tpf.avg_salary - LAG(tpf.avg_salary) OVER (PARTITION BY tpf.industry_branch_code ORDER BY tpf.year)) * 100.0 / LAG(tpf.avg_salary) OVER (PARTITION BY tpf.industry_branch_code ORDER BY tpf.year) AS numeric), 2) AS yoy_growth_percent
    FROM
        t_filip_krikava_project_SQL_primary_final tpf
    LEFT JOIN
        czechia_payroll_industry_branch cpib ON tpf.industry_branch_code = cpib.code
    WHERE
        tpf.industry_branch_code IS NOT NULL
        AND tpf.avg_salary IS NOT NULL
)
SELECT
    industry_name,
    COUNT(CASE WHEN yoy_growth_percent < 0 THEN 1 ELSE NULL END) AS number_of_decline_years,
    COUNT(CASE WHEN yoy_growth_percent >= 0 THEN 1 ELSE NULL END) AS number_of_increase_or_nochange_years,
    MIN(yoy_growth_percent) AS largest_decline_percent,
    MAX(yoy_growth_percent) AS largest_increase_percent
FROM
    AnnualSalaryChanges
WHERE yoy_growth_percent IS NOT NULL
GROUP BY
    industry_name
ORDER BY
    number_of_decline_years DESC, industry_name;