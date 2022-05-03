GO
CREATE OR ALTER FUNCTION ufValidateName (@name VARCHAR(40))
RETURNS INT
AS
BEGIN
	DECLARE @return INT
	SET @return = 1
	
	IF (@name IS NULL OR LEN(@name) < 3)
	BEGIN
		SET @return = 0
	END

	RETURN @return
END

GO
CREATE OR ALTER FUNCTION ufValidateYear (@year INT)
RETURNS INT
AS
BEGIN
	DECLARE @return INT
	SET @return = 1
	
	IF (@year < 1700 OR @year > 2022)
	BEGIN
		SET @return = 0
	END

	RETURN @return
END

GO
CREATE OR ALTER FUNCTION ufValidateNrOfEmployeesOrMarketPower (@number INT)
RETURNS INT
AS
BEGIN
	DECLARE @return INT
	SET @return = 1

	IF (@number <= 0)
	BEGIN
		SET @return = 0
	END

	RETURN @return
END


GO
CREATE OR ALTER PROCEDURE uspAddTeamRecover (@teamID INT, @teamName VARCHAR(40), @teamLocation VARCHAR(40), @yearOfAppearance INT)
AS
	BEGIN TRAN
	BEGIN TRY
		IF (dbo.ufValidateName(@teamName) = 0)
		BEGIN
			RAISERROR('Team name is not valid!', 14, 1)
		END
		IF (dbo.ufValidateName(@teamLocation) = 0)
		BEGIN
			RAISERROR('Team location is not valid!', 14, 1)
		END
		IF (dbo.ufValidateYear(@yearOfAppearance) = 0)
		BEGIN
			RAISERROR('Team year of appearance is not valid!', 14, 1)
		END
		IF EXISTS (SELECT * FROM Team WHERE teamID = @teamID)
		BEGIN
			RAISERROR('Team already exists in the database!', 14, 1)
		END

		INSERT INTO Team VALUES (@teamID, @teamName, @teamLocation, @yearOfAppearance)
		INSERT INTO LogTable VALUES ('Add', 'Team', GETDATE())
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH

GO
CREATE OR ALTER PROCEDURE uspAddCompanyRecover (@companyName VARCHAR(40), @nrOfEmployees INT, @marketPower INT)
AS
	BEGIN TRAN
	BEGIN TRY
		IF (dbo.ufValidateName(@companyName) = 0)
		BEGIN
			RAISERROR('Company name is not valid!', 14, 1)
		END
		IF (dbo.ufValidateNrOfEmployeesOrMarketPower(@nrOfEmployees) = 0)
		BEGIN
			RAISERROR('Company number of employees is not valid!', 14, 1)
		END
		IF (dbo.ufValidateNrOfEmployeesOrMarketPower(@marketPower) = 0)
		BEGIN
			RAISERROR('Company market power is not valid!', 14, 1)
		END
		IF EXISTS (SELECT * FROM Company WHERE CompanyName = @companyName)
		BEGIN
			RAISERROR('Company already exists in the database!', 14, 1)
		END

		INSERT INTO Company VALUES (@companyName, @nrOfEmployees, @marketPower)
		INSERT INTO LogTable VALUES ('Add', 'Company', GETDATE())
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH

GO
CREATE OR ALTER PROCEDURE uspAddTeamCompanyRecover (@teamID INT, @companyName VARCHAR(40), @sponsoredWith VARCHAR(40))
AS
	BEGIN TRAN
	BEGIN TRY
		IF (dbo.ufValidateName(@sponsoredWith) = 0)
		BEGIN
			RAISERROR('Sponsored with is not valid!', 14, 1)
		END
		IF NOT EXISTS (SELECT * FROM Team WHERE TeamID = @teamID)
		BEGIN
			RAISERROR('The team is not in the database!', 14, 1)
		END
		IF NOT EXISTS (SELECT * FROM Company WHERE CompanyName = @companyName)
		BEGIN
			RAISERROR('The company is not in the database!', 14, 1)
		END
		IF EXISTS (SELECT * FROM Team_Company WHERE TeamID = @teamID AND CompanyName = @companyName)
		BEGIN
			RAISERROR('Pair already exists in the database!', 14, 1)
		END

		INSERT INTO Team_Company VALUES (@teamID, @companyName, @sponsoredWith)
		INSERT INTO LogTable VALUES ('Add', 'Team_Company', GETDATE())
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH


GO
CREATE OR ALTER PROCEDURE uspAddGoodTest
AS
	EXEC uspAddTeamRecover 10, 'Slam Bucuresti', 'Bucuresti', 1999
	EXEC uspAddCompanyRecover 'Aterm', 50, 5
	EXEC uspAddTeamCompanyRecover 10, 'Aterm', 'money'

GO 
CREATE OR ALTER PROCEDURE uspAddBadTest
AS
	EXEC uspAddTeamRecover 10, 'Slam Bucuresti', 'Bucuresti', 1999
	EXEC uspAddCompanyRecover 'X', 50, 5		-- fail
	EXEC uspAddTeamCompanyRecover 10, 'Aterm', 'money'


GO
EXEC uspAddBadTest
SELECT * FROM LogTable

EXEC uspAddGoodTest
SELECT * FROM LogTable

DELETE FROM Team_Company WHERE TeamID = 10 AND CompanyName = 'Aterm'
DELETE FROM Team WHERE TeamID = 10
DELETE FROM Company WHERE CompanyName = 'Aterm'