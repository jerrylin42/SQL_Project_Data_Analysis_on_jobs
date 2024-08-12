/*
Ranking the top 10 most popular skills for each job type and putting the results
into a table
*/


WITH top10_analyst_skills AS (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY skill_count DESC) AS ranknumber,
        skills AS analyst_skills, 
        skill_count 
    FROM 
    (
    SELECT 
        skills,
        COUNT(*) AS skill_count
    FROM skills_job_dim
    INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        OR job_title_short = 'Senior Data Analyst'
        OR job_title_short = 'Business Analyst'
    GROUP BY skills
    )
    LIMIT 10
),

top10_dataengineer_skills AS (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY skill_count DESC) AS ranknumber,
        skills AS dataengineer_skills,
        skill_count 
    FROM 
    (
    SELECT 
        skills,
        COUNT(*) AS skill_count
    FROM skills_job_dim
    INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Engineer'
        OR job_title_short = 'Senior Data Engineer'
    GROUP BY skills
    )
    LIMIT 10
),

top10_datascientist_skills AS (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY skill_count DESC) AS ranknumber,
        skills AS datascientist_skills,
        skill_count 
    FROM 
    (
    SELECT 
        skills,
        COUNT(*) AS skill_count
    FROM skills_job_dim
    INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Scientist'
        OR job_title_short = 'Senior Data Scientist'
    GROUP BY skills
    )
    LIMIT 10
),

top10_cloudengineer_skills AS (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY skill_count DESC) AS ranknumber,
        skills AS cloudengineer_skills,
        skill_count 
    FROM 
    (
    SELECT 
        skills,
        COUNT(*) AS skill_count
    FROM skills_job_dim
    INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Cloud Engineer'
    GROUP BY skills
    )
    LIMIT 10
),

top10_MLengineer_skills AS (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY skill_count DESC) AS ranknumber,
        skills AS MLengineer_skills,
        skill_count 
    FROM 
    (
    SELECT 
        skills,
        COUNT(*) AS skill_count
    FROM skills_job_dim
    INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Machine Learning Engineer'
    GROUP BY skills
    )
    LIMIT 10
),

top10_SWE_skills AS (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY skill_count DESC) AS ranknumber,
        skills AS SWE_skills,
        skill_count 
    FROM 
    (
    SELECT 
        skills,
        COUNT(*) AS skill_count
    FROM skills_job_dim
    INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Software Engineer'
    GROUP BY skills
    )
    LIMIT 10
)

SELECT 
top10_analyst_skills.ranknumber,
analyst_skills,
datascientist_skills,
dataengineer_skills,
MLengineer_skills,
SWE_skills,
cloudengineer_skills
FROM top10_analyst_skills
FULL OUTER JOIN top10_datascientist_skills ON top10_analyst_skills.ranknumber = top10_datascientist_skills.ranknumber
FULL OUTER JOIN top10_dataengineer_skills ON top10_analyst_skills.ranknumber = top10_dataengineer_skills.ranknumber
FULL OUTER JOIN top10_MLengineer_skills ON top10_analyst_skills.ranknumber = top10_MLengineer_skills.ranknumber
FULL OUTER JOIN top10_SWE_skills ON top10_analyst_skills.ranknumber = top10_SWE_skills.ranknumber
FULL OUTER JOIN top10_cloudengineer_skills ON top10_analyst_skills.ranknumber = top10_cloudengineer_skills.ranknumber;


