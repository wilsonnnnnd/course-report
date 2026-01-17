USE course_report;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Enrolments;
TRUNCATE TABLE Users;
TRUNCATE TABLE Courses;
SET FOREIGN_KEY_CHECKS = 1;


INSERT INTO Users (first_name, last_name)
SELECT CONCAT('First', n) AS first_name,
       CONCAT('Last',  n) AS last_name
FROM (
  SELECT (a.d + b.d * 10) + 1 AS n
  FROM
    (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
  CROSS JOIN
    (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
) nums
WHERE n <= 50;

INSERT INTO Courses (description)
SELECT CONCAT('Course ', LPAD(n, 2, '0')) AS description
FROM (
  SELECT (d + 1) AS n
  FROM (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
        UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t
) nums
WHERE n <= 10;

INSERT INTO Enrolments (user_id, course_id, completion_status, enrolled_at, completed_at)
SELECT
  x.user_id,
  x.course_id,
  x.completion_status,
  x.enrolled_at,
  IF(
    x.completion_status = 'completed',
    DATE_ADD(x.enrolled_at, INTERVAL (1 + FLOOR(RAND() * 30)) DAY),
    NULL
  ) AS completed_at
FROM (
  SELECT
    u.user_id,
    c.course_id,
    CASE
      WHEN RAND() < 0.33 THEN 'not started'
      WHEN RAND() < 0.66 THEN 'in progress'
      ELSE 'completed'
    END AS completion_status,
    (NOW() - INTERVAL FLOOR(RAND() * 90) DAY) AS enrolled_at
  FROM Users u
  CROSS JOIN Courses c
  ORDER BY RAND()
  LIMIT 120
) x;

SELECT
  COUNT(*) AS enrolment_rows,
  COUNT(DISTINCT CONCAT(user_id, '-', course_id)) AS unique_user_course
FROM Enrolments;

SELECT * FROM Enrolments ORDER BY enrolment_id DESC LIMIT 10;
