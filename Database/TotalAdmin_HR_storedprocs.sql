USE TotalAdmin;
GO

-- create department
CREATE OR ALTER PROC spInsertDepartment
	@Name NVARCHAR(128),
	@Description NVARCHAR(512),
	@InvocationDate DATETIME2(7),
	@DepartmentId INT OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO Department 
		([Name], 
		[Description], 
		InvocationDate,
		[RowVersion]
		)
		VALUES 
		(@Name, 
		@Description, 
		@InvocationDate,
		1
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
			InvocationDate <= GETDATE()
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO

-- create employee
CREATE OR ALTER PROC spInsertEmployee
	@FirstName NVARCHAR(30),
	@MiddleInitial CHAR(1),
	@LastName NVARCHAR(30),
	@Email NVARCHAR(255),
	@HashedPassword NVARCHAR(255),
	@StreetAddress NVARCHAR(255),
	@City NVARCHAR(50),
	@PostalCode NVARCHAR(7),
	@SIN NVARCHAR(9),
	@JobTitle NVARCHAR(60),
	@CompanyStartDate DATETIME2(7),
	@JobStartDate DATETIME2(7),
	@OfficeLocation NVARCHAR(255),
	@WorkPhoneNumber NVARCHAR(12),
	@CellPhoneNumber NVARCHAR(12),
	@IsActive BIT,
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
			CompanyStartDate,
			JobStartDate,
			OfficeLocation,
			WorkPhoneNumber,
			CellPhoneNumber,
			IsActive,
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
			@CompanyStartDate,
			@JobStartDate,
			@OfficeLocation,
			@WorkPhoneNumber,
			@CellPhoneNumber,
			@IsActive,
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

-- search employees by id and last name
CREATE OR ALTER PROC spSearchEmployees
    @EmployeeNumber INT = NULL,
    @DepartmentId INT = NULL,
	@LastName NVARCHAR(50) = NULL
AS
BEGIN
    SELECT
        LastName,
        FirstName,
        WorkPhoneNumber,
        OfficeLocation,
        JobTitle
    FROM
        Employee
    WHERE
        IsActive = 1
        AND (@EmployeeNumber IS NULL OR @EmployeeNumber = 0 OR EmployeeNumber = @EmployeeNumber)
        AND (@LastName IS NULL OR LastName LIKE '%' + @LastName + '%')
        AND (@DepartmentId IS NULL OR @DepartmentId = 0 OR DepartmentId = @DepartmentId)
    ORDER BY
        LastName,
        FirstName;
END
GO

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
			[Role].RoleName
		FROM
			Employee
				INNER JOIN [Role] ON Employee.RoleId = [Role].RoleId
		WHERE
			EmployeeNumber = @EmployeeNumber
			AND [HashedPassword] = @HashedPassword
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO