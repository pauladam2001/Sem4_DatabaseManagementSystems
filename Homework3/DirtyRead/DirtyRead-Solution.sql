-- When a transaction is allowed to read a row that has been modified by an another transaction which is not committed yet that time Dirty Reads occurred. 
-- It is mainly occurred because of multiple transaction at a time which is not committed.

GO
SET TRAN ISOLATION LEVEL READ COMMITED		-- the solution is to set isolation level to read commited
BEGIN TRAN
SELECT * FROM Team
WAITFOR DELAY '00:00:06'
SELECT * FROM Team
COMMIT TRAN