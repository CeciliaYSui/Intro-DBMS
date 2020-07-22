SET FOREIGN_KEY_CHECKS=0;
DROP DATABASE IF EXISTS LIPSCOMB; 
CREATE DATABASE LIPSCOMB;
USE LIPSCOMB;


CREATE TABLE LOCATION (
    Loc_ID INT NOT NULL,		
    #PK: Loc_ID is the only unique identifier for each tuple in LOCATION table  
    Bldg_Code VARCHAR(5) NOT NULL,
    Room VARCHAR(3) NOT NULL,
    Capacity INT, 
    PRIMARY KEY (Loc_ID)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;


CREATE TABLE TERM (
    Term_ID INT NOT NULL,		
    #PK: A unique identifier for each tuple in TERM table. Term_Desc is also unique, 
    #but Term_ID is easier to manage as a int value comparing to the varying characters. 
    Term_Desc VARCHAR(15) NOT NULL,
    Status_ VARCHAR(6) NOT NULL CHECK (Status_ = 'CLOSED' OR Status_='OPEN'), 
    Start_Date VARCHAR(10) NOT NULL,
    PRIMARY KEY (Term_ID)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;



CREATE TABLE COURSE (
    C_ID INT NOT NULL UNIQUE,		
    #PK: only unique identifier for each tuple 
    C_No CHAR(6) NOT NULL,
    C_Name VARCHAR(30) NOT NULL,
    Credits INT DEFAULT 3,
    PRIMARY KEY (C_ID)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;



CREATE TABLE FACULTY (
    F_ID INT NOT NULL,		
    #PK: only unique identifier for each tuple
    # is F_PIN unique also? 
    F_Last VARCHAR(20) NOT NULL,
    F_First VARCHAR(20) NOT NULL,
    F_MI CHAR(1),
    Loc_ID INT,		#refer to location
    F_Phone VARCHAR(15) NOT NULL,
    F_Rank VARCHAR(15) NOT NULL,
    F_Super INT, 
    F_PIN VARCHAR(5),		
    PRIMARY KEY (F_ID),
    CONSTRAINT FACULTY_ibfk_1 FOREIGN KEY (Loc_ID)
        REFERENCES LOCATION (Loc_ID) 
        ON DELETE SET NULL 
        # When Loc_ID in LOCATION is deleted, Loc_ID in FACULTY tuples are set null and 
        # other attributes in FACULTY tuples are not affected.
        ON UPDATE CASCADE, 
        # When Loc_ID in LOCAITON is updated, all corresponding Loc_ID in FACULTY are updated. 
    CONSTRAINT FACULTY_ibfk_2 FOREIGN KEY (F_Super)
        REFERENCES FACULTY (F_ID)
        ON DELETE SET NULL
        # When F_ID in FACULTY is deleted, F_Super attribute is set null in the FACULTY tuples. 
        ON UPDATE CASCADE
        # When F_ID is updated in FACULTY, the FK is also updated. 
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;



CREATE TABLE STUDENT (
    S_ID INT NOT NULL,
    #PK: A unique identifier; easier to manage than S_PIN; shorter than S_PIN
    S_Last VARCHAR(20) NOT NULL,		
    S_First VARCHAR(20) NOT NULL,
    S_MI CHAR(1) ,
    S_Address VARCHAR(30),
    S_City VARCHAR(15) ,
    S_State CHAR(2) ,
    S_Zip INT(5) ,
    S_Phone VARCHAR(10) NOT NULL,
    S_Class CHAR(2) NOT NULL,
    S_DOB DATE ,
    S_PIN VARCHAR(4) DEFAULT NULL UNIQUE, 		
    F_ID INT DEFAULT NULL,
    Date_Enrolled DATE DEFAULT NULL,
    PRIMARY KEY (S_ID),
    CONSTRAINT STUDENT_ibfk_1 FOREIGN KEY (F_ID)
        REFERENCES FACULTY (F_ID)
        ON DELETE SET NULL
        # If F_ID in FACULTY is deleted, the FK F_ID is set null but tuples in STUDENT table are kept. 
        ON UPDATE CASCADE 
        # IF F_ID in FACULTY is updated, all FK related are updated. 
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;


CREATE TABLE COURSE_SECTION (
    C_Sec_ID INT NOT NULL UNIQUE,		
    #PK: unique identifier for each tuple 
    C_ID INT NOT NULL,
    Term_ID INT NOT NULL,
    Sec_Num INT DEFAULT 1,
    F_ID INT NOT NULL,
    Mtg_Days VARCHAR(5) NOT NULL,		# modified 
    Start_Time VARCHAR(10) NOT NULL,	# modified 
    End_Time VARCHAR(10) NOT NULL,	# modified 
    Loc_ID INT,
    Max_Enrl INT  DEFAULT 30,
    PRIMARY KEY (C_Sec_ID),
    CONSTRAINT COURSE_SECTION_ibfk_1 FOREIGN KEY (C_ID)
        REFERENCES COURSE (C_ID)
        ON DELETE CASCADE
        # If C_ID in COURSE is deleted, the tuple containing FK C_ID will also be deleted,
        # since the course is not offered any more, no sections will be offered. 
        ON UPDATE CASCADE, 
        # If C_ID in COURSE is updated, FK C_ID will also be updated. 
    CONSTRAINT COURSE_SECTION_ibfk_2 FOREIGN KEY (Loc_ID)
        REFERENCES LOCATION (Loc_ID)
        ON DELETE SET NULL
        # If parent Loc_ID is deleted, child Loc_ID will be set null, but 
        # tuples in COURSE_SECTION containing Loc_ID will be kept. 
        ON UPDATE CASCADE,
        # If parent is updated, child will also be updated. 
    CONSTRAINT COURSE_SECTION_ibfk_3 FOREIGN KEY (Term_ID)
        REFERENCES TERM (Term_ID)
        ON DELETE CASCADE
        # If parent Term_ID is deleted, the row containing the child will also be deleted.
        # Since the term does not exist anymore, no course can be offered at that deleted term. 
        ON UPDATE CASCADE
        # If parent is updated, child is also updated. 
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;


CREATE TABLE ENROLLMENT (
    S_ID INT NOT NULL,
    C_Sec_ID INT NOT NULL,
    Grade CHAR(1),
    PRIMARY KEY (S_ID , C_Sec_ID),
    # PK: the combination of S_ID and C_Sec_ID is the unique identifier for each row. 
    # Grade is not unique and can be null, so Grade cannot be included in the PK. 
    CONSTRAINT ENROLLMENT_ibfk_1 FOREIGN KEY (S_ID)
        REFERENCES STUDENT (S_ID)
        ON DELETE CASCADE 
        # If parent S_ID is deleted, the row containing child S_ID in ENROLLMENT table will be deleted. 
        # Since the student does not go to Lipscomb anymore, no course is enrolled and no grade is given to the student. 
        ON UPDATE CASCADE,
        # If parent S_ID is updated, the child is also updated. 
    CONSTRAINT ENROLLMENT_ibfk_2 FOREIGN KEY (C_Sec_ID)
        REFERENCES COURSE_SECTION (C_Sec_ID)
        ON DELETE CASCADE
        # If parent is deleted, the row containing the child in ENROLLMENT table is also deleted. 
        # If course section is not offered, no grade can be given. 
        ON UPDATE CASCADE
        # If parent is updated, child is also updated. 
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4; 

# show tables; 
USE LIPSCOMB; 


