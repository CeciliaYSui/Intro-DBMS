SET FOREIGN_KEY_CHECKS=1;
DROP DATABASE IF EXISTS LIPSCOMB; 
CREATE DATABASE LIPSCOMB;
USE LIPSCOMB;


CREATE TABLE LOCATION (
    Loc_ID INT NOT NULL UNIQUE,		
    #PK: Loc_ID is the only unique identifier for each tuple in LOCATION table  
    Bldg_Code VARCHAR(5) NOT NULL,
    Room VARCHAR(3) NOT NULL,
    Capacity INT DEFAULT NULL,
    PRIMARY KEY (Loc_ID)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;


CREATE TABLE TERM (
    Term_ID INT NOT NULL UNIQUE,		
    #PK: A unique identifier for each tuple in TERM table. Term_Desc is also unique, 
    #but Term_ID is easier to manage as a int value comparing to the varying characters. 
    Term_Desc VARCHAR(15) NOT NULL UNIQUE,
    Status_ VARCHAR(6) NOT NULL CHECK (Status_ = 'CLOSED' OR Status_='OPEN'), 
    Start_Date VARCHAR(10) NOT NULL,
    PRIMARY KEY (Term_ID)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;



CREATE TABLE FACULTY (
    F_ID INT NOT NULL UNIQUE,		
    #PK: only unique identifier for each tuple
    # is F_PIN unique also? 
    F_Last VARCHAR(20) NOT NULL,
    F_First VARCHAR(20) NOT NULL,
    F_MI CHAR(1) DEFAULT NULL,
    Loc_ID INT,		#refer to location
    F_Phone VARCHAR(10) NOT NULL,
    F_Rank VARCHAR(10) NOT NULL,
    F_Super INT DEFAULT NULL, 
    F_PIN VARCHAR(4) DEFAULT NULL,		
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
    S_ID INT NOT NULL UNIQUE,
    #PK: A unique identifier; easier to manage than S_PIN; shorter than S_PIN
    S_Last VARCHAR(20) NOT NULL,		
    S_First VARCHAR(20) NOT NULL,
    S_MI CHAR(1) DEFAULT NULL,
    S_Address VARCHAR(30) NOT NULL,
    S_City VARCHAR(15) NOT NULL,
    S_State CHAR(2) NOT NULL,
    S_Zip INT(5) NOT NULL,
    S_Phone VARCHAR(10) NOT NULL,
    S_Class CHAR(2) NOT NULL,
    S_DOB DATE NOT NULL,
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


CREATE TABLE COURSE (
    C_ID INT NOT NULL UNIQUE,		
    #PK: only unique identifier for each tuple 
    C_No CHAR(6) NOT NULL,
    C_Name VARCHAR(30) NOT NULL,
    Credits INT DEFAULT 3,
    PRIMARY KEY (C_ID)
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
    Grade CHAR(1) DEFAULT NULL,
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
# Location
INSERT INTO `LIPSCOMB`.`LOCATION` VALUES (1    , 'CR',    '101',    150);
INSERT INTO `LIPSCOMB`.`LOCATION` VALUES (2    ,'CR'    ,'202',    40);
INSERT INTO `LIPSCOMB`.`LOCATION` VALUES (3    ,'CR'    ,'103',    35);
INSERT INTO `LIPSCOMB`.`LOCATION` VALUES (4    ,'CR'    ,'105',    35);
INSERT INTO `LIPSCOMB`.`LOCATION` VALUES (5    ,'BUS'    ,'105',    42);
INSERT INTO `LIPSCOMB`.`LOCATION` VALUES (6    ,'BUS'    ,'404',    35);
INSERT INTO `LIPSCOMB`.`LOCATION` VALUES (7    ,'BUS'    ,'421',    35);
INSERT INTO `LIPSCOMB`.`LOCATION` VALUES (8    ,'BUS'    ,'211',    55);
INSERT INTO `LIPSCOMB`.`LOCATION` VALUES (9    ,'BUS'    ,'424',    1);
INSERT INTO `LIPSCOMB`.`LOCATION` VALUES (10    ,'BUS'    ,'402',    1);
INSERT INTO `LIPSCOMB`.`LOCATION` VALUES (11    ,'BUS'    ,'433',    1);
INSERT INTO `LIPSCOMB`.`LOCATION` VALUES (12    ,'LIB'    ,'217',    2);
INSERT INTO `LIPSCOMB`.`LOCATION` VALUES ( 13,    'LIB',    '222',    1);

#Term 
INSERT INTO `LIPSCOMB`.`TERM` VALUES (1,    'Fall 2006',    'CLOSED',    '2006-08-28');
INSERT INTO `LIPSCOMB`.`TERM` VALUES (2,    'Spring 2007',    'CLOSED',    '2008-01-09');
INSERT INTO `LIPSCOMB`.`TERM` VALUES (3,    'Summer 2007',    'CLOSED',    '2006-05-15');
INSERT INTO `LIPSCOMB`.`TERM` VALUES (4,    'Fall 2007',    'CLOSED',    '2007-08-28');
INSERT INTO `LIPSCOMB`.`TERM` VALUES (5,    'Spring 2019',    'OPEN',    '2008-01-08');
INSERT INTO `LIPSCOMB`.`TERM` VALUES (6,    'Fall 2018',    'OPEN',    '2008-05-07');

# Faculty 
INSERT INTO `LIPSCOMB`.`FACULTY` VALUES (4,    'Brown',    'Jonnel',    'D',    11,    '3254567890',    'Full'    , NULL, '6339');
INSERT INTO `LIPSCOMB`.`FACULTY` VALUES (2    ,'Zhulin',    'Mark',    'M',    10,    '3252345678',    'Full',   NULL, '1121' );
INSERT INTO `LIPSCOMB`.`FACULTY` VALUES (1    ,'Marx',    'Teresa',    'J'    , 9,    '3251234567',    'Associate',    4  , '9871' );
INSERT INTO `LIPSCOMB`.`FACULTY` VALUES (3,    'Langley',    'Colin',    'A',    12,    '3253456789',    'Assistant',    4 , '8297');
INSERT INTO `LIPSCOMB`.`FACULTY` VALUES (5,    'Sealy',    'James',    'L',    13,    '3255678901',    'Associate',    2 , '6089');

# STUDENT 
INSERT INTO `LIPSCOMB`.`STUDENT` VALUES (1, 'Jones',		 'Tammy', 	'R', '1817 Eagleridge Circle', 'Houston', 'TX', 77027, '3250987654',    'SR', '1886-07-14',  '8891',  1, ' 2003-06-03' );
INSERT INTO `LIPSCOMB`.`STUDENT` VALUES (2, 'Perez',		 'Jorge', 		'C', '951 Rainbow Drive','Abilene', 'TX', 79901, '3258765432', 'SR', '1886-08-19',  '1230', 1, '2002-01-10');
INSERT INTO `LIPSCOMB`.`STUDENT` VALUES (3, 'Marsh', 		 'John',		     'A', '1275 W Main St,', 'Dallas', 'TX', 78012, '3257654321',    'JR',    '1883-10-10',   '1613',  1,    '2003-08-24');
INSERT INTO `LIPSCOMB`.`STUDENT` VALUES (4, 'Smith',   	 'Mike',   NULL,	'428 EN 16 Street', 'Abilene'    , 'TX',     79902, '3256543210',    'SO',    '1887-09-24',  '1841',    2,    '2004-08-23');
INSERT INTO `LIPSCOMB`.`STUDENT` VALUES (5, 'Johnson',   'Lisa' , 'M',    '764 College Drive',    'Abilene','TX'    ,79901, '3255432109',    'SO',    '1887-11-20',  '4420',    4,    '2005-01-08');
INSERT INTO `LIPSCOMB`.`STUDENT` VALUES (6, 'Nguyen',    'Ni',  'M',    '688 4th Street',    'Ft Worth'    ,'TX',    78767, '3254321098', 'FR',    '1988-12-04',  '9188',  3,    '2006-08-22');

# Course
INSERT INTO `LIPSCOMB`.`COURSE` VALUES (1,    'IT 101',    'Intro. to Info. Tech.',    3);
INSERT INTO `LIPSCOMB`.`COURSE` VALUES (2,    'IS 301',    'Systems Analysis',    3);
INSERT INTO `LIPSCOMB`.`COURSE` VALUES (3,    'IT 240',    'Database Management',    3);
INSERT INTO `LIPSCOMB`.`COURSE` VALUES (4,    'CS 120',    'Intro. To Programming',    3);
INSERT INTO `LIPSCOMB`.`COURSE` VALUES (5,    'IT 451',    'Web-Based Systems',    3);

#Course_Section
INSERT INTO `LIPSCOMB`.`COURSE_SECTION` VALUES (1,    1,    4,    1,    2,    'MWF',    '10:00 AM'    ,'10:50 AM',    1,    140);
INSERT INTO `LIPSCOMB`.`COURSE_SECTION` VALUES (2,    1,    4,    2,    3,    'TR',    '9:30 AM',    '10:45 AM',    7,    35);
INSERT INTO `LIPSCOMB`.`COURSE_SECTION` VALUES (3,    1,    4,    3,    3,    'MWF',    '8:00 AM',    '8:50 AM',    2,    35);
INSERT INTO `LIPSCOMB`.`COURSE_SECTION` VALUES (4,    2,    4,    1,    4,    'TR',    '11:00 AM',    '12:15 AM',    6,    35);
INSERT INTO `LIPSCOMB`.`COURSE_SECTION` VALUES (5,    2,    5,    2,    4,    'TR',    '2:00 PM',    '3:15 PM',    6,    35);
INSERT INTO `LIPSCOMB`.`COURSE_SECTION` VALUES (6,    3,    5,    1,    1,    'MWF',    '9:00 AM',    '9:50 AM',    5,    30);
INSERT INTO `LIPSCOMB`.`COURSE_SECTION` VALUES (7,    3,    5,    2,    1,    'MWF',    '10:00 AM',    '10:50 AM',    5,    30);
INSERT INTO `LIPSCOMB`.`COURSE_SECTION` VALUES (8,    4,    5,    1,    5,    'TR',    '8:00 AM',    '9:15 AM',    3,    35);
INSERT INTO `LIPSCOMB`.`COURSE_SECTION` VALUES (9,    5,    5,    1,    2,    'MWF',    '2:00 PM',    '2:50 PM',    5,    35);
INSERT INTO `LIPSCOMB`.`COURSE_SECTION` VALUES (10,    5,    5,    2,    2, 'MWF',    '3:00 PM',    '3:50 PM',    5,    35);
INSERT INTO `LIPSCOMB`.`COURSE_SECTION` VALUES (11,    1,    6,    1,    1,    'MTWRF',    '8:00 AM',    '9:30 AM',    1,    50);
INSERT INTO `LIPSCOMB`.`COURSE_SECTION` VALUES (12,    2,    6,    1,    2,    'MTWRF',    '8:00 AM',    '9:30 AM',    6,    35);
INSERT INTO `LIPSCOMB`.`COURSE_SECTION` VALUES (13,    3,    6,    1,    3,    'MTWRF',    '8:00 AM',    '9:30 AM',    5,    35);

# ENROLLMENT
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (1,    1,    'A');
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (1,    4,    'A');
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (1,    6,    'B');
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (1,    9,    'B');
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (2,    1,    'C');
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (2,    5,    'B');
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (2,    6,    'A');
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (2,    9,    'B');
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (3,    1,    'C');
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (3,    12,    NULL);
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (3,    13,    NULL);
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (4,    11,    NULL);
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (4,    12,    NULL);
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (5,    1,    'B');
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (5,    5,    'C');
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (5,    9,    'C');
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (5,    11,    NULL);
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (5,    13,    NULL);
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (6,    11,    NULL);
INSERT INTO `LIPSCOMB`.`ENROLLMENT` VALUES (6,    12,    NULL);

#show tables; 