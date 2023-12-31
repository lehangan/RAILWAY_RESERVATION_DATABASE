select ts.train_id, ts.station_from_id, ts.station_to_id, 
from train_schedule ts, stop s
where staion


SELECT ts.train_id, ts.station_from_id, ts.station_to_id, s1.no AS station_from_no, s2.no AS station_to_no
FROM train_schedule ts, stop s1, stop s2
WHERE ts.train_id = s1.train_id AND ts.station_from_id = s1.station_id
AND ts.train_id = s2.train_id AND ts.station_to_id = s2.station_id;

SELECT ts.train_id, ts.station_from_id, ts.station_to_id, s1.no AS station_from_no, s2.no AS station_to_no
FROM train_schedule ts
JOIN stop s1 ON ts.train_id = s1.train_id AND ts.station_from_id = s1.station_id
JOIN stop s2 ON ts.train_id = s2.train_id AND ts.station_to_id = s2.station_id;

CREATE OR REPLACE FUNCTION check_overlap()
RETURNS TRIGGER AS $$
DECLARE
  	overlap_count INTEGER;
BEGIN
  	SELECT COUNT(*) INTO overlap_count
  	FROM reservation r
  	JOIN train_schedule ts1 ON r.ticket_id = ts1.schedule_id
  	JOIN train_schedule ts2 ON NEW.ticket_id = ts2.schedule_id
  	JOIN stop s1 ON ts1.station_from_id = s1.station_id AND ts1.train_id = s1.train_id
  	JOIN stop s2 ON ts2.station_from_id = s2.station_id AND ts2.train_id = s2.train_id
  	WHERE ts1.train_id = ts2.train_id AND (s1.no, s2.no) OVERLAPS (r.departure_no, r.arrival_no);

  	IF overlap_count > 0 THEN
    	RAISE EXCEPTION 'The new reservation overlaps with an existing reservation for the same train.';
  	END IF;

  	RETURN NEW;
END; 
$$ LANGUAGE plpgsql;

CREATE TRIGGER reservation_insert_trigger
BEFORE INSERT ON reservation
FOR EACH ROW EXECUTE FUNCTION check_overlap();
