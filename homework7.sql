-- 1.
select 
	e.employee_id,
	e.first_name || ' ' || e.last_name as full_name,
	e.title,
	e.reports_to,
	m.first_name || ' ' || m.last_name as manager_full_name,
	m.title as manager_title
from employee e 
left join employee m on e.reports_to = m.employee_id;

-- 2.
with avg_invoice_2023 as (
	select avg(total) as avg_total_2023
	from invoice
	where extract(year from invoice_date) = 2023
)
select 
	i.invoice_id,
	i.invoice_date,
	extract(year from i.invoice_date)::text || lpad(extract(month from i.invoice_date)::text, 2, '0') as monthKey,
	i.customer_id,
	i.total
from invoice i
join avg_invoice_2023 a on i.total > a.avg_total_2023
where extract(year from i.invoice_date) = 2023;

-- 3.
with avg_invoice_2023 as (
	select avg(total) as avg_total_2023
	from invoice
	where extract(year from invoice_date) = 2023
)
select 
	i.invoice_id,
	i.invoice_date,
	extract(year from i.invoice_date)::text || lpad(extract(month from i.invoice_date)::text, 2, '0') as monthKey,
	i.customer_id,
	i.total,
	c.email
from invoice i
join avg_invoice_2023 a on i.total > a.avg_total_2023
join customer c on i.customer_id = c.customer_id
where extract(year from i.invoice_date) = 2023;

-- 4.
with avg_invoice_2023 as (
	select avg(total) as avg_total_2023
	from invoice
	where extract(year from invoice_date) = 2023
)
select 
	i.invoice_id,
	i.invoice_date,
	extract(year from i.invoice_date)::text || lpad(extract(month from i.invoice_date)::text, 2, '0') as monthKey,
	i.customer_id,
	i.total,
	c.email
from invoice i
join avg_invoice_2023 a on i.total > a.avg_total_2023
join customer c on i.customer_id = c.customer_id
where extract(year from i.invoice_date) = 2023
and c.email not like '&@gmail.com%';

-- 5. 
with total_revenue_2024 as (
    select sum(total) as total_2024
    from invoice 
    where extract(year from invoice_date) = 2024
)
select 
    i.invoice_id,
    i.invoice_date,
    i.total,
    round((i.total / tr.total_2024) * 100, 2) as percent_of_total
from invoice i 
cross join total_revenue_2024 tr
where extract(year from i.invoice_date) = 2024;

-- 6.
with total_revenue_2024 as (
	select sum(total) as total_2024
	from invoice
	where extract(year from invoice_date) = 2024
),
customer_revenue_2024 as (
	select 
		customer_id,
		sum(total) as customer_total
	from invoice
	where extract(year from invoice_date) = 2024
	group by customer_id
) 
select 
	cr.customer_id,
	cr.customer_total,
	round((cr.customer_total / tr.total_2024) * 100, 2) as percent_of_total
from customer_revenue_2024 cr
join total_revenue_2024 tr on true;
