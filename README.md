# Introduction
The following project looks into the data analytics job market in 2023. The project reveals the top paying jobs, top-paying skills and highly-demanded skills for data analyst roles located in San Francisco, CA.

Please see the SQL queries for this project: [project_sql folder](/project_sql/)

# Background
The project and the associated dataset is based on the course created by Luke Barousse, which can be found [here](https://www.lukebarousse.com/sql). 

The purpose of this project is to enable prospective data analysts to understand the skillsets that are in high demand and are high paying. These high demand and high paying skills are defined in this project as **optimal**. This will allow prospective data analysts to focus their energy on the skills for their ideal role within data analytics. 

The queries used within this course project can be adapted to fit other data analytics roles, such as data scientists.

## The questions we wanted to answer in this project
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
This project includes the following tools:
- **PostgreSQL**: Postgres was used locally to store and create the tables, which are included in the [csv_files folder](/csv_files/). 
- **SQL**: SQL was used to analyze the dataset and provide the insights.
- **VS Code**: VS Code was the main tool used to analyze and run the queries.
- **GitHub**: With the help of Git and GitHub, I have been able to share these findings. It also is essential to capture different versions within the code.

# The Analysis
### 1. What are the top-paying data analyst jobs?
The query obtains the data for the 10 highest paying data analyst roles in San Francisco, CA in 2023.

![Bar Chart Top](/images/AverageYearlySalaries.png)
**Note: The following chart was created with ChatGPT for demonstration and learning purposes.**

From the chart, you can see that the highest paying salaries range from $165,000 t0 $350,000. The companies offering these top-paying analyst roles vary in industries, including technology (Salesforce, Anthropic, OpenAI) to healthcare (GoodRx).

If you are interested, please review query 1.
```sql
SELECT
    company_dim.name,
    job_postings_fact.job_id,
    job_postings_fact.job_title,
    job_postings_fact.job_location,
    job_postings_fact.job_schedule_type,
    job_postings_fact.salary_year_avg,
    job_postings_fact.job_posted_date
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_location = 'San Francisco, CA' AND
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
ORDER BY   
    salary_year_avg DESC
LIMIT 10;
```

### 2. What skills are required for these top-paying jobs?
For those top 10 highest paying data analyst roles found in the first query, we gathered a list of the top 10 skills from those job postings.

![Skills from Top 10 Jobs](/images/SkillsFromTop10Jobs.png)
**Note: The following chart was created with ChatGPT for demonstration and learning purposes.**

Through this bar chart, you can see that the top 5 skills required from the top 10 highest paying job include:
- SQL
- Python
- Tableau
- Excel
- Spark

Let's use this and compare it to the top skills for data analysts in general (query 3) and the highest paying skills (query 4). 

If you are interested, please review query 2.
```sql
WITH top_paying_jobs AS (
    SELECT
        company_dim.name,
        job_postings_fact.job_id,
        job_postings_fact.job_title,
        job_postings_fact.salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_location = 'San Francisco, CA' AND
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
    ORDER BY   
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```

### 3. What skills are most in demand for data analysts?
In this query, we are expanding our analysis to find the top 5 demanded skills for data analysts in general within San Francisco, CA.

| Skills  | Demand Count |
|---------|--------------|
| SQL     | 735          |
| Tableau | 451          |
| Python  | 442          |
| Excel   | 348          |
| R       | 327          |

From the table above, you will see familiar skills found from query 2, including: SQL, Tableau, Python, and Excel. The only differences between the two insights are the order of the skills and this time R made it into the ranking. This means many employers are expecting data analysts to have a combination of these skills.

If you are interested, please review query 3.
```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'San Francisco, CA'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

### 4. Which skills are associated with higher salaries?
In query 4, we are looking more deeply into the top skills that are associated to higher salaries. This is important because job seekers who have the knowledge of higher-paying skillsets can use this to focus their studying and hone their expertise.

| Skills     | Average Salary |
|------------|----------------|
| Asana      | 235000         |
| Scala      | 200000         |
| GitHub     | 179250         |
| TensorFlow | 174040         |
| Keras      | 174040         |
| PyTorch    | 174040         |
| Notion     | 158750         |
| Spark      | 143720         |
| SAS        | 143000         |
| Airflow    | 142025         |
| Express    | 136793         |
| Looker     | 133854         |
| C          | 133750         |
| SPSS       | 133667         |
| Git        | 131000         |
| Zoom       | 130588         |
| Snowflake  | 128823         |
| Python     | 128542         |
| Flow       | 126850         |
| Jira       | 125000         |
| Slack      | 124000         |
| SQL        | 123203         |
| PowerPoint | 123125         |
| Go         | 122735         |
| R          | 116773         |
 
Interestingly, some of the most in-demand skills are not the highest paid. For example, Python, SQL, and R at the bottom of the top 25 list. However, seeing as it was included in this list, those skills remain worthwhile to pursue. 

Notably, some of the top-paid skills in this list are related to artificial intelligence and machine learning tools. Just to name a few:
- Scala
- TensorFlow
- Keras
- PyTorch
- Spark

If you are interested, please review query 4.
```sql
SELECT
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
    skills
ORDER BY
    average_salary DESC
LIMIT 25;
```

### 5. What are the most optimal skills to learn?
With query 5, we are combining the queries 3 and 4. Query 3 focused on the in-demand skills and query 4 focused on the high-paying skills.

Based on the definition of optimal, within San Francisco the highest demanded and highest paid skills include the folowwing:

| Skills     | Demand Count | Average Salary |
|------------|--------------|----------------|
| SQL        | 57           | 123203         |
| Python     | 37           | 128542         |
| Tableau    | 33           | 115331         |
| R          | 25           | 116773         |
| Excel      | 21           | 110626         |
| Looker     | 13           | 133854         |


If you are interested, please review query 5.
```sql
SELECT
    skills_dim.skill_id AS skillId,
    skills_dim.skills AS skill,
    COUNT(job_postings_fact.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE   
    job_title_short = 'Data Analyst' AND
    job_location = 'San Francisco, CA' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skillId
HAVING
    COUNT(job_postings_fact.job_id) > 10
ORDER BY
    demand_count DESC,
    average_salary DESC
LIMIT 25;

```

# Conclusions
Based on the findings above, here are some of the insights answering our 5 main questions:
1. **Highest Paying Job**: The highest paying job last year was offered by Anthropic.
2. **Skills for Top-Paying Jobs**: SQL was at the top of the list, indicating the need for Data Analyst to have a solid understanding of this skill.
3. **In-Demand Skills**: Similar to query 2, the most in-demand skill was SQL.
4. **High-Paying Skills**: The highest-paying skills were more niche, focusing on tools for data engineering, machine learning, and artificial intelligence.
5. **Optimal Skills**: The optimal skills suggests data analysts require a strong skillset in the core fundamentals of data analytics. At the present time, that is SQL and Python at the top of the list.

# Learnings and Closing Thoughts
Throughout this course, I honed my SQL skills. I had some prior SQL knowledge from my college days. However, it was great to revist this skillset and learn more advanced topics. Notably:

1. Setting up a local database with PostgreSQL
2. Creating and manipulating tables
3. Use cases for
    1. Common Table Expressions (CTEs)
    2. Subqueries
4. Connecting VSCode to GitHub to track changes
5. Understanding when to use particular joins

Not only was the course a great reminder of SQL, but it provided practical experience and great insights into the optimal skills to learn for a job seeker looking for data analytics jobs. 

The highlight of the course was the organized and clear approach in structuring data projects. I particularly enjoyed how the questions were the basis for the queries. It provided me with further ideas on future self-learning projects and has inspired me to come up with my own questions.