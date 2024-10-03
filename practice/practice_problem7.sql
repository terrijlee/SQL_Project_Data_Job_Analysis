/*
Find the number of remote jobs per skill
-Display top 5 skills by their demand in remote jobs
-Include skill ID, name, and count of postings requiring the skill
*/

--Achieves the same results, but not as efficient
WITH skills_and_count AS
(SELECT
    skills_dim.skill_id AS skillId,
    skills_dim.skills AS skill,
    skills_job_dim.job_id AS job,
    COUNT(skills_job_dim.skill_id) AS skill_count
FROM
    skills_job_dim
LEFT JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
GROUP BY
    skillId, skill, job
ORDER BY
    skill_count DESC)



SELECT
    skills_and_count.skillId,
    skills_and_count.skill AS skill_name,
    COUNT(skills_and_count.skill_count) AS job_count
FROM
    job_postings_fact
LEFT JOIN skills_and_count ON  skills_and_count.job = job_postings_fact.job_id
WHERE
    job_location = 'Anywhere'
GROUP BY
    skillId, skill_name
ORDER BY
    job_count DESC
LIMIT 5;

--Solution in video
--CTE calculating the count of skills per job
WITH remote_skills AS
(
SELECT
    skills_job_dim.skill_id AS skillId,
    COUNT(skills_job_dim.skill_id) AS skill_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE
    job_postings_fact.job_work_from_home = TRUE
GROUP BY
    skillId
)

SELECT
    skills_dim.skill_id AS id,
    skills_dim.skills AS skill,
    remote_skills.skill_count AS count
FROM
    skills_dim
INNER JOIN remote_skills ON skills_dim.skill_id = remote_skills.skillId
ORDER BY
    count DESC
LIMIT 5;
