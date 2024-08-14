COPY company_dim
FROM 'C:\Users\jerry\Class or Personal Projects\SQL_Project_Data_Analysis\csv_files\company_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_dim
FROM 'C:\Users\jerry\Class or Personal Projects\SQL_Project_Data_Analysis\csv_files\skills_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY job_postings_fact
FROM 'C:\Users\jerry\Class or Personal Projects\SQL_Project_Data_Analysis\csv_files\job_postings_fact.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_job_dim
FROM 'C:\Users\jerry\Class or Personal Projects\SQL_Project_Data_Analysis\csv_files\skills_job_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

