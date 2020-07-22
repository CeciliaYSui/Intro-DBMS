SET FOREIGN_KEY_CHECKS=0;
DROP DATABASE IF EXISTS HW; 
CREATE DATABASE HW;
USE HW;

CREATE TABLE COURSE (
    Course_name VARCHAR(40),
    Course_number VARCHAR(15) NOT NULL UNIQUE,
    Credit_hours INT(1),
    Department CHAR(5)
);

CREATE TABLE STUDENT (
    Name_ VARCHAR(15),
    Student_number INT NOT NULL UNIQUE,
    Class INT,
    Major VARCHAR(5)
);

CREATE TABLE SECTION (
    Section_identifier INT NOT NULL UNIQUE,
    Course_number VARCHAR(15),
    Semester VARCHAR(15),
    Year_ INT,
    Instructor VARCHAR(15),
    CONSTRAINT SECTION_ibfk_1 FOREIGN KEY (Course_number)
        REFERENCES COURSE (Course_number)
);

CREATE TABLE GRADE_REPORT (
    Student_number INT,
    Section_identifier INT,
    Grade CHAR(1),
    CONSTRAINT GRADE_REPORT_ibfk_1 FOREIGN KEY (Student_number)
        REFERENCES STUDENT (Student_number),
    CONSTRAINT GRADE_REPORT_ibfk_2 FOREIGN KEY (Section_identifier)
        REFERENCES SECTION (Section_identifier)
);

CREATE TABLE PREREQUISITE (
    Course_number VARCHAR(15),
    Prerequisite_number VARCHAR(15),
    CONSTRAINT PREREQUISITE_ibfk_1 FOREIGN KEY (Course_number)
        REFERENCES COURSE (Course_number)
);


INSERT INTO STUDENT VALUES ('Smith', 17, 1, 'CS');
INSERT INTO STUDENT VALUES ('Brown', 8, 2, 'CS'); 
 
INSERT INTO COURSE VALUES ('Intro to CS', 'CS1310', 4, 'CS'); 
INSERT INTO COURSE VALUES ('Data Structures', 'CS3320', 4, 'CS'); 
INSERT INTO COURSE VALUES ('Discrete Math', 'MATH2410', 3, 'MATH'); 
INSERT INTO COURSE VALUES ('Database', 'CS3380', 3, 'CS'); 
  

INSERT INTO SECTION VALUES (85, 'MATH2410', 'Fall', 07, 'King'); 
INSERT INTO SECTION VALUES (92, 'CS1310', 'Fall', 07, 'A'); 
INSERT INTO SECTION VALUES (102, 'CS3320', 'S', 08, 'Knuth'); 
INSERT INTO SECTION VALUES (112, 'MATH2410', 'F', 08, 'C'); 
INSERT INTO SECTION VALUES (119, 'CS1310', 'F', 08, 'A');
INSERT INTO SECTION VALUES (135, 'CS3380', 'F', 08, 'Stone'); 
INSERT INTO SECTION VALUES (35, 'CS3320', 'F', 07, 'Knuth'); 
 
INSERT INTO GRADE_REPORT VALUES (17, 112, 'B'); 
INSERT INTO GRADE_REPORT VALUES (17, 119, 'C'); 
INSERT INTO GRADE_REPORT VALUES (8, 85, 'A');  
INSERT INTO GRADE_REPORT VALUES (8, 92, 'A'); 
INSERT INTO GRADE_REPORT VALUES (8, 102, 'B'); 
INSERT INTO GRADE_REPORT VALUES (8, 135, 'A'); 
INSERT INTO GRADE_REPORT VALUES (8, 35, 'A'); 

 
show tables; 
 
SELECT Name_
FROM STUDENT
WHERE Major = 'CS' AND Class = 4; 

SELECT 	Course_name
FROM 	COURSE NATURAL JOIN SECTION 
WHERE (Year_ = 07 OR Year_ = 08) AND Instructor = 'Knuth'; 




SELECT 
    Course_number, Semester, Year_, COUNT(*) AS No_of_students
FROM
    SECTION
        NATURAL JOIN
    GRADE_REPORT
WHERE
    Instructor = 'Knuth'
GROUP BY Section_identifier;



SELECT 
    Name_,
    Course_name,
    Course_number,
    Credit_hours,
    Semester,
    Year_,
    Grade
FROM
    (STUDENT
    NATURAL JOIN GRADE_REPORT)
        NATURAL JOIN
    (COURSE
    NATURAL JOIN SECTION)
WHERE
    (Class = 2 OR Class = 1) AND Major = 'CS'; 










