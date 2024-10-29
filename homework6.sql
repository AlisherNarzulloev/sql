-- 1

create table students (
	student_id serial primary key
	, student_name varchar(100) not null
	, username varchar(50) not null
	, bio text
	, mobile varchar(20)
	, has_picture boolean
)

insert into students (student_id, student_name, username, bio, mobile, has_picture)
values
 (1, 'Alisher Narzulloev', '@avixon', 'Insta: av1xon', '882280220', true),
 (2, 'Fotima', '@chashmaki', 'empty', 'empty', false),
 (3, '𝕯𝖆𝖗𝖙𝖍 𝕭𝖊𝖍𝖟𝖔𝖉☠️', '@behzod_31', 'empty', '559009474', true),
 (4, 'Jamshed Boboev', '@jamik2306', 'Могуч пахуч и волосат', 'empty', true),
 (5, 'Murtazoev Alijon', '@M_Alijon', 'I am Batman', 'empty', true),
 (6, 'Farhod Ismailov', '@fismailov_bjj', 'Programmer_tjk', 'empty', true),
 (7, 'Jahon', '@Jahon987', 'empty', '917162800', false),
 (8, 'Sadriddin Khojazoda', '@khojazodas', '.', 'empty', true),
 (9, 'Академия ИИ - AI Concil', 'empty', 'empty', '+992 92 444 2731', true),
 (10, 'Munira K', '@krb_munira', '✨🌝', 'empty', true),
 (11, 'Hakim', '@hakim25753', 'empty', '+992 50 205 5054', false),
 (12, 'أمير', '@Amir_Olimi', 'Не забывай дни, когда ты молился о вещах, которые у тебя есть сегодня', '+992 80 311 1177', false),
 (13, 'Alexandra Leshukovich', '@Alexandraleshaya', 'Amor fati - полюби свою судьбу', 'empty', true),
 (14, 'Ibodullo', '@ZAR1509', 'empty', 'empty', true),
 (15, 'Farhod JKH', '@FarhodJKH', 'Фарход', 'empty', false),
 (16, 'Aziz Abdullaev', 'empty', 'empty', 'hidden', true),
 (17, 'Maruf Ibragimov', '@marufibragimov', 'Ever tried. Ever failed. No matter. Try again. Fail again. Fail better', 'empty', true);


select *
from students
-- 2.
create table lessons (
	lesson_id serial primary key
	, lesson_name varchar(100) not null
	, lesson_date timestamp not null
	, attendance varchar(10) check (attendance in ('был', 'не был'))
);

insert into lessons (lesson_id, lesson_name, lesson_date, attendance)
values 
	(1, 'SQL intro', '2024-10-18', 'не был'),
    (2, 'Операторы выборки, фильтрации и агрегации данных', '2024-10-18', 'не был'),
    (3, 'Работа с текстом и датой', '2024-10-21', 'был'),
    (4, 'Создание, редактирование и удаление таблиц', '2024-10-23', 'был'),
    (5, 'Подзапросы', '2024-10-25', 'не был'),
    (6, 'Джойны и сочетания запросов', '2024-10-28', 'не был');
   
select * 
from lessons
-- 3.
create table scores (
	score_id serial primary key,
	user_id integer references students(student_id) on delete cascade,
	lesson_id integer references lessons(lesson_id) on delete cascade,
	score integer
);

insert into scores(user_id, lesson_id, score)
values 
	(1, 1, 90),
	(1, 2, 90),
	(1, 3, null),
	(1, 4, null),
	(1, 5, null),
	(1, 6, null);
	
select *
from scores

-- 4.
create index idx_username on students(username);

-- 5.
create view my_results as
select 
	s.student_id,
	s.student_name,
	s.username,
	s.mobile,
	count(l.lesson_id) filter (where l.attendance = 'был') as lessons_attended,
	avg(sc.score) as avg_score
from students s
left join scores sc on s.student_id = sc.user_id
left join lessons l on sc.lesson_id = l.lesson_id
group  by 
	s.student_id, s.student_name, s.username, s.mobile

	
select *
from my_results