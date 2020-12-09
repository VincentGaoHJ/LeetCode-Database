# ----------------------------------------------------------------------------------------------------
# 177. Nth Highest Salary
# ----------------------------------------------------------------------------------------------------
# Write a SQL query to get the nth highest salary from the Employee table.
# ----------------------------------------------------------------------------------------------------
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    SET N := N-1;
  RETURN (
      # Write your MySQL query statement below.
      SELECT DISTINCT Salary AS getNthHighestSalary
      FROM Employee
      ORDER BY Salary DESC
      LIMIT 1 OFFSET N
  );
END;

# ----------------------------------------------------------------------------------------------------
# 178. Rank Scores
# ----------------------------------------------------------------------------------------------------
# Write a SQL query to rank scores. If there is a tie between two scores, both should have the same ranking.
# Note that after a tie, the next ranking number should be the next consecutive integer value.
# In other words, there should be no "holes" between ranks.
# ----------------------------------------------------------------------------------------------------
SELECT Score, dense_rank() over(ORDER BY Score DESC) AS 'RANK'
FROM Scores;


# ----------------------------------------------------------------------------------------------------
# 180. Consecutive Numbers
# ----------------------------------------------------------------------------------------------------
# Write a SQL query to find all numbers that appear at least three times consecutively.
# ----------------------------------------------------------------------------------------------------
SELECT DISTINCT l1.Num AS ConsecutiveNums
FROM
    Logs l1,
    Logs l2,
    Logs l3
WHERE
    l1.Id = l2.Id - 1
    AND l2.Id = l3.Id - 1
    AND l1.Num = l2.Num
    AND l2.Num = l3.Num
;

