-- A phantom read occurs when, in the course of a transaction, two identical queries are executed, and the collection of rows returned by the second query
-- is different from the first.

GO
SET TRAN ISOLATION LEVEL SERIALIZABLE		-- the solution is to set isolation level to serializable
BEGIN TRAN
SELECT * FROM Team
WAITFOR DELAY '00:00:06'
SELECT * FROM Team
COMMIT TRAN