# ----------------------------------------------------------------------------------------------------
# 196. Delete Duplicate Emails
# ----------------------------------------------------------------------------------------------------
# Write a SQL query to delete all duplicate email entries in a table named Person,
# keeping only unique emails based on its smallest Id.
# Your output is the whole Person table after executing your sql. Use delete statement.
# ----------------------------------------------------------------------------------------------------
# 最原始的 delete 语句
# delete from table1 where table1.id = 1;
# 如果需要关联其他表进行删除
# delete table1
# from table1 inner join table2 on table1.id = table2.id
# where table2.type = 'something' and table1.id = 'idnums';
# ----------------------------------------------------------------------------------------------------
# 官方题解，DELETE + 自连接
DELETE P1
FROM Person P1, Person P2
WHERE P1.Email = P2.Email   -- 利用where进行自连接
AND P1.Id > P2.Id   -- 选择Id较大的行
# ---------------------------
# DELETE + 子查询，实测效率更高
DELETE FROM Person
WHERE Id NOT IN (   -- 删除不在查询结果中的值
    SELECT id FROM
   (
       SELECT MIN(Id) AS Id -- 排除 Email 相同时中 Id 较大的行
       FROM Person
       GROUP BY Email
   ) AS temp    -- 此处需使用临时表，否则会发生报错
)
