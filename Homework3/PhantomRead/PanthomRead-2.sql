GO
SET TRAN ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
SELECT * FROM Team				-- the inserted value does not exist yet
WAITFOR DELAY '00:00:06'
SELECT * FROM Team				-- we can see the inserted value now
COMMIT TRAN