/*
Below counts for remote, local, and onsite.
whats interesting here is that group_by runs before everything else
so it technically shouldnt work with the locat_cat alias, but postgres
allows this actually
*/

    SELECT COUNT(*),
        CASE
            WHEN job_location = 'Anywhere' THEN 'Remote'
            WHEN job_location = 'New York, NY' THEN 'Local'
            ELSE 'Onsite'
        END AS location_category
    FROM job_postings_fact
    WHERE job_title_short = 'Data Analyst'
    GROUP BY location_category; --here



/*
uses CTE to create temporary table with company ID+counts, then combines 
company data table to add the names.

*/
WITH company_job_count AS (
    SELECT company_id, COUNT(*) AS total_jobs FROM job_postings_fact
    GROUP BY company_id)
SELECT company_job_count.company_id, 
    company_dim.name, 
    company_job_count.total_jobs
FROM company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs DESC;


/*
count num of data analyst job postings by skill */

WITH remotejobskills AS (
SELECT 
    skill_id,
    COUNT(job_postings_fact.job_id) AS job_count
FROM skills_job_dim
INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
WHERE job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY skill_id
)
SELECT 
    remotejobskills.skill_id,
    skills,
    type,
    job_count
FROM remotejobskills
INNER JOIN skills_dim ON skills_dim.skill_id = remotejobskills.skill_id
ORDER BY job_count DESC