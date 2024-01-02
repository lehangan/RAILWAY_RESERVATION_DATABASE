
------------
CREATE OR REPLACE FUNCTION Sign_Up(phone1 varchar, email1 varchar, password1 varchar, name1 varchar, dob1 date)
RETURNS void AS
$$
BEGIN
    INSERT INTO passenger( phone, email, password, name, dob) 
    VALUES(phone1, email1, password1, name1, dob1);
END;
$$
LANGUAGE plpgsql;

--- Sign In , show info if ok
CREATE OR REPLACE FUNCTION Sign_In(emailOrphone varchar, password1 varchar)
RETURNS TABLE (
    passenger_id integer,
    name varchar,
    password varchar,
	email varchar,
	phone varchar
    -- Add other columns as needed
	)
AS
$$
    
    SELECT passenger_id, name, password, email, phone 
    FROM passenger
    WHERE (phone = emailOrPhone  OR email = emailOrphone) AND password = password1;

$$
LANGUAGE sql;

----Check admin, give notification 

CREATE OR REPLACE FUNCTION CheckAdmin(name1 varchar, password1 varchar)
RETURNS VOID
AS
$$
DECLARE
    Admin_exists boolean;
    CorrectPassword boolean;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM admin_railway
        WHERE account = name1
    ) INTO Admin_exists;

    IF Admin_exists THEN
        SELECT EXISTS (
            SELECT 1
            FROM admin_railway
            WHERE account = name1 AND password = password1
        ) INTO CorrectPassword;

        IF CorrectPassword THEN
            -- Correct name and correct password
            RAISE NOTICE 'Notification: Admin information found for name: %', name1;
        ELSE
            -- Correct name, but incorrect password
            RAISE NOTICE 'Notification: Incorrect Password for name: %', name1;
        END IF;
    ELSE
        -- Incorrect name
        RAISE NOTICE 'Notification: Admin information not found for name: %', name1;
    END IF;
END;
$$
LANGUAGE plpgsql;

-- -------return a number 
-- CREATE OR REPLACE FUNCTION CheckAdmin(name1 varchar, password1 varchar)
-- RETURNS integer
-- AS
-- $$
-- DECLARE
--     Admin_exists boolean;
--     CorrectPassword boolean;
-- BEGIN
--     SELECT EXISTS (
--         SELECT 1
--         FROM admin_railway
--         WHERE account = name1
--     ) INTO Admin_exists;

--     IF Admin_exists THEN
--         SELECT EXISTS (
--             SELECT 1
--             FROM admin_railway
--             WHERE account = name1 AND password = password1
--         ) INTO CorrectPassword;

--         IF CorrectPassword THEN
--             -- Correct name and correct password
--             RETURN 1;
--         ELSE
--             -- Correct name, but incorrect password
--             RETURN 2;
--         END IF;
--     ELSE
--         -- Incorrect name
--         RETURN 3;
--     END IF;
-- END;
-- $$
-- LANGUAGE plpgsql;




