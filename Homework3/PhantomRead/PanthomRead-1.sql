GO
BEGIN TRAN
WAITFOR DELAY '00:00:05'
INSERT INTO Team VALUES (30, 'Steaua Magic', 'Bucuresti', 2015)
COMMIT TRAN