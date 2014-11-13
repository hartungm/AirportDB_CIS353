SPOOL project.out
SET ECHO ON

/* 
CIS 353 - Database Design Project (PEMN-X Airport)
Nick Bushen
Patrick Dishaw
Evan Dunne
Michael Hartune
Xinyi Ou
*/ 
-- -----------------------------------------------------------------------------
-- Drop the tables (in case they already exist)
-- -----------------------------------------------------------------------------
DROP TABLE Passenger CASCADE CONSTRAINTS;
DROP TABLE Plane CASCADE CONSTRAINTS;
DROP TABLE Maintained CASCADE CONSTRAINTS;
DROP TABLE Flight CASCADE CONSTRAINTS;
DROP TABLE Employee CASCADE CONSTRAINTS;
DROP TABLE Certifications CASCADE CONSTRAINTS;
DROP TABLE Works_On CASCADE CONSTRAINTS;
DROP TABLE Passenger_Flight_Info CASCADE CONSTRAINTS;
DROP TABLE Seats_On_Flight CASCADE CONSTRAINTS;
-- -----------------------------------------------------------------------------
-- Create the tables
-- -----------------------------------------------------------------------------
CREATE TABLE Passenger(
	passenger_id INTEGER PRIMARY KEY,
	name CHAR(20) NOT NULL,
	age INTEGER NOT NULL,
	guardian INTEGER /*Passengers over 16 do not need a guardian*/
);

CREATE TABLE Plane(
	plane_id INTEGER PRIMARY KEY,
	seating_capacity INTEGER NOT NULL,
	carrying_weight DOUBLE PRECISION NOT NULL
);

CREATE TABLE Maintained(
	plane_id INTEGER,
	service_date TIMESTAMP,
	essn INTEGER,
	PRIMARY KEY(plane_id, service_date, essn)
);

CREATE TABLE Flight(
	fid INTEGER PRIMARY KEY,
	origin CHAR(40),
	destination CHAR(40),
	ETD TIMESTAMP WITH LOCAL TIME STAMP,
	duration INTEGER,
	gate CHAR(10),
	plane_id INTEGER
);

CREATE TABLE Employee(
	essn INTEGER PRIMARY KEY,
	name CHAR(20) NOT NULL,
	job_title CHAR(20) NOT NULL
);

CREATE TABLE Certifications(
	essn INTEGER,
	certificate CHAR(20),
	PRIMARY KEY(essn, certificate)
);

CREATE TABLE Works_On(
	essn INTEGER,
	fid INTEGER,
	PRIMARY KEY(essn, fid)
);

CREATE TABLE Passenger_Flight_Info(
	passenger_id INTEGER,
	fid INTEGER,
	seat_number INTEGER,
	pieces_of_luggage INTEGER,
	PRIMARY KEY(passenger_id, fid, seat_number)
);

CREATE TABLE Seats_On_Flight(
	fid INTEGER,
	seat_number INTEGER,
	seat_type CHAR(10),
	PRIMARY KEY(fid, seat_number)
);
--
SET FEEDBACK OFF 
--
-- -----------------------------------------------------------------------------
-- Add the Foreign Keys
-- -----------------------------------------------------------------------------
ALTER TABLE passenger
ADD FOREIGN KEY (guardian) references passenger(passenger_id)
Deferrable initially deferred;

-- -----------------------------------------------------------------------------
-- Populate the database instance
-- -----------------------------------------------------------------------------
--< The INSERT statements that populate the tables> 
--Important: Keep the number of rows in each table small enough so that the results of 
--your queries can be verified by hand. See the Sailors database as an example.

INSERT INTO Passengers VALUES (10, 'Xinyi Ou', 21, NULL);
INSERT INTO Passengers VALUES (15, 'Ai Mei', 11, 10); /*needs guardian--Xinyi*/
--
SET FEEDBACK ON 
COMMIT 
-- 
--< One query (per table) of the form: SELECT * FROM table; in order to print out your 
--database > 
-- 
SELECT * FROM Passenger;
SELECT * FROM Plane;
SELECT * FROM Maintained;
SELECT * FROM Flight;
SELECT * FROM Employee;
SELECT * FROM Certifications;
SELECT * FROM Works_On;
SELECT * FROM Passenger_Flight_Info;
SELECT * FROM Seats_On_Flight;
--
--< The SQL queries>. Include the following for each query: 
--1. A comment line stating the query number and the feature(s) it demonstrates 
--(e.g. – Q25 – correlated subquery). 
--2. A comment line stating the query in English. 
--3. The SQL code for the query. 
-- 

/* (Q1) - self-join
 Find the passenger_id, name, and age of every passenger that has a guardian.
*/
-- <<<SQL CODE GOES HERE>>>
--

--< The insert/delete/update statements to test the enforcement of ICs > 
--Include the following items for every IC that you test (Important: see the next section titled 
--“Submit a final report” regarding which ICs to test). 
--A comment line stating: Testing: < IC name> 
--A SQL INSERT, DELETE, or UPDATE that will test the IC.

COMMIT 
-- 
SET ECHO OFF
SPOOL OFF
