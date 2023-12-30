delete from train
delete from station

delete from stop
delete from passenger
delete from seat

select * from ticket
select * from seat
select * from passenger
select * from station
select * from train
select * from stop
select * from train_schedule

insert into train_schedule(arrival_time, departure_time, track_number, station_to_id, station_from_id , train_id) 
values
('1/1/2024 6:00','1/1/2024 6:15',1,'LOB','HAN',1)

insert into train(train_id, train_name) values
(1,'HN1')

insert into ticket(price, ticket_type, schedule_id, seat_id) values
('56000' ,'Student' , 1, 5 )

insert into seat(seat_id, coach, number_seat, train_id, class) values
(301, 5, 58, 1, 'C')

insert into passenger(phone, email, password, name, dob) values
('0977519474' , 'lehnngan@gmail.com' , 'lehan' , 'le ha ' , '2003-10-30')

delete from seat 
where seat_id = 298
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

	drop function add_seat();

	CREATE OR REPLACE TRIGGER trigger_add_seat
	AFTER INSERT ON train
	FOR EACH ROW
	EXECUTE PROCEDURE add_seat();

--2. Trigger không cho phép add seat quá số toa (tổng số ghế)  
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

drop trigger trigger_unable_to_insert_seat on seat
-- 1. Auto add ticket when insert new seat
CREATE OR REPLACE FUNCTION add_ticket()
RETURNS TRIGGER AS 
$$
BEGIN
		FOR coach in 1..5 LOOP
			FOR n in 1..60 LOOP
				IF coach = 1 then
				INSERT INTO seat VALUES (DEFAULT, coach, n, NEW.train_id, 'A');
				END IF;
				IF coach = 2 OR coach = 3 OR coach = 4 then
				INSERT INTO seat VALUES (DEFAULT, coach, n, NEW.train_id, 'B');
				END IF;
				IF coach = 5 then
				INSERT INTO seat VALUES (DEFAULT, coach, n, NEW.train_id, 'C');
				END IF;
			END LOOP;
		END LOOP;
		RETURN NEW;
END;
$$
LANGUAGE plpgsql;

drop function add_seat();

CREATE OR REPLACE TRIGGER trigger_add_seat
AFTER INSERT ON train
FOR EACH ROW
EXECUTE PROCEDURE add_seat();


delete from seat;
delete from train;

select * from seat;
select * from train;
insert into train(train_id, train_name) values
(1, 'HN1')