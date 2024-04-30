USE [master]
GO

DROP DATABASE IF EXISTS TotalAdmin
CREATE DATABASE TotalAdmin
GO
USE TotalAdmin
GO

-- item status
IF OBJECT_ID('TotalAdmin.dbo.ItemStatus', 'U') IS NULL
	CREATE TABLE ItemStatus(
		ItemStatusId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		ItemStatusName NVARCHAR(50) NOT NULL
	);
GO
-- purchase order status
IF OBJECT_ID('TotalAdmin.dbo.PurchaseOrderStatus', 'U') IS NULL
	CREATE TABLE PurchaseOrderStatus(
		PoStatusId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		PoStatusName NVARCHAR(50) NOT NULL
	);
GO
-- role
IF OBJECT_ID('TotalAdmin.dbo.Role', 'U') IS NULL
	CREATE TABLE [Role](
		RoleId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		RoleName NVARCHAR(255) NOT NULL
	);
GO
-- department
IF OBJECT_ID('TotalAdmin.dbo.Department', 'U') IS NULL
	CREATE TABLE [Department](
		DepartmentId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		DepartmentName NVARCHAR(128) NOT NULL,
		DepartmentDescription NVARCHAR(512) NOT NULL,
		[Version] INT NOT NULL,
		IsActive BIT NOT NULL
	);
GO
-- employee
IF OBJECT_ID('TotalAdmin.dbo.Employee', 'U') IS NULL
	CREATE TABLE Employee(
		EmployeeNumber INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		UserName NVARCHAR(50) NOT NULL,
		FirstName NVARCHAR(50) NOT NULL,
		MiddleInitial CHAR(1) NULL,
		LastName NVARCHAR(50) NOT NULL,
		EmailAddress NVARCHAR(255) NOT NULL,
		HashedPassword NVARCHAR(255) NOT NULL,
		StreetAddress NVARCHAR(255) NOT NULL,
		City NVARCHAR(50) NOT NULL,
		PostalCode NVARCHAR(7) NOT NULL,
		[SIN] NVARCHAR(9) NOT NULL,
		JobTitle NVARCHAR(60) NOT NULL,
		CompanyStartDate DATETIME2(7) NOT NULL,
		JobStartDate DATETIME2(7) NOT NULL,
		WorkPhoneNumber NVARCHAR(12) NOT NULL,
		CellPhoneNumber NVARCHAR(12) NOT NULL,
		IsActive BIT NOT NULL,
		[Version] INT NOT NULL,
		SupervisorEmpNumber INT NULL,
		DepartmentId INT NOT NULL,
		RoleId INT NOT NULL,
		CONSTRAINT FK_Employee_Employee FOREIGN KEY (SupervisorEmpNumber) REFERENCES Employee(EmployeeNumber),
		CONSTRAINT FK_Department_Employee FOREIGN KEY (DepartmentId) REFERENCES Department(DepartmentId),
		CONSTRAINT FK_Role_Employee FOREIGN KEY (RoleId) REFERENCES [Role](RoleId)
	);
GO
-- purchase order
IF OBJECT_ID('TotalAdmin.dbo.PurchaseOrder', 'U') IS NULL
	CREATE TABLE PurchaseOrder(
		PoNumber INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		PoCreationDate DATETIME2(7) NOT NULL,
		[Version] INT NOT NULL,
		PurchaseOrderStatus INT NOT NULL,
		Employee INT NOT NULL
		CONSTRAINT FK_PurchaseOrderStatus_PurchaseOrder FOREIGN KEY (PurchaseOrderStatus) REFERENCES PurchaseOrderStatus(PoStatusId),
		CONSTRAINT FK_Employee_PurchaseOrder FOREIGN KEY (Employee) REFERENCES Employee(EmployeeNumber)
	);
GO
-- item
IF OBJECT_ID('TotalAdmin.dbo.PurchaseOrder', 'U') IS NULL
	CREATE TABLE Item(
		ItemId INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	);
GO