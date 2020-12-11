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








