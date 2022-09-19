
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS status;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS sales;

/* Start Location TABLE */

create table location (
	id int IDENTITY(1,1) not null,
	location_name varchar(100) not null,

	PRIMARY KEY (id)

);
    INSERT INTO location ( location_name) 
	VALUES ('New York'),
		   ('Springfield'),
		   ('Boston'),
		   ('Miami'),
		   ('Los Angeles');
	select*from location;

/* END Location TABLE */


/* START USER TABLES */
create table roles(
	id int IDENTITY(1,1) not null,
	role_name varchar(100) not null,
	role_description varchar(200) not null,
	
	PRIMARY KEY (id)

);
   INSERT INTO roles (role_name, role_description)
   VALUES ('Owner','Own the tavern'),
		  ('Staff','Employee of the tavern');

create table users (
	id int IDENTITY(1,1) not null,
	user_name varchar(100) not null,
	birthday date not null,
	role_id int,

	PRIMARY KEY (id),
);
ALTER TABLE users ADD FOREIGN KEY (role_id) REFERENCES roles(id);

select*from users;

INSERT INTO users (user_name,birthday,role_id)
 VALUES ('Romel','03-18-1998', 1),
		('Alfredo','03-18-1994' ,2),
		('Kate','01-15-1998', 1),
		('Laura','11-08-1995', 1),
		('Bryan','12-13-1995', 2),
		('Alicia','12-13-1995', 2);


/* END User TABLES */


create table taverns (
	id int not null IDENTITY(1,1),
	tavern_name varchar(100) not null,
	owner_id int,
	floors_count int,
	location_id int,
	supply_id int,
	
	PRIMARY KEY (id),
	FOREIGN KEY (owner_id) REFERENCES users(id),	
    FOREIGN KEY (location_id) REFERENCES location(id),
    FOREIGN KEY (supply_id) REFERENCES supply(id),
);

  INSERT INTO taverns (tavern_name,owner_id,floors_count,location_id,supply_id)
   VALUES ('Moe Tavern', 1,1,2,3);
   INSERT INTO taverns (tavern_name,owner_id,floors_count,location_id,supply_id)
   VALUES ('Warren Tavern',3,2,1,2),
		  ('The Green Dragon Tavern', 4,1,3,2);
   INSERT INTO taverns (tavern_name,owner_id,floors_count,location_id,supply_id)
   VALUES ('The Blue Dragon Tavern', 4,1,4,2),
		  ('The Wild Dog Tavern', 4,2,5,1);

select*from taverns;


/* Start supply tables */
create table supply (
	id int IDENTITY(1,1) not null,
	unit varchar(100) not null,
	supply_name varchar(100) not null,
	PRIMARY KEY (id),

);
select*from supply;
INSERT INTO supply (unit,supply_name)
	VALUES (' 11.2 Ounce', 'Strong Ale'),
			('16 Ounce', 'Whiskey'),
			('12 ounce', 'Vodka');

create table inventory (
	id int IDENTITY (1,1) not null,
	supply_id int not null,
	current_count varchar (100) not null,
	date_updated date not null,
	tavern_id int not null,

);

ALTER TABLE inventory ADD PRIMARY KEY (id);
ALTER TABLE inventory ADD FOREIGN KEY (supply_id) REFERENCES supply(id);
ALTER TABLE inventory ADD FOREIGN KEY (tavern_id) REFERENCES taverns(id);

INSERT INTO inventory (supply_id,current_count,date_updated,tavern_id)
	VALUES  ( 1, '10 Bottles ','09-14-2022',1),
			( 2, '15 Bottles ','09-14-2022',2),
			( 3, '20 Bottles' ,'09-14-2022',3),
			( 1, '5 Bottles ','09-14-2022',4),
			( 2, '20 Bottles ','09-14-2022',5);
			
select* from inventory;

create table supply_recieved (
	id int IDENTITY(1,1) not null,
	supply_id int not null,
	tavern_id int not null,
	cost varchar(100) not null,
	amount_recieved varchar(100) not null,
	date_revieved date not null,

	PRIMARY KEY (id),
	

);


 ALTER TABLE supply_recieved ADD FOREIGN KEY (supply_id) REFERENCES supply(id);
 ALTER TABLE supply_recieved ADD FOREIGN KEY (tavern_id) REFERENCES taverns(id);

INSERT INTO supply_recieved (supply_id,amount_recieved,cost,date_revieved,tavern_id)
	VALUES  ( 1, '50 Bottles ','$6 e/u','08-30-2022',1),
			( 2, '70 Bottles ','$10 e/u','09-01-2022',2),
			( 3, '40 Bottles' ,'$9 e/u','08-25-2022',3),
			( 1, '60 Bottles ','$6 e/u','08-29-2022',4),
			( 2, '70 Bottles ','$10 e/u','09-02-2022',5);
			
Select * from supply_recieved;

create table supply_sales(
	id int IDENTITY(1,1) not null,
	supply_recievedID int not null, 

);
ALTER TABLE supply_sales ADD PRIMARY KEY (id);
ALTER TABLE supply_sales ADD FOREIGN KEY (supply_recievedID) REFERENCES supply_recieved(id);

INSERT INTO supply_sales(supply_recievedID) 
VALUES (1),
	   (2),
	   (3),
	   (4),
	   (5);


SELECT supply_sales.id, supply_recieved.supply_id,supply_recieved.amount_recieved,supply_recieved.cost,supply_recieved.date_revieved,supply_recieved.tavern_id FROM supply_sales INNER JOIN supply_recieved ON supply_sales.id=supply_recieved.id;

/* END supply tables  */

/* START SERVICE TABLES */
create table status (
	id int IDENTITY(1,1) not null,
	status_name varchar(100) not null,

	PRIMARY KEY (id)

);
	INSERT INTO status (status_name) 
	VALUES ('ACTIVE'),
		   ('INACTIVE'),
		   ('OUT OF STOCK'),
		   ('DISCONTINUED');

Select * from status;


create table services (
	id int IDENTITY(1,1) not null,
	service_name varchar(100) not null,
	status_id int not null,

	PRIMARY KEY (id),
	

);
ALTER TABLE services ADD FOREIGN KEY (status_id) REFERENCES status(id);

Select * from services;

     INSERT INTO services(service_name,status_id)
	 VALUES ('Pool', 1),
			('Weapon sharpening', 2);

create table service_sales (
	id int IDENTITY(1,1) not null,
	service_id int not null,
	guest varchar(100) not null,
	price varchar(100) not null,
	date_purchased date not null,
	tavern_id int not null,

	PRIMARY KEY (id),
	

);

ALTER TABLE service_sales ADD FOREIGN KEY (service_id) REFERENCES services (id);
ALTER TABLE service_sales ADD FOREIGN KEY (tavern_id) REFERENCES taverns (id);



    INSERT INTO service_sales(service_id,guest,price,date_purchased,tavern_id)
	VALUES (1, 'Romel Florian', '$10','09-15-2022', 1),
		   (2, 'Kaitlyn Florian', '$15','09-15-2022', 5),
		   (1, 'Laura Florian', '$12','09-15-2022', 2),
		   (1, 'Alicia Florian', '$10','09-15-2022', 3),
		   (2, 'Bryan Cabreja', '$12','09-15-2022', 4);

select*from service_sales;

/* END SERVICE TABLES */

create table basement_rats (
	id int IDENTITY(1,1) not null,
	name varchar(100) not null,
	tavern_id int not null,

	PRIMARY KEY (id),
	

);

	ALTER TABLE basement_rats ADD FOREIGN KEY (tavern_id) REFERENCES taverns(id);

    INSERT INTO basement_rats (name,tavern_id)
	VALUES ('Mikey', 2),
		   ('Minnie', 1),
		   ('Mikey', 1),
		   ('Minnie', 5),
		   ('Mikey', 4),
		   ('Minnie', 4);

select*from basement_rats;


/* Start Sales TABLE */

create table sales(
	id int IDENTITY(1,1) not null,
	supply_salesID int not null,
	service_salesID int not null,
);
ALTER TABLE sales ADD FOREIGN KEY (supply_salesID) REFERENCES supply_sales(id);
ALTER TABLE sales ADD FOREIGN KEY (service_salesID) REFERENCES service_sales(id);

INSERT INTO sales(supply_salesID,service_salesID)
VALUES (1,1),
	   (2,2),
	   (3,3),
	   (4,4),
	   (5,5);
		

SELECT * FROM sales;

SELECT sales.id, service_sales.service_id, service_sales.guest,service_sales.price,service_sales.date_purchased,service_sales.tavern_id FROM sales INNER JOIN service_sales ON sales.id=service_sales.id;

/* End Sales TABLE */


/* Start Guest TABLES */

create table guest (
id int IDENTITY (1,1) not null,
name varchar(100) not null,
birthdays date,
cakedays varchar (100),
status_id int not null,


Primary key (id),
);

ALTER TABLE guest ADD FOREIGN KEY (status_id) REFERENCES guest_status(id);

 INSERT INTO guest (name,birthdays,cakedays,status_id) 
 VALUES ('Romel','03-18-1998', 'Monday and Friday', 3),
		('Kate','01-15-1998', 'Tuesday and Saturday', 1),
		('Laura','11-08-1995', 'Sunday', 5);

SELECT * FROM guest;

create table guest_status (
 id int IDENTITY(1,1) not null,
 name varchar(100) not null,
 
 primary key (id)
);


 INSERT INTO guest_status( name) 
 VALUES ('Sick'),
		('Fine'),
		('Hangry'),
		('Raging'),
		('Placid');


SELECT * FROM guest_status;

create table classes (
	id int IDENTITY(1,1) not null,
	name varchar (100) not null,
	Primary key (id)

);
INSERT INTO classes( name) 
 VALUES ('Rookie'),
		('Mage'),
		('Fighter');

SELECT * FROM classes;

create table levels (
 id int IDENTITY(1,1) not null,
 guest_id int not null,
 classes_id int not null,


 Primary key (id),

 Foreign key (guest_id) REFERENCES levels(id),
 Foreign key (classes_id) REFERENCES classes(id)

);

INSERT INTO levels (guest_id, classes_id)
VALUES (1,3),
	   (2,1),
		(3,2);

select*from levels;

/* End Guest TABLES */