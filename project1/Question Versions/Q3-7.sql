# Q 3 - Q7
#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Question 3: 
# Part a: 
INSERT INTO COURSE_SECTION VALUES (12, 2, 6, 2, 2, 'MTWRF', 10:00 AM, 11:30 AM, 5, 35); 
INSERT INTO COURSE_SECTION VALUES (12, 2, 6, 2, 2, 'MTWRF', 9:00 AM, 10:30 AM, 6, 35);
INSERT INTO COURSE_SECTION VALUES (2, 1, 4, 2, 3, 'TR', 9:30 AM, 10:45 AM, 4, 35); 
# Duplicate PKs, & wrong data type of several entries. 
# corrected version: 
# a.i.    
INSERT INTO COURSE_SECTION VALUES (14, 2, 6, 2, '2', 'MTWRF', '10:00 AM', '11:30 AM', 5, 35); 
SELECT * FROM COURSE_SECTION; 
# a.ii. 
INSERT INTO COURSE_SECTION VALUES (15, 2, 6, 2, '2', 'MTWRF', '9:00 AM', '10:30 AM', 6, 35);
SELECT * FROM COURSE_SECTION; 

# a.iii. 
# INSERT INTO COURSE_SECTION VALUES (16, 1, 4, 2, '3', 'TR', '9:30 AM', '10:45 AM', 4, 35); 
INSERT INTO COURSE_SECTION VALUES (16, 1, 4, 2, '5', 'TR', '9:30 AM', '10:45 AM', 4, 35); 
SELECT * FROM COURSE_SECTION; 
#------------------------------------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Part b:
# i. 
INSERT INTO FACULTY VALUES (4, 'Brown', 'Colin', 'D', 11, '3253456789', 'Assistant', 4, 9871); 
#ii. 
INSERT INTO FACULTY VALUES (6, 'Reeves', 'Bob', 'S', 15, '3256789012', 'Full',  , 1234); 
# iii. 
INSERT INTO FACULTY VALUES (6, 'Reeves', 'Bob', 'S', 10, '3256789012', 'Assistant', 7, 1234); 
# corrected version: 
INSERT INTO FACULTY VALUES (6, 'Reeves', 'Bob', 'S', 10, '3256789012', 'Assistant', NULL, 1234); 
# iv. 
INSERT INTO FACULTY VALUES (6, 'Reeves', 'Bob', 'S', 10, '3255678901', 'Assistant', 2, 1234);  
#------------------------------------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Part c: 
INSERT INTO COURSE VALUES (4, 'CS 120', 'Intro. to Programming in C++', 3); 
#------------------------------------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Part d:
DELETE FROM LOCATION 
WHERE Loc_ID = 11 AND Bldg_Code = 'BUS' AND Room = '222' AND Capacity = 1
AND (SELECT COUNT(*) 
		  FROM LOCATION  AS L
          WHERE L.Loc_ID = 11 AND L.Bldg_Code = 'BUS' AND L.Room = '222' AND L.Capacity = 1) = 1; 
#------------------------------------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------------------------------------
# Part e: 
DELETE FROM TERM
WHERE Term_ID = 4 AND Term_Desc = 'Fall 2007' AND Status_ = 'CLOSED' AND Start_Date = '28-AUG-07'; 
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Question 4: Simple Database Queries 
#------------------------------------------------------------------------------------------------------------------------------
# a. students with As & Bs (use IN or NOT IN)
SELECT DISTINCT S_ID, S_Last, S_First 
FROM STUDENT 
WHERE S_ID IN (
						SELECT DISTINCT S_ID
						FROM  ENROLLMENT AS R
						WHERE 'A' IN (SELECT Grade
												FROM ENROLLMENT AS E
												WHERE E.S_ID = R.S_ID)
						AND 
						'B' IN (SELECT Grade
								   FROM ENROLLMENT AS E
							       WHERE E.S_ID = R.S_ID)
                                   ); 

#------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------
# b. terms for 2007 academic year (use LIKE) 
SELECT *
FROM TERM 
WHERE TERM_DESC LIKE ('%2007'); 
#------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------
# c. Bldg_Code, Room, Capacity for all rooms (sort in asceding order by Bldg_Code, then Room)
SELECT Bldg_Code, Room, Capacity
FROM LOCATION
ORDER BY Bldg_Code ASC, Room ASC; 
#------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------
# d. for each course. list C_No, C_Name, Tuition_Charge 
SELECT C_No, C_Name,  730 * Credits AS Tuition_Charge 
FROM COURSE; 
#------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------
# e. use group funcitons to sum the max enrollment for all course sections and calculate the avg, max, min current enrollmetn for Summer 2008. 
SELECT MIN(E.Enrl) AS current_max, MAX(E.Enrl) AS current_min, AVG(S.Max_Enrl) AS term_avg, MAX(S.Max_Enrl) AS term_max 
FROM (SELECT C_Sec_ID, COUNT(*) AS Enrl
			 FROM COURSE_SECTION NATURAL JOIN ENROLLMENT
			 WHERE Term_ID = (SELECT Term_ID
											  FROM TERM
                                              WHERE Term_Desc ='Summer 2008')
			 GROUP BY C_Sec_ID)  AS E, 
             (SELECT * 
              FROM COURSE_SECTION NATURAL JOIN TERM
              WHERE Term_Desc = 'Summer 2008') AS S; 
#------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------
# f. total no. of courses where Lisa Johnson received a grade 
SELECT COUNT(*) 
FROM STUDENT NATURAL JOIN ENROLLMENT 
WHERE S_First = 'Lisa' AND S_Last = 'Johnson' AND Grade IS NOT NULL; 
#------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------
# g. (use GROUP BY) list bldg_code, total capacity of each, but only for those with total capacity 100+ 
SELECT bldg_code, capacity 
FROM location 
WHERE capacity > 100
GROUP BY bldg_code, capacity;
#------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------
# h. list student ID, student last name, first name, faculty ID, faculty last name 
SELECT S_ID, S_LAST, S_FIRST, S.F_ID, F_LAST
FROM STUDENT AS S, FACULTY AS F
WHERE S.F_ID = F.F_ID;
#------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------
# i. list last names of faculty who are teaching in Summer 2008 term 
SELECT DISTINCT F_Last  
FROM (COURSE_SECTION AS C JOIN FACULTY AS F ON C.F_ID = F.F_ID) NATURAL JOIN TERM
WHERE Term_ID = (select Term_ID from TERM where TERM_DESC = 'Summer 2008');
#------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------
# j. list all courses & grades for a student by the name Tammy Jones (no ID, no course info) 
SELECT C_Name, grade
FROM Course NATURAL JOIN Course_section NATURAL JOIN Enrollment
WHERE s_id = (SELECT s_id FROM Student WHERE s_first =  'Tammy' AND s_last = 'Jones');
#------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------
# k. return union of student & faculty tables over attributes (s_last, s_first, s_phone) & (f_last, f_first, f_phone) 
(SELECT S_Last AS Lastname, S_First AS Firstname, S_Phone AS Phone 
FROM Student)
UNION ALL 
(SELECT F_last AS Lastname , F_first AS fFrstname , F_phone AS phone 
FROM Faculty);
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------







#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Question 5: Slightly Complex Database Queries 
# a. 
SELECT s_first, s_last
FROM Student
WHERE s_class =
	(SELECT s_class
	FROM Student
	Where s_first = 'Jorge' AND s_last = 'Perez') AND (S_Last <> 'Perez' AND S_First <> 'Jorge');
#------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------
# b. last & first names of students enrolled in ANY of the same course as Jorge Perez 
SELECT DISTINCT S_Last, S_First 
FROM STUDENT NATURAL JOIN COURSE_SECTION 
WHERE C_SEC_ID IN (SELECT C_SEC_ID 
									   FROM ENROLLMENT NATURAL JOIN STUDENT 
									   WHERE S_Last = 'Perez' AND S_First = 'Jorge') AND (S_Last <> 'Perez' AND S_First <> 'Jorge'); 
#------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------
# c. 
SELECT DISTINCT s_first, s_last
FROM Student NATURAL JOIN Enrollment
WHERE (s_class, c_sec_id) IN
	(SELECT  s_class, c_sec_id
	FROM Student NATURAL JOIN Enrollment
	WHERE s_first = 'Jorge' AND s_last = 'Perez') AND (S_Last <> 'Perez' AND S_First <> 'Jorge');
#------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------
# d. 
SELECT DISTINCT S_First, S_Last
FROM Student NATURAL JOIN Enrollment
WHERE c_sec_id IN
	(SELECT c_sec_id
	FROM Student NATURAL JOIN Enrollment
	WHERE s_first = 'Jorge' AND s_last = 'Perez' AND c_sec_id IN
														(SELECT C_SEC_ID
														 FROM Course_section NATURAL JOIN Location
														 WHERE bldg_code = 'CR')) AND (S_Last <> 'Perez' AND S_First <> 'Jorge');
#------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------
# e. 
SELECT DISTINCT C_Name
FROM course NATURAL JOIN course_section 
WHERE c_sec_id IN (SELECT c_sec_id 
									FROM student NATURAL JOIN Enrollment 
									WHERE  student.s_class <> 'SR') 
                                    UNION 
                                    (SELECT DISTINCT C_Name 
									FROM course NATURAL JOIN course_section 
									WHERE term_id IN 
															(SELECT term_id 
															FROM course_section 
															WHERE term_id = 6));
#------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------
# f.
#SELECT C_Name
#FROM Course NATURAL JOIN Course_section
#WHERE c_sec_id IN
#	(SELECT c_sec_id 
#	FROM Student NATURAL JOIN Enrollment 
#	WHERE s_class <> 'SR')
#	INTERSECT  # MySQL does not support intersect 
#		(SELECT c_sec_id
#		FROM Course_section
#		WHERE term_id <> 6);

SELECT C_Name
FROM COURSE NATURAL JOIN COURSE_SECTION
WHERE C_sec_id IN (SELECT c_sec_id 
									FROM Student NATURAL JOIN Enrollment 
									WHERE s_class <> 'SR')
                                    AND C_sec_id  IN
                                    (SELECT c_sec_id
									 FROM Course_section
									 WHERE term_id <> 6);
#------------------------------------------------------------------------------------------------------------------------------       
        
        

#------------------------------------------------------------------------------------------------------------------------------
# g. (use MINUS) coures taken by FR, SO, JR but not offered in Term 6 
#SELECT * 
#FROM COURSE 
#WHERE C_NAME IN 
#				(SELECT DISTINCT C_Name
#				 FROM (STUDENT NATURAL JOIN ENROLLMENT) NATURAL JOIN (COURSE NATURAL JOIN COURSE_SECTION) 
#				 WHERE S_Class IN ('FR', 'SO', 'JR'))
#MINUS 				# MySQL does not support MINUS 
#(SELECT DISTINCT C_Name
#FROM TERM NATURAL JOIN COURSE NATURAL JOIN COURSE_SECTION 
#WHERE Term_ID = 6); 
SELECT C_Name 
FROM COURSE NATURAL JOIN COURSE_SECTION 
WHERE C_Sec_id IN (SELECT C_sec_id 
									 FROM STUDENT NATURAL JOIN ENROLLMENT 
                                     WHERE S_Class IN ('FR', 'SO', 'JR')) 
                                     AND C_Sec_id NOT IN 
                                     (SELECT C_sec_id
                                      FROM COURSE_SECTION 
                                      WHERE Term_id = 6); 
#------------------------------------------------------------------------------------------------------------------------------



#------------------------------------------------------------------------------------------------------------------------------
# Junior Faculty is defined by an academic rank of Instructor or Assistant Professor
# h. list names of all junior faculty members & their supervisors 
SELECT A.F_Last, A.F_First, B.F_Last AS Super_Last, B.F_First AS Super_First
FROM FACULTY AS A, FACULTY AS B 
WHERE A.F_Rank = 'Assistant'  AND A.F_Super = B.F_ID; 
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Question 6: Experimenting wiht Views 
USE LIPSCOMB; 
#------------------------------------------------------------------------------------------------------------------------------
# a. create view: faculty_view with all cols but F_PIN
CREATE OR REPLACE VIEW faculty_view
AS SELECT F_ID, F_Last, F_First, F_MI, Loc_ID, F_Phone, F_Rank, F_Super 
	  FROM FACULTY; 
SELECT * FROM faculty_view; 
# 5 rows returned 


#------------------------------------------------------------------------------------------------------------------------------
# b. Insert tuple into faculty_views (6, 'May', 'Lisa', 'I', 11, '3256789012', 'Assistant') 
INSERT INTO faculty_view VALUES (6, 'May', 'Lisa', 'I', 11, '3256789012', 'Assistant', NULL); 
SELECT * FROM faculty_view; 
# NULL is needed here for F_Super, since no value is provided 


#------------------------------------------------------------------------------------------------------------------------------
# c. Retrieve all tuples of faculty_view to check for Lisa May 
SELECT * FROM faculty_view; 

#------------------------------------------------------------------------------------------------------------------------------
# d. Explain the effect of insert operation in b to the database 
SELECT * FROM FACULTY; 
# A view is a stored query accessible as a virtual table and is composed of the result set of the query. 
# Changing the data in a referenced tables alters the data shown in subsequent invocations of the view.
# If you have created the view of certain table then there is automatic update in the data 
# in the view as you change the data or insert new data in its respective table. 
# Some views are updatable, like this one. That is, you can use them in statements such as UPDATE, DELETE, INSERT 
# to update the contents of the underlying table. 
# For a view to be updatable, there must be a one-to-one relationship between the rows in the view & 
# the rows in the underlying table. 

# The view definition is frozen at creation time & is not affected by subsequent changes to the definitions of the 
# underlying tables. e.g. new cols added to the table later do not become part of the view, & cols dropped from 
# the table will result in an erorr when selecting from the view. 

#------------------------------------------------------------------------------------------------------------------------------
# e. create query that joins faculty_view with location to list the names of each faculty member & the bldg_code & room no. 
# A view can be thought of as either a virtual table or a stored query. 
# The data accessible through the view is not stored in the DS as a distinct object. 
# What is stored in the DB is a SELECT statement. 
# The result of the SELECT statement forms the virtual table returned by the view. 

SELECT F_First, F_Last, Bldg_code, Room AS Room_no
FROM faculty_view NATURAL JOIN LOCATION; 


#------------------------------------------------------------------------------------------------------------------------------
# f. Remove faculty_view 
DROP VIEW IF EXISTS faculty_view; 
SELECT * FROM faculty_view; 

#------------------------------------------------------------------------------------------------------------------------------
# g. Explain the effect if any of f to the database 
# The LIPSCOMB.faculty_view VIEW is deleted, but the database is not changed via this command. 0 rows affected. 
# When you drop a view, the definition of the view and other information about the view is deleted from the system catalog.
# All permissions for the view are also deleted. 
# The underlying table is not dropped, so essentially this DROP VIEW command did not affect the database. 
# The VIEW is simply a SELECT statement that is stored in the database. 
SELECT * FROM FACULTY; 
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Question 7: Updating the Database 
#------------------------------------------------------------------------------------------------------------------------------
# a. change the room to BUS 211 for all courses taught by Brown. 
SELECT * FROM FACULTY; 
SELECT * FROM COURSE_SECTION; 

# Error Code: 1175. must use PK in WHERE clause for safe update mode.  OR use 
SET SQL_SAFE_UPDATES = 0;

UPDATE COURSE_SECTION
SET Loc_ID = (SELECT Loc_ID 
						FROM LOCATION 
                        WHERE Bldg_Code = 'BUS' AND Room = '211')
WHERE F_ID = (SELECT F_ID
						   FROM FACULTY
                           WHERE F_Last = 'Brown'); 
                           
SELECT * FROM COURSE_SECTION; 
#------------------------------------------------------------------------------------------------------------------------------


#------------------------------------------------------------------------------------------------------------------------------
# b. create & fill a new table, called enrollment_numbers, which shows each course_no & the no. of
# students enrolled in it per section for the Spring 2008. Display the table. 
DROP TABLE IF EXISTS ENROLLMENT_NUMBERS; 
CREATE TABLE ENROLLMENT_NUMBERS  (
	SELECT C_No, Sec_num, COUNT(*) AS No_of_students 
    FROM COURSE NATURAL JOIN COURSE_SECTION NATURAL JOIN ENROLLMENT 
    WHERE Term_ID = (SELECT Term_ID 
									 FROM TERM 
                                     WHERE Term_Desc = 'Spring 2008')   	
	GROUP BY C_sec_id 
); 
SELECT * FROM ENROLLMENT_NUMBERS; 
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

