--1. Function to check when insert ticket train_id in seat and train_id in schedule are the same
CREATE OR REPLACE FUNCTION check_train_id_match(p_schedule_id int, p_seat_id int)
RETURNS BOOLEAN AS $$
DECLARE 
  a int;
BEGIN
    SELECT count(s.seat_id) into a
    FROM seat s, train_schedule ts
    WHERE s.seat_id = p_seat_id
	AND ts.schedule_id = p_schedule_id
	AND ts.train_id = s.train_id;
	if( a = 1 ) then 
		return true;
	else 
		return false;
	end if;
END;
$$ LANGUAGE plpgsql;

