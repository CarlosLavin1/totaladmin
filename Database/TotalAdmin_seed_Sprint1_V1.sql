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
GO

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

INSERT INTO Department
	([Name],
	[Description],
	InvocationDate,
	[RowVersion])
VALUES
	('Marketing', 'Marketing department', '12/04/1999', 1),
	('HR', 'Human resources', '12/04/1999', 1),
	('Dev', 'Software Development', '12/04/1999', 1)
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

insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Avril', null, 'Chesson', 'achesson0@odnoklassniki.ru', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '6 Holy Cross Crossing', 'Halifax', 'G1I8Q3', '371414274', 'Human Resources Manager', '9/11/2006', '5/21/2014', 'Room 1350', '991-636-4566', '997-673-1215', 1, NULL, 1, 1, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Bealle', 'P', 'Tarquini', 'btarquini1@issuu.com', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '882 Kropf Avenue', 'Mississauga', 'H8T4T0', '228656303', 'Senior Sales Associate', '3/31/2016', '4/26/2005', 'Room 339', '211-233-0956', '181-328-1762', 1, 1, 2, 2, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Timmy', 'L', 'Byway', 'tbyway2@un.org', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '10511 School Center', 'Moncton', 'C6M1A8', '507706961', 'Research Nurse', '5/16/2008', '5/1/1999', 'Room 1650', '322-214-2163', '551-556-0402', 1, 1, 3, 3, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Evvy', null, 'Langman', 'elangman3@pinterest.com', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '4 Russell Center', 'Mississauga', 'I2T2C4', '528459139', 'Help Desk Technician', '9/18/2008', '1/21/2000', 'Suite 8', '977-147-9549', '976-556-7323', 1, 1, 1, 5, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Philomena', 'O', 'Lathom', 'plathom4@edublogs.org', '06fef4bfe2f355eab0aeb5052331e634977e074e3384bbb24c6e9cb127627e47', '2048 Chive Junction', 'Montreal', 'A5F6Y9', '174027109', 'Programmer Analyst I', '4/14/2003', '2/7/1996', 'Room 1398', '167-423-8073', '914-684-7993', 1, 1, 2, 2, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Guendolen', 'X', 'Vint', 'gvint5@123-reg.co.uk', 'd50795cf6d02eb2591e501d43465353834ceeecf3ae0277ff186db59dfe9f696', '19739 Bonner Circle', 'Timmins', 'A9Z3A4', '769821925', 'Quality Control Specialist', '1/16/2009', '3/8/2023', '3rd Floor', '498-134-6280', '755-303-5339', 1, 1, 2, 2, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Monika', null, 'Penson', 'mpenson6@merriam-webster.com', 'ac7c8bdb479e47a423de8e8a4020473d04a9541caf30920bb75f9439ed5a9197', '338 Laurel Crossing', 'Moncton', 'V4K0R6', '669569877', 'Executive Secretary', '7/15/2017', '8/13/2013', 'Room 701', '717-810-0762', '278-709-9708', 0, 1, 2, 2, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Mindy', null, 'Silber', 'msilber7@unicef.org', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '613 Bobwhite Circle', 'Dieppe', 'W6S0G7', '319872454', 'Quality Engineer', '2/9/2005', '5/22/2023', 'Suite 38', '389-414-1238', '193-897-3335', 1, 1, 2, 3, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Devonna', 'Q', 'Capsey', 'dcapsey8@bravesites.com', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '7 Calypso Park', 'Montreal', 'G0P6E4', '256507651', 'Senior Quality Engineer', '3/22/2013', '7/3/1999', '4th Floor', '366-940-8819', '994-985-5947', 1, 2, 2, 5, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Alessandra', null, 'Taplin', 'ataplin9@phoca.cz', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '6 Sauthoff Point', 'Montreal', 'J8N9Q0', '796727192', 'Cost Accountant', '12/4/2009', '2/15/2021', 'Suite 44', '948-818-5525', '827-514-8479', 1, 1, 1, 2, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Marissa', 'S', 'Guillerman', 'mguillermana@sogou.com', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '2892 Longview Road', 'Montreal', 'I4S4H9', '254858742', 'Developer III', '10/3/2009', '5/28/2002', 'Room 8047', '162-850-9923', '328-873-3717', 1, 3, 1, 4, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Bili', 'U', 'Mac', 'bmacb@eepurl.com', '785e68a22eb81d9e942cbc7f2dc2f86d6ca7d5f3d1222413f9e74e78b6b68a74', '3978 Warrior Street', 'Toronto', 'M6L2S8', '444038125', 'Computer Systems Analyst II', '7/28/2016', '8/18/2000', '7th Floor', '810-916-8912', '277-905-2090', 1, 3, 1, 5, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Tobi', 'T', 'Tuffrey', 'ttuffreyc@opensource.org', '92de0b754aa96503ea8639312a4a788ee48fc3cdb1481caefa5b1b457ce95672', '9 Dunning Junction', 'Vancouver', 'P2E2X5', '161275684', 'Environmental Tech', '4/14/2021', '11/8/1999', 'Suite 2', '591-117-0033', '509-927-1357', 1, 3, 1, 5, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Hyman', 'X', 'Jarritt', 'hjarrittd@slate.com', '55cd3dfedfb5d96655c0c366be7f2b966338bda5933f55f8895d12462ffd2c9e', '9 Northridge Trail', 'Vancouver', 'Z4N3E0', '116315063', 'Electrical Engineer', '8/28/2011', '12/16/1999', 'Room 356', '177-751-2511', '772-908-7701', 0, 4, 1, 5, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Phaidra', null, 'Slane', 'pslanee@webeden.co.uk', 'b80a134cec47246fe0571cc8e9c28a8dff462d7db782714b94d8f6bb4d14cced', '3 2nd Alley', 'Vancouver', 'B8D4G4', '716556358', 'Professor', '10/25/2015', '4/16/1997', 'Suite 46', '377-810-3825', '641-543-6891', 1, 4, 1, 5, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Cash', null, 'Grishanin', 'cgrishaninf@squidoo.com', '91520ad7cb52dd96e4901f0a2193c3a165cd85b9bef1cfe3163f754bc6cdcc21', '4 Talmadge Junction', 'Moncton', 'C0O4S7', '361402559', 'Assistant Professor', '9/13/1995', '3/23/2013', 'Room 1189', '737-218-1922', '937-214-3876', 0, 4, 3, 5, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Kevina', 'S', 'Freemantle', 'kfreemantleg@bbc.co.uk', '31e22b17290d1c2a1c672668929bf4752fa312b8d6f8be79a1303bf5cb7427d1', '326 Esker Center', 'Riverview', 'C0L4E1', '014161125', 'Senior Developer', '6/17/1995', '10/19/2018', '2nd Floor', '979-571-1209', '944-201-7539', 1, 5, 1, 5, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Cayla', 'C', 'Hinners', 'chinnersh@netvibes.com', '64bd186f6f51f500e79956ed815d515b2a6721a65d3fd8a8722fa39495e94dcc', '26213 Hauk Street', 'Truro', 'K3L7Z3', '242099899', 'Media Manager IV', '3/24/2004', '6/30/2000', 'Room 1786', '138-387-3592', '281-370-1130', 1, 5, 1, 4, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Jaymie', null, 'Syder', 'jsyderi@artisteer.com', '887f81e3c2b92ae5851bcfd398d25a7667ab1ce001fc6024c601cbb4cc93a469', '2446 Mccormick Hill', 'Belleville', 'W9K4O1', '774849266', 'Staff Scientist', '11/28/2003', '9/11/2010', 'Room 1788', '319-989-3501', '598-608-5409', 1, 1, 1, 3, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, IsActive, SupervisorEmpNumber, DepartmentId, RoleId, [RowVersion]) values ('Daniel', null, 'Richel', 'drichelj@cmu.edu', '6afe1e909d91a6b30327d3bcf91c492783b37f015d471ce390817edc1b5e6854', '3744 Sauthoff Drive', 'Moncton', 'R9O1I9', '245818537', 'Occupational Therapist', '1/5/2013', '11/10/2000', '13th Floor', '350-109-7119', '997-917-7166', 1, 1, 2, 2, 1);
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
INSERT INTO PurchaseOrder (CreationDate, [RowVersion], PurchaseOrderStatusId, EmployeeNumber)
VALUES
('2024-04-01', 1, 1, 5),
('2024-03-15', 1, 2, 5),
('2024-02-28', 1, 3, 3),
('2024-04-10', 1, 1, 9),
('2024-03-20', 1, 2, 2);

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
INSERT INTO Item ([Name], Quantity, [Description], Price, Justification, ItemLocation, [RowVersion], PoNumber, ItemStatusId)
VALUES
('Laptop Computers', 10, 'High-performance laptops for IT department', 1512.45, 'Upgrade outdated equipment', 'Main Office IT Room', 1, 3, 1),
('Office Chairs', 25, 'Ergonomic chairs for new employees', 258.00, 'Improve workplace comfort', 'Executive Conference Room', 1, 2, 1),
('Projectors', 3, 'Multimedia projectors for conference rooms', 799.00, 'Enhance presentation capabilities', 'Training Room', 1, 3, 2),
('Printers', 8, 'High-volume printers for office use', 504.99, 'Replace old printers', 'Print Room', 1, 4, 1),
('Headsets', 20, 'Noise-cancelling headsets for customer support', 158.85, 'Improve communication quality', 'Customer Service Desk', 1, 5, 1);
