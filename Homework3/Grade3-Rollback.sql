SELECT * FROM Team
SELECT * FROM Company
SELECT * FROM Team_Company


GO
CREATE TABLE LogTable(
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	TypeOp VARCHAR(40),
	TableOp VARCHAR(40),
	ExecTime DATETIME)
	

-- m:n rel.: Team - Team_Company - Company

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
CREATE OR ALTER PROCEDURE uspAddTeam (@teamID INT, @teamName VARCHAR(40), @teamLocation VARCHAR(40), @yearOfAppearance INT)
AS
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

GO
CREATE OR ALTER PROCEDURE uspAddCompany (@companyName VARCHAR(40), @nrOfEmployees INT, @marketPower INT)
AS
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

GO
CREATE OR ALTER PROCEDURE uspAddTeamCompany (@teamID INT, @companyName VARCHAR(40), @sponsoredWith VARCHAR(40))
AS
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


GO
CREATE OR ALTER PROCEDURE uspAddCommitTest
AS
	BEGIN TRAN
	BEGIN TRY
		EXEC uspAddTeam 10, 'Slam Bucuresti', 'Bucuresti', 1999
		EXEC uspAddCompany 'Aterm', 50, 5
		EXEC uspAddTeamCompany 10, 'Aterm', 'money'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		RETURN
	END CATCH

GO
CREATE OR ALTER PROCEDURE uspAddRollbackTest
AS
	BEGIN TRAN
	BEGIN TRY
		EXEC uspAddTeam 10, 'Slam Bucuresti', 'Bucuresti', 1999
		EXEC uspAddCompany 'X', 50, 5		-- fail
		EXEC uspAddTeamCompany 10, 'Aterm', 'money'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		RETURN
	END CATCH


GO
EXEC uspAddRollbackTest
EXEC uspAddCommitTest

SELECT * FROM LogTable

DELETE FROM Team_Company WHERE TeamID = 10 AND CompanyName = 'Aterm'
DELETE FROM Team WHERE TeamID = 10
DELETE FROM Company WHERE CompanyName = 'Aterm'