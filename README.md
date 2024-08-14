# Introduction and Background
This is a mini personal/self-learning project I performed using PostgreSQL and Visual Studio Code analyzing and summarizing data on job postings from the year 2023. My objective was to answer a variety of questions about salary and demand based on aspects like company, location, timeframe, and skill. 

You can find all my SQL queries here: [Analysis_Project folder](/Analysis_Project/)


### Data Source (Important!)
ALL credit for the dataset comes from Luke Barousse's SQL course found here: [SQL Course](https://www.lukebarousse.com/sql)

This jobs dataset is a large set of real-world data jobs (such as data analysts, data engineers, and data scientists) and information about them compiled from 2023, such as skills, salary, location, company, and much more, split across 4 tables and linked with IDs. 

Though I used this provided dataset for my analysis (Also using the provided code for importing the csv data), I **did not** follow along with the project tutorial's queries (mainly rather using it for inspiration), instead opting to challenge myself by creating and answering my own questions I was interested in. 

### Tools Used
- PostgreSQL as the database of choice
- VS Code for writing SQL queries and organizing files
- Github for version control and sharing the project publicly

### Questions I was interested in
1) How does the demand and salary for analyst roles differ based on location?
2) How does demand, average salary, and min/max salary differ based on company for analysts?
3) Which yearly quarter has the highest demand for intern positions in the USA?
4) Which NC cities (My hometown) have the most data-related job openings? 
5) What are the top 10 skills to have (based on demand) across ALL job types represented in this dataset? 


# Analysis and Insights
This section will focus of each question as well as how I reached conclusions based on queries I execute in SQL on this dataset. 

I started off by running extremely basic queries to get a feel of the data I was working with, finding things like total listings and distinct job titles. 

## Question 1

**How does the demand and salary for analyst roles differ based on location?**

I answered this question by writing two seperate queries: one for number of postings, and one for average salary. I grouped by job location and filtered only for analyst positions, ordering by the descending order. 

```sql
--Query for number of postings
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


--Query for average salary
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
```

### Snapshot of Results
|job_location                              |counts   |
|------------------------------------------|---------|
|Anywhere                                  |18469    |
|Singapore                                 |9636     |
|Paris, France                             |4486     |
|Hong Kong                                 |3801     |
|New York, NY                              |3767     |
|Atlanta, GA                               |3749     |
|Madrid, Spain                             |3603     |
|India                                     |3118     |
|Chicago, IL                               |3115     |
|Lisbon, Portugal                          |2820     |



|job_location                              |averages |
|------------------------------------------|---------|
|Belarus                                   |400000.00|
|Hildesheim, Germany                       |200000.00|
|Nea Smyrni, Greece                        |200000.00|
|Merced, CA                                |200000.00|
|Berkeley Heights, NJ                      |200000.00|
|Renningen, Germany                        |199837.50|
|Iași, Romania                             |194500.00|
|Fairview, PA                              |193048.00|
|South San Francisco, CA                   |182770.79|
|Taipei, Taiwan                            |180000.00|
|Vancouver, BC, Canada                     |175000.00|
|Burlington, MA                            |175000.00|
|Rock Island, IL                           |175000.00|
|Valparaiso, IN                            |173500.00|
|Ho-Ho-Kus, NJ                             |172015.00|

### Breakdown of Results
- For demand for analyst roles, "Anywhere" job location had the most demand, with over 18k job listings, almost twice as much as the runner up, Singapore. Other in-demand locations for analysts include Paris, Hong Kong, NYC, Atlanta, Madrid, India, Chicago, and Lisbon. 
- For average salary for analyst roles, Belarus, several cities in Germany, Greece, several California cities, several Northeast US cities have the highest average salaries for analysts, many of these with upwards of 170k per year. However, many of these cities may be skewed with few entries, making the data possibly misrepresenting the true average salary in these cities. 


## Question 2
**How does demand, average salary, and min/max salary differ based on company for analysts?**

I answered this question by using count, average, max, and min with grouping by company name after joining the job listings table with the company table, and filtering by analyst roles.

```sql
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

```

### Snapshot of results
|name                                      |total_jobs|avg_salary|highest_salary_posting|lowest_salary_posting|
|------------------------------------------|----------|----------|----------------------|---------------------|
|Emprego                                   |1985      |          |                      |                     |
|Citi                                      |1455      |123422.50 |235040.00             |40560.00             |
|Robert Half                               |1196      |89507.94  |170000.00             |50000.00             |
|Insight Global                            |1058      |94008.05  |157500.00             |43000.00             |
|UnitedHealth Group                        |1029      |108366.79 |131085.00             |90000.00             |
|Confidenziale                             |859       |          |                      |                     |
|Dice                                      |760       |107500.00 |107500.00             |107500.00            |
|Get It Recruit - Information Technology   |666       |90782.07  |184000.00             |36000.00             |
|Michael Page                              |653       |94166.67  |130000.00             |80000.00             |
|Randstad                                  |586       |92500.00  |115000.00             |75000.00             |
|Accenture                                 |580       |97100.00  |115000.00             |79200.00             |
|Confidential                              |526       |89876.59  |112500.00             |77500.00             |
|Wells Fargo                               |508       |117933.33 |174000.00             |90000.00             |
|PepsiCo                                   |492       |111750.00 |125000.00             |98500.00             |
|Hays                                      |469       |104333.33 |140000.00             |85000.00             |
|Deloitte                                  |465       |92314.32  |125000.00             |44100.00             |

### Breakdown of results
- I sorted by total jobs, because many of the highest salary jobs have extremely few job offerings. 
- Many of these have NULL values for the salaries because they weren't provided
- These companies all have very good-paying average salaries for analysts, with many being near 100k or even above 100k a year, and also have a need for analysts.
- Banks like Wells Fargo and Citi seem to hire a lot of analysts, as well as consulting. Of the companies represented in the snapshot, Citi has the highest average salary and the highest max salary. 

## Question 3
**Which yearly quarter has the highest demand for intern positions in the USA?**

I solved this question by using a case when to categorize each listing by a yearly quarter based off of the post date. Then I grouped by the quarters to find the count of internships in each quarter, classifying by internship and USA locations.

```sql
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

```

### Results
|annual_quarter                            |internship_count|
|------------------------------------------|----------------|
|Q1: Jan, Feb, Mar                         |576             |
|Q2: Apr, May, Jun                         |274             |
|Q3: Jul, Aug, Sept                        |378             |
|Q4: Oct, Nov, Dec                         |432             |

### Breakdown of results
It looks like Q1 has the highest amount of postings, followed by Q4, Q3, and Q2 with the least. This could help students like me optimize applications by taking note of the peak months of internship posts. From this, it looks optimal to apply during the Fall to Winter of the following year. 

## Question 4
**Which NC cities (My hometown) have the most data-related job openings?**

To solve this, I used wildcard letters to filter for locations with NC in the location, grouping by location, then finding counts, and for fun, the yearly and hourly salary at those locations. 

```sql
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
```
### Snapshot of Results
|job_location                              |job_count|yearly_salary|hourly_salary|
|------------------------------------------|---------|-------------|-------------|
|Charlotte, NC                             |3744     |118356.32    |50.56        |
|Raleigh, NC                               |677      |131823.65    |45.88        |
|Durham, NC                                |663      |126822.44    |50.20        |
|Cary, NC                                  |224      |114311.37    |45.01        |
|Fayetteville, NC                          |128      |116700.00    |44.70        |
|Burnsville, NC                            |124      |120950.00    |56.25        |
|Wilmington, NC                            |117      |95224.25     |47.02        |
|Greensboro, NC                            |104      |106999.33    |51.00        |
|Fort Bragg, NC                            |102      |172990.63    |55.00        |

### Breakdown of results
My hometown of Charlotte, NC has the most job openings by a significant amount compared to the runner-up, Raleigh. Durham, Cary, and Fayetteville follow. These results make sense because of the Research Triangle being one of the fastest growing areas in North Carolina. 

## Question 5
**What are the top 10 skills to have (based on demand) across ALL job types represented in this dataset?**

Solving this was a bit challenging at first, but it constitued breaking down the code into CTEs for each type of role, then creating a table ranking of the top 10 most in-demand skills for each (This was done by joining tables together to show skills, then filtering by the job role, and then grouping by skills to show counts). I then joined all these tables together with the ID being the ranking, from 1-10. 

```sql
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
```

### Results
|ranknumber                                |analyst_skills|datascientist_skills|dataengineer_skills|mlengineer_skills|swe_skills|cloudengineer_skills|
|------------------------------------------|--------------|--------------------|-------------------|-----------------|----------|--------------------|
|1                                         |sql           |python              |sql                |python           |python    |python              |
|2                                         |excel         |sql                 |python             |pytorch          |sql       |aws                 |
|3                                         |python        |r                   |aws                |tensorflow       |aws       |azure               |
|4                                         |tableau       |sas                 |azure              |aws              |java      |sql                 |
|5                                         |power bi      |tableau             |spark              |sql              |azure     |linux               |
|6                                         |r             |aws                 |java               |azure            |kubernetes|terraform           |
|7                                         |sas           |spark               |kafka              |spark            |docker    |kubernetes          |
|8                                         |powerpoint    |azure               |scala              |docker           |linux     |java                |
|9                                         |word          |tensorflow          |hadoop             |java             |javascript|gcp                 |
|10                                        |sap           |excel               |snowflake          |kubernetes       |git       |docker              |


### Breakdown of results
- Python and SQL seem to be the most popular skills across all these roles, making them extremely valuable skills to learn for their popularity and use in a variety of career paths. 
- For the engineer roles, it seems like cloud skills such as AWS and Azure are very valuable skills to learn.
- For data analysts and scientists, it's good to know visualization skills like Power BI and Tableau. 

# Final Takeaways 
This is my first SQL project, and I wanted to do this primarily as a way of teaching myself SQL through an informal but applied setting. I was able to hone my query writing skills and my analytical skills by challenging myself to lay out frameworks and come up with solutions for these questions I had in mind. 

I was able to use features like joins, CTEs, rankings, wildcard characters, subqueries, aliases, grouping, and filtering to accomplish my goals, and I feel I've been able to get a solid foundational grasp of what SQL has to offer.

My results would be greatly helpful to anyone in the job-search process, or intern-seeking process like myself, particularily for seeing the demand and salary for various companies/locations, peak intern application times, or the optimal skills to learn for what role you're interested in. I certainly was able to get some valuable information and insights from tackling the above questions in the analysis portion. 

I want to give a huge thank you to Luke Barousse and his SQL course for inspiration and guidance through my learning and coding progress, especially with the dataset provided. 