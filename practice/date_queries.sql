/*Can select strings without a FROM statement
Showcasing the :: and how you can switch the data type
*/
SELECT '3' :: INT,
    '2024-09-24':: DATE;

SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date
FROM 
    job_postings_fact
LIMIT 100;

/*At Time Zone to convert the UTC time to EST*/
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date
FROM 
    job_postings_fact


/*Extract the month from the job_posted_date*/
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date,
    EXTRACT(YEAR FROM job_posted_date)  AS column_year
FROM 
    job_postings_fact
LIMIT 100;

/*Finds the number of titles posted per month*/
SELECT
    job_title_short AS title,
   COUNT(job_title_short) AS number_of_title,
   EXTRACT(MONTH FROM job_posted_date) AS posted_month
FROM 
    job_postings_fact
GROUP BY
    title, posted_month
ORDER BY
    posted_month;

/*Counting the number of jobs posted each month for a data analyst*/
SELECT
    COUNT(job_id) AS job_posted_account,
    EXTRACT(MONTH FROM job_posted_date) AS posted_month
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    posted_month
ORDER BY
    job_posted_account DESC;

--Practice Problem 1: Finding average salary for job postings after June 1, 2023
SELECT
    job_schedule_type,
    job_posted_date::DATE AS posted_date,
    AVG(salary_year_avg) AS avg_salary,
    AVG(salary_hour_avg) AS avg_hourly_salary
FROM job_postings_fact
WHERE
    job_posted_date >= '2023-06-02' AND 
    job_schedule_type IS NOT NULL
GROUP BY
    posted_date, job_schedule_type
ORDER BY
    posted_date;

--Practice Problem 2: Count number of job postings per month in EST time
SELECT
    COUNT(job_title_short) AS job_count,
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') AS posted_month
FROM
    job_postings_fact
GROUP BY
    posted_month
ORDER BY
    posted_month;

/*Practice Problem 3: Find companies who offered health insurance
and made the posting in the 2nd quarter of 2023
*/
SELECT
    company_dim.name AS company,
    job_postings_fact.job_health_insurance AS health_insurance,
    EXTRACT(MONTH FROM job_postings_fact.job_posted_date) AS posted_month
FROM
    job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_postings_fact.job_health_insurance = TRUE AND
    EXTRACT(MONTH FROM job_postings_fact.job_posted_date) >= 4 AND
    EXTRACT(MONTH FROM job_postings_fact.job_posted_date) <= 6
ORDER BY
    posted_month;