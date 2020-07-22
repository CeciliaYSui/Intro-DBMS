# Question 6: Experimenting wiht Views 
#------------------------------------------------------------------------------------------------------------------------------
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










