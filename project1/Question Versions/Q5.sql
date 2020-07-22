# Question 5: Slightly Complex Database Queries 
#------------------------------------------------------------------------------------------------------------------------------


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
#------------------------------------------------------------------------------------------------------------------------------

