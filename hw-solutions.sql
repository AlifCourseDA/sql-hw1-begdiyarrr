    -- PART 1

-- 1
select billing_country, count(invoice_id) AS count_invoice
from invoice
group by billing_country
order by count_invoice;

-- 2
select billing_city, sum(total) AS sum_total
from invoice
group by billing_city
order by sum_total
limit 5;

-- 3
select c.first_name, c.last_name, sum(i.total) as sum_total
from customer c
join invoice i on c.customer_id = i.customer_id
group by c.first_name, c.last_name
order by sum_total
limit 1;

-- 4
select DISTINCT c.email, c.first_name, c.last_name, g.name
from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line i_l on i.invoice_id = i_l.invoice_id
join track t on i_l.track_id = t.track_id
join genre g on g.genre_id = t.genre_id
where g.name = 'Rock' and c.email like 's%';

-- 5
with t1 as (
    select i.billing_country as bil_country, sum(i.total) as sum_total
    from customer c
    join invoice i on c.customer_id = i.customer_id
    group by bil_country, c.first_name, c.last_name
),

t2 as (
    select bil_country, max(sum_total) as max_sum_total
    from t1
    group by t1.bil_country
)

select c.country, c.first_name, c.last_name, max_sum_total
from customer c
join t2 on c.country = t2.bil_country
group by c.country, c.first_name, c.last_name, max_sum_total
order by c.country;


    -- PART 2

-- 1
select count_name as num_appereance, count(count_name) as num_of_tracks
from (
select track.track_id, count(playlist_track.track_id) as count_name
from track
join playlist_track
on track.track_id = playlist_track.track_id
group by track.track_id)
group by count_name
order by count_name DESC;

-- 2
select a.title, sum(i.total) as revenue
from album a
join track t
on a.album_id = t.album_id
join invoice_line i_l
on t.track_id = i_l.track_id
join invoice i
on i_l.invoice_id = i.invoice_id
group by a.title
order by revenue DESC
limit 1;

-- 3
select invoice.billing_country, round(sum(invoice.total) / (select sum(invoice.total)
                                                      from invoice) * 100 , 3) as revenue_percent
from invoice
group by billing_country
order by revenue_percent DESC;

-- 4
select employee.employee_id, count(customer.support_rep_id) as num_customers_per_employee,
       AVG(invoice.total) as average_sale, sum(invoice.total) as total_for_employee
from employee
join customer
on employee.employee_id = customer.support_rep_id
join invoice
on customer.customer_id = invoice.customer_id
group by employee.employee_id;

select avg(CHAR_LENGTH(album.title)) as avg_length_of_data
from album;

-- 5
select a.album_id, count(t.track_id) as num_tracks_in_album, avg(i.total) as avg_revenue
from album a
join track t
on a.album_id = t.album_id
join invoice_line i_l
on t.track_id = i_l.track_id
join invoice i
on i_l.invoice_id = i.invoice_id
group by a.album_id
order by a.album_id;

-- 6
select t.track_id, count(t.track_id) as num_apperreances, sum(i.total) as total_revenue
from track t
join invoice_line i_l
on t.track_id = i_l.invoice_id
join invoice i
on i_l.invoice_id = i.invoice_id
group by t.track_id
order by 2 desc ;

-- 7

select year, sum(sum_total)
from (
select date_part('year', invoice_date) as year, sum(total) as sum_total
from invoice
group by invoice_date
order by invoice_date )
group by 1
order by 1;
