---- Giá dựa trên quãng thời gian đi 
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

--------------------- lấy giá dựa trên schedule_id 
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
------------------------------
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
    standard_price := take_price(schedule_id1,seat_id1);
	
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
    VALUES (price_ticket, ticket_type1, schedule_id1, seat_id1,from_no, to_no, passenger_id1);
END;
$$
LANGUAGE plpgsql;
