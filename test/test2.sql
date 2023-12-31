select ts.train_id, ts.station_from_id, ts.station_to_id, 
from train_schedule ts, stop s
where staion

select * from reservation
select * from ticket
select * from seat
select * from passenger
select * from station
select * from train
select * from stop
select * from train_schedule

insert into ticket(price, ticket_type, schedule_id, seat_id) values
(50000, 'Student', 4, 2)

insert into reservation(ticket_id, passenger_id, reservation_date, arrival_no, departure_no) values
(4 , 1, '2024-01-01' , 2 ,1)

select not (2 <= 2 OR 3 <= 1)

insert into reservation(ticket_id, passenger_id, reservation_date, arrival_no, departure_no) values
(5, 1, '2024-01-01' , 3 ,2)

insert into reservation(ticket_id, passenger_id, reservation_date, arrival_no, departure_no) values
(6, 1, '2024-01-01' , 5 ,1)

SELECT ts.train_id, ts.station_from_id, ts.station_to_id, s1.no AS station_from_no, s2.no AS station_to_no
FROM train_schedule ts, stop s1, stop s2
WHERE ts.train_id = s1.train_id AND ts.station_from_id = s1.station_id
AND ts.train_id = s2.train_id AND ts.station_to_id = s2.station_id;

SELECT ts.train_id, ts.station_from_id, ts.station_to_id, s1.no AS station_from_no, s2.no AS station_to_no
FROM train_schedule ts
JOIN stop s1 ON ts.train_id = s1.train_id AND ts.station_from_id = s1.station_id
JOIN stop s2 ON ts.train_id = s2.train_id AND ts.station_to_id = s2.station_id;

select (2,6) overlaps (4,5)


CREATE OR REPLACE FUNCTION check_overlap()
RETURNS TRIGGER AS $$
DECLARE
  overlap_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO overlap_count
  FROM reservation r
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

drop trigger 

