/*
Grouping by job location, what is:
-number of postings for analyst roles for each location
-the average salary of analyst roles (IGNORE NULL ROWS)
Limiting to the top 100 for each query. 
 */


SELECT 
    job_location,
    COUNT(*) as counts
FROM job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
    OR job_title_short = 'Senior Data Analyst'
    OR job_title_short = 'Business Analyst'
GROUP BY job_location
ORDER BY counts DESC
LIMIT 100;




SELECT
    job_location,
    ROUND(AVG(salary_year_avg), 2) as averages
FROM job_postings_fact 
WHERE 
    salary_year_avg IS NOT NULL
    AND (job_title_short = 'Data Analyst'
    OR job_title_short = 'Senior Data Analyst'
    OR job_title_short = 'Business Analyst')
GROUP BY job_location
ORDER BY averages DESC
LIMIT 100;



