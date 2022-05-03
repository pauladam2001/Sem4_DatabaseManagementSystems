-- A non-repeatable read occurs, when during the course of a transaction, a row is retrieved twice and the values within the row differ between reads.

GO
SET TRAN ISOLATION LEVEL REPEATABLE READ		-- the solution is to set isolation level to repeatable read
BEGIN TRAN
SELECT * FROM Team
WAITFOR DELAY '00:00:06'
SELECT * FROM Team			-- we see the value before the update
COMMIT TRAN