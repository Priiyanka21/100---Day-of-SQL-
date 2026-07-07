-- UNION -- Combine results, remove duplicates
SELECT student_name, course
FROM students_2025
UNION
SELECT student_name, course
FROM students_2026;

-- UNION ALL -- Combine results, keeps duplicates
SELECT student_name, course
FROM students_2025
UNION ALL
SELECT student_name, course
FROM students_2026;

-- INTERSECT -- Returns common results in both tables
SELECT student_name, course
FROM students_2025
INTERSECT
SELECT student_name, course
FROM students_2026;

-- EXCEPT -- Returns results in the first table but not in the second
SELECT student_name, course
FROM students_2025
EXCEPT
SELECT student_name, course
FROM students_2026;
