SELECT 
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs

--Practice
CREATE TABLE quarter1_jobs AS
    SELECT *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 1 AND
        EXTRACT(MONTH FROM job_posted_date) = 2 OR
        EXTRACT(MONTH FROM job_posted_date) = 3

WITH quarter1_jobs AS
(
    SELECT job_id
    FROM january_jobs

    UNION ALL

    SELECT job_id
    FROM february_jobs

    UNION ALL

    SELECT job_id
    FROM march_jobs

)

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    skills_dim.type
FROM skills_job_dim 
LEFT JOIN quarter1_jobs ON quarter1_jobs.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE   
    quarter1_jobs
