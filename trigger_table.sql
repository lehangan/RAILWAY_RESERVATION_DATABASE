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
RETURNS TRIGGER
LANGUAGE plpgsql
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
        HAVING COUNT(*) > 60
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
