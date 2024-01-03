select * from passenger;
select * from station;
select * from train;
select * from stop;
select * from train_schedule;
select * from seat;
select * from ticket;
select * from admin_railway;


---- 1. Insert all data to table
---- Trigger auto add seat

insert into train(train_name) values('HN10');

select s.* from seat s, train t
where t.train_id = s.train_id
and t.train_name = 'HN10';

--- Trigger can't add seat when full
insert into seat(coach, number_seat, train_id, class) 
values(1, 1, 31, 'A');

--- Trigger can't add if conflict (track number)
select * from train_schedule;

-- Because track 1 in this time have train id 1
select * from train_schedule
where track_number = 1 ;

insert into train_schedule(arrival_time, departure_time, track_number, station_to_id, station_from_id, train_id)
values( '2024-01-03 08:00' , '2024-01-03 07:00' , 1, 'GLA' , 'HAN' , 20);

--- Trigger can't add if no enough time
--- We check track_number first
select * from train_schedule
where track_number = 5 ;

insert into train_schedule(arrival_time, departure_time, track_number, station_to_id, station_from_id, train_id)
values
( '2024-01-03 08:00' , '2024-01-03 07:00' , 5, 'BHO' , 'SGO' , 20),
( '2024-01-03 09:00' , '2024-01-03 08:00' , 5, 'BTO' , 'BHO' , 20);

---- 2. User function - Book

---2.1 Function to query id of station with station name

select check_station('Hai Phong');

-- 2.2 Funciton get information about schedule return( schedule_id,staion_from_ id, station_to_id, 
-- departure_time, arrival_time)

select show_schedule('Ha Noi' , 'Hai Phong' , '2024-01-05');

--2.3 Function to get all seat with schedule id

select * from get_seat_all(44);
select * from get_seat_empty(44);

-- 2.4 Funciton to get standard price of ticket by provide schedule_id, seat_id
select take_price(44, 1);

-- 2.5 Function to book ticket when passenger provide schedule_id, seat_id, and passenger_id for 
-- having sale or discount
select book_ticket(44, 1, 1);

---Query the reservation history by provide passenger_id

select * from get_history_booking(1);

---Query the reservation history by provide ticket_id

select * from get_history_booking_ticket(43);

-- We check seat empty when having some one reserve
select * from get_seat_empty(44);

-- Case1: If someone try to book ticket with same schedule and same seat ?

select book_ticket(44,1,2);

-- Case 2: Check overlap (true) - Cannot booked
--- First there is a people booking from Hanoi to Hai Phong (from_station is 1, to_station is 5)
--- Another passenger will query buy same ticket from Ha Noi to Long Bien ( from_station is 1, to_station is 2)
--- with same seat ? Can it be reserved ?
select show_schedule('Ha Noi' , 'Long Bien' , '2024-01-05');

select * from get_seat_empty(41);

-- Case 3: Check overlap (false) - Can booked
-- First some one booked from (Hanoi to Long Bien, 1-2)
-- Function to book ticket when passenger provide schedule_id, seat_id, and passenger_id and return ticket_id
select book_ticket(41, 2, 2);
select * from ticket;

-- Second: Now some one want to reserve ticket from Hai Duong to Hai Phong (4-5)
select show_schedule('Hai Duong' , 'Hai Phong' , '2024-01-05');
select * from get_seat_empty(50);

select book_ticket(50, 2, 3);

select * from ticket;

-- Third some one want to reserve ticket from Long Bien to Hai Duong (2-4) 

select show_schedule('Long Bien' , 'Hai Duong' , '2024-01-05');
select * from get_seat_empty(50);

select book_ticket(50, 2, 3);

select * from ticket;


-- Case 4: When booking with time departure - time current > 15 minitues (can book)
select show_schedule('Hai Phong' , 'Ha Noi' , '2024-01-05');

select book_ticket(2484, 10, 3);

-- Case 5: When booking with time departure - time current < 15 minutes (can not book)
select show_schedule('Hai Phong' , 'Ha Noi' , '2024-01-02');

select book_ticket(2454, 1, 3);


-- 2.6 Function refund ticket
-- If people refund ticket with ticket_id 
-- case with time before departure date
select refund_ticket(45);

-- case with time not before departure date
select show_schedule('Gia Lam' , 'Hai Phong' , '2024-01-03');
select book_ticket(1249, 1, 1);
select refund_ticket(49,1);

--- Function sign-in , sign-up
-- Sign Up function for passenger to have information to book ticket provide
-- ( phone or email, password, name, dob)

select Sign_Up('09977519479','lehangan30@gmail.com' ,'lehangan', 'Le Ha Ngan', '2003-02-02');

select Sign_In('lehangan30@gmail.com' , 'lehangan');

select * from admin_railway
select CheckAdmin('admin1' , 'password5');


