create table passenger(
	passenger_id serial primary key,
	phone varchar(15),
	email varchar(100),
	password varchar(100) NOT NULL,
	name varchar(50) NOT NULL,
	dob date,
	CONSTRAINT passenger_chk_email_phone CHECK ((email IS NOT NULL) OR (phone IS NOT NULL))
);

create table station(
	station_id varchar(20) primary key,
	station_name varchar(100) not null,
	city varchar(20) not null
);

create table train(
	train_id serial primary key,
	train_name varchar(10) not null
);

create table stop(
	train_id integer,
	station_id varchar(20),
	no integer, 
	foreign key(train_id) references train(train_id),
	foreign key(station_id) references  station(station_id)
);

create table train_schedule(
	schedule_id serial primary key,
	arrival_time timestamp not null,
	departure_time timestamp not null,
	track_number integer not null,
	station_to_id varchar(20) not null,
	station_from_id varchar(20) not null,
	train_id integer not null,
	foreign key (train_id) references train(train_id)
);

create table seat(
	seat_id serial primary key,
	coach integer not null,
	number_seat  integer not null,
	train_id integer not null,
	class char(1) not null,
	constraint class_constraint check (class in ( 'A', 'B', 'C') ),
	foreign key (train_id) references train(train_id)
);

create table ticket(
	ticket_id serial primary key,
	price integer not null,
	ticket_type varchar(40) not null,
	schedule_id integer not null,
	seat_id integer not null,
	foreign key(schedule_id) references train_schedule(schedule_id),
	foreign key(seat_id) references seat(seat_id),
	constraint ticket_type_constraint check (ticket_type in ('Student', 'Elder', 'Adult', 'Children' ))
);

create table reservation(
	ticket_id integer,
	passenger_id integer,
	reservation_date timestamp not null,
	arrival_no varchar(20) not null,
	departure_no varchar(20) not null,
	foreign key (ticket_id) references ticket(ticket_id),
	foreign key (passenger_id) references passenger(passenger_id),
	primary key(ticket_id, passenger_id)
);

create table admin_railway(
	account varchar(30) primary key,
	password varchar(40) not null
);

