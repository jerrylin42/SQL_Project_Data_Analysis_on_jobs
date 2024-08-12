/*
Grouping by company, finding these values for analysts:
-total jobs 
-average salary (if available)
-highest salary (if available)
-lowest salary (if available)

--Order by job counts;
note that in the total_jobs col, not every entry counted has a yearly
salary associated with it. But the avg_salary column only calculates based on entries WITH a
salary associated to it. 

This is why, for example, S&P Global has 401 postings but avg salary, min, and max are all
the same value. Likely because only 1 entry out of those 401 has a salary listed. 
*/



SELECT
    company_dim.name, 
    COUNT(*) as total_jobs,
    ROUND(AVG(salary_year_avg), 2) as avg_salary,
    ROUND(MAX(salary_year_avg), 2) as highest_salary_posting,
    ROUND(MIN(salary_year_avg), 2) as lowest_salary_posting
FROM company_dim
LEFT JOIN job_postings_fact ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst'
    OR job_title_short = 'Senior Data Analyst'
    OR job_title_short = 'Business Analyst'
GROUP BY company_dim.name
ORDER BY total_jobs DESC;

