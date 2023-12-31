delete from train
delete from station
delete from train_schedule
delete from stop
delete from passenger
delete from seat
delete from ticket

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

--3. Trigger don't allow insert train_schedule when have conflict 

CREATE OR REPLACE FUNCTION train_schedule_problem()
RETURNS TRIGGER LANGUAGE plpgsql
AS $$
DECLARE 
	a record;
BEGIN
	for a in ( select arrival_time, departure_time, train_schedule.train_id, track_number
				from train_schedule, train
				where train.train_id = train_schedule.train_id
			  	and train_schedule.train_id != new.train_id 
			  	and train_schedule.track_number = new.track_number
			    and cast(train_schedule.arrival_time as date) = cast(new.arrival_time as date)
			  	or cast(train_schedule.departure_time as date) = cast(new.departure_time as date)
			 ) loop
		if( ( cast(a.departure_time as time), cast(a.departure_time as time) )
		   	overlaps ( cast(new.departure_time as time), cast(new.arrival_time as time) ) 
		  ) then 
			raise notice 'The train_schedule conflicts with another one:';
			return null;
		end if;
	end loop;
	return new;
END
$$;

drop trigger if EXISTS train_schedule_problem on train_schedule
CREATE OR REPLACE TRIGGER solve_train_schedule_problem
BEFORE INSERT ON train_schedule
FOR EACH ROW
EXECUTE PROCEDURE train_schedule_problem();

insert into train_schedule(arrival_time, departure_time, track_number, station_to_id, station_from_id , train_id) 
values
('1/1/2024 6:15','1/1/2024 6:00',1,'LOB','HAN',1)

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