GO
BEGIN TRAN
UPDATE Team SET TeamLocation = 'Darlos' WHERE TeamName = 'CSM Medias'		-- exclusive lock on table Company
WAITFOR DELAY '00:00:10'
UPDATE Company SET NrOfEmployees = 9999 WHERE CompanyName =  'Romgaz'	-- this transaction will be blocked because there already is an exclusive lock on Company
COMMIT TRAN