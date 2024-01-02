ALTER TABLE passenger 
drop CONSTRAINT constraint_phone;

ALTER TABLE passenger 
drop CONSTRAINT constraint_email;

ALTER TABLE passenger 
ADD CONSTRAINT constraint_phone UNIQUE (phone);

ALTER TABLE passenger 
ADD CONSTRAINT constraint_email UNIQUE (email);

create index idx_p_pass on passenger using hash
create index idx_p_email on passenger using hash(email);
create index idx_p_phone on passenger using hash(phone);
drop index idx_p_email;
drop index idx_p_phone;
create index idx_p_email_pass on passenger (email, password);
create index idx_p_phone_pass on passenger (phone, password);
drop index idx_p_email_pass;
drop index idx_p_phone_pass;


EXPLAIN ANALYZE
SELECT * from passenger
where (email = 'lehangan30@gmail.com' or phone = 'lehangan30@gmail.com') 
and password ='ngan'

EXPLAIN ANALYZE
select * from Sign_In('lehangan30@gmail.com', 'ngan');

----------------------------------------------------------------------
CREATE INDEX idx_s_seatid ON Seat USING HASH (train_id);
CREATE INDEX idx_t_seatid ON Ticket USING HASH (seat_id);
drop index idx_s_seatid;
drop index idx_t_seatid;

drop INDEX idx_ts_train_schedule_id;
drop index idx_ts_train_id;
drop index idx_s_trainid_n;

CREATE INDEX idx_ts_train_schedule_id ON train_schedule USING HASH (schedule_id);
CREATE INDEX idx_ts_train_id ON train_schedule (train_id);
CREATE INDEX idx_s_trainid_n ON seat (train_id);

CREATE INDEX idx_s_seatid ON seat USING HASH (seat_id);
CREATE INDEX idx_t_seatid ON ticket USING HASH (seat_id);

drop index idx_s_seatid ;
drop index idx_t_seatid ;

create index idx_ts_schedule_id on train_schedule using hash(schedule_id);
drop index idx_ts_schedule_id;

CREATE INDEX idx_s_trainid_n ON seat using hash(train_id);

EXPLAIN ANALYZE
SELECT s.seat_id, s.coach, s.number_seat
FROM seat s, train_schedule ts
WHERE ts.train_id=s.train_id
AND ts.schedule_id=17;


-----------------------------------

EXPLAIN ANALYZE
select * from get_seat_empty(120);

CREATE INDEX idx_train_schedule_from_to ON train_schedule(station_from_id, station_to_id);
CREATE INDEX idx_train_schedule_from_to ON train_schedule(station_from_id);

EXPLAIN ANALYZE
select * from train_schedule 
where station_from_id = 'HAN'
and station_to_id = 'HAP'
and date(departure_time) = '2024-01-05';

explain analyze
select check_station('Ha Noi');

----------------

select * from train_schedule
CREATE INDEX idx_train_schedule_from_to_time ON train_schedule(station_from_id, station_to_id, departure_time);
drop index idx_train_schedule_from_to_time;

drop index idx_train_schedule_from_to;
CREATE INDEX idx_train_schedule_from_to ON train_schedule (station_from_id, station_to_id);
CREATE INDEX idx_train_schedule_date ON train_schedule using btree(departure_time);
drop index idx_train_schedule_date;

explain analyze
select * from show_schedule('Ha Noi' , 'Hai Phong', '2024-01-10');

--------------------------------------------
