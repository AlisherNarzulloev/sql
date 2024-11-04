-- 1. Задача №1

with client_counts as (
	select 
		e.employee_id,
		e.first_name || ' ' || e.last_name as full_name,
		count(c.customer_id) as client_count
	from employee e 
	left join customer c on e.employee_id = c.support_rep_id
	group by e.employee_id, e.first_name, e.last_name
),
total_clients as (
	select count(*) as total_client_count
	from customer c 
)
select 
	cc.employee_id,
	cc.full_name,
	cc.client_count,
	round((cc.client_count::DECIMAL / tc.total_client_count) * 100, 2) as client_percent
from client_counts cc
join total_clients tc on true
order by cc.client_count desc;

-- 2. Задача №2

select 
	a.title as album_title,
	art.name as artist_name
from album a
join artist art on a.artist_id = art.artist_id 
left join track t on a.album_id  = t.album_id 
left  join invoice_line il on t.track_id  = il.track_id 
where il.invoice_line_id  is null 
group by a.title, art.name 


-- 3. Задача №3
with monthly_sales as (
	select 
		c.customer_id,
		c.first_name || ' ' || c.last_name as full_name,
		extract(year from i.invoice_date)::text || lpad(extract(month from i.invoice_date)::text, 2, '0') as monthkey,
		sum(i.total) as total
	from customer c 
	join invoice i on c.customer_id = i.customer_id
	group by c.customer_id, full_name, monthkey
),
monthly_totals as (
	select 
		monthkey,
		sum(total) as month_total
	from monthly_sales
	group by monthkey
)
select 
	ms.customer_id,
	ms.full_name,
	ms.monthkey,
	ms.total,
	round((ms.total / mt.month_total) * 100, 2) as percentage_of_month_total,
	sum(ms.total) over (partition by ms.customer_id, extract(year from to_date(ms.monthkey, 'YYYYMM'))) as cumulative_total,
	avg(ms.total) over (partition by ms.customer_id order by ms.monthkey rows between 2 preceding and current row) as moving_avg,
	ms.total - lag(ms.total) over (partition by ms.customer_id order by ms.monthkey) as difference_from_prev
from monthly_sales ms
join monthly_totals mt on ms.monthkey = mt.monthkey
order by ms.customer_id, ms.monthkey

-- 4. Выведите список сотрудников у которых нет подчинённых.
select 
	e.employee_id,
	e.first_name || ' ' || e.last_name as full_name
from employee e
left join employee e2 on e.employee_id = e2.reports_to 
where e2.employee_id is null

-- 5. Задача №5
select 
	c.customer_id,
	c.first_name || ' ' || c.last_name as full_name,
	min(i.invoice_date) as first_purch,
	max(i.invoice_date) as last_purch,
	extract(year from age(max(i.invoice_date), min(i.invoice_date))) as diff_in_years
from customer c 
join invoice i on c.customer_id = i.customer_id
group by c.customer_id, full_name;

-- 6. Задача №6
with album_sales as (
	select 
		a.album_id,
		a.title as album_title,
		ar.name as artist_name,
		extract(year from i.invoice_date) as sale_year,
		count(il.invoice_line_id) as total_track_sold
	from album a 
	join artist ar on a.artist_id = ar.artist_id
	join track t on a.album_id = t.album_id
	join invoice_line il on t.track_id = il.track_id
	join invoice i on il.invoice_id = i.invoice_id
	group by a.album_id, album_title, artist_name, sale_year
)
select 
	sale_year,
	album_title,
	artist_name,
	total_track_sold
from (
	select
		sale_year,
		album_title,
		artist_name,
		total_track_sold,
		row_number() over (partition by sale_year order by total_track_sold desc) as rank 
	from album_sales
) as ranked_sales
where rank <= 3
order by sale_year, rank;

-- 7. Задача №7

select distinct 
	t.track_id,
	t.name as track_name
from track t 
join invoice_line il on t.track_id  = il.track_id 
join invoice i ON il.invoice_id  = i.invoice_id 
where i.billing_country  = 'USA'
and t.track_id in (
	select il2.track_id
	from invoice_line il2 
	join invoice i2 on il2.invoice_id = i2.invoice_id
	where i2.billing_country = 'Canada'
);

-- 8. Задача №8
select distinct 
	t.track_id,
	t.name as track_name
from track t 
join invoice_line il on t.track_id  = il.track_id 
join invoice i ON il.invoice_id  = i.invoice_id 
where i.billing_country  = 'Canada'
and t.track_id not in (
	select il2.track_id
	from invoice_line il2 
	join invoice i2 on il2.invoice_id = i2.invoice_id
	where i2.billing_country = 'USA'
);



























