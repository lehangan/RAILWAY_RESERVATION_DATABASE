--1. Sign Up function for passenger to have information to book ticket
CREATE OR REPLACE FUNCTION Sign_Up(
    phone1 varchar, 
    email1 varchar, 
    password1 varchar, 
    name1 varchar, 
    dob1 date
)
RETURNS boolean AS
$$
BEGIN
    BEGIN
        INSERT INTO passenger(phone, email, password, name, dob) 
        VALUES(phone1, email1, password1, name1, dob1);
        -- If the INSERT statement executed successfully, print a notice and return true
        RAISE NOTICE 'User signed up successfully';
        RETURN true;
    EXCEPTION
        -- If there is an exception (e.g., unique constraint violation), print a notice and return false
        WHEN others THEN
            RAISE NOTICE 'Failed to sign up user: %', SQLERRM;
            RETURN false;
    END;
END;
$$
LANGUAGE plpgsql;


--2. Function Sign In , will show information if valid
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


--3. Funciton to Check admin 
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





