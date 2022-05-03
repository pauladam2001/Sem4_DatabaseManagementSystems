GO
SET TRAN ISOLATION LEVEL READ UNCOMMITTED  -- we can read uncomitted data (dirty read)
BEGIN TRAN
SELECT * FROM Team			-- we can see the update 
WAITFOR DELAY '00:00:06'
SELECT * FROM Team			-- we cannot see the update because it was rolled back
COMMIT TRAN