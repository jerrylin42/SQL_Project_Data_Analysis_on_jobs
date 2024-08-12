/*
Which quarter had the most amount of job postings for internships in the USA?
*/


SELECT 
    CASE
        WHEN EXTRACT(MONTH from job_posted_date) IN (1,2,3) THEN 'Q1: Jan, Feb, Mar'
        WHEN EXTRACT(MONTH from job_posted_date) IN (4,5,6) THEN 'Q2: Apr, May, Jun'
        WHEN EXTRACT(MONTH from job_posted_date) IN (7,8,9) THEN 'Q3: Jul, Aug, Sept'
        WHEN EXTRACT(MONTH from job_posted_date) IN (10,11,12) THEN 'Q4: Oct, Nov, Dec'
        ELSE 'NA'
    END AS annual_quarter,
    COUNT(*) AS internship_count
    FROM job_postings_fact
    WHERE job_schedule_type = 'Internship' AND job_country = 'United States'
    GROUP BY annual_quarter;
