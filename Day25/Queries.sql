-- Day 25 of #100DaysOfSQL —

--Create employees Table
CREATE TABLE Employees3 (
employee_id SERIAL primary key,
first_name varchar(50),
last_name varchar(50),
department_id int
);

--insert data into Employees
Insert into employees3 (first_name, last_name, department_id)
values
('Rahul', 'Sharma', 101),
('Priya', 'Varma', 102),
('Raj', 'rao', 103),
('Aman', 'Singh', null),
('Nia', 'Mehta', 101);

Select * from employees3;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

--insert data into Departments
insert into departments (department_id, department_name)
values
(101,'sales'),
(102,'marketing'),
(103,'it'),
(104,'hr');

Select * from Departments;


--full outer join
select e.employee_id, e.first_name, e.last_name, d.department_name
from employees3 e
full outer join
departments d
on e.department_id=d.department_id;


--cross join
select  e.first_name, e.last_name, d.department_name
from employees3 e
cross join
departments d;


--self join
select e1.first_name as employee_name1,
       e2.first_name as employee_name2,
       d.department_name
from employees3 e1 join employees3 e2
on e1.department_id=e2.department_id and e1.employee_id!=e2.employee_id
join
departments d
on
e1.department_id=d.department_id;
