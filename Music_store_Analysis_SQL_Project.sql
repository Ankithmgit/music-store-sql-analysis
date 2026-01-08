create database if not exists music_store;


use music_store;

SET GLOBAL local_infile = 1;

/* LOAD DATA LOCAL INFILE can be abused:

A malicious server can trick a client into uploading any local file

Example: passwords, SSH keys, system files */

SET FOREIGN_KEY_CHECKS = 0;

-- 0. Genre .
CREATE TABLE if not exists Genre ( 
genre_id INT AUTO_INCREMENT PRIMARY KEY, 
name VARCHAR(120) 
); 

-- 1. Media Type .
CREATE TABLE if not exists MediaType ( 
media_type_id INT AUTO_INCREMENT PRIMARY KEY, 
name VARCHAR(120) 
); 

-- 2. Employee .
CREATE TABLE if not exists Employee ( 
 employee_id INT AUTO_INCREMENT PRIMARY KEY, 
 last_name VARCHAR(120), 
 first_name VARCHAR(120), 
 title VARCHAR(120), 
 reports_to INT, 
  levels VARCHAR(255), 
 birthdate DATE, 
 hire_date DATE, 
 address VARCHAR(255), 
 city VARCHAR(100), 
 state VARCHAR(100), 
 country VARCHAR(100), 
 postal_code VARCHAR(20), 
 phone VARCHAR(50), 
 fax VARCHAR(50), 
 email VARCHAR(100) 
);

 -- 3. Customer .
CREATE TABLE if not exists Customer ( 
 customer_id INT AUTO_INCREMENT PRIMARY KEY, 
 first_name VARCHAR(120), 
 last_name VARCHAR(120), 
 company VARCHAR(120), 
 address VARCHAR(255), 
 city VARCHAR(100), 
 state VARCHAR(100), 
 country VARCHAR(100), 
 postal_code VARCHAR(20), 
 phone VARCHAR(50), 
 fax VARCHAR(50), 
 email VARCHAR(100), 
 support_rep_id INT, 
 FOREIGN KEY (support_rep_id) REFERENCES Employee(employee_id) 
 ON DELETE SET NULL ON UPDATE CASCADE
); 
/*
If you update the PRIMARY KEY of a parent table row,
MySQL will automatically update all matching FOREIGN KEY values in child tables.
When a parent row is deleted, then:

Child rows are NOT deleted

The foreign key column in the child table is set to NULL */

 -- 4. Artist .
CREATE TABLE if not exists Artist ( 
 artist_id INT AUTO_INCREMENT PRIMARY KEY, 
 name text 
); 

 -- 5. Album .
CREATE TABLE if not exists Album ( 
 album_id INT AUTO_INCREMENT PRIMARY KEY, 
 title VARCHAR(160), 
 artist_id INT, 
 FOREIGN KEY (artist_id) REFERENCES Artist(artist_id) 
 ON DELETE SET NULL ON UPDATE CASCADE
); 

 -- 6. Track .
CREATE TABLE if not exists Track ( 
 
 track_id INT AUTO_INCREMENT PRIMARY KEY, 
 name VARCHAR(200), 
 album_id INT, 
 media_type_id INT, 
 genre_id INT, 
 composer VARCHAR(220), 
 milliseconds INT, 
 bytes INT, 
 unit_price DECIMAL(10,2), 
 FOREIGN KEY (album_id) REFERENCES Album(album_id) ON DELETE SET NULL ON UPDATE CASCADE, 
 FOREIGN KEY (media_type_id) REFERENCES MediaType(media_type_id) ON DELETE SET NULL ON UPDATE CASCADE, 
 FOREIGN KEY (genre_id) REFERENCES Genre(genre_id) ON DELETE SET NULL ON UPDATE CASCADE
); 

 -- 7. Invoice .
CREATE TABLE if not exists Invoice ( 
 invoice_id INT AUTO_INCREMENT PRIMARY KEY, 
 customer_id INT, 
 invoice_date DATE, 
 billing_address VARCHAR(255), 
 billing_city VARCHAR(100), 
 billing_state VARCHAR(100), 
 billing_country VARCHAR(100), 
 billing_postal_code VARCHAR(20), 
 total DECIMAL(10,2), 
 FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE SET NULL ON UPDATE CASCADE
); 

 -- 8. InvoiceLine .
CREATE TABLE if not exists InvoiceLine ( 
 invoice_line_id INT AUTO_INCREMENT PRIMARY KEY, 
 invoice_id INT, 
 track_id INT, 
 unit_price DECIMAL(10,2), 
 quantity INT, 
 FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id) ON DELETE SET NULL ON UPDATE CASCADE, 
 FOREIGN KEY (track_id) REFERENCES Track(track_id) ON DELETE SET NULL ON UPDATE CASCADE
); 

 -- 9. Playlist .
CREATE TABLE if not exists Playlist ( 
  playlist_id INT AUTO_INCREMENT PRIMARY KEY, 
 name VARCHAR(255) 
); 

 -- 10. PlaylistTrack .
CREATE TABLE if not exists PlaylistTrack ( 
 playlist_id INT, 
 track_id INT, 
 PRIMARY KEY AUTO_INCREMENT (playlist_id, track_id), 
 FOREIGN KEY (playlist_id) REFERENCES Playlist(playlist_id) ON DELETE CASCADE, 
 FOREIGN KEY (track_id) REFERENCES Track(track_id) ON DELETE CASCADE
); 





LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/genre.csv'
INTO TABLE Genre
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/media_type.csv'
INTO TABLE MediaType
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/employee.csv'
INTO TABLE Employee
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
  employee_id,
  last_name,
  first_name,
  title,
  @reports_to,
  levels,
  birthdate,
  hire_date,
  address,
  city,
  state,
  country,
  postal_code,
  phone,
  fax,
  email
)
SET reports_to = NULLIF(@reports_to, '');
-- returns null if @reports to == null; otherwise returns @reports_to value.

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customer.csv'
INTO TABLE Customer
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/artist.csv'
INTO TABLE Artist
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/album.csv'
INTO TABLE Album
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/track.csv'
INTO TABLE Track
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/invoice.csv'
INTO TABLE Invoice
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/invoice_line.csv'
INTO TABLE InvoiceLine
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/playlist.csv'
INTO TABLE Playlist
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8./Uploads/playlist_track.csv'
INTO TABLE PlaylistTrack
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SET FOREIGN_KEY_CHECKS = 1;


SELECT 'Genre' AS table_name, COUNT(*) AS total_rows FROM Genre
UNION ALL
SELECT 'MediaType', COUNT(*) FROM MediaType
UNION ALL
SELECT 'Employee', COUNT(*) FROM Employee
UNION ALL
SELECT 'Customer', COUNT(*) FROM Customer
UNION ALL
SELECT 'Artist', COUNT(*) FROM Artist
UNION ALL
SELECT 'Album', COUNT(*) FROM Album
UNION ALL
SELECT 'Track', COUNT(*) FROM Track
UNION ALL
SELECT 'Invoice', COUNT(*) FROM Invoice
UNION ALL
SELECT 'InvoiceLine', COUNT(*) FROM InvoiceLine
UNION ALL
SELECT 'Playlist', COUNT(*) FROM Playlist
UNION ALL
SELECT 'PlaylistTrack', COUNT(*) FROM PlaylistTrack;


select * from employee;
select * from invoice;
select * from customer;
select * from genre;

-- 1. Who is the senior most employee based on job title?  
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    title,
    levels
FROM Employee
ORDER BY CAST(SUBSTRING(levels, 2) AS UNSIGNED) DESC
LIMIT 1;





-- 2. Which countries have the most Invoices? 
-- billing country from invoice table gives you that. 
-- select * from invoice;

SELECT
    billing_country,
    COUNT(*) AS total_invoices
FROM invoice
GROUP BY billing_country
ORDER BY total_invoices DESC
LIMIT 5;



-- 3. What are the top 3 values of total invoice? 
-- top 3 totals from invoice table answers this.

-- select * from invoice;

SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;



-- 4. Which city has the best customers? - We would like to throw a promotional Music Festival in 
-- the city we made the most money. Write a query that returns one city that has the highest sum of 
-- invoice totals. Return both the city name & sum of all invoice totals 

-- Total column coupled with billing_city and then their aggregation gives the desired output. Again use invoice table.

SELECT billing_city,
       SUM(total) AS total_revenue
FROM invoice
GROUP BY billing_city
ORDER BY total_revenue DESC
LIMIT 1;


-- 5. Who is the best customer? - The customer who has spent the most money will be declared 
-- the best customer. Write a query that returns the person who has spent the most money.

-- Based on customer id in invoice table find out who spent the most and then retrieve the customer name from customer table using the same id. 

SELECT c.first_name,
       c.last_name,
       SUM(i.total) AS total_spent
FROM customer c
JOIN invoice i
  ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 1;


-- 6. Write a query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A 

-- genre table gives the genre_id of 'rock' then customer table gives the first name, last name, and email. It must be ordered with email('A' being starting).

select * from genre; 

SELECT DISTINCT
       c.email,
       c.first_name,
       c.last_name,
       g.name AS genre
FROM customer c
JOIN invoice i  ON c.customer_id = i.customer_id
JOIN invoiceline il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE LOWER(TRIM(g.name)) LIKE '%rock%'
ORDER BY c.email;


-- 7. Let's invite the artists who have written the most rock music in our dataset. Write a query that 
-- returns the Artist name and total track count of the top 10 rock bands.

SELECT 
       ar.name AS artist_name,
       COUNT(t.track_id) AS total_rock_tracks
FROM artist ar
JOIN album al
  ON ar.artist_id = al.artist_id
JOIN track t
  ON al.album_id = t.album_id
JOIN genre g
  ON t.genre_id = g.genre_id
WHERE LOWER(TRIM(g.name)) LIKE '%rock%'
GROUP BY ar.artist_id, ar.name
ORDER BY total_rock_tracks DESC
LIMIT 10;



-- 8. Return all the track names that have a song length longer than the average song length.- 
-- Return the Name and Milliseconds for each track. Order by the song length, with the longest 
-- songs listed first.

SELECT 
       name,
       milliseconds
FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds)
    FROM track
)
ORDER BY milliseconds DESC;

-- select AVG(milliseconds) as avg_time from track;

-- 9. Find how much amount is spent by each customer on artists? Write a query to return 
-- customer name, artist name and total spent  

SELECT
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       ar.name AS artist_name,
       SUM(il.unit_price * il.quantity) AS total_spent
FROM customer c
JOIN invoice i
  ON c.customer_id = i.customer_id
JOIN invoiceline il
  ON i.invoice_id = il.invoice_id
JOIN track t
  ON il.track_id = t.track_id
JOIN album al
  ON t.album_id = al.album_id
JOIN artist ar
  ON al.artist_id = ar.artist_id
GROUP BY c.customer_id, ar.artist_id
ORDER BY customer_name, total_spent DESC;




-- 10. We want to find out the most popular music Genre for each country. We determine the most 
-- popular genre as the genre with the highest amount of purchases. Write a query that returns 
-- each country along with the top Genre. For countries where the maximum number of purchases 
-- is shared, return all Genres. 

SELECT
    i.billing_country AS country,
    g.name AS genre,
    COUNT(il.invoice_line_id) AS purchase_count
FROM invoice i
JOIN invoiceline il
  ON i.invoice_id = il.invoice_id
JOIN track t
  ON il.track_id = t.track_id
JOIN genre g
  ON t.genre_id = g.genre_id
GROUP BY i.billing_country, g.genre_id, g.name;


WITH genre_purchases AS (
    SELECT
        i.billing_country AS country,
        g.name AS genre,
        COUNT(il.invoice_line_id) AS purchase_count,
        DENSE_RANK() OVER (
            PARTITION BY i.billing_country
            ORDER BY COUNT(il.invoice_line_id) DESC
        ) AS genre_rank
    FROM invoice i
    JOIN invoiceline il
      ON i.invoice_id = il.invoice_id
    JOIN track t
      ON il.track_id = t.track_id
    JOIN genre g
      ON t.genre_id = g.genre_id
    GROUP BY i.billing_country, g.genre_id, g.name
)
SELECT
    country,
    genre,
    purchase_count
FROM genre_purchases
WHERE genre_rank = 1
ORDER BY country;




-- 11. Write a query that determines the customer that has spent the most on music for each 
-- country. Write a query that returns the country along with the top customer and how much they 
-- spent. For countries where the top amount spent is shared, provide all customers who spent this 
-- amount

WITH customer_spending AS (
    SELECT
        i.billing_country AS country,
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(il.unit_price * il.quantity) AS total_spent,
        DENSE_RANK() OVER (
            PARTITION BY i.billing_country
            ORDER BY SUM(il.unit_price * il.quantity) DESC
        ) AS spending_rank
    FROM customer c
    JOIN invoice i
      ON c.customer_id = i.customer_id
    JOIN invoiceline il
      ON i.invoice_id = il.invoice_id
    GROUP BY
        i.billing_country,
        c.customer_id,
        c.first_name,
        c.last_name
)
SELECT
    country,
    customer_name,
    total_spent
FROM customer_spending
WHERE spending_rank = 1
ORDER BY country;