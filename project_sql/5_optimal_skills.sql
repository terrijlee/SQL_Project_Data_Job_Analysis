/*
Answer: What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?
-Identify skills in high demand and associated with high average salaries for Data Analyst roles
-Concentrates on remote positions with specified salaries
-Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
    offering strategic insights for career development in data analysis
*/
/*
Taking queries 3 and 4, then creating them as CTEs
Removed order by to speed up the query
Removed limit because we want to combine the two tables
Added skill id to combine the results set
Group by adjusted to skill id to confirm that the aggregate is correct
*/

WITH skills_demand AS (
    SELECT
        skill_id,
        skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_location = 'San Francisco, CA'
    GROUP BY
        skill_id
)

WITH average_salary AS (
    SELECT
        skill_id,
        skills,
        ROUND(AVG(salary_year_avg), 0) as average_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_location = 'San Francisco, CA'
    GROUP BY
        skill_id
)