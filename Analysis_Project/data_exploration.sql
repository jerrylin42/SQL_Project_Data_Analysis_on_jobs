--This section is primarily focused on exploring the data and some basic questions.

--Viewing the data

SELECT * FROM job_postings_fact
LIMIT 50;

SELECT * FROM skills_dim
LIMIT 50;

SELECT * FROM company_dim
LIMIT 50;

SELECT * FROM skills_job_dim
LIMIT 50;


--Total job postings, skills, companies listed
SELECT COUNT(*) FROM job_postings_fact AS total_postings;
SELECT COUNT(*) FROM skills_dim AS number_of_skills;
SELECT COUNT(*) FROM company_dim AS number_of_companies;


--How many unique job locations are represented here?
SELECT COUNT(DISTINCT job_location) FROM job_postings_fact AS unique_locations;

--What data job categories are being represented here?
SELECT DISTINCT job_title_short FROM job_postings_fact;

--From where (websites, apps) are these postings being located and how many listngs are associated with each?
SELECT job_via, COUNT(*) as postingscount FROM job_postings_fact 
GROUP BY job_via
ORDER BY postingscount DESC;

