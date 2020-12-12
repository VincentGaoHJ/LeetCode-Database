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
