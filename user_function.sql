--1. Function get information about station_name and get station_id
CREATE OR REPLACE FUNCTION check_station(station_name1 VARCHAR)
RETURNS varchar -- Assuming station_id is of INTEGER type
AS 
$$
DECLARE
    station_id1 varchar;
BEGIN
    SELECT station_id INTO station_id1
    FROM station
    WHERE station_name = station_name1;

    -- If the station is not found, you might want to handle that case
    IF station_id1 IS NULL THEN
        RETURN NULL; -- or handle it in another way
    END IF;

    RETURN station_id1;
END
$$
LANGUAGE plpgsql;


--2. Funciton get information about schedule 
CREATE OR REPLACE FUNCTION show_schedule(station_from VARCHAR, station_to VARCHAR, depart_time DATE)
RETURNS TABLE (schedule_id1 int, from1 VARCHAR, to1 VARCHAR, depart TIMESTAMP, arrival TIMESTAMP)
AS  
$$ 
DECLARE 
    from_name VARCHAR;
    to_name VARCHAR;
BEGIN 
    SELECT check_station(station_from) INTO from_name;
    SELECT check_station(station_to) INTO to_name;

    RETURN QUERY
    SELECT  schedule_id, station_from, station_to , departure_time, arrival_time  
    FROM train_schedule 
    WHERE station_from_id = from_name AND station_to_id = to_name AND date(departure_time) = depart_time;
END
$$
LANGUAGE plpgsql;

---3. Function to get all seat with schedule id
CREATE OR REPLACE FUNCTION get_seat_all(schedule_id integer)
RETURNS TABLE(
	seat_id integer,
	seat_coach integer,
	seat_number integer
) AS
$$
BEGIN
	RETURN QUERY
	SELECT s.seat_id, s.coach, s.number_seat
	FROM seat s, train_schedule ts
	WHERE ts.train_id=s.train_id
	AND ts.schedule_id=$1;
END;
$$
LANGUAGE plpgsql;


--4. Function to get all seat are booked with schedule_id
CREATE OR REPLACE FUNCTION check_overlap_integer(range1_start INT, range1_end INT, range2_start INT, range2_end INT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN range1_end > range2_start AND range1_start < range2_end;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_seat_booked(p_schedule_id integer)
RETURNS TABLE(
	seat_id integer,
	seat_coach integer,
	seat_number integer
) AS
$$
DECLARE 
	from_no int;
	to_no int;
	d date;
	tr int:= (select train_id from train_schedule where schedule_id = p_schedule_id);
BEGIN
	
	SELECT ts.arrival_time, s1.no, s2.no into d, from_no, to_no
	FROM train_schedule ts, stop s1, stop s2, train t
	WHERE ts.schedule_id = p_schedule_id
	AND ts.train_id = s1.train_id AND ts.station_from_id = s1.station_id
	AND ts.train_id = s2.train_id AND ts.station_to_id = s2.station_id;
	
	
	RETURN QUERY
	SELECT DISTINCT(s.seat_id), s.coach, s.number_seat
	FROM seat s
	JOIN ticket t ON s.seat_id= t.seat_id 
	JOIN train_schedule ts ON ts.train_id = tr
	WHERE t.schedule_id = $1  
	OR (
		t.schedule_id != $1
		AND cast(ts.arrival_time as date) = d
		AND check_overlap_integer(t.departure_no, t.arrival_no, from_no, to_no)
	);
	
END;
$$
LANGUAGE plpgsql;

--5. Function to get all seat are empty with schedule_id
CREATE OR REPLACE FUNCTION get_seat_empty(schedule_id integer)
RETURNS TABLE(
	seat_id integer,
	seat_coach integer,
	seat_number integer
) AS
$$
BEGIN
	RETURN QUERY
	SELECT A.seat_id, A.seat_coach, A.seat_number
	FROM get_seat_all($1) A 
	LEFT JOIN get_seat_booked($1) B ON A.seat_id=B.seat_id
	WHERE B.seat_id IS NULL;
END;
$$
LANGUAGE plpgsql;

--6. Calculate price depend on time in train_schedule 
CREATE OR REPLACE FUNCTION price_per_time(departure timestamp, arrival timestamp)
	RETURNS integer
	AS
	$$
	DECLARE
		price integer;
		time_dis interval;
	BEGIN
		-- Calculate the time difference between arrival and departure
		time_dis := arrival - departure;

		-- Calculate the price based on the time difference in minutes
		price := EXTRACT(SECOND FROM time_dis) +
             EXTRACT(MINUTE FROM time_dis) * 60 +
             EXTRACT(HOUR FROM time_dis) * 3600 +
             EXTRACT(DAY FROM time_dis) * 24 * 3600;

    -- Convert total time difference to minutes and calculate the price
    price := price / 60 * 1000;
		RETURN price;
	END;
	$$
	LANGUAGE plpgsql;

--7. Get price by schedule_id
CREATE OR REPLACE FUNCTION take_price(schedule_id1 integer, seat_id1 integer )
RETURNS integer
AS 
$$
DECLARE
    price_ticket integer;
    from_id varchar;
    to_id varchar;
    class1 char;
    coef float;
BEGIN
    
    SELECT class INTO class1 FROM seat WHERE seat_id = seat_id1;

    SELECT station_from_id, station_to_id INTO from_id, to_id
    FROM train_schedule
    WHERE schedule_id = schedule_id1;

    IF class1 = 'A' THEN 
        coef := 1.2;
    ELSIF class1 = 'B' THEN 
        coef := 1;
    ELSIF class1 = 'C' THEN 
        coef := 0.9;
    END IF;

    -- Call the price_per_time function with extracted station IDs
    price_ticket := coef * price_per_time(
        -- Replace with your actual column name
        (SELECT departure_time FROM train_schedule WHERE schedule_id = schedule_id1), 
        (SELECT arrival_time FROM train_schedule WHERE schedule_id = schedule_id1) -- Replace with your actual column name
    );

    RETURN price_ticket;
END;
$$
LANGUAGE plpgsql;

--8. Function book ticket for passenger
CREATE OR REPLACE FUNCTION book_ticket(schedule_id1 integer, seat_id1 integer, passenger_id1 integer)
RETURNS void 
AS 
$$
DECLARE
    standard_price integer;
    price_ticket integer;
    ticket_type1 varchar;
    ages integer;
    from_no integer;
	to_no integer;
BEGIN
    standard_price := take_price(schedule_id1);
	
	SELECT s1.no, s2.no into from_no, to_no
	FROM train_schedule ts, stop s1, stop s2
	WHERE ts.schedule_id = schedule_id1
	AND ts.train_id = s1.train_id AND ts.station_from_id = s1.station_id
	AND ts.train_id = s2.train_id AND ts.station_to_id = s2.station_id;
	
    SELECT EXTRACT(YEAR FROM AGE(NOW(), dob)) INTO ages
    FROM passenger
    WHERE passenger_id = passenger_id1;

    IF ages >= 60 THEN
        ticket_type1 := 'Elder';
        price_ticket := standard_price * 0.85;
    ELSIF ages <= 6 THEN
        ticket_type1 := 'Children';
        price_ticket := standard_price * 0.50;
    ELSIF ages >= 18 AND ages <= 22 THEN
        ticket_type1 := 'Student';
        price_ticket := standard_price * 0.9;
    ELSE
        ticket_type1 := 'Adult';
        price_ticket := standard_price;
    END IF;

    -- Insert into the ticket table
    INSERT INTO ticket(price, ticket_type, schedule_id, seat_id, arrival_no, departure_no, passenger_id)
    VALUES (price_ticket, ticket_type1, schedule_id1, seat_id1, to_no, from_no, passenger_id1);
END;
$$
LANGUAGE plpgsql;