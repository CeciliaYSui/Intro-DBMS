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
#------------------------------------------------------------------------------------------------------------------------------



