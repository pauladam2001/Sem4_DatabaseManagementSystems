--  a deadlock occurs when two (or more) processes lock the separate resource. Under these circumstances, each process cannot continue and begins to wait
-- for others to release the resource.

GO
SET DEADLOCK_PRIORITY HIGH		-- the solution is to set the deadlock priority high for the second transaction
BEGIN TRAN						-- now, insted of the second transaction, the first transaction will be chosen as a victim, because it has a lower priority
UPDATE Company SET NrOfEmployees = 8888 WHERE CompanyName = 'Transgaz'
WAITFOR DELAY '00:00:10'
UPDATE Team SET TeamLocation = 'Atel' WHERE TeamName = 'CSU Sibiu'
COMMIT TRAN