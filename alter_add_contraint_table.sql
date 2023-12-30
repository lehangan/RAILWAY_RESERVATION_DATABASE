alter table seat
add	constraint fk_seat_train_id foreign key (train_id) references train(train_id) on delete cascade;

alter table train_schedule
add constraint fk_train_schedule_train_id foreign key (train_id) references train(train_id) on delete cascade;

alter table ticket 
add constraint fk_ticket_seat_id foreign key(seat_id) references seat(seat_id) on delete cascade,
add constraint fk_ticket_train_schedule_id foreign key(schedule_id) references train_schedule(schedule_id) on delete cascade;

alter table reservation
add constraint fk_reservation_seat_id foreign key (ticket_id) references ticket(ticket_id) on delete set null,
add constraint fk_reservarion_passenger_id foreign key (passenger_id) references passenger(passenger_id) on delete set null;