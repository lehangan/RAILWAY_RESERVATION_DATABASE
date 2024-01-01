---- funciton test
drop function get_seat_all(int)

--- funciton get_seat_all
CREATE OR REPLACE FUNCTION get_seat_all(schedule_id integer)
RETURNS TABLE(
	seat_id integer,
	seat_coach integer,
	seat_number integer,
	train_name varchar(10)
) AS
$$
BEGIN
	RETURN QUERY
	SELECT s.seat_id, s.coach, s.number_seat, t.train_name
	FROM seat s, train t, train_schedule ts
	WHERE t.train_id = s.train_id
	AND ts.train_id=s.train_id
	AND ts.schedule_id=$1;
END;
$$
LANGUAGE plpgsql;

SELECT * FROM get_seat_all(10);

--- funciton get_seat_booked
SELECT ts.train_id, ts.station_from_id, ts.station_to_id, s1.no AS station_from_no, s2.no AS station_to_no
FROM train_schedule ts, stop s1, stop s2
WHERE ts.train_id = s1.train_id AND ts.station_from_id = s1.station_id
AND ts.train_id = s2.train_id AND ts.station_to_id = s2.station_id;

drop function get_seat_booked(integer);
CREATE OR REPLACE FUNCTION get_seat_booked(p_schedule_id integer)
RETURNS TABLE(
	seat_id integer,
	seat_coach integer,
	seat_number integer
) AS
$$
BEGIN
	RETURN QUERY
	SELECT s.seat_id, s.coach, s.number_seat
	FROM seat s, train_schedule ts, stop s1, stop s2
	JOIN ticket t ON s.seat_id= t.seat_id --- trung ghe
	WHERE t.schedule_id = $1 -- trung lich 
	AND ts.train_id = s.train_id
	AND ts.train_id = s1.train_id
	AND ts.train_id = s2.train_id
	OR (
		t.schedule_id != $1
		AND ts.train_id = 
	);
END;
$$
LANGUAGE plpgsql;

SELECT * FROM get_seat_booked(10);

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
