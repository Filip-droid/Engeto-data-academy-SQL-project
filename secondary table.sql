DROP TABLE IF EXISTS t_filip_krikava_project_SQL_secondary_final;

CREATE TABLE t_filip_krikava_project_SQL_secondary_final AS
SELECT 
    c.country,
    e.year,
    e.GDP,
    e.gini,
    e.population
FROM economies e
JOIN countries c ON e.country = c.country
WHERE c.continent = 'Europe'
    AND c.country != 'Czech Republic'
    AND e.year BETWEEN 2006 AND 2018
ORDER BY c.country, e.year;