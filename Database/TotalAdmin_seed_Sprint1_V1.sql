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
		[Name] NVARCHAR(50) NOT NULL
	);
GO

-- Item Statuses
INSERT INTO ItemStatus([Name]) 
VALUES
	('Pending'),
	('Approved')


-- purchase order statuses
IF OBJECT_ID('TotalAdmin.dbo.PurchaseOrderStatus', 'U') IS NULL
	CREATE TABLE PurchaseOrderStatus(
		PoStatusId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[Name] NVARCHAR(50) NOT NULL
	);
GO

-- Purchase Order Statuses
INSERT INTO PurchaseOrderStatus([Name]) 
VALUES
	('Pending'),
	('Under Review'),
	('Approved')

-- role
IF OBJECT_ID('TotalAdmin.dbo.Role', 'U') IS NULL
	CREATE TABLE [Role](
		RoleId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		RoleName NVARCHAR(255) NOT NULL
	);
GO

-- user privileges
INSERT INTO [Role](RoleName) 
VALUES 
	('CEO'),
	('HR Supervisor'),
	('Supervisor'),
	('HR Employee'),
	('Employee')


-- department
IF OBJECT_ID('TotalAdmin.dbo.Department', 'U') IS NULL
	CREATE TABLE [Department](
		DepartmentId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[Name] NVARCHAR(128) NOT NULL,
		[Description] NVARCHAR(512) NOT NULL,
		InvocationDate DATETIME2(7) NOT NULL,
		[RowVersion] INT NOT NULL
	);
GO


-- employee
IF OBJECT_ID('TotalAdmin.dbo.Employee', 'U') IS NULL
	CREATE TABLE Employee(
		EmployeeNumber INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		FirstName NVARCHAR(50) NOT NULL,
		MiddleInitial CHAR(1) NULL,
		LastName NVARCHAR(50) NOT NULL,
		EmailAddress NVARCHAR(255) NOT NULL,
		HashedPassword NVARCHAR(255) NOT NULL,
		StreetAddress NVARCHAR(255) NOT NULL,
		City NVARCHAR(50) NOT NULL,
		PostalCode NVARCHAR(7) NOT NULL,
		[SIN] NVARCHAR(9) NOT NULL UNIQUE,
		JobTitle NVARCHAR(60) NOT NULL,
		CompanyStartDate DATETIME2(7) NOT NULL,
		JobStartDate DATETIME2(7) NOT NULL,
		OfficeLocation NVARCHAR(255) NOT NULL,
		WorkPhoneNumber NVARCHAR(12) NOT NULL,
		CellPhoneNumber NVARCHAR(12) NOT NULL,
		IsActive BIT NOT NULL,
		[RowVersion] INT NOT NULL,
		SupervisorEmpNumber INT NULL,
		DepartmentId INT NULL,
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
		CreationDate DATETIME2(7) NOT NULL,
		[RowVersion] INT NOT NULL,
		PurchaseOrderStatusId INT NOT NULL,
		EmployeeNumber INT NOT NULL
		CONSTRAINT FK_PurchaseOrderStatus_PurchaseOrder FOREIGN KEY (PurchaseOrderStatusId) REFERENCES PurchaseOrderStatus(PoStatusId),
		CONSTRAINT FK_Employee_PurchaseOrder FOREIGN KEY (EmployeeNumber) REFERENCES Employee(EmployeeNumber)
	);
GO
-- item
IF OBJECT_ID('TotalAdmin.dbo.Item', 'U') IS NULL
	CREATE TABLE Item(
		ItemId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[Name] VARCHAR(45) NOT NULL,
		Quantity INT NOT NULL,
		[Description] NTEXT NOT NULL,
		Price MONEY NOT NULL,
		Justification NVARCHAR(255),
		ItemLocation NVARCHAR(255),
		[RowVersion] INT NOT NULL,
		PoNumber INT NOT NULL,
		ItemStatusId INT NOT NULL,
		CONSTRAINT FK_PurchaseOrder_Item FOREIGN KEY (PoNumber) REFERENCES PurchaseOrder(PoNumber),
		CONSTRAINT FK_Item_Status FOREIGN KEY (ItemStatusId) REFERENCES ItemStatus(ItemStatusId)
	);
GO

