---1. Function to get all seat with schedule id
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


--2. Function to get all seat are booked with schedule_id
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

--3. Function to get all seat are empty with schedule_id
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