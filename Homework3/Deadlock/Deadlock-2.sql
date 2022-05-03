GO
BEGIN TRAN
UPDATE Company SET NrOfEmployees = 8888 WHERE CompanyName = 'Transgaz'		-- exclusive lock on table Company
WAITFOR DELAY '00:00:10'
UPDATE Team SET TeamLocation = 'Atel' WHERE TeamName = 'CSU Sibiu'	-- this transaction will be blocked because there already is an exclusive lock on Team
COMMIT TRAN