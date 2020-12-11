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
)