GO
INSERT INTO Team VALUES (20, 'Dan Dacian', 'Bucuresti', 2010)
BEGIN TRAN
WAITFOR DELAY '00:00:05'
UPDATE Team
SET YearOfAppearance = 2005
WHERE TeamName = 'Dan Dacian'
COMMIT TRAN