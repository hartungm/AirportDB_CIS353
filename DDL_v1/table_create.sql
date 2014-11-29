SPOOL project.out
SET ECHO ON

/* 
Test Comment
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
	guardian INTEGER, /*Passengers over 16 do not need a guardian*/
--
-- passIC1: passenger IDs are unique
CONSTRAINT passIC1 PRIMARY KEY (passenger_id),
-- passIC2: every guardian must be a passenger too	
CONSTRAINT passIC2 FOREIGN KEY (guardian) REFERENCES passenger(passenger_id)
	ON DELETE CASCADE
	DEFERRABLE INITIALLY DEFERRED,
-- passIC3: if a passenger's age is 16 or under, he or she must have a guardian
CONSTRAINT passIC3 CHECK (guardian IS NOT NULL OR age > 16)
-- passIC4: age must be between 0 and 120 (reasonable for flying)
CONSTRAINT passIC4 CHECK (age >= 0 AND age <= 120)
);
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
-- mainIC2: Only maintenance workers can maintain on a plane (Not sure about this one)
CONSTRAINT mainIC2 CHECK( VALUE IN (SELECT E.essn FROM Employee E WHERE E.job_title = 
'mechanic')
);
--
CREATE TABLE Flight(
	fid INTEGER,
	origin CHAR(40) NOT NULL,
	destination CHAR(40) NOT NULL,
	ETD TIMESTAMP NOT NULL,
	ETA TIMESTAMP NOT NULL,
	gate CHAR(3) NOT NULL,
	plane_id INTEGER NOT NULL,
--
-- flightIC1: flight IDs are unique
CONSTRAINT flightIC1 PRIMARY KEY (fid),
-- flightIC2: flight must have different origin and destination
CONSTRAINT flightIC2 CHECK (NOT (origin = destination)),
-- flightIC3: flight departure must precede flight arrival
CONSTRAINT flightIC3 CHECK (ETD < ETA),
-- flightIC4: gate name must be a gate from PEMN-X airport
CONSTRAINT flightIC4 CHECK (gate IN ('A1', 'A2', 'A3', 'A4', 
				    'B1', 'B2', 'B3', 'B4'))
);
--
CREATE TABLE Employee(
	essn INTEGER PRIMARY KEY,
	name CHAR(20) NOT NULL,
	job_title CHAR(20) NOT NULL
--
-- <<more constraints needed!>>
--emplIC1: Job Title must either be pilot, attendant, or mechanic
CONSTRAINT emplIC1 CHECK (job_title IN ('pilot', 'attendant', 'mechanic')
);
--
CREATE TABLE Certifications(
	essn INTEGER,
	certificate CHAR(20) NOT NULL,
	PRIMARY KEY(essn, certificate)
--
-- <<more constraints needed!>>
--CertIC1: An employee must exist to be certified
CONSTRAINT CertIC1 FOREIGN KEY (essn) REFERENCES Employee(essn)
Deferrable initially deferred;
);
--
CREATE TABLE Works_On(
	essn INTEGER,
	fid INTEGER,
	PRIMARY KEY(essn, fid)
--
-- <<more constraints needed!>>
-- WorkIC1: Employee must be in the Employee database
CONSTRAINT WorkIC1 FOREIGN KEY (essn) REFERENCES Employee(essn)
Deferrable initially deferred
-- WorkIC2: The flight that the employees work on must exist
CONSTRAINT WorkIC2 FOREIGN KEY (fid) REFERENCES Flight(fid);
Deferrable initially deferred
);
--
CREATE TABLE Passenger_Flight_Info(
	passenger_id INTEGER,
	fid INTEGER,
	seat_number INTEGER NOT NULL,
	PRIMARY KEY(passenger_id, fid)
-- <<more constraints needed!>>
-- PassFlightIC1: passenger id must reference a passenger
CONSTRAINT PassFlightIC1 FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id)
Deferrable initially deferred
-- PassFlightIC2: flight must exist
CONSTRAINT PassFlightIC2 FOREIGN KEY (fid) REFERENCES Flight(fid)
Deferrable initially deferred
);
--
CREATE TABLE Seat_On_Flight(
	fid INTEGER,
	seat_number INTEGER NOT NULL,
	seat_type CHAR(10) NOT NULL,
	PRIMARY KEY(fid, seat_number)
-- SeatOnIC1: flight must exist
CONSTRAINT SeatOnIC1 FOREIGN KEY (fid) REFERENCES Flight(fid)
-- SeatOnIC2: seat_number cannot be less than zero 
-- (should/could we make this so that seat number is not greater than the seating 
-- capacity for the plane we are flying on?)
CONSTRAINT SeatOnIC1 CHECK seat_number > 0
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
Deferrable initially deferred;
--
ALTER Table Maintained
ADD CONSTRAINT fk2 (essn) REFERENCES Employee(essn)
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
-- Stored Procedures
-- -----------------------------------------------------------------------------
--
/* (SP1)
 Calculates the number of passengers currently booked on a given flight
*/
CREATE OR REPLACE FUNCTION numPassengers(id IN Passenger_Flight_Info.fid%TYPE) 
RETURN INTEGER IS
--
num INTEGER;
  BEGIN
    SELECT Count(*) INTO num
    FROM Passenger_Flight_Info F
    WHERE F.fid = id;
  RETURN num;
END numPassengers;
SHOW ERROR 
SELECT OBJECT_NAME FROM USER_PROCEDURES;
--
--
-- -----------------------------------------------------------------------------
-- Populate the database instance
-- -----------------------------------------------------------------------------
--< The INSERT statements that populate the tables> 
--Important: Keep the number of rows in each table small enough so that the results of 
--your queries can be verified by hand. See the Sailors database as an example.

INSERT INTO Passengers VALUES (10, 'Xinyi Ou', 21, NULL);
INSERT INTO Passengers VALUES (15, 'Ai Mei', 11, 10); /*needs guardian--Xinyi*/
INSERT INTO Passengers VALUES (20, 'Eric Joffrey', 54, NULL);
INSERT INTO Passengers VALUES (25, 'Allie Rowe', 31, NULL);
INSERT INTO Passengers VALUES (30, 'Lucille Holloway', 24, NULL);
INSERT INTO Passengers VALUES (35, 'Mohammed Tawfiq', 44, NULL);
INSERT INTO Passengers VALUES (40, 'Adam Joffrey', 5, 20);
INSERT INTO Passengers VALUES (45, 'Ada Joffrey', 7, 20);
INSERT INTO Passengers VALUES (50, 'Jonathan Ramirez', 19, NULL);
--
INSERT INTO Plane VALUES (100, 6);
INSERT INTO Plane VALUES (211, 120);
INSERT INTO Plane VALUES (377, 85);
INSERT INTO Plane VALUES (401, 12);
--
INSERT INTO Maintained VALUES (100, TIMESTAMP '2014-11-01 07:35:21', 568-242-1353);
INSERT INTO Maintained VALUES (401, TIMESTAMP '2014-10-31 18:04:56', 333-456-2314);
INSERT INTO Maintained VALUES (211, TIMESTAMP '2014-11-04 09:37:40', 333-456-2314);
INSERT INTO Maintained VALUES (377, TIMESTAMP '2014-11-10 16:12:22', 568-242-1353);
INSERT INTO Maintained VALUES (100, TIMESTAMP '2014-11-17 10:13:00', 568-242-1353);
INSERT INTO Maintained VALUES (211, TIMESTAMP '2014-11-16 11:11:45', 333-456-2314);
--
INSERT INTO Flight VALUES(1024, 'Allendale, MI', 'Detroit, MI', TIMESTAMP '2014-11-21 10:32:00',
		TIMESTAMP '2014-11-21 13:37:00', 'A3', 100);
INSERT INTO Flight VALUES(2204, 'Detroit, MI', 'Allendale, MI', TIMESTAMP '2014-11-21 5:15:00',
		TIMESTAMP '2014-11-21 8:20:00', 'A3', 100);
INSERT INTO Flight VALUES(9705, 'Allendale, MI', 'Seattle, WA', TIMESTAMP '2014-11-21 12:19:00',
		TIMESTAMP '2014-11-21 18:35:00', 'B1', 211);
INSERT INTO Flight VALUES(5536, 'Cincinnati, KY', 'Allendale, MI', TIMESTAMP '2014-11-22 14:09:00',
		TIMESTAMP '2014-11-22 15:20:00', 'A4', 401);
--
INSERT INTO Employee VALUES(333-456-2314, 'Richard Marks', 'Mechanic');
INSERT INTO Employee VALUES(568-240-1005, 'Elizabeth Volk', 'Mechanic');
INSERT INTO Employee VALUES(487-224-1285, 'Annabelle VanSickle', 'Attendant');
INSERT INTO Employee VALUES(235-669-4203, 'Mark DeRoy', 'Attendant');
INSERT INTO Employee VALUES(476-090-9232, 'Erin Tripp', 'Attendant');
INSERT INTO Employee VALUES(557-529-0975, 'Tricia Whittle', 'Pilot');
INSERT INTO Employee VALUES(880-236-1376, 'Brody Young', 'Pilot');
INSERT INTO Employee VALUES(234-612-4444, 'Olga Grianni', 'Pilot');
INSERT INTO Employee VALUES(777-956-2340, 'Matthew Ingall', 'Pilot');
--
INSERT INTO Certifications VALUES();
INSERT INTO Certifications VALUES();
INSERT INTO Certifications VALUES();
INSERT INTO Certifications VALUES();
INSERT INTO Certifications VALUES();
INSERT INTO Certifications VALUES();
--
INSERT INTO Works_On VALUES (487-224-1285, 1024); /*Annabelle, attendant*/
INSERT INTO Works_On VALUES (234-612-4444, 1024); /*Olga, pilot1*/
INSERT INTO Works_On VALUES (880-236-1376, 1024); /*Brody, pilot2*/
INSERT INTO Works_On VALUES (487-224-1285, 2204); /*Annabelle, attendant*/
INSERT INTO Works_On VALUES (880-236-1376, 2204); /*Brody, pilot1*/
INSERT INTO Works_On VALUES (557-529-0975, 2204); /*Tricia, pilot2*/
INSERT INTO Works_On VALUES (235-669-4203, 9705); /*Mark, attendant1*/
INSERT INTO Works_On VALUES (476-090-9232, 9705); /*Erin, attendant2*/
INSERT INTO Works_On VALUES (777-956-2340, 9705); /*Matthew, pilot1 */
INSERT INTO Works_On VALUES (557-529-0975, 9705); /*Tricia, pilot2 */
INSERT INTO Works_On VALUES (476-090-9232, 5536); /*Erin, attendant*/
INSERT INTO Works_On VALUES (234-612-4444, 5536); /*Olga, pilot1*/
INSERT INTO Works_On VALUES (880-236-1376, 5536); /*Brody, pilot2*/
--
INSERT INTO Passenger_Flight_Info VALUES (10, 1024, 1);
INSERT INTO Passenger_Flight_Info VALUES (15, 1024, 2);
INSERT INTO Passenger_Flight_Info VALUES (20, 1024, 3);
INSERT INTO Passenger_Flight_Info VALUES (30, 1024, 4);
INSERT INTO Passenger_Flight_Info VALUES (40, 1024, 5);
INSERT INTO Passenger_Flight_Info VALUES (45, 1024, 6);
INSERT INTO Passenger_Flight_Info VALUES (25, 2204, 4);
INSERT INTO Passenger_Flight_Info VALUES (35, 9705, 88);
INSERT INTO Passenger_Flight_Info VALUES (50, 5536, 10);
--
INSERT INTO Seat_On_Flight (1024, 1, 'Business');
INSERT INTO Seat_On_Flight (1024, 2, 'Business');
INSERT INTO Seat_On_Flight (1024, 3, 'Economy');
INSERT INTO Seat_On_Flight (1024, 4, 'Economy');
INSERT INTO Seat_On_Flight (1024, 5, 'Economy');
INSERT INTO Seat_On_Flight (1024, 6, 'Economy');
INSERT INTO Seat_On_Flight (2204, 4, 'First');
INSERT INTO Seat_On_Flight (9705, 88, 'Economy');
INSERT INTO Seat_On_Flight (5536, 10, 'First');
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
 Find the passenger_id, name, age, and guardian id of every passenger that has a guardian.
*/
SELECT p1.passenger_id, p1.name, p1.age, p2.passenger_id
FROM Passenger p1, Passenger p2
WHERE p1.guardian = p2.passenger_id;
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
/* Testing: PassIC1 (primary key)*/
INSERT INTO Passengers VALUES (10, 'Jonathan Rosales', 29, NULL);
--
/* Testing: PassIC2 (foreign key)*/
INSERT INTO Passengers VALUES (5, 'Mary Ramus', 54, 2);
--
/* Testing: PassIC3 */
INSERT INTO Passengers VALUES (1, 'Trinity Marcus', 8, NULL);

/* Testing: PassIC3 */
INSERT INTO Passengers VALUES (2, 'Abigail Lin', 16, NULL);

COMMIT 
-- 
SET ECHO OFF
SPOOL OFF
