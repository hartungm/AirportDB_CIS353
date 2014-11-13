CREATE TABLE Passenger(
	passenger_id INTEGER PRIMARY KEY,
	name CHAR(20),
	age INTEGER,
	guardian CHAR(20)
);

CREATE TABLE Plane(
	plane_id INTEGER PRIMARY KEY,
	seating_capacity INTEGER,
	carrying_weight DOUBLE PRECISION
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
	flight_date TIMESTAMP,
	ETD TIMESTAMP,
	duration INTEGER,
	gate CHAR(10),
	plane_id INTEGER
);

CREATE TABLE Employee(
	essn INTEGER PRIMARY KEY,
	name CHAR(20),
	job_title CHAR(20)
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