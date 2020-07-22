SET FOREIGN_KEY_CHECKS=1;
DROP DATABASE IF EXISTS COMPANY;
CREATE DATABASE COMPANY; 
USE COMPANY; 

# TABLE: `COMPANY`.`employee`
CREATE TABLE EMPLOYEE (
Fname varchar(15) NOT NULL,
Minit char(1) DEFAULT NULL,
Lname varchar(15) NOT NULL, 
SSN char(9) NOT NULL, 
Bdate date DEFAULT NULL, 
Address varchar(30) DEFAULT NULL, 
Sex varchar(2) DEFAULT NULL, 
Salary decimal(10,2) DEFAULT NULL, 
Super_ssn char(9) DEFAULT NULL, 
Dno int(11) NOT NULL, 
PRIMARY KEY (SSN)); 
# CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`Dno`) REFERENCES `department` (`dnumber`)


# TABLE: `COMPANY`.`department`
CREATE TABLE DEPARTMENT (
Dname varchar(15) NOT NULL,
Dnumber int(11) NOT NULL, 
Mgr_ssn char(9) NOT NULL, 
Mgr_start_date date DEFAULT NULL, 
PRIMARY KEY (Dnumber), 
UNIQUE KEY (Dname),
KEY (Mgr_ssn), 
CONSTRAINT Department_ibfk_1 FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE (SSN) ); 

SHOW TABLES; 