delete from train;
delete from station;
delete from train_schedule;
delete from stop;
delete from passenger;
delete from seat;
delete from ticket;

drop table admin_railway
drop table train;
drop table station;
drop table train_schedule;
drop table stop;
drop table passenger;
drop table seat;
drop table ticket;

alter table seat
drop constraint fk_seat_train_id ;

alter table train_schedule
drop constraint fk_train_schedule_train_id ;

alter table ticket 
drop constraint fk_ticket_passenger_id ,
drop constraint fk_ticket_seat_id ,
drop constraint fk_ticket_train_schedule_id ;

select * from ticket
select * from seat
select * from passenger
select * from station
select * from train
select * from stop
select * from train_schedule

COPY passenger FROM 'E:\railway_project_database_sql\data\passenger.txt' WITH DELIMITER E'\t';
COPY train FROM 'E:\railway_project_database_sql\data\train.txt' WITH DELIMITER E',';
COPY stop FROM 'E:\railway_project_database_sql\data\stop.txt' WITH DELIMITER E',';
COPY train_schedule FROM 'E:\railway_project_database_sql\data\train_schedule2.txt' WITH DELIMITER E'\t';
 
insert into train_schedule(arrival_time, departure_time, track_number, station_to_id, station_from_id, train_id)
values
('1/1/2024 6:00','1/1/2024 5:45',3,	'LOB', 'HAN',11),
('1/1/2024 6:30','1/1/2024 6:10',3,	'GLA',	'LOB',11)

INSERT INTO station(station_id, station_name, city) VALUES
('HAN' , 'Ha Noi' , 'Ha Noi'),
('LOB' , 'Long Bien' , 'Ha Noi'),
('GLA' , 'Gia Lam' , 'Ha Noi'),
('HAD' , 'Hai Duong' , 'Hai Duong'),
('HAP' , 'Hai Phong', ' Hai Phong'),
('PUT' , 'Phu Tho' , 'Phu Tho'),
('YEB' , 'Yen Bai' , 'Yen Bai'),
('LAC' , 'Lao Cai' , 'Lao Cai'),
('NAD' , 'Nam Dinh' , 'Nam Dinh'),
('NIB' , 'Ninh Binh' , 'Ninh Binh'),
('THA' , 'Thanh Hoa' , 'Thanh Hoa'),
('VIN' , 'Vinh' , 'Nghe An'),
('DOH' , 'Dong Hoi' , 'Quang Binh'),
('HUE' , 'Hue' , 'Hue'),
('DAN' , 'Da Nang' , 'Da Nang'),
('QNGA' , 'Quang Ngai' , 'Quang Ngai'),
('QNHO' , 'Quy Nhon' , 'Quy Nhon'),
('TUH' , 'Tuy Hoa' , 'Phu Yen'),
('NHT' , 'Nha Trang' , 'Khanh Hoa'),
('PAT' , 'Phan Thiet' , 'Binh Thuạn'),
('BTH' , 'Binh Thuan' , 'Binh Thuan'),
('BHO' , 'Bien Hoa' , 'Dong Nai'),
('SGO' , 'Sai Gon' , 'Sai Gon');

insert into ticket(price, ticket_type, schedule_id, seat_id) values
(50000, 'Student', 1, 1)

----------------------

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
    RAISE EXCEPTION 'This train do not have this schedule';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_check_train_id_match
BEFORE INSERT ON ticket
FOR EACH ROW
EXECUTE FUNCTION check_train_id_match();


--------------------------------------------

CREATE OR REPLACE FUNCTION client_get_schedule(from_id varchar(20), to_id varchar(20))
RETURNS table (schedule_id int, from_station varchar(20), to_station varchar(20) ) 
as
$$
BEGIN
	RETURN QUERY
	SELECT ts.schedule_id, ts.station_from_id, ts.station_to_id
	FROM train_schedule ts
	WHERE ts.station_from_id = $2 and ts.station_to_id = $3
END;
$$
LANGUAGE plpgsql;
select client_get_schedule(1, 'HAN', 'LOB');

drop function get_train_by_id( int)
CREATE OR REPLACE FUNCTION get_train_by_id(train_id_param INTEGER)
RETURNS TABLE (
  train_id INTEGER,
  train_name VARCHAR(10)
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    t.train_id,
    t.train_name
  FROM
    train t
  WHERE
    t.train_id = train_id_param;

  RETURN;
END;
$$ LANGUAGE plpgsql;
select * from get_train_by_id(6)

drop function client_get_schedule(integer,date )

select extract(dow from date('2024-01-01'))

select * from train_schedule 
where cast(arrival_time as time) > '7:00:00'
AND cast(arrival_time as time) <= '11:30:00'
and date(arrival_time) = '2024-01-01'
and station_from_id = 'HAN'
and station_to_id = 'HAD'

SELECT (TIME cast('2024-01-01 7:30:00' as time) , TIME cast('2024-01-01 11:15:00' as time)) OVERLAPS
       (TIME cast('2024-01-01 11:15:00' as time) , TIME cast('2024-01-01 15:15:00' as time));
	   
SELECT (cast('2024-01-01 7:30:00' as time) , cast('2024-01-01 11:15:00' as time)) OVERLAPS
       (cast('2024-01-01 11:00:00' as time) , cast('2024-01-01 15:15:00' as time));
------------------------------

INSERT INTO station(station_id, station_name, city) VALUES
('HAN' , 'Ha Noi' , 'Ha Noi'),
('LOB' , 'Long Bien' , 'Ha Noi'),
('GLA' , 'Gia Lam' , 'Ha Noi'),
('HAD' , 'Hai Duong' , 'Hai Duong'),
('HAP' , 'Hai Phong', ' Hai Phong'),
('PUT' , 'Phu Tho' , 'Phu Tho'),
('YEB' , 'Yen Bai' , 'Yen Bai'),
('LAC' , 'Lao Cai' , 'Lao Cai'),
('NAD' , 'Nam Dinh' , 'Nam Dinh'),
('NIB' , 'Ninh Binh' , 'Ninh Binh'),
('THA' , 'Thanh Hoa' , 'Thanh Hoa'),
('VIN' , 'Vinh' , 'Nghe An'),
('DOH' , 'Dong Hoi' , 'Quang Binh'),
('HUE' , 'Hue' , 'Hue'),
('DAN' , 'Da Nang' , 'Da Nang'),
('QNGA' , 'Quang Ngai' , 'Quang Ngai'),
('QNHO' , 'Quy Nhon' , 'Quy Nhon'),
('TUH' , 'Tuy Hoa' , 'Phu Yen'),
('NHT' , 'Nha Trang' , 'Khanh Hoa'),
('PAT' , 'Phan Thiet' , 'Binh Thuạn'),
('BTH' , 'Binh Thuan' , 'Binh Thuan'),
('BHO' , 'Bien Hoa' , 'Dong Nai'),
('SGO' , 'Sai Gon' , 'Sai Gon')

----------------------------------------------
SELECT
        train_id,
        station_id,
        ROW_NUMBER() OVER (PARTITION BY train_id ORDER BY no) AS station_order
FROM stop
	
CREATE OR REPLACE FUNCTION insert_reservation()
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

--3. Trigger don't allow insert train_schedule when have conflict 

select * from train_schedule

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

select time '8:45:00' - time '8:30:00' >= interval '15 minutes'

select * from train_schedule

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


drop trigger solve_train_schedule_problem on train_schedule

-------------------------------------------

-- Create a function to check for overlapping time intervals
-- Create a function to check for overlapping time intervals
CREATE OR REPLACE FUNCTION check_overlap()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (
    SELECT *
    FROM train_schedule
    WHERE
      train_schedule.train_id != NEW.train_id
      AND train_schedule.track_number = NEW.track_number
      AND (
        cast(train_schedule.arrival_time as date) = cast(new.arrival_time as date)
			  		or cast(train_schedule.departure_time as date) = cast(new.departure_time as date)
      )
	  AND ( ( cast(departure_time as time), cast(arrival_time as time) )
		   	overlaps ( cast(new.departure_time as time), cast(new.arrival_time as time) ) )
  ) THEN
    RAISE EXCEPTION 'Overlap detected: train_id=%, track_number=%, arrival_time=%, departure_time=%',
      NEW.train_id, NEW.track_number, NEW.arrival_time, NEW.departure_time;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to call the check_overlap function before insert
CREATE TRIGGER before_insert_check_overlap
BEFORE INSERT ON train_schedule
FOR EACH ROW
EXECUTE FUNCTION check_overlap();

drop trigger before_insert_check_overlap on train_schedule

insert into train_schedule(arrival_time, departure_time, track_number, station_to_id, station_from_id , train_id) 
values
('1/1/2024 6:15','1/1/2024 6:00',1,'LOB','HAN',2)

select * 
from train_schedule
where train_id != 2 
and track_number = 1
and ( cast(train_schedule.arrival_time as date) = '1/1/2024'
		or cast(train_schedule.departure_time as date) = '1/1/2024' )
and (( cast(departure_time as time), cast(departure_time as time) )
		   	overlaps ( cast(new.departure_time as time), cast(new.arrival_time as time) ))
					

insert into train(train_name) values
('HN100')

insert into ticket(price, ticket_type, schedule_id, seat_id) values
('56000' ,'Student' , 1, 5 )

insert into seat(seat_id, coach, number_seat, train_id, class) values
(301, 5, 58, 1, 'C')

insert into passenger(passenger_id, phone, email, password, name, dob) values
('1001', '0977519474' , 'lehnngan@gmail.com' , 'lehan' , 'le ha ' , '2003-10-30')

insert into passenger( phone, email, password, name, dob) values
('0977519474' , 'lehnngan@gmail.com' , 'lehan' , 'le ha ' , '2003-10-30')

----------------------------------------


delete from seat;
delete from train;

select * from seat;
select * from train;
insert into train(train_id, train_name) values
(1, 'HN1')

drop trigger before_insert_check_train_id_match on ticket
drop trigger reservation_insert_trigger on reservation


