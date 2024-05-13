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
	('Approved'),
	('Denied')
	
-- employee status
IF OBJECT_ID('TotalAdmin.dbo.EmployeeStatus', 'U') IS NULL
	CREATE TABLE EmployeeStatus(
		EmployeeStatusId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[Name] NVARCHAR(50) NOT NULL
	);
GO
-- Employee Statuses
INSERT INTO EmployeeStatus([Name]) 
VALUES
	('Active'), ('Retired'), ('Terminated')

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
	('Closed'),
	('All')
	

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
		[RowVersion] ROWVERSION NOT NULL
	);
GO

INSERT INTO Department
	([Name],
	[Description],
	InvocationDate)
VALUES
	('Marketing', 'Marketing department', '12/04/1999'),
	('HR', 'Human resources', '12/04/1999'),
	('Dev', 'Software Development', '12/04/1999')
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
		DateOfBirth DATETIME2(7) NOT NULL,
		CompanyStartDate DATETIME2(7) NOT NULL,
		JobStartDate DATETIME2(7) NOT NULL,
		OfficeLocation NVARCHAR(255) NOT NULL,
		WorkPhoneNumber NVARCHAR(12) NOT NULL,
		CellPhoneNumber NVARCHAR(12) NOT NULL,
		RetiredDate DATETIME2(7) NULL,
		TerminatedDate DATETIME2(7) NULL,
		StatusId INT NOT NULL,
		[RowVersion] ROWVERSION NOT NULL,
		SupervisorEmpNumber INT NULL,
		DepartmentId INT NULL,
		RoleId INT NOT NULL,
		CONSTRAINT FK_Status_Employee FOREIGN KEY (StatusId) REFERENCES EmployeeStatus(EmployeeStatusId),
		CONSTRAINT FK_Employee_Employee FOREIGN KEY (SupervisorEmpNumber) REFERENCES Employee(EmployeeNumber),
		CONSTRAINT FK_Department_Employee FOREIGN KEY (DepartmentId) REFERENCES Department(DepartmentId),
		CONSTRAINT FK_Role_Employee FOREIGN KEY (RoleId) REFERENCES [Role](RoleId)
	);
GO

insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Avril', null, 'Chesson', 'achesson0@yahoo.ca', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '6 Holy Cross Crossing', 'Halifax', 'G1I8Q3', '371414274', 'CEO', '8/8/1972', '9/11/1970', '5/21/2014', 'Room 1350', '991-636-4566', '997-673-1215', 1, NULL, 1, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Bealle', 'P', 'Tarquini', 'btarquini1@issuu.com', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '882 Kropf Avenue', 'Mississauga', 'H8T4T0', '228656303', 'Senior Sales Associate', '2/11/1988', '3/31/1987', '4/26/2005', 'Room 339', '211-233-0956', '181-328-1762', 1, 1, 2, 2);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Timmy', 'L', 'Byway', 'tbyway2@un.org', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '10511 School Center', 'Moncton', 'C6M1A8', '507706961', 'Research Nurse', '5/16/2008', '2/11/1987', '5/1/1999', 'Room 1650', '322-214-2163', '551-556-0402', 1, 1, 3, 3);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Evvy', null, 'Langman', 'elangman3@pinterest.com', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '4 Russell Center', 'Mississauga', 'I2T2C4', '528459139', 'Help Desk Technician', '2/11/1977', '9/18/1944', '1/21/2000', 'Suite 8', '977-147-9549', '976-556-7323', 1, 1, 1, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Philomena', 'O', 'Lathom', 'plathom4@edublogs.org', '06fef4bfe2f355eab0aeb5052331e634977e074e3384bbb24c6e9cb127627e47', '2048 Chive Junction', 'Montreal', 'A5F6Y9', '174027109', 'Programmer Analyst I', '2/12/1998', '4/14/1995', '2/7/1996', 'Room 1398', '167-423-8073', '914-684-7993', 1, 1, 2, 2);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Guendolen', 'X', 'Vint', 'gvint5@123-reg.co.uk', 'd50795cf6d02eb2591e501d43465353834ceeecf3ae0277ff186db59dfe9f696', '19739 Bonner Circle', 'Timmins', 'A9Z3A4', '769821925', 'Quality Control Specialist', '5/11/1983', '1/16/1978', '3/8/2023', '3rd Floor', '498-134-6280', '755-303-5339', 1, 1, 2, 2);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Monika', null, 'Penson', 'mpenson6@merriam-webster.com', 'ac7c8bdb479e47a423de8e8a4020473d04a9541caf30920bb75f9439ed5a9197', '338 Laurel Crossing', 'Moncton', 'V4K0R6', '669569877', 'Executive Secretary', '6/11/1998', '7/15/1994', '8/13/2013', 'Room 701', '717-810-0762', '278-709-9708', 2, 1, 2, 2);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Mindy', null, 'Silber', 'msilber7@unicef.org', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '613 Bobwhite Circle', 'Dieppe', 'W6S0G7', '319872454', 'Quality Engineer', '2/11/1988', '2/9/1977', '5/22/2023', 'Suite 38', '389-414-1238', '193-897-3335', 1, 1, 2, 3);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Devonna', 'Q', 'Capsey', 'dcapsey8@bravesites.com', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '7 Calypso Park', 'Montreal', 'G0P6E4', '256507651', 'Senior Quality Engineer', '2/4/1998', '3/22/1994', '7/3/1999', '4th Floor', '366-940-8819', '994-985-5947', 1, 2, 2, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Alessandra', null, 'Taplin', 'ataplin9@phoca.cz', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '6 Sauthoff Point', 'Montreal', 'J8N9Q0', '796727192', 'Cost Accountant', '8/11/1981', '12/4/1980', '2/15/2021', 'Suite 44', '948-818-5525', '827-514-8479', 1, 1, 1, 2);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Hyman', 'X', 'Jarritt', 'hjarrittd@slate.com', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '9 Northridge Trail', 'Vancouver', 'Z4N3E0', '116315063', 'Electrical Engineer', '4/8/1990', '8/28/1989', '12/12/1999', 'Room 356', '177-751-2511', '772-908-7701', 2, 4, 1, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Phaidra', null, 'Slane', 'pslanee@webeden.co.uk', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '3 2nd Alley', 'Vancouver', 'B8D4G4', '716556358', 'Professor', '10/25/2015', '8/12/2001', '4/16/1997', 'Suite 46', '377-810-3825', '641-543-6891', 1, 4, 1, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Kevina', 'S', 'Freemantle', 'kfreemantleg@bbc.co.uk', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '326 Esker Center', 'Riverview', 'C0L4E1', '014161125', 'Senior Developer', '2/11/1998', '6/17/1995', '10/19/2018', '2nd Floor', '979-571-1209', '944-201-7539', 1, 5, 1, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Cayla', 'C', 'Hinners', 'chinnersh@netvibes.com', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '26213 Hauk Street', 'Truro', 'K3L7Z3', '242099899', 'Media Manager IV', '8/9/1998', '3/24/2004', '6/30/2000', 'Room 1786', '138-387-3592', '281-370-1130', 1, 5, 2, 4);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Jaymie', null, 'Syder', 'jsyderi@artisteer.com', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '2446 Mccormick Hill', 'Belleville', 'W9K4O1', '774849266', 'Staff Scientist', '2/11/1978', '11/28/1777', '9/11/2010', 'Room 1788', '319-989-3501', '598-608-5409', 1, 1, 1, 3);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Daniel', null, 'Richel', 'drichelj@cmu.edu', '6afe1e909d91a6b30327d3bcf91c492783b37f015d471ce390817edc1b5e6854', '3744 Sauthoff Drive', 'Moncton', 'R9O1I9', '245818537', 'Occupational Therapist', '5/11/2001', '1/5/2000', '11/10/2000', '13th Floor', '350-109-7119', '997-917-7166', 1, 1, 2, 2);
-- timmy byway emp #3 supervisor with role #3 is in department #3, add 10 employees under supervision 
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Marissa', 'S', 'Guillerman', 'mguillermana@sogou.com', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '2892 Longview Road', 'Montreal', 'I4S4H9', '254858742', 'Developer III', '10/11/1988', '10/3/1984', '5/28/2002', 'Room 807', '162-850-9963', '506-873-3717', 1, 3, 3, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Bili', 'U', 'Mac', 'bmacb@eepurl.com', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '3978 Warrior Street', 'Toronto', 'M6L2S8', '444038125', 'Computer Systems Analyst II', '11/11/2001', '7/28/2000', '8/18/2000', '7th Floor', '902-316-8912', '506-905-2090', 1, 3, 3, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Tobi', 'T', 'Tuffrey', 'ttuffreyc@opensource.org', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '9 Dunning Junction', 'Vancouver', 'P2E2X5', '161275684', 'Environmental Tech', '11/11/1978', '4/14/1976', '11/8/1999', 'Suite 2', '591-147-0033', '506-927-1357', 1, 3, 3, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Cash', null, 'Grishanin', 'cgrishaninf@squidoo.com', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '4 Talmadge Junction', 'Whistler', 'C0O4S7', '361402559', 'Assistant Professor', '2/11/1999', '9/13/1995', '3/23/2013', 'Room 1189', '431-218-1922', '506-214-3876', 1, 3, 3, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Emily', 'L', 'Sanchez', 'mguillermana@sogou.com', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '292 Main Road', 'Markham', 'E4C4H9', '255158742', 'Developer I', '1/11/1990', '10/3/1988', '5/28/2002', 'Room 800', '506-850-9923', '902-873-3717', 1, 3, 3, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Billy', 'U', 'Mac', 'billyb@eepurl.com', '785e68a22eb81d9e942cbc7f2dc2f86d6ca7d5f3d1222413f9e74e78b6b68a74', '178 Moon Street', 'Hamilton', 'E6L2S8', '144038125', 'Quality Assurance', '6/11/1992', '7/28/1990', '8/18/2000', '7th Floor', '467-916-8912', '902-905-2090', 1, 3, 3, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Harris', 'T', 'Tuff', 'ttuf@gmail.org', '92de0b754aa96503ea8639312a4a788ee48fc3cdb1481caefa5b1b457ce95672', '92 Dunn Crossing', 'Milton', 'X2E2X5', '160275684', 'Security', '11/11/1983', '4/14/2021', '11/8/1999', '6th Floor', '467-117-0033', '902-927-1357', 1, 3, 3, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Cameron', null, 'Gomez', 'cgrishaninf@squidoo.com', '91520ad7cb52dd96e4901f0a2193c3a165cd85b9bef1cfe3163f754bc6cdcc21', '40 Bruce Street', 'Truro', 'K0O4S7', '961402559', 'Junior Dev', '7/11/1991', '9/13/1990', '3/23/2013', 'Room 119', '506-218-1922', '902-214-3876', 1, 3, 3, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Mary', null, 'Guillerman', 'mguillermana@sogou.com', '2bb80d537b1da3e38bd30361aa855686bde0eacd7162fef6a25fe97bf527a25b', '100 Longhorn Road', 'Montreal', 'X4S4H9', '954848742', 'Developer', '8/11/1994', '10/3/1992', '5/28/2002', 'Room 8047', '902-850-9923', '416-873-3717', 1, 3, 3, 3);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('William', null, 'Macmanaman', 'bmacb@eepurl.com', '785e68a22eb81d9e942cbc7f2dc2f86d6ca7d5f3d1222413f9e74e78b6b68a74', '38 Westminster Street', 'Moncton', 'E6E2S8', '924038125', 'Analyst', '11/11/2000', '7/28/1999', '8/18/2000', '7th Floor', '416-916-8912', '416-985-2090', 1, 3, 3, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Steve', null, 'Macmanaman', 'steveb@eepurl.com', '785e68a22eb81d9e942cbc7f2dc2f86d6ca7d5f3d1222413f9e74e78b6b68a74', '38 Westminster Street', 'Moncton', 'E6E2S8', '024502932', 'DevOps', '9/11/1998', '7/28/1997', '10/18/2002', '7th Floor', '416-900-8932', '416-985-2140', 1, 3, 3, 5);

GO

-- purchase order
IF OBJECT_ID('TotalAdmin.dbo.PurchaseOrder', 'U') IS NULL
	CREATE TABLE PurchaseOrder(
		PoNumber INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
		CreationDate DATETIME2(7) NOT NULL,
		PurchaseOrderStatusId INT NOT NULL,
		EmployeeNumber INT NOT NULL,
		[RowVersion] ROWVERSION NOT NULL
		CONSTRAINT FK_PurchaseOrderStatus_PurchaseOrder FOREIGN KEY (PurchaseOrderStatusId) REFERENCES PurchaseOrderStatus(PoStatusId),
		CONSTRAINT FK_Employee_PurchaseOrder FOREIGN KEY (EmployeeNumber) REFERENCES Employee(EmployeeNumber)
	);
GO
INSERT INTO PurchaseOrder (CreationDate, PurchaseOrderStatusId, EmployeeNumber)
VALUES
('2024-04-01', 1, 5),
('2024-03-15', 1, 5),
('2024-02-28', 1, 3),
('2024-05-2', 1, 3),
('2024-04-10', 1, 9),
('2024-03-20', 1, 2),
('2024-04-20', 1, 17),
('2024-05-10', 1, 9),
('2024-05-13', 1, 9),
('2024-01-13', 1, 18),
('2023-08-03', 1, 11),
('2023-12-07', 1, 11),
('2023-05-11', 2, 11);

GO
-- item
IF OBJECT_ID('TotalAdmin.dbo.Item', 'U') IS NULL
	CREATE TABLE Item(
		ItemId INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
		[Name] VARCHAR(45) NOT NULL,
		Quantity INT NOT NULL,
		[Description] NTEXT NOT NULL,
		Price MONEY NOT NULL,
		Justification NVARCHAR(255) NOT NULL,
		ItemLocation NVARCHAR(255) NOT NULL,
		RejectedReason NVARCHAR(100) NULL,
		PoNumber INT NOT NULL,
		ItemStatusId INT NOT NULL,
		[RowVersion] ROWVERSION NOT NULL
		CONSTRAINT FK_PurchaseOrder_Item FOREIGN KEY (PoNumber) REFERENCES PurchaseOrder(PoNumber),
		CONSTRAINT FK_Item_Status FOREIGN KEY (ItemStatusId) REFERENCES ItemStatus(ItemStatusId)
	);
GO
INSERT INTO Item ([Name], Quantity, [Description], Price, Justification, ItemLocation, RejectedReason, PoNumber, ItemStatusId)
VALUES
('Laptop Computers', 10, 'High-performance laptops for IT department', 1512.45, 'Upgrade outdated equipment', 'Main Office IT Room', NULL, 3, 1),
('Office Chairs', 25, 'Ergonomic chairs for new employees', 258.00, 'Improve workplace comfort', 'Executive Conference Room', NULL, 2, 1),
('Whiteboard/flipchart', 3, 'Facilitate brainstorming sessions and presentations', 58.08, 'Support collaborative work and visual communication in HR department', 'Warehouse - Office Supplies Section', NULL, 4, 1),
('Projectors', 3, 'Multimedia projectors for conference rooms', 799.00, 'Enhance presentation capabilities', 'Training Room', NULL, 3, 1),
('Printers', 8, 'High-volume printers for office use', 504.99, 'Replace old printers', 'Print Room', NULL, 4, 1),
('Headsets', 20, 'Noise-cancelling headsets for customer support', 158.85, 'Improve communication quality', 'Customer Service Desk', NULL, 5, 1),
('External Hard Drives', 15, '4TB portable hard drives for data backup', 89.99, 'Improve data security and storage', 'Data Center', NULL, 6, 1),
('Webcams', 30, 'HD webcams for video conferencing', 65.89, 'Enable remote collaboration', 'Warehouse', NULL, 7, 1),
('Monitors', 12, '27-inch LED monitors for workstations', 199.99, 'Replace outdated monitors', 'Warehouse - IT Equipment', NULL, 7, 1),
('Sony WH-1000XM4', 30, 'Sony WH-1000XM4: Industry-leading noise-canceling headphones with exceptional sound quality and long battery life', 349.99, 'Upgrade employee productivity and comfort with top-of-the-line noise-canceling headphones', 'Walmart Distribution Center', NULL, 7, 1),
('Smartphones', 20, 'Latest model smartphones for executives', 899.00, 'Upgrade to new devices', 'Warehouse - Mobile Devices', NULL, 8, 1),
('Tablets', 8, 'High-end tablets for sales team', 599.00, 'Enhance mobility and productivity', 'Sales Department', NULL, 8, 1),
('Document Scanners', 3, 'High-speed duplex document scanners for digitizing employee records', 799.99, 'Transition to paperless employee file management', 'HR File Room', NULL, 8, 1),
('Payroll Software', 1, 'Integrated payroll and HR management software', 14999.99, 'Streamline payroll processes and ensure compliance', 'HR Department', NULL, 9, 1),
('Virtual Machines', 1, 'Annual subscription for virtual machine hosting and management', 6999.99, 'Enable isolated dev environments and rapid provisioning', 'Online Service', NULL, 7, 1),
('Programmable Keyboards', 15, 'Customizable mechanical keyboards for developers', 149.99, 'Enhance coding experience and productivity', 'Development Lab', NULL, 10, 1),
('Virtual Event Platform', 1, 'Subscription for hosting virtual events, webinars, and live streams', 4999.00, 'Facilitate online marketing events and customer engagement', 'Online Service', NULL, 13, 1),
('Graphic Design Software', 10, 'Professional-grade graphic design suite for creating marketing materials', 899.99, 'Enable in-house design capabilities and reduce outsourcing costs', 'Marketing Department', NULL, 11, 1),
('Social Media Management Tool', 1, 'All-in-one platform for managing social media campaigns and analytics', 3999.00, 'Streamline social media marketing efforts and track performance', 'Online Service', NULL, 12, 1),
('High-end Laptops', 5, 'Powerful laptops with dedicated GPUs for graphic design and video editing', 2499.99, 'Enable efficient creation and rendering of multimedia content', 'Marketing Department', NULL, 11, 1);