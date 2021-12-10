
/* Author: pg25357
   Dropping all the tables first*/
DROP TABLE Customer_Payment;
DROP TABLE Location_Features_Linking;
DROP TABLE Features;
DROP TABLE Reservation_Details;
DROP TABLE Room;
DROP TABLE Reservation;
DROP TABLE Location;
DROP TABLE Customer;

/* Author: pg25357
   Dropping all the Sequences*/

DROP SEQUENCE payment_id_seq;
DROP SEQUENCE reservation_id_seq;
DROP SEQUENCE room_id_seq;
DROP SEQUENCE location_id_seq;
DROP SEQUENCE feature_id_seq;
DROP SEQUENCE customer_id_seq;

/* Author: pg25357
   Creating all the tables*/

CREATE TABLE Customer(
    customer_id             NUMBER              primary key,
    first_name              VARCHAR(50)         NOT NULL,
    last_name               VARCHAR(50)         NOT NULL, 
    email                   VARCHAR(50)         NOT NULL        UNIQUE,
    phone                   CHAR(12)            NOT NULL,
    address_line_1          VARCHAR(50)         NOT NULL,
    address_line_2          VARCHAR(50),
    city                    VARCHAR(50)         NOT NULL,
    state                   CHAR(2)             NOT NULL,
    zip                     CHAR(5)             NOT NULL,
    birthdate               Date,
    stay_credits_earned     NUMBER              NOT NULL,
    stay_credits_used       NUMBER              NOT NULL,
    
    CONSTRAINT credits_earned_more_than_used CHECK (stay_credits_earned >= stay_credits_used),
    CONSTRAINT email_length_ck CHECK (LENGTH(email) >=7)
   );


CREATE TABLE Location(
    Location_id             NUMBER              primary key,
    Location_Name           VARCHAR(50)         NOT NULL        UNIQUE,
    Address                 VARCHAR(50)         NOT NULL,
    City                    VARCHAR(50)         NOT NULL, 
    State                   CHAR(2)             NOT NULL,
    Zip                     CHAR(5)             NOT NULL,
    Phone                   CHAR(12)         NOT NULL,
    URL                     VARCHAR(50)         NOT NULL);


CREATE TABLE Reservation(
    Reservation_id          NUMBER              primary key,
    Customer_id             NUMBER              References Customer(Customer_id) NOT NULL,
    Location_id             NUMBER              References Location(Location_id) NOT NULL,
    Confirmation_Nbr        CHAR(8)             NOT NULL        UNIQUE, 
    Date_Created            Date                NOT NULL,
    Check_In_Date           Date                NOT NULL,
    Check_Out_Date          Date,
    Status                  CHAR(1)             NOT NULL ,
    Number_of_Guests        NUMBER              NOT NULL,
    Reservation_Total       NUMBER              NOT NULL,
    Discount_Code           VARCHAR(50),
    Customer_Rating         NUMBER ,
    Notes                   VARCHAR(50),
    CONSTRAINT status_ck CHECK (Status IN ('U', 'I', 'C', 'N', 'R'))
    );
    
    
CREATE TABLE Room(
    Room_id                 NUMBER              primary key, 
    Location_id             NUMBER              References Location(Location_id) NOT NULL,
    Room_Number             NUMBER              NOT NULL,
    Floor                   NUMBER              NOT NULL,
    Room_Type               CHAR(1)             NOT NULL,
    Square_Footage          NUMBER              NOT NULL,
    Max_People              NUMBER              NOT NULL,
    Weekday_Rate            NUMBER              NOT NULL,
    Weekend_Rate            NUMBER              NOT NULL,
    CONSTRAINT unique_room UNIQUE (Location_id, Room_Number),
    CONSTRAINT room_type_ck CHECK (Room_Type IN ('D', 'Q', 'K', 'S', 'C'))

);


CREATE TABLE Reservation_Details(
    Reservation_id          NUMBER              References Reservation(Reservation_id),
    Room_id                 NUMBER              References Room(Room_id),
    CONSTRAINT reservation_details_pk primary key (Reservation_id, Room_id)
);


CREATE TABLE Features(
    Feature_id              NUMBER              primary key,
    Feature_Name            VARCHAR(50)         NOT NULL        UNIQUE);
        
    
CREATE TABLE Location_Features_Linking(
    Location_id             NUMBER              References Location(Location_id), 
    Feature_id              NUMBER              References features(Feature_id),
    CONSTRAINT location_features_linking_pk primary key (Location_id, Feature_id));
       
    
CREATE TABLE Customer_Payment(
    Payment_id              NUMBER              primary key,
    Customer_id             NUMBER              References customer(customer_id)        NOT NULL      UNIQUE,
    cardholder_first_name   VARCHAR(50)         NOT NULL, 
    cardholder_mid_name     VARCHAR(50), 
    cardholder_last_name    VARCHAR(50)         NOT NULL, 
    card_type               CHAR(4)             NOT NULL, 
    cardnumber              VARCHAR(16)         NOT NULL, 
    expiration_date         DATE                NOT NULL, 
    cc_id                   CHAR(3)             NOT NULL, 
    billing_address         VARCHAR(50)         NOT NULL, 
    billing_city            VARCHAR(50)         NOT NULL, 
    billing_state           CHAR(2)             NOT NULL,
    billing_zip             CHAR(5)             NOT NULL
    );
    
    

    
ALTER TABLE Customer
MODIFY Stay_Credits_Earned DEFAULT 0;

ALTER TABLE Customer
MODIFY Stay_Credits_Used DEFAULT 0;

ALTER TABLE Reservation
MODIFY Date_Created DEFAULT SYSDATE;


/* Author: pg25357
   Creating SEQUENCES*/

CREATE SEQUENCE payment_id_seq 
START WITH 1;

CREATE SEQUENCE reservation_id_seq 
START WITH 1;

CREATE SEQUENCE room_id_seq 
START WITH 1;
 
CREATE SEQUENCE location_id_seq 
START WITH 1;
 
CREATE SEQUENCE feature_id_seq 
START WITH 1;
 
CREATE SEQUENCE customer_id_seq 
START WITH 100001;

/* Author: pg25357
   USing the SEQUENCES to autoincrement tables ids */
   
ALTER TABLE Customer_Payment
MODIFY Payment_id DEFAULT payment_id_seq.NEXTVAL;
 
ALTER TABLE Reservation
MODIFY Reservation_id DEFAULT reservation_id_seq.NEXTVAL;

ALTER TABLE Room
MODIFY Room_id DEFAULT room_id_seq.NEXTVAL;
 
ALTER TABLE Location
MODIFY Location_id DEFAULT location_id_seq.nextval;

ALTER TABLE Features
MODIFY Feature_id DEFAULT feature_id_seq.NEXTVAL;

ALTER TABLE Customer
MODIFY customer_id DEFAULT customer_id_seq.NEXTVAL;

/* Author: pg25357
   Insert Data into tables*/

--  Create the 3 locations mentioned in HW1 and make-up details on address, phone, and URL.
INSERT INTO Location (Location_Name, Address, City, State, Zip, Phone, URL) 
VALUES ('Balcones', '2810 salado street', 'Austin', 'TX', '78705', '512-123-1234', 'http://hotel-Balcones.com');

INSERT INTO Location (Location_Name, Address, City, State, Zip, Phone, URL) 
VALUES ('south congress', '3124 Gaudalupe street', 'Austin', 'TX', '78814', '512-123-1235', 'http://hotel-South_Congress.com'); 

INSERT INTO Location (Location_Name, Address, City, State, Zip, Phone, URL) 
VALUES ('East 7th lofts', '5676 Puru street', 'Austin', 'TX', '71123', '512-123-1236', 'http://hotel-East-7-Lofts.com'); 
commit; 



-- Create up to 3 features that can be shared or unique to the locations but make sure at least one location has multiple features assigned to it


INSERT INTO Features (Feature_Name) 
VALUES ('Swimming Pool'); 

INSERT INTO Features (Feature_Name) 
VALUES ('Gym'); 

INSERT INTO Features (Feature_Name) 
VALUES ('Spa'); 
commit; 

INSERT INTO Location_Features_Linking (Location_id, Feature_id) 
VALUES (1, 1); 
INSERT INTO Location_Features_Linking (Location_id, Feature_id) 
VALUES (2, 1);
INSERT INTO Location_Features_Linking (Location_id, Feature_id) 
VALUES (2, 2);
INSERT INTO Location_Features_Linking (Location_id, Feature_id) 
VALUES (3, 3);
commit; 


SELECT * FROM Location_Features_Linking;

-- Create 2 rooms for each location (even though in reality there should be more)
INSERT INTO Room (Location_id, Room_Number, Floor, Room_Type, Square_Footage, Max_People, Weekday_Rate, Weekend_Rate)
VALUES (1, 101, 1, 'D', 1200, 4, 500, 700);

INSERT INTO Room (Location_id, Room_Number, Floor, Room_Type, Square_Footage, Max_People, Weekday_Rate, Weekend_Rate)
VALUES (1, 102, 1, 'Q', 1000, 2, 300, 500);

INSERT INTO Room (Location_id, Room_Number, Floor, Room_Type, Square_Footage, Max_People, Weekday_Rate, Weekend_Rate)
VALUES (2, 201, 1, 'D', 1200, 4, 500, 700); 

INSERT INTO Room (Location_id, Room_Number, Floor, Room_Type, Square_Footage, Max_People, Weekday_Rate, Weekend_Rate)
VALUES (2, 202, 1, 'Q', 1000, 3, 300, 500);

INSERT INTO Room (Location_id, Room_Number, Floor, Room_Type, Square_Footage, Max_People, Weekday_Rate, Weekend_Rate)
VALUES (3, 101, 1, 'Q', 1000, 3, 200, 300); 

INSERT INTO Room (Location_id, Room_Number, Floor, Room_Type, Square_Footage, Max_People, Weekday_Rate, Weekend_Rate)
VALUES (3, 102, 1, 'K', 1500, 3, 700, 800); 
commit; 


-- Create 2 customers that have payments attached.  
-- The first customer should have your first and last name. 
-- Their email should be your uteid + “utexas.edu”. 
-- (e.g. abd123@utexas.edu). The rest of the data about you can be fake. Make up data for the 2nd customer. 


INSERT INTO Customer (first_name, last_name, email, phone,address_line_1, 
City, State, Zip, Birthdate, Stay_Credits_Earned, Stay_Credits_Used)
VALUES ('Preeti', 'Gupta', 'pg25357@utexas.edu', '512-111-1234', '2811 Salado Street', 'Austin', 'TX', '78705', '01-10-95', 100, 10);


INSERT INTO Customer (first_name, last_name, email, phone,address_line_1, 
City, State, Zip, Birthdate, Stay_Credits_Earned, Stay_Credits_Used)
VALUES ('Silky', 'Gupta', 'sg25357@utexas.edu', '512-111-1235', '2822 Salado Street', 'Austin', 'TX', '78705', '20-02-93', 50, 40);


INSERT INTO Customer_Payment (Customer_id, cardholder_first_name, cardholder_mid_name, cardholder_last_name,card_type, 
cardnumber, expiration_date, cc_id, billing_address, billing_city, billing_state, billing_zip)
VALUES (100001, 'Preeti',  'Kar', 'Gupta', 'VISA', '123456789012345', '01-01-2025', '011', '2020 Salado Street', 'Austin', 'TX', '78705');


INSERT INTO Customer_Payment (Customer_id, cardholder_first_name, cardholder_mid_name, cardholder_last_name,card_type, 
cardnumber, expiration_date, cc_id, billing_address, billing_city, billing_state, billing_zip)
VALUES (100002, 'Silky',  'Kar', 'Gupta', 'MAST', '123456789012346', '01-01-2026', '022', '2010 Salado Street', 'Austin', 'TX', '78705');
commit; 


-- For your customer account, create a single room reservation.  
-- For the 2nd, create two separate reservations that are on different dates.

INSERT INTO Reservation (Customer_id, Location_id, Confirmation_Nbr, Date_Created, Check_In_Date, 
Check_Out_Date, Status, Number_of_Guests, Reservation_Total, Discount_Code, Customer_Rating, Notes) 
VALUES (100001, 1, '12345678', '20-09-21', '25-09-21', '29-09-2021', 'U', 2, 500, 'Sept-End', 4, 'Please provide a list of Indian restaurnats nearby');

INSERT INTO Reservation (Customer_id, Location_id, Confirmation_Nbr, Date_Created, Check_In_Date, 
Check_Out_Date, Status, Number_of_Guests, Reservation_Total, Discount_Code, Customer_Rating, Notes) 
VALUES (100002, 2, '22345678', '20-09-21', '25-09-21', '29-09-2021', 'U', 2, 500, 'Sept-End', 4, 'Extra Table Lamp Required');


INSERT INTO Reservation (Customer_id, Location_id, Confirmation_Nbr, Date_Created, Check_In_Date, 
Check_Out_Date, Status, Number_of_Guests, Reservation_Total, Discount_Code, Customer_Rating) 

VALUES (100002, 2, '32345678', '21-09-21', '01-10-21', '05-10-2021', 'U', 2, 500, 'Oct-Deeds', 4.5);
commit; 


/* Author: pg25357
   Creating INDEXES for foreign keys not part of primary keys*/

CREATE INDEX reservation_customer_id_ix ON Reservation (Customer_id);
CREATE INDEX reservation_location_id_ix ON Reservation (Location_id);

CREATE INDEX room_location_id_ix ON Room (Location_id);
/* Author: pg25357
   Creating INDEXES on few more columns which might be used more often than the rests*/

CREATE INDEX Customer_last_name_ix ON Customer(last_name);
CREATE INDEX Reservation_check_in_date_ix ON Reservation(Check_In_Date);

commit;
