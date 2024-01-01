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


--2. Check overlap arrival_no and departure_no when insert reservation
CREATE OR REPLACE FUNCTION check_overlap(p_ticket_id int, arr int, depart int)
RETURNS TRIGGER AS $$
DECLARE
  overlap_count int;
  train_check int
BEGIN
  select tr.train_id into train_check
  from train tr, ticket t, seat se
  where t.seat_id = se.seat_id
  and se.train_id = tr.train_id
  
  select count(r.*) into overlap_count
  from reservation r, ticket t, seat se, train t
  JOIN stop s1 ON ts1.station_from_id = s1.station_id AND ts1.train_id = s1.train_id
  JOIN stop s2 ON ts1.station_to_id = s2.station_id AND ts1.train_id = s2.train_id
  where r.ticket_id = t.ticket_id
  and se.seat_id = t.seat_id
  and t.train_id = train_check
  and not
  
  JOIN ticket t ON r.ticket_id = t.ticket_id
  JOIN train_schedule ts1 ON t.schedule_id = ts1.schedule_id
  JOIN stop s1 ON ts1.station_from_id = s1.station_id AND ts1.train_id = s1.train_id
  JOIN stop s2 ON ts1.station_to_id = s2.station_id AND ts1.train_id = s2.train_id
  WHERE NOT( s2.no <= new.departure_no OR new.arrival_no <= s1.no );
  IF overlap_count > 0 THEN
    RAISE EXCEPTION 'The new reservation overlaps with an existing reservation for the same train.';
  END IF;

  RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER reservation_insert_trigger
BEFORE INSERT ON reservation
FOR EACH ROW EXECUTE FUNCTION check_overlap();