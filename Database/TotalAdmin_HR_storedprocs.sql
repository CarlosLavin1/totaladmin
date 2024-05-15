USE TotalAdmin;
GO

-- create department
CREATE OR ALTER PROC spInsertDepartment
	@DepartmentId INT OUTPUT,
	@Name NVARCHAR(128),
	@Description NVARCHAR(512),
	@InvocationDate DATETIME2(7)
AS
BEGIN
	BEGIN TRY
		INSERT INTO Department 
		([Name], 
		[Description], 
		InvocationDate
		)
		VALUES 
		(@Name, 
		@Description, 
		@InvocationDate
		)
		SET @DepartmentId = SCOPE_IDENTITY()
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO

-- get all active departments
CREATE OR ALTER PROC spGetActiveDepartments
AS
BEGIN
	BEGIN TRY
		SELECT
			DepartmentId,
			[Name],
			[Description],
			InvocationDate
		FROM
			Department
		WHERE
			InvocationDate <= CAST( GETDATE() AS Date )
		ORDER BY
			[Name]
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO

-- get all departments
CREATE OR ALTER PROC spGetAllDepartments
AS
BEGIN
	BEGIN TRY
		SELECT
			DepartmentId,
			[Name],
			[Description],
			InvocationDate
		FROM
			Department
		ORDER BY
			[Name]
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO

-- create employee
CREATE OR ALTER PROC spInsertEmployee
	@FirstName NVARCHAR(50),
	@MiddleInitial CHAR(1),
	@LastName NVARCHAR(60),
	@Email NVARCHAR(255),
	@HashedPassword NVARCHAR(255),
	@StreetAddress NVARCHAR(255),
	@City NVARCHAR(50),
	@PostalCode NVARCHAR(7),
	@SIN NVARCHAR(9),
	@JobTitle NVARCHAR(60),
	@DateOfBirth DATETIME2(7),
	@CompanyStartDate DATETIME2(7),
	@JobStartDate DATETIME2(7),
	@OfficeLocation NVARCHAR(255),
	@WorkPhoneNumber NVARCHAR(12),
	@CellPhoneNumber NVARCHAR(12),
	@StatusId INT,
	@SupervisorEmpNumber INT,
	@DepartmentId INT,
	@RoleId INT,
	@EmployeeNumber INT OUTPUT
AS
BEGIN
	BEGIN TRY 
		INSERT INTO Employee(
			FirstName,
			MiddleInitial,
			LastName,
			EmailAddress,
			HashedPassword,
			StreetAddress,
			City,
			PostalCode,
			[SIN],
			JobTitle,
			DateOfBirth,
			CompanyStartDate,
			JobStartDate,
			OfficeLocation,
			WorkPhoneNumber,
			CellPhoneNumber,
			StatusId,
			SupervisorEmpNumber,
			DepartmentId,
			RoleId)
		 VALUES (
			@FirstName,
			@MiddleInitial,
			@LastName,
			@Email,
			@HashedPassword,
			@StreetAddress,
			@City,
			@PostalCode,
			@SIN,
			@JobTitle,
			@DateOfBirth,
			@CompanyStartDate,
			@JobStartDate,
			@OfficeLocation,
			@WorkPhoneNumber,
			@CellPhoneNumber,
			@StatusId,
			@SupervisorEmpNumber,
			@DepartmentId,
			@RoleId)
			SET @EmployeeNumber = SCOPE_IDENTITY()
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO

-- update employee
CREATE OR ALTER PROC spUpdateEmployee
	@EmployeeNumber INT,
	@FirstName NVARCHAR(50),
	@MiddleInitial CHAR(1),
	@LastName NVARCHAR(60),
	@Email NVARCHAR(255),
	@HashedPassword NVARCHAR(255),
	@StreetAddress NVARCHAR(255),
	@City NVARCHAR(50),
	@PostalCode NVARCHAR(7),
	@SIN NVARCHAR(9),
	@JobTitle NVARCHAR(60),
	@DateOfBirth DATETIME2(7),
	@CompanyStartDate DATETIME2(7),
	@JobStartDate DATETIME2(7),
	@OfficeLocation NVARCHAR(255),
	@WorkPhoneNumber NVARCHAR(12),
	@CellPhoneNumber NVARCHAR(12),
	@TerminatedDate DATETIME2(7) = NULL,
	@RetiredDate DATETIME2(7) = NULL,
	@StatusId INT,
	@SupervisorEmpNumber INT,
	@DepartmentId INT,
	@RoleId INT,
	@RowVersion ROWVERSION
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		UPDATE Employee
		SET
			FirstName = @FirstName, 
			MiddleInitial = @MiddleInitial, 
			LastName = @LastName,
			EmailAddress = @Email,
			HashedPassword = @HashedPassword,
			StreetAddress = @StreetAddress,
			City = @City,
			PostalCode = @PostalCode,
			[SIN] = @SIN,
			JobTitle = @JobTitle,
			DateOfBirth = @DateOfBirth,
			CompanyStartDate = @CompanyStartDate,
			JobStartDate = @JobStartDate,
			OfficeLocation = @OfficeLocation,
			WorkPhoneNumber = @WorkPhoneNumber,
			CellPhoneNumber = @CellPhoneNumber,
			TerminatedDate = @TerminatedDate,
			RetiredDate = @RetiredDate,
			StatusId = @StatusId,
			SupervisorEmpNumber = @SupervisorEmpNumber,
			DepartmentId = @DepartmentId,
			RoleId = @RoleId
		WHERE
			EmployeeNumber = @EmployeeNumber AND
			[RowVersion] = @RowVersion;

		IF @@ROWCOUNT = 0
			BEGIN
				-- No rows updated, possible RowVersion mismatch
				;THROW 50100, 'The record has been modified by another user since it was last fetched. Please refresh the page', 1;
			END
		
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO

-- search employees by id, last name, and department
CREATE OR ALTER PROC spSearchEmployees
    @EmployeeNumber INT = NULL,
    @DepartmentId INT = NULL,
	@LastName NVARCHAR(50) = NULL
AS
BEGIN
    SELECT
        EmployeeNumber,
        FirstName,
		MiddleInitial,
		LastName,
		StreetAddress,
		City, 
		PostalCode,
        WorkPhoneNumber,
        CellPhoneNumber,
        EmailAddress,
		JobTitle
    FROM
        Employee
    WHERE
        StatusId = 1
        AND (@EmployeeNumber IS NULL OR @EmployeeNumber = 0 OR EmployeeNumber = @EmployeeNumber)
        AND (@LastName IS NULL OR LastName LIKE '%' + @LastName + '%')
        AND (@DepartmentId IS NULL OR @DepartmentId = 0 OR DepartmentId = @DepartmentId)
    ORDER BY
        LastName,
        FirstName;
END
GO

-- get employees in a department
CREATE OR ALTER PROC spGetEmployeesInDepartment
    @DepartmentId INT
AS
BEGIN
    SELECT
        COUNT(EmployeeNumber)
    FROM
        Employee
    WHERE
        StatusId = 1
        AND (DepartmentId = @DepartmentId)
END
GO

-- get employees for a supervisor
CREATE OR ALTER PROC spGetEmployeesForSupervisorCount
    @SupervisorEmployeeNumber INT,
	@EmployeeNumber INT
AS
BEGIN
    SELECT
        COUNT(EmployeeNumber)
    FROM
        Employee
    WHERE
        StatusId = 1
        AND (SupervisorEmpNumber = @SupervisorEmployeeNumber)
		AND (EmployeeNumber != @EmployeeNumber)
END
GO

-- get employee by id
CREATE OR ALTER PROC spGetEmployeeById
    @EmployeeNumber INT = NULL
AS
BEGIN
    SELECT
        *
    FROM
        Employee
    WHERE
		EmployeeNumber = @EmployeeNumber
END
GO

-- get supervisors for a department and role
CREATE OR ALTER PROC spGetSupervisors
	@DepartmentId INT,
	@RoleId INT
AS
BEGIN
	IF @RoleId = 2 OR @RoleId = 3 -- Supervisors have to be supervised by the ceo
		BEGIN
			SELECT
				*
			FROM
				Employee
			WHERE
				StatusId = 1
				AND RoleId = 1
		END
	ELSE
		BEGIN
			IF @RoleId = 4  -- HR employee
				BEGIN
					SELECT
					*
					FROM
						Employee
					WHERE
						StatusId = 1
						AND RoleId = 2
						AND DepartmentId = @DepartmentId
				END
			ELSE -- roleId 5 Employee
				BEGIN
					SELECT
					*
					FROM
						Employee
					WHERE
						StatusId = 1
						AND RoleId = 3
						AND DepartmentId = @DepartmentId
				END
		END
END
GO

-- update department
CREATE OR ALTER PROC spUpdateDepartment
	@DepartmentId INT OUTPUT,
	@Name NVARCHAR(128),
	@Description NVARCHAR(512),
	@InvocationDate DATETIME2(7),
	@RowVersion ROWVERSION
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		UPDATE Department
		SET
			[Name] = @Name, 
			[Description] = @Description, 
			InvocationDate = @InvocationDate
		WHERE
			DepartmentId = @DepartmentId AND
			[RowVersion] = @RowVersion;

		IF @@ROWCOUNT = 0
			BEGIN
				-- No rows updated, possible RowVersion mismatch
				;THROW 50100, 'The record has been modified by another user since it was last fetched. Please refresh the page', 1;
			END
		
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO

-- get department for employee
CREATE OR ALTER PROC spGetDepartmentForEmployee
	@EmployeeNumber INT
AS
BEGIN
	SELECT
		DepartmentId,
		[Name],
		[Description],
		InvocationDate,
		[RowVersion]
	FROM Department
	WHERE DepartmentId = (SELECT DepartmentId FROM Employee WHERE EmployeeNumber = @EmployeeNumber)
END
GO

-- search employees by id and last name
CREATE OR ALTER PROC spSearchEmployeesDirectory
    @EmployeeNumber INT = NULL,
	@LastName NVARCHAR(50) = NULL
AS
BEGIN
    SELECT
        EmployeeNumber,
        FirstName,
		MiddleInitial,
		LastName,
		StreetAddress,
		City, 
		PostalCode,
        WorkPhoneNumber,
        CellPhoneNumber,
        EmailAddress,
		JobTitle
    FROM
        Employee
    WHERE
        (@EmployeeNumber IS NULL OR @EmployeeNumber = -1 OR EmployeeNumber = @EmployeeNumber)
        AND (@LastName IS NULL OR @LastName = '' OR LastName LIKE '%' + @LastName + '%')
    ORDER BY
        LastName,
        FirstName;
END
GO

-- get old invocation date for department
CREATE OR ALTER PROC getOldInvocationDateForDepartment
	@DepartmentId INT
AS
BEGIN
	SELECT
		InvocationDate
	FROM
		Department
	WHERE 
		DepartmentId = @DepartmentId
END
GO

-- get department by id
CREATE OR ALTER PROC getDepartmentById
	@DepartmentId INT
AS
BEGIN
	SELECT
		*
	FROM
		Department
	WHERE 
		DepartmentId = @DepartmentId
END
GO

-- delete department
CREATE OR ALTER PROC spDeleteDepartment
	@DepartmentId INT
AS
BEGIN
	BEGIN TRY	
		DELETE FROM Department
		WHERE DepartmentId = @DepartmentId;
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO

-- select * from Role
-- login
CREATE OR ALTER PROC spLogin
	@EmployeeNumber INT,
	@HashedPassword NVARCHAR(255)
AS
BEGIN
	BEGIN TRY
		SELECT
			EmployeeNumber,
			FirstName + ' ' + CAST(MiddleInitial AS NVARCHAR(1)) + ' ' + LastName AS FullName,
			EmailAddress,
			[Role].RoleName,
			WorkPhoneNumber
		FROM
			Employee
				INNER JOIN [Role] ON Employee.RoleId = [Role].RoleId
		WHERE
			EmployeeNumber = @EmployeeNumber
			AND UPPER([HashedPassword]) = UPPER(@HashedPassword)
			AND StatusId = 1
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO

-- get reviews for employee
CREATE OR ALTER PROC spGetReviewsForEmployee
	@EmployeeNumber INT
AS
BEGIN
	BEGIN TRY	
		SELECT *
		FROM Review
		WHERE EmployeeNumber = @EmployeeNumber
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO

--get review reminder date
CREATE OR ALTER PROC spGetMostRecentReviewReminderDate
AS
BEGIN
	BEGIN TRY	
		SELECT MAX(DaySent) AS MostRecentDate
		FROM ReviewReminder
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO

-- add review
CREATE OR ALTER PROC spInsertReview
	@ReviewId INT OUTPUT,
	@RatingId INT,
	@Comment NVARCHAR(MAX),
	@EmployeeNumber INT,
	@SupervisorEmployeeNumber INT,
	@ReviewDate DATETIME2(7),
	@HasBeenRead BIT
AS
BEGIN
	BEGIN TRY	
		INSERT INTO Review (
			ReviewRatingId,
			Comment,
			EmployeeNumber,
			SupervisorEmployeeNumber,
			ReviewDate,
			IsRead
		)
		VALUES (
			@RatingId,
			@Comment,
			@EmployeeNumber,
			@SupervisorEmployeeNumber,
			@ReviewDate,
			@HasBeenRead
		)
		-- Retrieve the last inserted ReviewId
		SET @ReviewId = SCOPE_IDENTITY()
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END 
GO