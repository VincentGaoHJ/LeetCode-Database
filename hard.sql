# ----------------------------------------------------------------------------------------------------
# 185. Department Top Three Salaries
# ----------------------------------------------------------------------------------------------------
# The Employee table holds all employees.
# Every employee has an Id, and there is also a column for the department Id.
# The Department table holds all departments of the company.
# ----------------------------------------------------------------------------------------------------
# Write a SQL query to find employees who earn the top three salaries in each of the department.
# For the above tables, your SQL query should return the following rows (order of rows does not matter).
# ----------------------------------------------------------------------------------------------------
SELECT dep.Name Department, emp.Name Employee, emp.Salary
FROM Employee emp
JOIN Department dep
ON emp.DepartmentId = dep.Id
JOIN (
    SELECT Id, DENSE_RANK () OVER (
        PARTITION BY DepartmentId
        ORDER BY Salary DESC
    ) salary_rank
    FROM Employee
) rank_tbl
ON rank_tbl.Id = emp.Id
WHERE rank_tbl.salary_rank < 4;
# ---------------------------
SELECT dep.Name Department, emp.Name Employee, emp.Salary
FROM Employee emp
JOIN Department dep
ON emp.DepartmentId = dep.Id
WHERE 3 > (
    SELECT COUNT(DISTINCT Salary)
    FROM Employee emp2
    WHERE emp2.Salary > emp.Salary
    AND emp.DepartmentId = emp2.DepartmentId
);


# ----------------------------------------------------------------------------------------------------
# 262. Trips and Users
# ----------------------------------------------------------------------------------------------------
# The Trips table holds all taxi trips.
# Each trip has a unique Id, while Client_Id and Driver_Id are both foreign keys to the Users_Id at the Users table.
# Status is an ENUM type of (‘completed’, ‘cancelled_by_driver’, ‘cancelled_by_client’).
# +----+-----------+-----------+---------+--------------------+----------+
# | Id | Client_Id | Driver_Id | City_Id |        Status      |Request_at|
# +----+-----------+-----------+---------+--------------------+----------+
# | 1  |     1     |    10     |    1    |     completed      |2013-10-01|
# | 2  |     2     |    11     |    1    | cancelled_by_driver|2013-10-01|
# | 3  |     3     |    12     |    6    |     completed      |2013-10-01|
# | 4  |     4     |    13     |    6    | cancelled_by_client|2013-10-01|
# | 5  |     1     |    10     |    1    |     completed      |2013-10-02|
# | 6  |     2     |    11     |    6    |     completed      |2013-10-02|
# | 7  |     3     |    12     |    6    |     completed      |2013-10-02|
# | 8  |     2     |    12     |    12   |     completed      |2013-10-03|
# | 9  |     3     |    10     |    12   |     completed      |2013-10-03|
# | 10 |     4     |    13     |    12   | cancelled_by_driver|2013-10-03|
# +----+-----------+-----------+---------+--------------------+----------+
# The Users table holds all users.
# Each user has an unique Users_Id, and Role is an ENUM type of (‘client’, ‘driver’, ‘partner’).
# +----------+--------+--------+
# | Users_Id | Banned |  Role  |
# +----------+--------+--------+
# |    1     |   No   | client |
# |    2     |   Yes  | client |
# |    3     |   No   | client |
# |    4     |   No   | client |
# |    10    |   No   | driver |
# |    11    |   No   | driver |
# |    12    |   No   | driver |
# |    13    |   No   | driver |
# +----------+--------+--------+
# Write a SQL query to find the cancellation rate of requests made by unbanned users
# (both client and driver must be unbanned) between Oct 1, 2013 and Oct 3, 2013.
# The cancellation rate is computed by dividing the number of canceled (by client or driver) requests
# made by unbanned users by the total number of requests made by unbanned users.
# For the above tables, your SQL query should return the following rows with the cancellation rate
# being rounded to two decimal places.
# +------------+-------------------+
# |     Day    | Cancellation Rate |
# +------------+-------------------+
# | 2013-10-01 |       0.33        |
# | 2013-10-02 |       0.00        |
# | 2013-10-03 |       0.50        |
# +------------+-------------------+
# ----------------------------------------------------------------------------------------------------
# 总体思想：
# 1) 排除该排除的
# 2) 按照正常思路来分组计算
# 3) 运算的部分在 SELECT 里面体现思路
# ----------------------------------------------------------------------------------------------------
# 利用除法算比例
SELECT T.request_at AS 'DAY', ROUND(
    SUM(IF(T.Status='completed',0,1)) / COUNT(*), 2
) AS 'Cancellation Rate'
FROM Trips AS T
JOIN Users AS U1 ON (T.client_id = U1.users_id AND U1.banned ='No')
JOIN Users AS U2 ON (T.driver_id = U2.users_id AND U2.banned ='No')
WHERE T.request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY T.request_at;
# ---------------------------
# 利用 AVG() 算比例，有点儿意思
# The AVG() function returns the average value of a numeric column.
SELECT request_at as 'Day',
       round(avg(Status!='completed'), 2) as 'Cancellation Rate'
FROM trips t
JOIN users u1 ON (t.client_id = u1.users_id AND u1.banned = 'No')
JOIN users u2 ON (t.driver_id = u2.users_id AND u2.banned = 'No')
WHERE request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY request_at


# ----------------------------------------------------------------------------------------------------
# 569. Median Employee Salary
# ----------------------------------------------------------------------------------------------------
# The Employee table holds all employees.
# The employee table has three columns: Employee Id, Company Name, and Salary.
# +-----+------------+--------+
# |Id   | Company    | Salary |
# +-----+------------+--------+
# |1    | A          | 2341   |
# |2    | A          | 341    |
# ......
# |17   | C          | 65     |
# +-----+------------+--------+
# Write a SQL query to find the median salary of each company.
# Bonus points if you can solve it without using any built-in SQL functions.
# +-----+------------+--------+
# |Id   | Company    | Salary |
# +-----+------------+--------+
# |5    | A          | 451    |
# |6    | A          | 513    |
# |12   | B          | 234    |
# |9    | B          | 1154   |
# |14   | C          | 2645   |
# +-----+------------+--------+
# ----------------------------------------------------------------------------------------------------
# Write your MySQL query statement below
SELECT Employee.Id, Employee.Company, Salary
FROM Employee
JOIN (
    SELECT Id, ROW_NUMBER () OVER (
        PARTITION BY Company
        ORDER BY Salary DESC
    ) AS rank_num
    FROM Employee
) AS rank_tbl
ON rank_tbl.Id = Employee.Id
JOIN (
    SELECT COUNT(*) company_count, Company
    FROM Employee
    GROUP BY Company
) AS count_tbl
ON count_tbl.Company = Employee.Company
WHERE rank_num >= count_tbl.company_count / 2
AND (Employee.Id, Employee.Company, Salary) IN (
    SELECT Employee.Id, Employee.Company, Salary
    FROM Employee
    JOIN (
        SELECT Id, ROW_NUMBER () OVER (
            PARTITION BY Company
            ORDER BY Salary
        ) AS rank_num
        FROM Employee
    ) AS rank_tbl
    ON rank_tbl.Id = Employee.Id
    JOIN (
        SELECT COUNT(*) company_count, Company
        FROM Employee
        GROUP BY Company
    ) AS count_tbl
    ON count_tbl.Company = Employee.Company
    WHERE rank_num >= count_tbl.company_count / 2
);
# ---------------------------
# 总的来说，不管是数组长度是奇是偶，也不管元素是不是唯一，中位数出现的频率一定大于等于大于它的数和小于它的数的绝对值之差。
SELECT Employee.Id, Employee.Company, Employee.Salary
FROM Employee, Employee alias
WHERE Employee.Company = alias.Company
GROUP BY Employee.Company , Employee.Salary
HAVING SUM(
    CASE
    WHEN Employee.Salary = alias.Salary THEN 1
    ELSE 0
    END) >= ABS(SUM(SIGN(Employee.Salary - alias.Salary)))
ORDER BY Employee.Id;
# ---------------------------
SELECT Id, E.Company, Salary
FROM (
    SELECT Id, Company, Salary, ROW_NUMBER() OVER(
        PARTITION BY Company
        ORDER BY Salary) rn
    FROM Employee) E
INNER JOIN(
    SELECT Company, COUNT(*) total
    FROM Employee
    GROUP BY Company) T
ON E.Company = T.Company
AND rn BETWEEN total / 2 AND total / 2 + 1;


# ----------------------------------------------------------------------------------------------------
# 571. Find Median Given Frequency of Numbers
# ----------------------------------------------------------------------------------------------------
# The Numbers table keeps the value of number and its frequency.
# +----------+-------------+
# |  Number  |  Frequency  |
# +----------+-------------|
# |  0       |  7          |
# |  1       |  1          |
# |  2       |  3          |
# |  3       |  1          |
# +----------+-------------+
# In this table, the numbers are 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, so the median is (0 + 0) / 2 = 0.
# +--------+
# | median |
# +--------|
# | 0.0000 |
# +--------+
# ----------------------------------------------------------------------------------------------------
# Write a query to find the median of all numbers and name the result as median.
# ----------------------------------------------------------------------------------------------------
SELECT AVG(Number) AS 'median'
FROM (
    SELECT Number,
    SUM(Frequency) OVER (
        ORDER BY Number
    ) asc_accmu,
    SUM(Frequency) OVER (
        ORDER BY Number DESC
    ) desc_accumu
    FROM Numbers
) tbl
JOIN (
    SELECT SUM(Frequency) total
    FROM Numbers
) tbl2
WHERE asc_accmu >= total / 2 and desc_accumu >= total / 2