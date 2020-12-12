# ----------------------------------------------------------------------------------------------------
# 175. Combine Two Tables
# ----------------------------------------------------------------------------------------------------
# Write a SQL query for a report that provides the following information for each person in the Person table,
# regardless if there is an address for each of those people:
# FirstName, LastName, City, State
# ----------------------------------------------------------------------------------------------------
SELECT FirstName, LastName, City, State
FROM Person
LEFT JOIN Address
ON Address.PersonID = Person.PersonID;

# ----------------------------------------------------------------------------------------------------
# 176. Second Highest Salary
# ----------------------------------------------------------------------------------------------------
# Write a SQL query to get the second highest salary from the Employee table.
# ----------------------------------------------------------------------------------------------------
# LIMIT row_count OFFSET offset
# In this syntax:
# The row_count determines the number of rows that will be returned.
# The OFFSET clause skips the offset rows before beginning to return the rows.
# ----------------------------------------------------------------------------------------------------
SELECT (
    SELECT DISTINCT Salary
    FROM Employee
    ORDER BY Salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;

# ----------------------------------------------------------------------------------------------------
# 181. Employees Earning More Than Their Managers
# ----------------------------------------------------------------------------------------------------
# Given the Employee table, write a SQL query that finds out employees who earn more than their managers.
# For the above table, Joe is the only employee who earns more than his manager.
# ----------------------------------------------------------------------------------------------------
SELECT e1.Name AS Employee
FROM Employee e1
JOIN Employee e2
ON e1.managerId = e2.Id
WHERE e1.Salary > e2.Salary

# ----------------------------------------------------------------------------------------------------
# 182. Duplicate Emails
# ----------------------------------------------------------------------------------------------------
# Write a SQL query to find all duplicate emails in a table named Person.
# ----------------------------------------------------------------------------------------------------
SELECT Email
FROM Person
GROUP BY Email
HAVING COUNT(Email) > 1;
# ---------------------------
SELECT Email
FROM (
    SELECT Email, COUNT(Email) AS num
    FROM Person
    GROUP BY Email
) AS TMP
WHERE num > 1;


# ----------------------------------------------------------------------------------------------------
# 183. Customers Who Never Order
# ----------------------------------------------------------------------------------------------------
# Suppose that a website contains two tables, the Customers table and the Orders table.
# Write a SQL query to find all customers who never order anything.
# ----------------------------------------------------------------------------------------------------
SELECT cus.Name AS 'Customers'
FROM Customers cus
WHERE cus.Id NOT IN (
    SELECT CustomerId
    FROM Orders
);


# ----------------------------------------------------------------------------------------------------
# 197. Rising Temperature
# ----------------------------------------------------------------------------------------------------
# Write an SQL query to find all dates' id with higher temperature compared to its previous dates (yesterday).
# Return the result table in any order.
# ----------------------------------------------------------------------------------------------------
# The query result format is in the following example:
# Weather
# +----+------------+-------------+
# | id | recordDate | Temperature |
# +----+------------+-------------+
# | 1  | 2015-01-01 | 10          |
# | 2  | 2015-01-02 | 25          |
# | 3  | 2015-01-03 | 20          |
# | 4  | 2015-01-04 | 30          |
# +----+------------+-------------+
# Result table:
# +----+
# | id |
# +----+
# | 2  |
# | 4  |
# +----+
# In 2015-01-02, temperature was higher than the previous day (10 -> 25).
# In 2015-01-04, temperature was higher than the previous day (30 -> 20).
# ----------------------------------------------------------------------------------------------------
# 蠢办: 利用 DATE_ADD() 创造新列为 yesterday_recordDate
SELECT wea1.id
FROM Weather wea1
JOIN (
    SELECT id, DATE_ADD(recordDate, INTERVAL -1 DAY) AS yesterday_recordDate
    FROM Weather
) AS tmp
ON wea1.id = tmp.id
JOIN Weather wea2
ON wea2.recordDate = tmp.yesterday_recordDate
WHERE wea1.temperature > wea2.temperature
# ---------------------------
# 聪明办: 利用 DATEDIFF() 错位拼接
SELECT weather.id AS 'Id'
FROM weather
JOIN weather w
ON DATEDIFF(weather.date, w.date) = 1
AND weather.Temperature > w.Temperature;


