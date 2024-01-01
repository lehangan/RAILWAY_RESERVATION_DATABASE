---- funciton test
drop function get_seat_all(int)

--- funciton get_seat_all
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

SELECT * FROM get_seat_all(10);

select 
CREATE OR REPLACE FUNCTION check_overlap_integer(range1_start INT, range1_end INT, range2_start INT, range2_end INT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN range1_end > range2_start AND range1_start < range2_end;
END;
$$ LANGUAGE plpgsql;

select check_overlap_integer(1,2,2,5);

--- funciton get_seat_booked
SELECT ts.schedule_id, s1.no AS station_from_no, s2.no AS station_to_no
FROM train_schedule ts, stop s1, stop s2
WHERE ts.train_id = s1.train_id AND ts.station_from_id = s1.station_id
AND ts.train_id = s2.train_id AND ts.station_to_id = s2.station_id;

delete from ticket
select * from ticket;
insert into ticket(price, ticket_type, schedule_id, seat_id, arrival_no, departure_no, passenger_id) values
(50000 , 'Student' , 1, 1,  2, 1, 1);


----------------------------------------

select * from test_function(1);
drop function test_function(int);

CREATE OR REPLACE FUNCTION test_function(p_schedule_id integer)
RETURNS table( 
	from_no int,
	to_no int,
	d date
) as
$$
DECLARE 
	from_no int;
	to_no int;
	d date;
BEGIN
-- 	SELECT ts.arrival_time, s1.no, s2.no into d, from_no, to_no
-- 	FROM train_schedule ts, stop s1, stop s2
-- 	WHERE ts.schedule_id = p_schedule_id
-- 	AND ts.train_id = s1.train_id AND ts.station_from_id = s1.station_id
-- 	AND ts.train_id = s2.train_id AND ts.station_to_id = s2.station_id;
	RETURN QUERY
	SELECT s1.no, s2.no, ts.arrival_time 
	FROM train_schedule ts, stop s1, stop s2
	WHERE ts.schedule_id = p_schedule_id
	AND ts.train_id = s1.train_id AND ts.station_from_id = s1.station_id
	AND ts.train_id = s2.train_id AND ts.station_to_id = s2.station_id;
	
END;
$$
LANGUAGE plpgsql;

--------------------------------
drop function get_seat_booked(integer);

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
BEGIN
	SELECT ts.arrival_time, s1.no, s2.no into d, from_no, to_no
	FROM train_schedule ts, stop s1, stop s2
	WHERE ts.schedule_id = p_schedule_id
	AND ts.train_id = s1.train_id AND ts.station_from_id = s1.station_id
	AND ts.train_id = s2.train_id AND ts.station_to_id = s2.station_id;
	
	
	RETURN QUERY
	SELECT DISTINCT(s.seat_id), s.coach, s.number_seat
	FROM seat s
	JOIN ticket t ON s.seat_id= t.seat_id 
	JOIN train_schedule ts ON ts.schedule_id = t.schedule_id
	WHERE t.schedule_id = $1  
	OR (
		t.schedule_id != $1
		AND cast(ts.arrival_time as date) = d
		AND check_overlap_integer(t.departure_no, t.arrival_no, from_no, to_no)
	);
	
END;
$$
LANGUAGE plpgsql;

SELECT * FROM get_seat_booked(3);

----------------------

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

select * from get_seat_empty(2);

select book_ticket(1,1,1);
--- MAKE_RESERVATION

CREATE OR REPLACE FUNCTION check_available_seat_in_schedule(p_schedule_id int, p_seat_id int)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE 
	a int;
	b int;
	c int;
BEGIN
	select count(*) from schedule_id into a where schedule_id = p_schedule_id;
	select count(*) from seat into c where seat_id = p_seat_id;
	if(a != 0 and c = 1) then
		select count(*) from ticket into b where schedule_id = p_schedule_id and seat_id = p_seat_id;
		if( b = 0) then
			return true;
		else
			raise notice 'Seat taken.';  
			return false;
		end if;
	else
		raise notice 'Schedule/Seat does not exist OR there is no available seat.'; 
		return false;
	end if;
END
$$;

