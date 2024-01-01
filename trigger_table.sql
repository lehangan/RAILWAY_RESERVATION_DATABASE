-- 1. Auto add seat when insert new train
CREATE OR REPLACE FUNCTION add_seat()
RETURNS TRIGGER AS 
$$
DECLARE
    seat_id_counter int := (SELECT COUNT(seat_id) FROM seat) ;  -- Initialize a counter for seat_id
BEGIN
		FOR coach in 1..5 LOOP
			FOR n in 1..60 LOOP
				seat_id_counter = seat_id_counter+1;
				IF coach = 1 then
				INSERT INTO seat VALUES (seat_id_counter, coach, n, NEW.train_id, 'A');
				END IF;
				IF coach = 2 OR coach = 3 OR coach = 4 then
				INSERT INTO seat VALUES (seat_id_counter, coach, n, NEW.train_id, 'B');
				END IF;
				IF coach = 5 then
				INSERT INTO seat VALUES (seat_id_counter, coach, n, NEW.train_id, 'C');
				END IF;
				
			END LOOP;
		END LOOP;
		RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_add_seat
AFTER INSERT ON train
FOR EACH ROW
EXECUTE PROCEDURE add_seat();


--2. Trigger don't allow to add seat when total seat exceed or total seat by coach exceed 
CREATE OR REPLACE FUNCTION unable_to_insert_seat()
RETURNS TRIGGER LANGUAGE plpgsql
AS 
$$
DECLARE 
    a int := (SELECT COUNT(*) FROM seat WHERE train_id = NEW.train_id);
    b int := (SELECT COUNT(DISTINCT coach) FROM seat WHERE train_id = NEW.train_id);
    c int;
BEGIN
    -- Check if total seats exceed the limit
    IF (a > 299) AND (TG_TABLE_NAME ILIKE 'SEAT') THEN
        RAISE NOTICE 'CANNOT INSERT/DELETE SEAT (%). Total seats for train_id % exceeds the limit.', a, NEW.train_id;
        RETURN NULL;
    END IF;

    -- Check if any coach has more than 59 seats
    SELECT COUNT(*) INTO c
    FROM (
        SELECT coach, COUNT(*) as seat_count
        FROM seat
        WHERE train_id = NEW.train_id
        GROUP BY coach
        HAVING COUNT(*) > 59
    ) subquery;

    IF (c > 0) THEN
        RAISE NOTICE 'CANNOT INSERT/DELETE SEAT (%). Some coaches for train_id % have more than 60 seats.', c, NEW.train_id;
        RETURN NULL;
    END IF;

    RETURN NEW;
END
$$;

CREATE OR REPLACE TRIGGER trigger_unable_to_insert_seat
BEFORE INSERT ON seat
FOR EACH ROW
EXECUTE PROCEDURE unable_to_insert_seat();


--3. Trigger don't allow insert train_schedule when have conflict 
CREATE OR REPLACE FUNCTION train_schedule_problem()
RETURNS TRIGGER LANGUAGE plpgsql
AS $$
DECLARE 
	a record;
BEGIN
	for a in ( select arrival_time, departure_time, train_schedule.train_id, track_number
				from train_schedule
			  	where new.train_id != train_id
			  	and train_schedule.track_number = new.track_number
			    and (
					cast(train_schedule.arrival_time as date) = cast(new.arrival_time as date)
			  		or cast(train_schedule.departure_time as date) = cast(new.departure_time as date)
				)
			 ) loop
		if( ( cast(a.arrival_time as time), cast(a.departure_time as time) )
		   	overlaps ( cast(new.departure_time as time), cast(new.arrival_time as time) ) 
		  ) then 
			raise notice 'Overlap detected: train_id=%, track_number=%, arrival_time=%, departure_time=%',
      			NEW.train_id, NEW.track_number, NEW.arrival_time, NEW.departure_time ; 
			return null;
		end if;
	end loop;
	return new;
END
$$;

CREATE OR REPLACE TRIGGER solve_train_schedule_problem
BEFORE INSERT ON train_schedule
FOR EACH ROW
EXECUTE PROCEDURE train_schedule_problem();


--4. Trigger don't allow insert train_schedule when not having enough time for passenger
CREATE OR REPLACE FUNCTION train_schedule_minutes_atleast()
RETURNS TRIGGER LANGUAGE plpgsql
AS $$
DECLARE 
	a record;
BEGIN
	for a in ( select arrival_time, departure_time, train_schedule.train_id, track_number
				from train_schedule
			  	where train_id = new.train_id
			  	and train_schedule.track_number = new.track_number
			    and (
					cast(train_schedule.arrival_time as date) = cast(new.arrival_time as date)
			  		and cast(train_schedule.departure_time as date) = cast(new.departure_time as date)
				)
			  	and station_to_id = new.station_from_id
			 ) loop
		if( cast (new.departure_time as time) - cast(a.arrival_time as time) < interval '15 minutes' ) then 
			raise notice 'Not enough time for passenger: % < 15 minutes',  (cast (new.departure_time as time) - cast(a.arrival_time as time)) ; 
			return null;
		end if;
	end loop;
	return new;
END
$$;

CREATE OR REPLACE TRIGGER at_least_15_miniute
BEFORE INSERT ON train_schedule
FOR EACH ROW
EXECUTE PROCEDURE train_schedule_minutes_atleast();


--5. Trigger to check when insert ticket train_id in seat and train_id in schedule are the same
CREATE OR REPLACE FUNCTION check_train_id_match()
RETURNS TRIGGER AS $$
BEGIN
  IF NOT EXISTS (
    SELECT s.seat_id
    FROM seat s, train_schedule ts
    WHERE s.seat_id = NEW.seat_id 
	AND ts.schedule_id = NEW.schedule_id
	AND ts.train_id = s.train_id
  ) THEN
    RAISE NOTICE 'This train do not have this schedule';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_check_train_id_match
BEFORE INSERT ON ticket
FOR EACH ROW
EXECUTE FUNCTION check_train_id_match();


--6. Check overlap arrival_no and departure_no when insert reservation
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
    RAISE NOTICE 'The new reservation overlaps with an existing reservation for the same train.';
  END IF;

  RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER reservation_insert_trigger
BEFORE INSERT ON reservation
FOR EACH ROW EXECUTE FUNCTION check_overlap();