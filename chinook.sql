/*

1. Создайте многострочный комментарий со следующей информацией:
   * ваши имя и фамилия
   * описание задачи 
1. Alisher Narzulloev

*/
-- 2. Напишите код, который вернёт из таблицы `track` поля *name* и *genreid*
-- select name, genre_id from track

-- 3. Напишите код, который вернёт из таблицы `track` поля *name*, *composer*, *unitprice*. Переименуйте поля на *song*, *author* и *price* соответственно. Расположите поля так, чтобы сначало следовало название произведения, далее его цена и в конце список авторов.
-- select name as song, unit_price as price, composer as author 
-- from track;

-- 4. Напишите код, который вернёт из таблицы `track` название произведения и его длительность в минутах. Результат должен быть отсортирован по длительности произведения по убыванию.
-- select milliseconds / 60000
-- from track
-- order by milliseconds desc

-- 5. Напишите код, который вернёт из таблицы `track` поля *name* и *genreid*, и **только первые 15 строк**.
-- select name, genre_id
-- from track
-- limit 15

-- 6. Напишите код, который вернёт из таблицы `track` все поля и все строки начиная **с 50-й строки**.
-- select * 
-- from track
-- offset 50

-- 7. Напишите код, который вернёт из таблицы `track` названия всех произведений, чей объём **больше 100 мегабайт**.
-- select name 
-- from track 
-- where bytes / 1048576 > 100

-- 8. Напишите код, который вернёт из таблицы `track` поля name и composer, где composer **не равен "U2"**. Код должен вернуть записи **с 10 по 20-й включительно**.
-- select name, composer, track_id
-- from track
-- where composer != 'U2'
-- limit 11
-- offset 9

-- 9. Напишите код, который из таблицы `invoice` вернёт дату самой первой и самой последней покупки.
-- select min(invoice_date), max(invoice_date)
-- from invoice

-- 10. Напишите код, который вернёт размер среднего чека для покупок из **США**.
-- select avg(total) as avg
-- from invoice
-- where billing_country = 'USA'

-- 11. Напишите код, который вернёт список городов в которых имеется **более одного клиента**.
-- select city
-- from customer
-- group by city
-- having count(*) > 1