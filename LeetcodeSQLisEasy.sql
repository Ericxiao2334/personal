-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

-- 175.Combine Two Tables
select p.FirstName as FirstName, p.LastName as LastName, a.City as City, a.State as State
from Person p
left join Address a
on p.PersonId = a.PersonId;

-- 176.Second Highest Salary
select ifnull((select Salary
from Employee
order by Salary DESC
limit 2,1),null) as SecondHighestSalary;

-- 181.Employees earning more than their managers
select e.Name as Employee
from Employee e 
left join Employee m
on e.ManagerId = m.Id
where e.Salary > m.Salary;

-- 182.Duplicate Emails
select Email
from Person
group by Email
having count(Email) >= 2;

-- 183.Customers who never order
select Name
from Customers c
left join Orders o
on c.Id = o.CustomerId
where o.Id is null

select Name as 'Customers'
from Customers
where CustomerId not in (select distinct CustomerId from Orders)

-- 196.Delete Duplicate Emails
delete from Person
where Id not in(
select u.Id as Id
from
(select Id, rank() over (partition by Email order by Id ASC) as IdRank
from Person) u
where u.IdRank = 1
);

-- Rising temperature
select a.id as 'Id'
from Weather a
left join Weather b
on a.id = b.id-1  ( or "on datediff(a.recordDate, b.recordDate)=1"
and a.Temperature > b.Temperature;

-- Game play analysis 1

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------2021.03.10--------------------------------------
----------------------------------------EASY_47------------------------------------------
--1-175 combine two Tables
select FirstName, LastName, City, State
from Person p left join Address a on p.PersonId = a.PersonId;

--2-176 second highest salary
select ifnull(select distinct Salary
from Employee
order by Salary DESC
limit 2,1 (or limit 1 offset 1),null) as SecondHighestSalary;

--3-181 employees earning more than their managers
select a.Name as 'Employee'
from Employee a left join Employee b
on a.ManagerId = b.Id
where a.Salary > b.Salary;

--4-182 duplicate emails
select Email
from Person
group by Email
having count(Email)>1

--5-183 customer who never order
select Name as 'Customers'
from Customers
where Id not in (select distinct CustomerId from Orders); 

--6-196 delete duplicate emails
delete from Person P
where Id not in
(select Id, Email 
from(select Id, Email, rank() over (partition by Email order by Id) as rank
from Person)sub
where sub.rank = 1);

--7 rising temperature
select a.id as id
from Weather a left join Weather b
on datediff(a.recordDate, b.recordDate) = 1
and a.Temperature > b.Temperature;

--8 game play analysis 1
select player_id, min(event_date) as first_login
from Activity
group by player_id, event_date;

select sub.player_id as player_id, sub.event_date as first_login
(select player_id, event_date, rank() over(partition by player_id, event_date order by event_date) as rank
from Activity)sub
where sub.rank = 1;

--9 game play analysis 2
select sub.player_id as player_id, sub.device_id as device_id
(select player_id, device_id, rank() over(partition by player_id, event_date order by event_date) as rank
from Activity)sub
where sub.rank = 1;

--10 employee bouns
select name, bouns
from Employee e left join Bonus b 
on e.empId = b.empId
and b.bonus < 1000 or bonus is null;

--11 find customer referee
select name
from customer
where referee_id != 2 or referee_id is null;

--12 customer placing the largest number of orders
select customer_number
from orders
group by customer_number
order by count(order_number) DESC
limit 1;

--13 big countries
select name, population, area
from World
where area > 3000000 or population > 2500000;

or 

select name, population, area
from World where area > 3000000
union
select name, populatiom, area
from World where population > 2500000; --union 选取不同的值，union可以重复

--14 classes more than 5 students
select class
from courses
group by class
having count(distinct student) >= 5;

--15 friend request 1: overall acceptance rate
select round(
    ifnull(
        (select count(*) from (select distinct requester_id, accepter_id from request_accepted)as A)
        /
        (select count(*) from (select distinct sender_id, send_to_id from FriendRequest)as B)
        , 0), 2) as accept_rate

    --无法count(distinct *),可以变通用select count(*) from (select distinct * from student)来实现

--16 consecutive available seats
select distinct seat_id
from cinema
where free = 1 and (seat_id-1 in (select seat_id from cinema where free=1)
or seat_id+1 in (select seat_id from cinema where free=1))
order by seat_id;

--17 sales person
select s.name as name
from salesperson s
where s.sales_id not in (
    select o.sales_id 
    from orders o left join company c on o.com_id = c.com_id
    where c.name = 'RED');

--18 triangle judgement
select x, y, z, case when x+y>z and x+z>y and y+z>x and x>0 and y>0 and z>0 then 'Yes'
                    else 'No' end as 'triangle'
from triangle

--19 shortest distance in a line
select min(abs(a.x-b.x)) as shortest
from point a left join point b on a.x != b.x;

--20 biggest single number
select max(num) as num
from (select num from my_numbers group by num having count(num) = 1) sub

--21 not boring moives
select *
from cinema
where id%2 = 1
and description != 'boring'
order by rating DESC;

--22 swap salary
update salary
set sex = case sex when 'm' then 'f'
                    when 'f' then 'm' end;

--23 actors and directors who cooperated at least three times
select actor_id, director_id
from ActorDirector
group by actor_id, director_id
having count(*) >= 3;

--24 product sales analysis 1
select product_name, year, price
from Sales s join Product p on s.product_id = p.product_id;

--25 product sales analysis 2
select product_id, sum(quantity) as total_quantity
from Sales
group by product_id;

--26 project employees 1
select project_id, round(avg(experience_years),2) as average_years
from Project p left join Employee e on p.employee_id = e.employee_id
group by project_id;

--27 project employees 2
select project_id
from Project
group by project_id
order by count(distinct employee_id) DESC
limit 1;

select sub.project_id as project_id
from
(select project_id, rank() over(partition by project_id order by count(distinct employee_id)DESC) as rank
from Project)sub
where rank = 1;

--28 sales analysis 1
select sub.seller_id as seller_id
from
    (select seller_id, rank() over(partition by seller_id order by sum(price) DESC)as rnk
    from Sales)sub
where rnk = 1;

select distinct seller_id
from Sales
group by seller_id
having sum(price) = (
    select sum(price) 
    from Sales 
    group by seller_id 
    order by sum(price) DESC 
    limit 1);

--29 sales analysis 2
select distinct buyer_id
from Sales s left join Product p on s.product_id = p.product_id
where product_name = 'S8'
and buyer_id not in (
    select distinct buyer_id 
    from Sales s left join Product p on s.product_id = p.product_id
    where product_name = 'iPhone');

select buyer_id
from Sales s inner join Product p on s.product_id = p.product_id
group by buyer_id
having sum(case when product_name = 'S8' then 1 else 0 end)>0
and sum(case when product_name = 'iPhone' then 1 else 0 end) = 0;

--30 sales analysis 3
select distinct p.product_id as product_id, product_name
from Sale s left join Product p on s.product_id = p.product_id
where sale_date between '2019-01-01' and '2019-03-31'
and p.product_id not in (
    select distinct p.product_id
    from Sale
    where sale_date < '2019-01-01' or sale_date > '2019-03-31') 

--31 reported posts
select extra as report_reason, count(distinct post_id) as report_count
from Actions a
where a.action_date = '2019-07-04'
and a.action = 'report'
group by a.action
order by count(*) DESC;

--32 user activity for the past 30 days 1
select activity_date as day, count(distinct user_id) as active_users
from Activity
where activity_date between date_sub('2019-07-27', interval 30 day) and '2019-07-27'
group by activity_date
order by activity_date;

select activity_date as day, count(distinct user_id) as active_users
from Activity
where datediff(activity_date, '2019-07-27') between 0 and 29
group by activity_date
order by activity_date;

--33 user activity for the post 30 days 2
select round(avg(sub.num_of_session),2) as average_session_per_user
from
    (select user_id, count(distinct session_id) as num_of_session
from Activity
where datediff(activity_date, '2019-07-27') between 0 and 29
group by user_id)sub;

--34 article views 1
select distinct author_id as id
from views
where author_id = viewer_id
order by author_id;

--35 immediate food delivery 1
select round(count(distinct delivery_id)/count(select distinct delivery_id from Delivery)*100,2) as immediate_percentage
from Delivery where order_date = customer_pref_delivery_date;

--36 reformat department table
select id,
    case when month = 'Jan' then revenue else null end as Jan_revenue,
    case when month = 'Feb' then revenue else null end as Feb_revenue,
    case when month = 'Mar' then revenue else null end as Mar_revenue,
    case when month = 'Apr' then revenue else null end as Apr_revenue,
    case when month = 'May' then revenue else null end as May_revenue,
    case when month = 'Jun' then revenue else null end as Jun_revenue,
    case when month = 'Jul' then revenue else null end as Jul_revenue,
    case when month = 'Aug' then revenue else null end as Aug_revenue,
    case when month = 'Sep' then revenue else null end as Sep_revenue,
    case when month = 'Oct' then revenue else null end as Oct_revenue,
    case when month = 'Nov' then revenue else null end as Nov_revenue,
    case when month = 'Dec' then revenue else null end as Dec_revenue
from Department
group by id;

--37 queries quality and percentage
select query_name, 
    round(avg(rating/position),2) as quality, 
    round((select count(*) from Queries where rating < 3)/count(*)*100,2) as poor_query_percentage
from Queries
group by query_name;

--38 number of comments per post
select a.sub_id as post_id, b.num_comment as number_of_comments
from (select distinct sub_id from Submissions where parent_id is null) a 
    left join 
    (select distinct parent_id,count(distinct sub_id) as num_comment 
        from Submissions where parent_id is not null group by parent_id) b
    on a.sub_id = b.parent_id
order by post_id;

--39 average selling price
select p.product_id as product_id,
    round(sum(u.units*p.price)/sum(u.units),2) as average_price
from Prices p right join UnitsSold u 
on p.product_id = u.product_id and purchase_date between start_date and end_date
group by p.product_id;

--40 students and examinations
select stu.student_id as student_id, stu.student_name as student_name,
        su.subject_name as subject_name, ifnull(count(e.subject_name),0) as attended_exams
from Student stu join Subjects su left join Examinations e
on stu.student_id = e.student_id and su.subject_name = e.subject_name
group by student_name, su.subject_name
order by student_name, su.subject_name

--如果没有可以连接的主键，那么join的效果是cross join
--left join时（A left join B on...）在满足on的条件下，
--如果B有重复records可以join到A的record，那么A对应的records也会重复

--41 weather type in each country
select c.country_name,
    case when avg(weather_state) > 25 then 'hot'
        when avg(weather_state) > 15 then 'warm'
        else 'cold' end as "weather type"
from Countries c right join Weather w on c.country_id = w.country_id
where w.day between '2019-11-01' and '2019-11-30'
group by country_name;

--42 find the team size
select employee_id, as team_size
from Employee e left join (select team_id, count(employee_id) as team_size from Employee group by team_id) t
    on e.team_id = t.team_id;

or

select employee_id, count(employee_id) over(partition by team_id) as team_size
from Employee;

--43 ads performance


--44 list the products ordered in a period


--45 students with invalid departments


--46 replace employee ID with the unique identifier
select b.unique_id, name
from Employees a left join EmployeeUNI b on a.id = b.id;

--47 top travelers
select name, ifnull(sum(distance),0) as travelled_distance
from Rides r right join Users u on r.user_id = u.id
group by r.user_id
order by sum(distance) DESC, name ASC;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-----------------------------------------MEDIUM_56----------------------------------------

--1-614 second degree follower
select followee as follower, count(distinct follower) as num
from follow
where followee in (select distinct follower from follow)
group by followee
order by followee;

--2-177 nth highest salary


--3-1132 reported posts 2


--4-1454 active users


--5-184 department highest salary


--6-578 get highest answer rate question


--7-180 consecutive numbers


--8-1098 unpopular books


--9-1107 new users daily count


--10-550 game play analysis 4


--11-1205 monthly transactions 2


--12-1149 article views 2


--13-178 rank scores


--14-1070 product sales analysis 3


--15-580 count student number in departments


--16-winning candidate


--17-1555 bank account summary


--18-585 investments in 2016


--19-602 friend requests 2: who has the most friends


--20-1212 team scores in football tournament


--21-1341 movie rating


--22-1501 countries you can safely invest in


--23-612 shortest distance in a plane


--24-1174 immediate food delivery 2


--25-1158 market analysis 1


--26-1459 rectangles area


--27-626 exchange seats


--28-1549 the most recent orders for each product


--29-570 managers with at least 5 direct reports


--30-1164 product price at a given date


--31-1045 customers who bought all products


--32-1126 active businesses


--33-608 tree node


--34-1193 monthly transactions 1


--35-1264 page recommendations


--36-1321 restaurant growth


--37-1204 last person to fit in the elevator


--38-1112 highest grade for each student


--39-1613 find the missing IDs


--40-1532 the most recent three orders


--41-1355 activity participants


--42-1440 evaluate boolean expression


--43-1077 project employees 3


--44-1364 number of trusted contacts of customer


--45-534 game play analysis 3


--46-1468 calculate salaries


--47-1709 biggest window between visits


--48-1421 NPV queries


--49-1398 customers who bought products A and B but not C


--50-1596 the most frequently ordered products for each customer


--51-1699 number of calls between two persons


--52-1285 find the start and end number of continuous ranges


--53-1308 running total for different genders


--54-1207 all people report to the given manager


--55-1393 capital gain or loss


--56-1445 apples & oranges



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-----------------------------------------HIGH--------------------------------------------

--1-262 trips and users


--2-1645 hopper company queries 2


--3-579 find cumulative salary of an employee


--4-185 department top three salaries


--5-601 human traffic of stadium


--6-1767 find the subtasks that did not execute


--7-1651 hopper company queries 3


--8-618 学生地理信息报告


--9-1369 获取最近第二次的活动


--10-1479 周内每天的销售额


--11-569 员工薪水中位数


--12-1225 报告系统状态的连续日期




---------NOWCODER----------

### insert 批量插入数据
    对表批量插入数据。Mysql
    insert into 表名 values(v1,v2,..),values(v1,v2,...),...
    insert into `table_name` ('id','value','memo') values ('1','replace','replace')

    insert into actor
    values(1,"PENELOPE","GUINESS",'2006-02-15 12:34:33'),
    (2,"NICK","WAHLBERG",'2006-02-15 12:34:33')
    这条语句高度依赖表中列的定义顺序。虽然简单，但是并不安全。如果表的结构发生变化，就会报错。
    最好表名后给出列名（如下）。这样即使表的结构发生变化，语句依然可以执行。（悄悄的嘀咕~虽然更繁琐）。
    insert into actor
    (actor_id,first_name,last_name,last_update)
    values
    (1,"PENELOPE","GUINESS","2006-02-15 12:34:33"),
    (2,"NICK","WAHLBERG","2006-02-15 12:34:33")

### replace into 与insert into的差别在于会先检查主键是否重复，
    如果重复则删掉之前的记录，插入新的（这样顺序会变，自编号的号码也会变），
    如果没有重复的主键则执行insert into一样的操作

### 对于表{table_name}插入数据,如果数据已经存在,请忽略
    grammar: insert ignore into {table_name} values(...) 
    e.g. insert ignore into actor values(3,'ED','CHASE','2006-02-15 12:34:33');

### alter 将titles_test 表名修改为titles_2017
    alter table titles_test
    rename to titles_2017

### delete 删除某些项
    delete from test_table
    where ....

### update 更新records
    表更新语句结构：
    UPDATE 表名
    SET 字段=值
    WHERE 过滤条件

    e.g. 将所有to_date为9999-01-01的全部更新为NULL,且 from_date更新为2001-01-01
    update titles_test
    set to_date = NULL, from_date = '2001-01-01'
    where to_date = '9999-01-01'


### update + replace  使用replace进行update
    语法：replace(object,search,replace)
    语义：把object对象中出现的的search全部替换成replace

    e.g. 将id=5以及emp_no=10001的行数据替换成id=5以及emp_no=10005,其他数据保持不变，使用replace实现，直接使用update会报错。
    update titles_test
    set emp_no=replace(emp_no,10001,10005)
    where id=5

### create a table 
    e.g. 
    create table actor(
        actor_id smallint(5) not null,
        first_name varchar(45) not null,
        last_name varchar(45) not null,
        last_update date not null,
        primary key (actor_id));

    or 

    create table actor(
        actor_id smallint(5) not null primary key,
        first_name varchar(45) not null,
        last_name varchar(45) not null,
        last_update date not null
    );

    创建数据表的三种方法：
    1. 常规创建
        create table if not exists {table_name}
    2. 复制表格
        create {target_table} like {source_table}
    3. 将actor的部分拿来创建actor_name
        create table if not exists actor_name
            (first_name varchar(45) not null,
            last_name varchar(45) not null);
        insert into actor_name
        select first_name, last_name from actor;




### 窗口函数    row_number()  dense_rank()  rank()

### concat(str1, str2...)
### concat_ws(seperator,str1,str2...) 一次指定所有分隔符 (concat_ws: 'concat with seperator')
### group_concat([distinct] 要连接的字段 [order by 排序字段 asc/desc ] [separator '分隔符'])

### exists / not exists
    子查询过程中，In和exist函数效率比较： 
    当进行连接的两个表大小相似，效率差不多； 
    如果子查询的内表更大，则exist的效率更高
    （exist先查询外表，然后根据外表中的每一个记录，分别执行exist语句判断子查询的内表是否满足条件，满足条件就返回ture）。 
    如果子查询的内表小，则in的效率高
    （in在查询的时候，首先查询子查询的表，然后将内表和外表做一个笛卡尔积 (表中的每一行数据都能够任意组合A表有a行，B表有b行，最后会输出a*b行)，然后按照条件进行筛选。所以相对内表比较小的时候，in的速度较快）。 
    Exist的原理: 使用exist时，若子查询能够找到匹配的记录，则返回true，外表能够提取查询数据；使用 not exist 时，若子查询找不到匹配记录，则返回true，外表能够提取查询数据 

    e.g. 使用含有关键字exists查找未分配具体部门的员工的所有信息
        select *
        from employees e
        where not exists(select emp_no from dept_emp d where d.emp_no = e.emp_no);


### 构造触发器 

    e.g. 构造触发器audit_log，在向employees_test表中插入一条数据的时候，触发插入相关的数据到audit中
    create trigger audit_log
    after insert on employees_test
    for each row
    begin
        insert into audit values(new.id,new.name);
    end

    在MySQL中，创建触发器语法如下：
    CREATE TRIGGER trigger_name
    trigger_time trigger_event ON tbl_name
    FOR EACH ROW
    trigger_stmt
    其中:
    trigger_name：标识触发器名称，用户自行指定；
    trigger_time：标识触发时机，取值为 BEFORE 或 AFTER；
    trigger_event：标识触发事件，取值为 INSERT、UPDATE 或 DELETE；
    tbl_name：标识建立触发器的表名，即在哪张表上建立触发器；
    trigger_stmt：触发器程序体，可以是一句SQL语句，或者用 BEGIN 和 END 包含的多条语句，每条语句结束要分号结尾。
    【NEW 与 OLD 详解】
    MySQL 中定义了 NEW 和 OLD，用来表示
    触发器的所在表中，触发了触发器的那一行数据。
    具体地：
    在 INSERT 型触发器中，NEW 用来表示将要（BEFORE）或已经（AFTER）插入的新数据；
    在 UPDATE 型触发器中，OLD 用来表示将要或已经被修改的原数据，NEW 用来表示将要或已经修改为的新数据；
    在 DELETE 型触发器中，OLD 用来表示将要或已经被删除的原数据；
    使用方法： NEW.columnName （columnName 为相应数据表某一列名）
    参考: https://blog.csdn.net/weixin_41177699/article/details/80302987

### round & truncate 四舍五入与直接取整
    ROUND(x,y)函数返回最接近于参数x的数，其值保留到小数点后面y位，若y为负值，则将保留x值到小数点左边y位。
        e.g. round(3.466,2) = 3.47
    TRUNCATE(x,y)函数返回被舍去至小数点后y位的数字x。若y的值为0，则结果不带有小数点或不带有小数部分。
    若y设为负数，则截去（归零）x小数点左起第y位开始后面所有低位的值。
        e.g. truncate(3.466,2) = 3.46