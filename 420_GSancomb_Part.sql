


Create Table Attendees (
    entry_ID        Number(10,0)    NOT NULL,
    person_ID       Number(10,0)    NOT NULL,
    event_ID        Number(10,0)    NOT NULL,
    current_date    Date            NOT NULL,
    current_status  VarChar(5)
            CHECK (current_status IN ('True', 'False')),
    Constraint Attendees_PK Primary Key (entry_ID));
Insert Into
    Attendees (entry_ID, person_ID, event_ID, current_date, current_status)
    Values
    (1, 1, 1, SYSDATE , 'False');
Insert into
    Attendees (entry_ID, person_ID, event_ID, current_date, current_status)
    Values
    (2, 2, 1, SYSDATE , 'False');
Insert into
    Attendees (entry_ID, person_ID, event_ID, current_date, current_status)
    Values
    (3, 3, 1, SYSDATE , 'False');
Insert into
    Attendees (entry_ID, person_ID, event_ID, current_date, current_status)
    Values
    (4, 1, 2, SYSDATE , 'False');
Insert into
    Attendees (entry_ID, person_ID, event_ID, current_date, current_status)
    Values
    (5, 2, 2, SYSDATE , 'False');
Insert into
    Attendees (entry_ID, person_ID, event_ID, current_date, current_status)
    Values
    (6, 3, 2, SYSDATE , 'False');
Insert into
    Attendees (entry_ID, person_ID, event_ID, current_date, current_status)
    Values
    (7, 1, 3, SYSDATE , 'False');
Insert into
    Attendees (entry_ID, person_ID, event_ID, current_date, current_status)
    Values
    (8, 3, 3, SYSDATE , 'False');

CREATE TABLE Houses
(
    house_ID         NUMBER          NOT NULL,
    house_address    VARCHAR2(60),
    house_city       VARCHAR2(15),
    house_state      VARCHAR2(15),
    house_zip        VARCHAR2(10),
    CONSTRAINT Houses_pk
        PRIMARY KEY (house_ID)
);

--Inserting sample data for Houses
INSERT INTO Houses
(house_ID,house_address,house_city,house_state,house_zip)
VALUES
(1,'8 Hudson St.','Salt Lake City','UT','84119');
INSERT INTO Houses
(house_ID,house_address,house_city,house_state,house_zip)
VALUES
(2,'7826 Old Glen Ridge Drive','Conyers','GA','30012');
INSERT INTO Houses
(house_ID,house_address,house_city,house_state,house_zip)
VALUES
(3,'528 Westport Ave.','Roy','UT','84067');

--Feature 2 Table for people
Create table Person
(
    person_ID           NUMBER            NOT NULL,
    house_ID            NUMBER            NOT NULL,
    person_last_name    VARCHAR2(30),
    person_first_name   VARCHAR2(30),
    person_phone        VARCHAR2(24),
    person_status       VARCHAR2(20)
        CHECK (person_status IN ('Positive', 'Negative')),
    CONSTRAINT Person_pk
        PRIMARY KEY (person_ID),
    CONSTRAINT Person_fk
        FOREIGN KEY (house_ID)
        REFERENCES Houses(house_ID)
);

--Inserting sample data into Person
INSERT INTO Person
(person_ID,house_ID,person_last_name,person_first_name,person_phone,person_status)
VALUES
(1,1,'Ross','Ronald','412-589-4309',NULL);
INSERT INTO Person
(person_ID,house_ID,person_last_name,person_first_name,person_phone,person_status)
VALUES
(2,2,'Evans','Robert','708-254-0333',NULL);
INSERT INTO Person
(person_ID,house_ID,person_last_name,person_first_name,person_phone,person_status)
VALUES
(3,3,'Martinez','Glenn','561-310-1906',NULL);

--Feature 3 Enter a new test result

CREATE TABLE Test_Result
(
    test_ID             NUMBER(10, 0)     NOT NULL,
    person_ID           NUMBER(10, 0)     NOT NULL,
    test_date           DATE,
    test_result         VARCHAR2(20)
        CHECK (test_result IN ('Positive', 'Negative')),
    CONSTRAINT Test_pk
        PRIMARY KEY (test_ID),
    CONSTRAINT Test_fk
        FOREIGN KEY (person_ID)
        REFERENCES Person(person_ID)
);

INSERT INTO Test_Result
(test_ID, person_ID, test_date, test_result)
VALUES
(1, 1, to_date('01-22-21','MM-DD-YY'), 'Negative');
INSERT INTO Test_Result
(test_ID, person_ID, test_date, test_result)
VALUES
(2, 2, to_date('01-25-21','MM-DD-YY'), 'Positive');
INSERT INTO Test_Result
(test_ID, person_ID, test_date, test_result)
VALUES
(3, 3, to_date('01-26-21','MM-DD-YY'), 'Negative');



Create Table Events_T (
    event_ID        Number(10,0)    NOT NULL,
    event_Name      VarChar(50)     NOT NULL,
    Attendee_Count  Number(5,0)     NOT NULL,
    event_date      Date            NOT NULL,
    event_address   VarChar(50)     NOT NULL,
    Constraint Events_T_PK Primary Key (event_ID)
);

Insert into Events_T
    (event_id, event_name, attendee_count, event_date, event_address)
    Values
    (1, 'Potato Festival', 0, to_date('03-01-20','MM-DD-YY'), '558 Beach Street');
Insert into Events_T
    (event_id, event_name, attendee_count, event_date, event_address)
    Values
    (2, 'Job Expo', 0, to_date('02-28-20','MM-DD-YY'), '4412 Brick Boulevard');
Insert into Events_T
    (event_id, event_name, attendee_count, event_date, event_address)
    Values
    (3, 'Gun Show', 0, to_date('02-27-20','MM-DD-YY'), '952 Heron Court');
Insert into Events_T
    (event_id, event_name, attendee_count, event_date, event_address)
    Values
    (4, 'Anime Convention', 0, to_date('02-15-20','MM-DD-YY'), '8562 Berry Avenue');
--Feature 7 Create Table and Entries

-- ____________________________________________________

CREATE OR REPLACE FUNCTION newEvent(
    newestName      VARCHAR,
    newestDate      DATE,
    newestAddress   VARCHAR
)
IS
BEGIN
     If isEvent(newestName, newestDate, newestAddress)
     ELSE
        INSERT INTO Events_T
        (event_id, event_name, attendee_count, event_date, event_address)
        Values
        (7, newestName, 0,newestDate, newestAddress);

    END IF;
--     EXCEPTION
--         when no_data_found then
-- 	        Dbms_output.put_line('no rows found');
-- 	        return;
    return;
END;

-- ____________________________________________________

CREATE OR REPLACE FUNCTION maxKeyEvent
RETURN NUMBER
IS
    NewMax Number := 0;
    Target_entry_ID EVENTS_T.event_ID%TYPE;
Begin
    Select Max(event_ID) Into Target_entry_ID
    From Events_T;
    NewMax := Target_entry_ID + 1;
    Return NewMax;
END;
--
-- -- ____________________________________________________

CREATE OR REPLACE FUNCTION isEvent(
    eventName      VARCHAR,
    eventDate      DATE,
    eventAddress   VARCHAR)
RETURN BOOLEAN as
--     target_row1 Events_T.event_Name%TYPE := Null;
-- --     target_row2 Events_T.event_Date%TYPE := Null;
-- --     target_row3 Events_T.event_Address%TYPE := Null;

BEGIN
    Select  event_name, event_date, event_address
    AS temp
    From Events_T
    Where event_Name = eventName and event_date = eventDate and event_Address = eventAddress;
    If select * temp Is NOT Null Then Return TRUE;
    END IF;
    RETURN FALSE;
    Select  event_name, event_date, event_address
    FOR EACH ROW [WHEN (event_Name = eventName and event_date = eventDate and event_Address = eventAddress)];
--         Select event_Date
--         Into target_row2
--         From Events_T
--         Where event_Date = eventDate;
--             Select event_Address
--             Into target_row3
--             From Events_T
--             Where event_Address = eventAddress;
--             If target_row3 Is NOT Null Then Return TRUE;
--
END;

-- ____________________________________________________



CALL newEvent('Anime Convention', TO_DATE( 'October 01, 2017', 'MONTH DD, YYYY' ), '8562 Berry Avenue' );
EXEC newEvent('Not Anime Convention', to_date("02-15-20","MM-DD-YY"), '8562 Berry Avenue' );


































