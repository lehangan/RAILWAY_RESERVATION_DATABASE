CREATE OR REPLACE FUNCTION check_station(station_name1 VARCHAR)
RETURNS varchar -- Assuming station_id is of INTEGER type
AS 
$$
DECLARE
    station_id1 varchar;
BEGIN
    SELECT station_id INTO station_id1
    FROM station
    WHERE station_name = station_name1;

    -- If the station is not found, you might want to handle that case
    IF station_id1 IS NULL THEN
        RETURN NULL; -- or handle it in another way
    END IF;

    RETURN station_id1;
END
$$
LANGUAGE plpgsql;

---------------
CREATE OR REPLACE FUNCTION show_schedule(station_from VARCHAR, station_to VARCHAR, depart_time DATE)
RETURNS TABLE (from1 VARCHAR, to1 VARCHAR, depart TIMESTAMP, arrival TIMESTAMP)
AS  
$$ 
DECLARE 
    from_name VARCHAR;
    to_name VARCHAR;
BEGIN 
    SELECT check_station(station_from) INTO from_name;
    SELECT check_station(station_to) INTO to_name;

    RETURN QUERY
    SELECT  station_from, station_to , departure_time, arrival_time  
    FROM train_schedule 
    WHERE station_from_id = from_name AND station_to_id = to_name AND date(arrival_time) = depart_time;
END
$$
LANGUAGE plpgsql