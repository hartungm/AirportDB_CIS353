SPOOL project.out
SET ECHO ON

/* 
CIS 353 - Database Design Project (PEMN-X Airport)
Nick Bushen
Patrick Dishaw
Evan Dunne
Michael Hartung
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
--
-- -----------------------------------------------------------------------------
-- Create the tables
-- -----------------------------------------------------------------------------
CREATE TABLE Passenger(
	passenger_id INTEGER,
	name CHAR(20) NOT NULL,
	age INTEGER NOT NULL,
	guardian INTEGER /*Passengers over 16 do not need a guardian*/
--
-- passIC1: passenger IDs are unique
CONSTRAINT passIC1 PRIMARY KEY (passenger_id),
-- passIC2: every guardian must be a passenger too	
CONSTRAINT passIC2 FOREIGN KEY (guardian) REFERENCES passenger(passenger_id)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED,
-- passIC3: if a passenger's age is 16 or under, he or she must have a guardian
CONSTRAINT passIC3 CHECK (guardian IS NOT NULL OR age > 16)
);
--
CREATE TABLE Plane(
	plane_id INTEGER,
	seating_capacity INTEGER NOT NULL,
--
-- planeIC1: plane IDs are unique
CONSTRAINT planeIC1 PRIMARY KEY (plane, id),
-- planeIC2: seating_capacity must be greater than zero
CONSTRAINT planeIC2 CHECK (seating_capacity > 0)
);
--
CREATE TABLE Maintained(
	plane_id INTEGER,
	service_date TIMESTAMP,
	essn INTEGER,
--
-- mainIC1: maintenance record has unique plane, timestamp, and personnel
CONSTRAINT mainIC1 PRIMARY KEY(plane_id, service_date, essn)
);
--
CREATE TABLE Flight(
	fid INTEGER,
	origin CHAR(40) NOT NULL,
	destination CHAR(40) NOT NULL,
	ETD TIMESTAMP NOT NULL,
	duration INTEGER NOT NULL,
	gate CHAR(3) NOT NULL,
	plane_id INTEGER NOT NULL
--
-- flightIC1: flight IDs are unique
CONSTRAINT flightIC1 PRIMARY KEY (fid),
-- flightIC2: flight must have different origin and destination
CONSTRAINT flightIC2 CHECK (NOT origin = destination),
-- flightIC3: flight duration must be greater than zero
CONSTRAINT flightIC3 CHECK (duration > 0)
-- flightIC4: gate name must be a gate from PEMN-X airport
CONSTRAINT flightIC4 CHECK gate IN ('A1', 'A2', 'A3', 'A4', 'B1', 'B2', 'B3', 'B4')
);
--
CREATE TABLE Employee(
	essn INTEGER PRIMARY KEY,
	name CHAR(20) NOT NULL,
	job_title CHAR(20) NOT NULL
--
-- <<more constraints needed!>>
);
--
CREATE TABLE Certifications(
	essn INTEGER,
	certificate CHAR(20),
	PRIMARY KEY(essn, certificate)
--
-- <<more constraints needed!>>
);
--
CREATE TABLE Works_On(
	essn INTEGER,
	fid INTEGER,
	PRIMARY KEY(essn, fid)
--
-- <<more constraints needed!>>
);
--
CREATE TABLE Passenger_Flight_Info(
	passenger_id INTEGER,
	fid INTEGER,
	seat_number INTEGER NOT NULL,
	PRIMARY KEY(passenger_id, fid)
-- <<more constraints needed!>>
);
--
CREATE TABLE Seat_On_Flight(
	fid INTEGER,
	seat_number INTEGER NOT NULL,
	seat_type CHAR(10) NOT NULL,
	PRIMARY KEY(fid, seat_number)
--
-- <<more constraints needed!>>
);
--
SET FEEDBACK OFF 
--
-- -----------------------------------------------------------------------------
-- Add the Foreign Keys
-- -----------------------------------------------------------------------------
ALTER TABLE Maintained
ADD CONSTRAINT fk1 (plane_id) REFERENCES Plane(plane_id)
ON UPDATE CASCADE
ON DELETE CASCADE
Deferrable initially deferred;
--
ALTER Table Maintained
ADD CONSTRAINT fk2 (essn) REFERENCES Employee(essn)
ON UPDATE CASCADE
Deferrable initially deferred;
--
ALTER TABLE Flight 
ADD CONSTRAINT fk3 (plane_id) REFERENCES Plane(plane_id)
ON UPDATE CASCADE
Deferrable initially deferred;
--
-- <<More foreign keys needed for tables after listed after flight>>
--
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
-- -----------------------------------------------------------------------------
-- Show the database instance
-- -----------------------------------------------------------------------------
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
-- -----------------------------------------------------------------------------
-- Perform SQL Queries
-- -----------------------------------------------------------------------------
--Include the following for each query: 
--1. A comment line stating the query number and the feature(s) it demonstrates 
--(e.g. – Q25 – correlated subquery). 
--2. A comment line stating the query in English. 
--3. The SQL code for the query. 
--
--IMPORTANT: You may of course demonstrate more than one feature in any one query 
--and thus end up having to write fewer, but more interesting, queries. 
--
/* (Q1) - A join involving at least four relations
english description goes here
*/
--<<<SQL CODE GOES HERE>>>
--
/* (Q2) - A self-join
 Find the passenger_id, name, and age of every passenger that has a guardian.
*/
-- <<<SQL CODE GOES HERE>>>
--
/* (Q3) - UNION, INTERSECT, and/or MINUS in a query
english description goes here
*/
-- <<<SQL CODE GOES HERE>>>
--
/* (Q4) - SUM, AVG, MAX, and/or MIN in a query
english description goes here
*/
-- <<<SQL CODE GOES HERE>>>
--
/* (Q5) - GROUP BY, HAVING, and ORDER BY, all appearing in the same query
english description goes here
*/
-- <<<SQL CODE GOES HERE>>>
--
/* (Q6) - A correlated subquery
english description goes here
*/
-- <<<SQL CODE GOES HERE>>>
--
/* (Q7) - A non-correlated subquery
english description goes here
*/
-- <<<SQL CODE GOES HERE>>>
--
/* (Q8) -  A relational DIVISION query
english description goes here
*/
-- <<<SQL CODE GOES HERE>>>
--
/* (Q9) - An outer join query
english description goes here
*/
-- <<<SQL CODE GOES HERE>>>
--
-- -----------------------------------------------------------------------------
-- Test Integrity Constraints
-- -----------------------------------------------------------------------------
--< The insert/delete/update statements to test the enforcement of ICs > 
--Include the following items for every IC that you test (Important: see the next section titled 
--“Submit a final report” regarding which ICs to test). 
--A comment line stating: Testing: < IC name> 
--A SQL INSERT, DELETE, or UPDATE that will test the IC.
--
/* Testing: PassIC1 */
INSERT INTO Passengers VALUES (10, 'Jonathan Rosales', 29, NULL);
--
/* Testing: PassIC2 */
INSERT INTO Passengers VALUES (5, 'Mary Ramus', 54, 2);
--
/* Testing: PassIC3 */
INSERT INTO Passengers VALUES (1, 'Trinity Marcus', 8, NULL);

/* Testing: PassIC3 */
INSERT INTO Passengers VALUES (1, 'Trinity Marcus', 16, NULL);

COMMIT 
-- 
SET ECHO OFF
SPOOL OFF
