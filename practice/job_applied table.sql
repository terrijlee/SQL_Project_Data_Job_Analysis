--Create the job_applied table
CREATE TABLE job_applied (
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter__sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)
);

--Check if there is anything in the table
SELECT * 
FROM job_applied;

--Add values into the columns
INSERT INTO job_applied
        (job_id,
        application_sent_date,
        custom_resume,
        resume_file_name,
        cover_letter__sent,
        cover_letter_file_name,
        status)
VALUES (1,
        '2024-02-01',
        true,
        'resume_01.pdf',
        true,
        'cover_letter_01.pdf',
        'submitted'),
        (2,
        '2024-02-15',
        false,
        'resume_02.pdf',
        true,
        'cover_letter_02.pdf',
        'ghosted'),
        (3,
        '2024-02-25',
        true,
        'resume_03.pdf',
        true,
        'cover_letter_03.pdf',
        'rejected');

/*Add a contact table to note who we contacted during applications
After adding the column, you will need to update the existing records*/
ALTER TABLE job_applied
ADD contact VARCHAR(50);

/*Updates the existing records*/
UPDATE job_applied
SET contact = 'Eric Buckman'
WHERE job_id = 1;

UPDATE job_applied
SET contact = 'Hannah Justins'
WHERE job_id = 2;

UPDATE job_applied
SET contact = 'Jenny French'
WHERE job_id = 3;

/*Renames the contact column*/
ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

/*Change the contact column's data type from VARCHAR to TEXT*/
ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE INT;

/*Deleting the contact_name column because we determined this is not necessary*/
ALTER TABLE job_applied
DROP COLUMN contact_name;

/*Delete the job_applied table*/
DROP TABLE job_applied;