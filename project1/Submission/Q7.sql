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





