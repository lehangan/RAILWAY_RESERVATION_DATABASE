create table passenger(
	passenger_id char(20) primary key, ---
	phone char(15) NOT NULL,
	email varchar NOT NULL UNIQUE,
	pass_word varchar(20) NOT NULL,
	name text,
	dob date,
	CONSTRAINT check_phone CHECK (phone like '^[0-9]+$')
);

create table station(
	station_id varchar(20) primary key,
	station_name varchar(100) not null,
	city varchar(20) not null
);

create table train(
	train_id varchar(10) primary key,
	train_name varchar(100) not null
);

create table stop(
	train_id varchar(10),
	station_id varchar(20),
	no int,
	foreign key(train_id) references train(train_id),
	foreign key(station_id) references  station(station_id)
);

create table train_schedule(
	schedule_id varchar(20) primary key,
	arrival_time time not null,
	departure_time time not null,
	track_number int not null,
	station_to_id varchar(20) not null,
	station_from_id varchar(20) not null,
	train_id varchar(10) not null,
	foreign key (train_id) references train(train_id)
);

create table seat(
	seat_id varchar(20) primary key,
	coach int not null,
	number_seat  int not null,
	train_id varchar(10) not null,
	class char(1) not null,
	constraint class_constraint check (class in ( 'A', 'B', 'C') ),
	foreign key (train_id) references train(train_id)
);

create table ticket(
	ticket_id varchar(20) primary key,
	price int not null,
	ticket_type varchar(40) not null,
	schedule_id varchar(20) not null,
	seat_id varchar(20) not null,
	foreign key(schedule_id) references train_schedule(schedule_id),
	foreign key(seat_id) references seat(seat_id),
	constraint ticket_type_constraint check (ticket_type in ('Student', 'Elder', 'Adult', 'Children' ))
);

create table reservation(
	ticket_id varchar(20),
	passenger_id varchar(20),
	reservation_date date not null,
	arrival_no varchar(20) not null,
	departure_no varchar(20) not null,
	foreign key (ticket_id) references ticket(ticket_id),
	foreign key (passenger_id) references passenger(passenger_id),
	primary key(ticket_id, passenger_id)
);

create table admin_railway(
	account varchar(30) primary key,
	password varchar(40) not null
)
