-- 1. Из таблицы customer вытащите список телефонных номеров, не содержащих скобок;
select phone
from customer
where phone not like '%(%' and phone not like '%)%';

-- 2. Измените текст 'lorem ipsum' так чтобы только первая буква первого слова была в верхнем регистре а всё остальное в нижнем;
select upper(substring('lorem ipsum', 1, 1)) || lower(substring('lorem ipsum', 2)) as formatted_text;



-- 3. Из таблицы track вытащите список названий песен, которые содежат слово 'run';
select name
from track
where lower(name) like '%run%'

-- 4. Вытащите список клиентов с почтовым ящиком в 'gmail';
select email 
from customer
where lower(email) like '%gmail%'

-- 5. Из таблицы track найдите произведение с самым длинным названием.
select name
from track
order by length(name) desc 
limit 1

-- 6. Посчитайте общую сумму продаж за 2021 год, в разбивке по месяцам. Итоговая таблица должна содержать следующие поля: month_id, sales_sum
select 
	extract(month from invoice_date) as month_id
	, sum(total) as sales_sum
from invoice
where extract(year from invoice_date) = 2021
group by month_id
order by month_id

-- 7. К предыдущему запросу (вопрос №6) добавьте также поле с названием месяца (для этого функции to_char в качестве второго аргумента нужно передать слово 'month'). Итоговая таблица должна содержать следующие поля: month_id, month_name, sales_sum. Результат должен быть отсортирован по номеру месяца.
select 
	extract(month from invoice_date) as month_id
	, to_char(invoice_date, 'Month') as month_name
	, sum(total) as sales_sum
from invoice
where extract(year from invoice_date) = 2021
group by month_id, month_name
order by month_id

-- 8. Вытащите список 3 самых возрастных сотрудников компании. Итоговая таблица должна содержать следующие поля: full_name (имя и фамилия), birth_date, age_now (возраст в годах в числовом формате)
select first_name || ' ' || last_name as full_name 
	, birth_date
	, cast(extract(year from age(now(), birth_date)) as integer) as age_now
from employee
order by birth_date
limit 3

-- 9. Посчитайте каков будет средний возраст сотрудников через 3 года и 4 месяца.
select avg(extract(year from age(birth_date)) + 3 + 4.0 / 12) as avg_age
from employee

-- 10. Посчитайте сумму продаж в разбивке по годам и странам. Оставьте только те строки где сумма продажи больше 20. Результат отсортируйте по году продажи (по возрастанию) и сумме продажи (по убыванию). 
select extract(year from invoice_date) as sale_year
	, billing_country
	, sum(total) as total_sales
from invoice
group by sale_year, billing_country
having sum(total) > 20
order by sale_year asc, total_sales desc



