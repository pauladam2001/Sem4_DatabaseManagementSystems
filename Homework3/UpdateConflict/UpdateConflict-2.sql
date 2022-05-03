GO
SET TRAN ISOLATION LEVEL SNAPSHOT		-- update conflict
BEGIN TRAN
WAITFOR DELAY '00:00:05'
UPDATE Team SET TeamName = 'CSM Satu Mare' WHERE TeamID = 3		-- the first transaction updated and obtained a lock on this table, trying to update
COMMIT TRAN														-- the same row will result in an error