select * from passenger;
select * from station;
select * from train;
select * from stop;
select * from train_schedule;
select * from seat;
select * from ticket;
---- 1. Insert all data to table
---- Trigger auto add seat
select * from seat;

--- Trigger can't add seat 
insert into seat(coach, number_seat, train_id, class) 
values(10, 1, 1, 'A');

--- Trigger can't add if conflict (track number)
select * from train_schedule;

insert into train_schedule(arrival_time, departure_time, track_number, station_to_id, station_from_id, train_id)
values( '2024-01-03 08:00' , '2024-01-03 07:00' , 1, 'GLA' , 'HAN' , 20);

--- Trigger can't add if no enough time
insert into train_schedule(arrival_time, departure_time, track_number, station_to_id, station_from_id, train_id)
values
( '2024-01-03 08:00' , '2024-01-03 07:00' , 5, 'BHO' , 'SGO' , 20),
( '2024-01-03 09:00' , '2024-01-03 08:00' , 5, 'BHO' , 'BHO' , 20);

---- 2. User function - Book

---2.1 Function to query id of station with station name

select check_station('Hai Phong');

-- 2.2 Funciton get information about schedule return( schedule_id,staion_from_ id, station_to_id, 
-- departure_time, arrival_time)

select show_schedule('Ha Noi' , 'Hai Phong' , '2024-01-03');

--2.3 Function to get all seat with schedule id

select * from get_seat_all(24);
select * from get_seat_empty(24);

-- 2.4 Funciton to get price of by provide schedule_id, seat_id
select take_price(24, 1);

-- 2.5 Function to book ticket when passenger provide schedule_id, seat_id, and passenger_id for 
-- having sale or discount
select book_ticket(24, 1, 1);

---Query the reservation history

select * from ticket
where passenger_id = 1;

select * from get_seat_empty(24);

--- First there are a people booking from Hanoi to Hai Phong (from_station is 1, to_station is 5)
--- Another passenger will query buy same ticket from Ha Noi to Long Bien ( from_station is 1, to_station is 2)
--- with same seat ?
select show_schedule('Ha Noi' , 'Long Bien' , '2024-01-03');

select * from get_seat_empty(21);

-- Function to book ticket when passenger provide schedule_id, seat_id, and passenger_id for 
select book_ticket(21, 2, 2);
select * from ticket;

select show_schedule('Hai Duong' , 'Hai Phong' , '2024-01-03');
select * from get_seat_empty(30);
select book_ticket(30, 2, 3);

--- Function sign-in , sign-up
-- 1.Function sign-up




