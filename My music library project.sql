-- Createing Database 
-- drop database music_library;

create database music_library ;

-- Reading the Database

use music_library ;

-- Creating Tables

create table employee
(employee_id int primary key auto_increment ,
 first_name varchar(100) ,
 last_name varchar(100) ,
 title varchar(100) ,
 reports_to int ,
 levels char(20) ,
 birthdate varchar(50) ,
 hire_date varchar(50),
 address varchar (50) ,
 city varchar(50) ,
 state varchar(10) ,
 country varchar (50) ,
 postal_code varchar(20) ,
 phone varchar(20) ,
 fax varchar(20) ,
 email varchar (50) ) ;
 
 create table customer
 (customer_id int primary key auto_increment ,
 first_name varchar(50) ,
 last_name varchar(50) ,
 company varchar (100),
 address varchar(100) ,
 city varchar (50) ,
 state varchar(50) ,
 country varchar (50) ,
 postal_code varchar (50) ,
 phone varchar (50) ,
 fax varchar (50) ,
 email varchar(100) ,
 support_rep_id int ,
 foreign key (support_rep_id) references employee(employee_id ) on delete set null) ;
 
 
 create table invoice
 (invoice_id int primary key auto_increment ,
 customer_id int ,
 invoice_date varchar (50) ,
 billing_address varchar (50) ,
 billing_city varchar (50) ,
 billing_state varchar(50) ,
 billing_country varchar(50) ,
 billing_postal_code varchar (50) ,
 total float , 
 foreign key (customer_id) references customer(customer_id) on delete set null ) ;
 
 
 
 create table playlist 
 (playlist_id int primary key auto_increment ,
 name varchar(50) ) ;
 

 create table media_type
 (media_type_id int primary key auto_increment ,
 name varchar (30) ) ;
 
 create table genre 
 (genre_id int primary key auto_increment ,
 name varchar(30) ) ;
 
 create table artist
( artist_id int primary key auto_increment ,
name varchar(100) ) ;
 
 create table album 
 (album_id int primary key auto_increment ,
 title varchar(100) ,
 artist_id int ,
 foreign key (artist_id) references artist(artist_id) on delete set null ) ;
 
 create table track 
 (track_id int primary key  ,
 name varchar(150),
 album_id int ,
 media_type_id int ,
 genre_id int ,
 composer varchar (150) ,
 milliseconds int ,
 bytes int ,
 unit_price float ,
 foreign key (media_type_id) references media_type(media_type_id) on delete set null,
 foreign key (genre_id) references genre(genre_id) on delete set null ,
 foreign key (album_id) references album(album_id) on delete set null ) ;
 
 
 
 
 create table invoice_line 
 (invoice_line_id int primary key auto_increment,
 invoice_id int ,
 track_id int ,
 unit_price float,
 quantity int ,
 foreign key (invoice_id) references invoice(invoice_id) on delete set null ,
 foreign key (track_id) references track(track_id) ) ;
 
  create table playlist_track 
 (playlist_id int ,
 track_id int ,
 foreign key (playlist_id) references playlist(playlist_id) on delete set null ,
 foreign key (track_id) references track(track_id) on delete set null ) ;
 
 -- Retriving The Data
 
select * from music_library.employee ;
select * from music_library.customer ;
select * from music_library.invoice ;
select * from music_library.playlist ;
select * from music_library.artist ;
select * from music_library.media_type ;
select * from music_library.genre ;
select * from music_library.album ;
select * from music_library.track ;    
select * from music_library.invoice_line ;

				
                -- Q N A --

-- 1. Who is the senior most employee based on job title? 

select employee_id ,first_name , last_name , title 
from employee 
where title = (select max(title) from employee) ;


-- 2. Which countries have the most Invoices?

select billing_country, count(invoice_id) as Most_invoice 
from invoice
group by billing_country limit 1;

-- 3. What are the top 3 values of total invoice?

select distinct(total) from invoice
order by total desc limit 3 ;

-- 4. Which city has the best customers? 
-- We would like to throw a promotional Music Festival in the city we made the most money.
-- Write a query that returns one city that has the highest sum of invoice totals. 
-- Return both the city name & sum of all invoice totals

select c.city ,round(sum(i.total)) as Invoice_total
from customer as c
join invoice as i
on c.customer_id = i.customer_id 
group by c.city 
order by Invoice_total desc;

/* 5.  Who is the best customer? 
The customer who has spent the most money will be declared the best customer.
 Write a query that returns the person who has spent the most money */
 
 select concat(c.first_name," ",c.last_name) as full_name ,round(sum(unit_price)) as Money_spend
 from customer as c
 join invoice as i
 on c.customer_id = i.customer_id 
 join invoice_line as il
 on i.invoice_id = il.invoice_id 
 group by full_name
 order by Money_spend desc;

/* 6. Write a query to return the email, first name, last name, & Genre of all Rock Music listeners.
 Return your list ordered alphabetically by email starting with A */
 
select distinct(concat(c.first_name," ",last_name)) as full_name , c.email 
from customer as c
join invoice as i 
on c.customer_id = i.customer_id
join invoice_line as il
on i.invoice_id = il.invoice_id
join track as t
on il.track_id = t.track_id 
join genre as g
on t.genre_id = g.genre_id
where g.name = "Rock" 
order by c.email;

/* 7. Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands */

select a.name as Artist_Name , count(t.name) as Total_Count
from artist as a
join album as al
on a.artist_id = al.artist_id
join track as t
on al.album_id = t.album_id
join genre as g
on t.genre_id = g.genre_id
where g.name = "Rock"
group by Artist_name
order by Total_count desc
limit 10 ;

/* 8. Return all the track names that have a song length longer than the average song length.
 Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first */

select name , milliseconds
from track 
where 
milliseconds > (select avg(milliseconds) as Average_length from track )
order by milliseconds desc ;

/* 9. Find how much amount is spent by each customer on artists? 
Write a query to return customer name, artist name and total spent */

select  (concat(c.first_name," ",c.last_name))as full_name ,
 ar.name as artist_name,round(sum(i.total)) as Total_spent from customer as c
join invoice as i
on c.customer_id = i.customer_id 
join invoice_line as il
on i.invoice_id = il.invoice_id
join track as t
on il.track_id = t.track_id
join album as a
on t.album_id = a.album_id
join artist as ar
on a.artist_id = ar.artist_id 
group by full_name,ar.name
order by Total_spent desc;

/* 10. We want to find out the most popular music Genre for each country.
 We determine the most popular genre as the genre with the highest amount of purchases.
 Write a query that returns each country along with the top Genre. 
 For countries where the maximum number of purchases is shared return all Genres */
 
with a as (select i.billing_country, g.name, round(sum(i.total)) as total, 
dense_rank() over(partition by i.billing_country order by sum(i.total) desc) as rnk
from invoice as i inner join invoice_line using(invoice_id) inner join track using(track_id) inner join genre as g using(genre_id)
group by i.billing_country, g.name order by total)
select * from a where rnk = 1;

/* 11. Write a query that determines the customer that has spent the most on music for each country.
 Write a query that returns the country along with the top customer and how much they spent. 
 For countries where the top amount spent is shared, provide all customers who spent this amount */

with a as(select i.billing_country as country, c.first_name as customer_name, round(sum(i.total),0) as total,
dense_rank() over(partition by billing_country order by(sum(i.total)) desc) as rnk
from invoice as i  join customer as c 
on i.customer_id = c.customer_id
group by billing_country, customer_name)
select country, customer_name, total from a where rnk = 1
order by total desc ;

    
