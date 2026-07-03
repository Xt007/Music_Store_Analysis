##SQL PROJECT- MUSIC STORE DATA ANALYSIS
##Question Set 1 - Easy

##1.	Who is the senior most employee based on job title?
        select *
        from `music_store.employee`
        order by levels desc
        limit 1
        ;

##2.	Which countries have the most Invoices?
	select billing_country,
               count(*) as total_invoices
        from `music_store.invoice`
        group by billing_country
        order by total_invoices desc 
        ;

##3.	What are top 3 values of total invoice?
    	select invoice_id,
        total
 	from `music_store.invoice`
	order by total desc 
	limit 3
	;

##4.	Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest 	sum of invoice totals. Return both the city name & sum of all invoice totals
	select billing_city,
        round(sum(total),2) as total_invoices
	from `music_store.invoice`
	group by billing_city
	order by total_invoices desc
	limit 1
	;

##5.	Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money
	select c.customer_id,concat(c.first_name," ",c.last_name) as full_name,
        round(sum(i.total),2) as total_spent
	from `music_store.customer` c join `music_store.invoice` i
	on c.customer_id = i.customer_id
	group by c.customer_id,full_name
	order by total_spent desc 
	limit 1
	;

##Question Set 2 – Moderate

##1.	Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A
  	select distinct
        c.email,
        c.first_name,
        c.last_name,
        g.name
	from `music_store.customer` c join `music_store.invoice` i
	on c.customer_id = i.customer_id
	join `music_store.invoice_line` il 
	on i.invoice_id = il.invoice_id
	join `music_store.track` t
	on il.track_id = t.track_id
	join `music_store.genre` g
	on t.genre_id = g.genre_id
	where t.track_id in (
           		          select track_id
                     		  from `music_store.track` t1 join `music_store.genre` g1
                     		  on t1.genre_id = g1.genre_id
                     		  where g1.name like 'Rock'
                    	    )
	order by c.email


2##.	Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands.
	select a.name,
        count(t.track_id) as total_track_count
	from `music_store.artist` a join `music_store.album` ab 
	on a.artist_id = ab.artist_id
	join `music_store.track` t
	on ab.album_id = t.album_id
	join `music_store.genre` g
	on t.genre_id = g.genre_id
	where g.name = "Rock"
	group by a.name
	order by total_track_count desc
	limit 10
	;


##3.	Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest 	songs listed first
	select name as track_name,
        milliseconds
	from `music_store.track`
	where milliseconds > (
                      		  select avg(milliseconds) as avg_milliseconds
                      		  from `music_store.track`
                   	     )
	order by milliseconds desc 
	;


##Question Set 3 – Advance

##1.	Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent
    	select concat(c.first_name," " ,c.last_name) as customer_name,a.name as artist_name,
        round(sum(i.total*t.unit_price),2) as total_spent
	from `music_store.customer` c join `music_store.invoice` i 
	on c.customer_id = i.customer_id
	join `music_store.invoice_line` il 
	on i.invoice_id = il.invoice_id
	join `music_store.track` t 
	on il.track_id = t.track_id
	join `music_store.album` ab 
	on t.album_id = ab.album_id
	join `music_store.artist` a
	on ab.artist_id = a.artist_id
	group by customer_name,artist_name
	order by total_spent desc
	;


##2.	We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest number of purchases. Write a query that returns 	each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres
        select i.billing_country as country,g.name as genre_name,
        round(sum(t.unit_price*i.total),2) as highest_purchase
	from `music_store.customer` c join `music_store.invoice` i
	on c.customer_id = i.customer_id
	join `music_store.invoice_line` il 
	on i.invoice_id = il.invoice_id
	join `music_store.track` t
	on il.track_id = t.track_id
	join `music_store.genre` g
	on t.genre_id = g.genre_id
	group by country,genre_name
	order by highest_purchase desc
	;


##3.	Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they 	spent. For countries where the top amount spent is shared, provide all customers who spent this amount
	select billing_country,concat(c.first_name," ",c.last_name) as customer_name,
        round(sum(total*t.unit_price),2) as highest_amount_spent
	from `music_store.customer` c join `music_store.invoice` i
	on c.customer_id = i.customer_id
	join `music_store.invoice_line` il 
	on i.invoice_id = il.invoice_id
	join `music_store.track` t
	on il.track_id = t.track_id
	group by billing_country,customer_name
	order by highest_amount_spent desc 
	;



