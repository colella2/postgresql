--- **** SQL Operations Overview **** ---
-- DDL: CREATE DROP ALTER TRUNCATE
-- DML: INSERT UPDATE DELETE MERGE
-- DCL: GRANT REVOTE
-- TCL: COMMIT ROLLBACK SAVEPOINT
-- DQL: SELECT


--- *** START YOUR PROJECT *** ---

-- see what tables are availble in a schema
SELECT *
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- create a DB
CREATE DATABASE database_name;

DROP TABLE IF EXISTS table_name;

-- can instead TRUNCATE a table to simply clear it but keep its structure
TRUNCATE TABLE table_name;


CREATE TABLE table_name
( row_ID SERIAL PRIMARY KEY
, ID_col int
, name_col varchar(50)
, other_name_col varchar(50)
, quant_col int not null
, other_quant_col float);

CREATE TABLE table_name AS
SELECT * FROM other_table;


---- Example: create an employee table

CREATE TABLE employee
( row_id SERIAL PRIMARY KEY
, emp_ID int
, emp_NAME varchar(50)
, DEPT_NAME varchar(50)
, SALARY int not null
, EMP_PAY float);


-- ** FOREIGN KEYS ** --

-- The table containing the foreign key is called the referencing table or child table. The parent table refers to the 
-- table to which the foreign key is related. 
-- A foreign key in the PostgreSQL child table is a reference to the primary key in the parent table.

DROP TABLE IF EXISTS table_name CASCADE;

-- ON DELETE CASCADE— this means that if the parent table is deleted, the child table will also be deleted.
ALTER TABLE table_name ADD FOREIGN KEY (column_name)
REFERENCES other_table(column_name_2) ON DELETE CASCADE;

-- Example: create a FK relationship w/ employee table
CREATE TABLE employee(emp_id SERIAL PRIMARY  KEY,
name VARCHAR(30),
STATUS text,
phone_num VARCHAR(12),
process_fk INT NOT NULL);

CREATE TABLE process(emp_id SERIAL PRIMARY KEY, SECTION VARCHAR(20));

ALTER TABLE employee ADD FOREIGN KEY (process_fk)
REFERENCES process(emp_id) ON DELETE CASCADE;

-- process is the child table
INSERT INTO process(SECTION) VALUES ('distribution');
INSERT INTO process(SECTION) VALUES ('curing');
INSERT INTO Process(SECTION) VALUES ('technology');

-- employee is the parent table
INSERT INTO employee(name,STATUS,phone_num,process_fk)
VALUES('joemarie','regular','0985959905','1'),
('shakhira','probationary','093948889487','2'),
('hyle','regular','095599093490','1'),
('kobe','probationary','097867556451','3'),
('nasty','regular','094458909099','2'),
('arianne','regular','097746890988','2');

DELETE FROM process WHERE SECTION='distribution';

SELECT * FROM employee;

SELECT * FROM process;



--- *** INSERT DATA INTO YOUR TABLES *** ---

INSERT INTO table_name (col_A, col_B, col_C, col_D)
SELECT col_A, col_B, col_C, col_D FROM other_table;

INSERT INTO table_name
SELECT * FROM other_table;

INSERT INTO receivingtable
(SELECT * FROM sourcetable WHERE col_1 = 'param' AND col_2 = 'another_param')

-- Example: can also insert values directly into respective fields (aligns w/ above employee table created)
INSERT INTO employee VALUES(101, 'Mohan', 'Admin', 4000);
INSERT INTO employee VALUES(102, 'Rajkumar', 'HR', 3000);
INSERT INTO employee VALUES(103, 'Akbar', 'IT', 4000);
INSERT INTO employee VALUES(104, 'Dorvin', 'Finance', 6500);
INSERT INTO employee VALUES(105, 'Rohit', 'HR', 3000);
INSERT INTO employee VALUES(106, 'Rajesh',  'Finance', 5000);
INSERT INTO employee VALUES(107, 'Preet', 'HR', 7000);
INSERT INTO employee VALUES(108, 'Maryam', 'Admin', 4000);
INSERT INTO employee VALUES(109, 'Sanjay', 'IT', 6500);
INSERT INTO employee VALUES(110, 'Vasudha', 'IT', 7000);
INSERT INTO employee VALUES(111, 'Melinda', 'IT', 8000);
INSERT INTO employee VALUES(112, 'Komal', 'IT', 10000);
INSERT INTO employee VALUES(113, 'Gautham', 'Admin', 2000);
INSERT INTO employee VALUES(114, 'Manisha', 'HR', 3000);
INSERT INTO employee VALUES(115, 'Chandni', 'IT', 4500);
INSERT INTO employee VALUES(116, 'Satya', 'Finance', 6500);
INSERT INTO employee VALUES(117, 'Adarsh', 'HR', 3500);
INSERT INTO employee VALUES(118, 'Tejaswi', 'Finance', 5500);
INSERT INTO employee VALUES(119, 'Cory', 'HR', 8000);
INSERT INTO employee VALUES(120, 'Monica', 'Admin', 5000);
INSERT INTO employee VALUES(121, 'Rosalin', 'IT', 6000);
INSERT INTO employee VALUES(122, 'Ibrahim', 'IT', 8000);
INSERT INTO employee VALUES(123, 'Vikram', 'IT', 8000);
INSERT INTO employee VALUES(124, 'Dheeraj', 'IT', 11000);
COMMIT;

-- wise to subsequently run the below to save changes invoked by database transaction, which saves all transactions 
-- to the database since the last COMMIT or ROLLBACK command
COMMIT;



--- *** ALTER OR UPDATE TABLES *** ---

-- add a col
ALTER TABLE table_name
ADD COLUMN new_column_name DATATYPE CONSTRAINT DEFAULT VALUE;

ALTER TABLE table_name
ADD COLUMN column_name INT UNIQUE;

-- Example aligned w/ employee example from above
ALTER TABLE employee
ADD COLUMN FAMILY_NAME VARCHAR(50) NOT NULL;

ALTER TABLE employee
ADD COLUMN emp_badge_cd INT NOT NULL DEFAULT 9;

-- change a col
ALTER TABLE  table_name 
ALTER COLUMN col_name SET NOT NULL; 


-- update a table
UPDATE table_name
SET col_name = 1
WHERE other_col = 'param';

-- Example for updating a table:
UPDATE process
SET mgr_name = 1
WHERE section = 'curing';



--- *** COALESCE *** ---

-- used when you could have a NULL value --> allows you to provide a default value
SELECT COALESCE(email, 'email not provided') FROM person;



--- *** WINDOW/ANALYTIC FUNCTIONS *** --- 

-- ** ROW_NUMBER() ** --
SELECT alias.*,
row_number() over() as rn
FROM table_name alias;

select e.*,
row_number() over(partition by dept_name) as rn
from employee e;

-- ASC is default
SELECT *,
row_number() over(PARTITION BY dept_name ORDER BY emp_id ASC) as rn
FROM employee;

-- Fetch the first 2 employees from each department to join the company.
select * from (
	select e.*,
	row_number() over(partition by dept_name order by emp_id) as rn
	from employee e) x
where x.rn < 3;


-- ** RANK() ** --
SELECT e.*
, rank() over(PARTITION BY dept_name ORDER BY salary DESC) as dept_rank_by_salary
FROM employee e;

-- Example: fetch the top 3 employees in each department earning the max salary.
select * from (
	select e.*,
	rank() over(partition by dept_name order by salary desc) as rnk
	from employee e) x
where x.rnk < 4;


-- ** DENSE_RANK() ** --

-- Checking the different between rank, dense_rnk and row_number window functions:
select e.*,
rank() over(partition by dept_name order by salary desc) as rnk,
dense_rank() over(partition by dept_name order by salary desc) as dense_rnk,
row_number() over(partition by dept_name order by salary desc) as rn
from employee e;


-- *** MAX() *** --

-- By using MAX as an window function, SQL will not reduce records but the result will be shown corresponding to each record.

SELECT e.*,
max(salary) over(PARTITION BY dept_name) as max_salary_dept
FROM employee e;

-- ** FIRST_VALUE() ** --
SELECT *, FIRST_VALUE(col_name) OVER() AS first_item
FROM table_name;

-- Example: FIRST_VALUE() over employee table
SELECT *, FIRST_VALUE(salary) OVER() AS first_sal
FROM employee;

-- order matters
SELECT *, FIRST_VALUE(salary) OVER(ORDER BY salary) lowest_sal
FROM employee;

-- put boundaries on the action of the analytic function
SELECT e.*, 
FIRST_VALUE(salary) OVER(ORDER BY e.salary) AS lowest_sal,
e.salary - FIRST_VALUE(salary) OVER(PARTITION BY e.dept_name ORDER BY e.salary) AS difference_btw_lowest
FROM employee e;

SELECT e.*, 
FIRST_VALUE(salary) OVER(PARTITION BY e.dept_name ORDER BY e.salary) AS lowest_in_dept
FROM employee e;


-- *** LAST_VALUE() *** --

-- the problem w/ this query is that the default will look for diff betw. unbounded preceeding & current row
-- so, it will always return the current row unless we make the changes specified in the query below this one
SELECT e.*, 
LAST_VALUE(salary) OVER(PARTITION BY e.dept_name ORDER BY e.salary) AS highest_in_dept
FROM employee e;

-- this custom windowing clause will allow the anlaytic function to act on all rows within the partition
SELECT e.*, 
LAST_VALUE(salary) OVER(PARTITION BY e.dept_name ORDER BY e.salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS highest_in_dept
FROM employee e;


--- *** LAG() & LEAD() *** ---

select alias.*,
lag(col_name) over(partition by other_col order by another_col) as prev_alias,
lead(col_name) over(partition by other_col order by another_col) as next_alias
from table_name alias;

SELECT e.*, lag(salary, 2, 0) OVER(PARTITION BY dept_name ORDER BY emp_id) AS two_previous_sals
FROM employee e;

-- Example: fetch a query to display if the salary of an employee is higher, lower or equal to the previous employee
select e.*,
lag(salary) over(partition by dept_name order by emp_id) as prev_empl_sal,
case when e.salary > lag(salary) over(partition by dept_name order by emp_id) then 'Higher than previous employee'
     when e.salary < lag(salary) over(partition by dept_name order by emp_id) then 'Lower than previous employee'
	 when e.salary = lag(salary) over(partition by dept_name order by emp_id) then 'Same than previous employee' end as sal_range
from employee e;

-- Example: similarly using lead function to see how it is different from lag.
select e.*,
lag(salary) over(partition by dept_name order by emp_id) as prev_empl_sal,
lead(salary) over(partition by dept_name order by emp_id) as next_empl_sal
from employee e;



-- *** DATES SECTION *** --

SELECT now();

SELECT now()::date;

SELECT (now() + INTERVAL '1 DAY') as OneDayLater;

-- convert text to date format
SELECT TO_DATE('31-01-2021', 'DD-MM-YYYY') as date_value;

-- extract info from dates
SELECT EXTRACT(DOY FROM NOW());

SELECT EXTRACT(DAY FROM NOW());

SELECT EXTRACT(MONTH FROM NOW());

SELECT EXTRACT(QUARTER FROM NOW());

-- getting to the end of the month; DATE_TRUNC returns the first day of specified yr, first day of specified month, or the Monday of the specified week
SELECT DATE_TRUNC('MONTH', NOW()) + INTERVAL'1 month - 1 day' as end_of_month;

SELECT DATE_TRUNC('MONTH', NOW()) + INTERVAL'1 month';

-- Example: creating a timestamp table
CREATE TABLE timestamp_demo (
    ts TIMESTAMP, 
    tstz TIMESTAMPTZ
);

CREATE TABLE table_b AS
SELECT * FROM table_a WHERE created < NOW();

-- Example: Orders table
CREATE TABLE orders(order_id SERIAL PRIMARY KEY
, created DATE NOT NULL DEFAULT CURRENT_DATE
, assigned DATE NOT NULL DEFAULT CURRENT_DATE
, started DATE NOT NULL DEFAULT CURRENT_DATE
, closed DATE NOT NULL DEFAULT CURRENT_DATE
);

INSERT INTO orders(order_ID) VALUES (1);
INSERT INTO orders(order_ID) VALUES (2);
INSERT INTO orders(order_ID) VALUES (3);

SELECT o.created
, o.started
, COUNT(DISTINCT(o.order_id)) AS orders
FROM orders o
GROUP BY o.created, o.started;

SELECT o.order_id
, o.created
, o.started
, o.started-o.created as interval
, (NOW() + interval '1 day') AS Onedaylater
FROM orders o;

SELECT x.created_month, x.started_month, COUNT(DISTINCT(x.order_id))
FROM
(SELECT o.order_id
, o.created 
, EXTRACT(MONTH FROM o.created) as created_month
, o.started
, EXTRACT(MONTH FROM o.started) as started_month
, o.started-o.created AS interval
FROM orders o) x
GROUP BY x.created_month, x.started_month;

-- Example: users table
SELECT u.*, DATE_TRUNC('YEAR', CAST(u.birthdate AS DATE)) AS year_of_birth
FROM users_data u;



--- *** AGES *** ---
SELECT username, birthdate, age(some_date, initial_date) AS age
FROM users_data;

-- may have to cast text fields as date
SELECT username, birthdate, AGE(CAST(some_date AS DATE), CAST(initial_date AS DATE))
FROM users_date;

-- Example: users
CREATE TABLE users_data (username TEXT, birthdate TEXT);

INSERT INTO users_data (username, birthdate) VALUES ('bob', '1980-02-15');
INSERT INTO users_data (username, birthdate) VALUES ('jane', '1985-07-22');
INSERT INTO users_data (username, birthdate) VALUES ('pia', '1970-10-07');

SELECT *, AGE(CAST('2022-03-12' AS DATE), CAST('2022-02-06' AS DATE)) AS age
FROM users_data;

-- if you are just basing date off of the current date, you just have one parameter
SELECT *, AGE(CAST(u.birthdate AS DATE)) AS age
FROM users_data u;

SELECT u.*, EXTRACT(YEAR FROM AGE(CAST(u.birthdate AS DATE))) AS age_in_yrs
FROM users_data u;



--- *** EXPLORE YOUR DATA *** ---

SELECT * FROM table_name;

-- the WHERE TRUE below has no specific functional purpose
-- it can be included if a style guide says to always include a specific WHERE clause
-- adding a WHERE clause that is always true has the same effect as grabbing all rows (as in the above SELECT *)
SELECT * FROM table_name WHERE TRUE;

-- helps check if col is primary key
SELECT count(*), count(distinct col_name) FROM table_name;

-- could have multiple cols used to create primary key
-- the || is used to concatenate strings (as many as you'd like) but can also use CONCAT(col_1, col_2)
SELECT count(*), count(distinct first_name || last_name) FROM table_name;

-- find examples of duplicate records
SELECT col_name, COUNT(*) as ct
FROM patients
GROUP BY col_name
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

-- COUNT: When you specify a col_name, NULL values are not included in COUNT()
-- When you don't specify a col_name, then they are included (e.g., COUNT(*))

-- Using Aggregate function as Window Function
-- Without window function, SQL will reduce the no of records.
select dept_name, max(salary) 
from employee
group by dept_name;

-- Examples on employees tables
SELECT e.emp_id, COUNT(DISTINCT emp_id) as distinct_employees
FROM employee e
GROUP BY e.emp_id;

SELECT dept_name, max(salary) AS max_salary
FROM employee
GROUP BY dept_name;



--- *** JOIN YOUR DATA *** ---

-- INNER JOIN
SELECT *
FROM table_a A
JOIN table_b B
ON A.col_name = B.col_name;

-- LEFT JOIN
SELECT *
FROM table_a A
LEFT JOIN table_b B
ON A.col_name = B.col_name;

-- LEFT OUTER JOIN
SELECT *
FROM table_a A
LEFT JOIN table_b B
ON A.col_name = B.col_name
WHERE B.col_name IS NULL;

-- RIGHT JOIN
SELECT *
FROM table_a A
RIGHT JOIN table_b B
ON A.col_name = B.col_name;

-- RIGHT OUTER JOIN
SELECT *
FROM table_a A
RIGHT JOIN table_b B
ON A.col_name = B.col_name
WHERE A.col_name IS NULL;

-- FULL OUTER JOIN
SELECT * 
FROM table_a A 
FULL OUTER JOIN table_b B 
ON A.col_name = B.col_name;

SELECT * 
FROM table_a A 
FULL OUTER JOIN table_b B 
ON A.key = B.key
WHERE A.col_name IS NULL OR B.col_name IS NULL;

-- UNION removes any duplicate records as it 1st performs sorting operation & eliminates dupe records across all cols
-- before returning combined data set. UNION ALL keeps all of the records from each of the original data sets.

-- Example: films data

DROP TABLE IF EXISTS top_rated_films;
CREATE TABLE top_rated_films(
	title VARCHAR NOT NULL,
	release_year SMALLINT
);

DROP TABLE IF EXISTS most_popular_films;
CREATE TABLE most_popular_films(
	title VARCHAR NOT NULL,
	release_year SMALLINT
);

INSERT INTO 
   top_rated_films(title,release_year)
VALUES
   ('The Shawshank Redemption',1994),
   ('The Godfather',1972),
   ('12 Angry Men',1957);

INSERT INTO 
   most_popular_films(title,release_year)
VALUES
   ('An American Pickle',2020),
   ('The Godfather',1972),
   ('Greyhound',2020);


SELECT * FROM top_rated_films;

SELECT * FROM most_popular_films;

-- remove duplicate of The Godfather
SELECT * FROM top_rated_films
UNION
SELECT * FROM most_popular_films;

-- self join
SELECT emp.emp_id, emp.emp_name, emp.emp_supervisor_id, supv.emp_name as supervisor_name 
FROM employees2 emp
LEFT JOIN employees2 supv
ON emp.emp_supervisor_id = supv.emp_id;



--- *** CASE STATEMENTS *** ---

-- these are SQL's IF...ELSE statements
-- they start with CASE WHEN THEN...ELSE...END AS

-- Example: gender for employees
SELECT CASE WHEN gender = 'M' THEN 'MALE'
            WHEN gender = 'F' THEN 'FEMALE'
      ELSE 'Other'
      END AS gender
FROM employee;

-- it can be powerful to use CASE & SUM() together
-- adding a WHERE clause can add additional power here
select 
     sum(case when col_name = 'param' and column_name_2 = 'param' then 1 else 0 end) as alias
   , sum(case when col_name_2 = 'param' and city = 'param' then 1 else 0 end)   as alias2
from table_name


-- CASE statements can also be run in the WHERE clause
-- the below two statements are equal
SELECT COUNT(*)
FROM employee 
WHERE dept_name = 'Admin';

SELECT COUNT(*) 
FROM employee 
WHERE TRUE AND 1 = (CASE WHEN dept_name = 'Admin' THEN 1 ELSE 0 END);



--- *** RUN PostgreSQL FROM TERMINAL *** ---

-- start a PG server from the command line
pg_ctl -D /usr/local/var/postgres start


-- stop a PG server from the command line
pg_ctl -D /usr/local/var/postgres stop


--- *** WITH() CLAUSE *** ---

-- CTE's / WITH() clause are superior to subqueries as they improve code readability
-- some will reserver subqueries only for one-liners
-- as a reminder, CTE stands for (Common Table Expression)


-- this version is the best practice
WITH average_salary (avg_sal) AS (SELECT AVG(salary) FROM employee)

SELECT * 
FROM employee e, average_salary av
WHERE e.salary > av.avg_sal;

-- second version
WITH average_salary AS (SELECT AVG(salary) AS avg_sal FROM employee)

SELECT * 
FROM employee e, average_salary av
WHERE e.salary > av.avg_sal;


-- Example: CTE vs. Sub-queries

-- Use of CTE
with combined_table as (
select
  *
 
FROM patients p
JOIN admissions a 
  on p.patient_id = a.patient_id
)

, name_most_admissions as (
select
    first_name || ' ' || last_name as full_name
  , count(*)                       as admission_ct
  
FROM combined_table
)

select * from name_most_admissions
;

-- Use of sub-queries :(
select * from 
   (select
        first_name || ' ' || last_name as full_name
      , count(*)                       as admission_ct
  
    FROM (select
             *
 
          FROM patients p
          JOIN admissions a 
              on p.patient_id = a.patient_id
          ) combined_table
    ) name_most_admissions
;



--- *** JUST EXAMPLES SECTION *** ---

-- Example: Process table
CREATE TABLE eng_process(emp_id SERIAL PRIMARY KEY, section VARCHAR(20), mgr_name INT);

INSERT INTO process(emp_id, section, mgr_name) VALUES(6, 'finance', 3)

INSERT INTO process(section) VALUES ('distribution');
INSERT INTO process(section) VALUES ('curing');
INSERT INTO Process(section) VALUES ('technology');

SELECT p.*
FROM process p;

-- Example: Parents table
CREATE TABLE parents ( parent_id SERIAL PRIMARY KEY NOT NULL, 
baby_name varchar(50) NOT NULL, 
baby_id int references baby_names(baby_id)
)


-- Example: License table

 CREATE TABLE licenses
  (purchased DATE,
   valid INT);
 
-- insert an item purchased today, valid 31 days 
INSERT INTO licenses VALUES (CURRENT_TIMESTAMP, 31);

SELECT * from licenses;