-- 1. Reset index for passenger (input from file doesn't increment passenger_id)
CREATE OR REPLACE FUNCTION reset_passenger_id()
RETURNS TRIGGER 
AS $$
BEGIN
	PERFORM setval(pg_get_serial_sequence('passenger', 'passenger_id'), coalesce(max(passenger_id),0) + 1, false) FROM passenger;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER reset_serial_passenger_id
BEFORE INSERT ON passenger
EXECUTE FUNCTION reset_passenger_id();

-- 2. Reset index for train_schedule (input from file doesn't increment schedule_id)
CREATE OR REPLACE FUNCTION reset_schedule_id()
RETURNS TRIGGER 
AS $$
BEGIN
	PERFORM setval(pg_get_serial_sequence('train_schedule', 'schedule_id'), coalesce(max(schedule_id),0) + 1, false) FROM train_schedule;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER reset_serial_schedule_id
BEFORE INSERT ON schedule_id
EXECUTE FUNCTION reset_schedule_id();

-- 3. Reset index for train (input from file doesn't increment train_id)
CREATE OR REPLACE FUNCTION reset_train_id()
RETURNS TRIGGER 
AS $$
BEGIN
	PERFORM setval(pg_get_serial_sequence('train', 'train_id'), coalesce(max(train_id),0) + 1, false) FROM train;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER reset_serial_train_id
BEFORE INSERT ON train
EXECUTE FUNCTION reset_train_id();

