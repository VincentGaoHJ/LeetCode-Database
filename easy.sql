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


