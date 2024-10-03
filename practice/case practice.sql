/*

Relabeling the location
Anywhere = Remote
San Francisco, CA = Local
Everywhere else = Onsite

Did further analysis to count the number of jobs by category and
filter by business analyst roles

*/

SELECT  
    COUNT(job_id) AS job_count,
    CASE
        WHEN job_location = 'San Francisco, CA' THEN 'Local'
        WHEN job_location = 'Anywhere' THEN 'Remote'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Business Analyst'
GROUP BY
    location_category;

/*

Bucket salaries based on low, medium, and high
Order from highest to lowest
Only look for Data Analyst roles

*/

SELECT
    job_location,
    salary_year_avg,
    CASE
        WHEN salary_year_avg > 200000 THEN 'High'
        WHEN salary_year_avg <= 120000 AND salary_year_avg >= 105000 THEN 'Medium'
        WHEN salary_year_avg < 105000 THEN 'Low'
    END AS salary_category    
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC;