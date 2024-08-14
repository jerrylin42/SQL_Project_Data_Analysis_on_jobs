/*
Which cities in NC has the highest demand for data roles?
*/

SELECT
    job_location,
    COUNT(*) as job_count,
    ROUND(AVG(salary_year_avg), 2) as yearly_salary,
    ROUND(AVG(salary_hour_avg), 2) as hourly_salary
FROM job_postings_fact
WHERE 
    job_location LIKE '%, NC'
GROUP BY job_location
ORDER BY job_count DESC
LIMIT 25;