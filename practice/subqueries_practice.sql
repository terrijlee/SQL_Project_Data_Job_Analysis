SELECT * 
FROM (SELECT *
      FROM job_postings_fact
      WHERE EXTRACT(MONTH FROM job_posted_date) = 1 
) AS january_jobs;

--CTE
WITH january_jobs AS (
      SELECT *
      FROM job_postings_fact
      WHERE EXTRACT(MONTH FROM job_posted_date) = 1 

)

SELECT * FROM january_jobs;

--Finding jobs that don't mention a degree
--Useful in this case because it's finding the company id from the subquery and returning the name
SELECT 
      name, 
      company_id
FROM company_dim
WHERE company_id IN (
      SELECT
            company_id
      FROM
            job_postings_fact
      WHERE
            job_no_degree_mention = true

);

--Finding companies with most job postings
WITH company_job_count AS (
SELECT
      company_id,
      COUNT(*) AS num_jobs
FROM
      job_postings_fact
GROUP BY
      company_id
)

SELECT 
      company_dim.name AS company_name,
      company_job_count.num_jobs
FROM company_dim
LEFT JOIN company_job_count ON company_dim.company_id = company_job_count.company_id
ORDER BY
      num_jobs DESC;

--Identify top 5 skills frequently mentioned in job postings
SELECT 
      top_5_skills.skill_id,
      top_5_skills.skill_count,
      skills_dim.skills
FROM (SELECT
            skill_id,
            COUNT(*) AS skill_count
      FROM
            skills_job_dim
      GROUP BY
            skill_id
      ORDER BY
            skill_count DESC
      LIMIT 5)
AS top_5_skills
LEFT JOIN skills_dim ON top_5_skills.skill_id = skills_dim.skill_id;

--Detemine the size of a company based on their job postings

SELECT 
      company_dim.name,
      company_categories.company_size,
      company_categories.count_jobs
FROM
(     SELECT
            company_id,
            COUNT(job_id) AS count_jobs,
            CASE
                  WHEN COUNT(job_id) < 10 THEN 'Small'
                  WHEN COUNT(job_id) >= 10 AND COUNT(job_id) <= 50 THEN 'Medium'
                  WHEN COUNT(job_id) > 50 THEN 'Large'
            END AS company_size
      FROM
            job_postings_fact
      GROUP BY
            company_id
) AS company_categories
LEFT JOIN company_dim ON company_dim.company_id = company_categories.company_id






