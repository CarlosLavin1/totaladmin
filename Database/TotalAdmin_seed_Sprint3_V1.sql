USE [master]
GO

DROP DATABASE IF EXISTS TotalAdmin
CREATE DATABASE TotalAdmin
GO
USE TotalAdmin
GO

-- review status
IF OBJECT_ID('TotalAdmin.dbo.ReviewRating', 'U') IS NULL
	CREATE TABLE ReviewRating(
		ReviewRatingId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[Name] NVARCHAR(50) NOT NULL
	);
GO
-- insert review statuses
INSERT INTO ReviewRating([Name]) 
VALUES
	('Below Expectations'),
	('Meets Expectations'),
	('Exceeds Expectations')
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
	('Dev', 'Software Development', '12/04/1999'),
	('Sales', 'Sales department', '12/04/1999'),
    ('Finance', 'Finance department', '12/04/1999'),
    ('Customer Support', 'Customer support services', '12/04/1999'),
    ('IT', 'Information Technology', '12/04/1999'),
	('Operations', 'Operations department', '12/04/1999'),
    ('R&D', 'Research and Development', '12/04/1999'),
    ('Procurement', 'Procurement department', '12/04/1999'),
    ('Logistics', 'Logistics department', '12/04/1999'),
    ('Legal', 'Legal department', '12/04/1999'),
    ('Public Relations', 'Public Relations department', '12/04/2025'),
    ('Quality Assurance', 'Quality Assurance department', '12/04/1999'),
    ('Strategy', 'Strategy department', '12/04/2025'),
    ('Administration', 'Administration department', '12/04/1999'),
    ('Training', 'Training and Development', '12/04/1999'),
    ('Compliance', 'Compliance department', '12/04/1999'),
    ('Facilities', 'Facilities Management', '12/04/1999'),
    ('Security', 'Security department', '12/04/1999'),
	('AI', 'Artificial Intelligence', '12/04/2025')
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

insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Avril', null, 'Chesson', 'achesson0@yahoo.ca', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '6 Holy Cross Crossing', 'Halifax', 'G1I8Q3', '371414274', 'CEO', '8/8/1950', '9/11/1972', '5/21/2014', 'Room 1350', '991-636-4566', '997-673-1215', 1, NULL, 1, 1);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Bealle', 'P', 'Tarquini', 'btarquini1@issuu.com', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '882 Kropf Avenue', 'Mississauga', 'H8T4T0', '228656303', 'Senior Sales Associate', '2/11/1988', '3/31/1971', '4/26/2005', 'Room 339', '211-233-0956', '181-328-1762', 1, 1, 2, 2);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Timmy', 'L', 'Byway', 'tbyway2@un.org', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '10511 School Center', 'Moncton', 'C6M1A8', '507706961', 'Research Nurse', '5/16/2008', '2/11/1987', '5/1/2009', 'Room 1650', '322-214-2163', '551-556-0402', 1, 1, 3, 3);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Evvy', null, 'Langman', 'elangman3@pinterest.com', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '4 Russell Center', 'Mississauga', 'I2T2C4', '528459139', 'Help Desk Technician', '2/11/1977', '9/18/1944', '1/21/2000', 'Suite 8', '977-147-9549', '976-556-7323', 1, 1, 1, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Philomena', 'O', 'Lathom', 'plathom4@edublogs.org', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '2048 Chive Junction', 'Montreal', 'A5F6Y9', '174027109', 'Programmer Analyst I', '2/12/1998', '4/14/1980', '2/7/2000', 'Room 1398', '167-423-8073', '914-684-7993', 1, 1, 2, 2);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Guendolen', 'X', 'Vint', 'gvint5@123-reg.co.uk', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '19739 Bonner Circle', 'Timmins', 'A9Z3A4', '769821925', 'Quality Control Specialist', '5/11/1999', '1/16/1970', '3/8/2023', '3rd Floor', '498-134-6280', '755-303-5339', 1, 1, 2, 2);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Monika', null, 'Penson', 'mpenson6@merriam-webster.com', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '338 Laurel Crossing', 'Moncton', 'V4K0R6', '669569877', 'Executive Secretary', '6/11/2005', '7/15/1980', '8/13/2013', 'Room 701', '717-810-0762', '278-709-9708', 2, 1, 2, 2);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Mindy', null, 'Silber', 'msilber7@unicef.org', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '613 Bobwhite Circle', 'Dieppe', 'W6S0G7', '319872454', 'Quality Engineer', '2/11/2010', '2/9/1977', '5/22/2023', 'Suite 38', '389-414-1238', '193-897-3335', 1, 1, 2, 3);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Devonna', 'Q', 'Capsey', 'dcapsey8@bravesites.com', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '7 Calypso Park', 'Montreal', 'G0P6E4', '256507651', 'Senior Quality Engineer', '2/4/1998', '3/22/1974', '7/3/1999', '4th Floor', '366-940-8819', '994-985-5947', 1, 2, 2, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Alessandra', null, 'Taplin', 'ataplin9@phoca.cz', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '6 Sauthoff Point', 'Montreal', 'J8N9Q0', '796727192', 'Cost Accountant', '8/11/2001', '12/4/1980', '2/15/2021', 'Suite 44', '948-818-5525', '827-514-8479', 1, 1, 1, 2);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Hyman', 'X', 'Jarritt', 'hjarrittd@slate.com', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '9 Northridge Trail', 'Vancouver', 'Z4N3E0', '116315063', 'Electrical Engineer', '4/8/1990', '8/28/1971', '12/12/1999', 'Room 356', '177-751-2511', '772-908-7701', 2, 4, 1, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Phaidra', null, 'Slane', 'pslanee@webeden.co.uk', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '3 2nd Alley', 'Vancouver', 'B8D4G4', '716556358', 'Professor', '10/25/2015', '8/12/1992', '4/16/2017', 'Suite 46', '377-810-3825', '641-543-6891', 1, 4, 1, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Kevina', 'S', 'Freemantle', 'kfreemantleg@bbc.co.uk', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '326 Esker Center', 'Riverview', 'C0L4E1', '014161125', 'Senior Developer', '2/11/1998', '6/17/1976', '10/19/2018', '2nd Floor', '979-571-1209', '944-201-7539', 1, 5, 1, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Cayla', 'C', 'Hinners', 'chinnersh@netvibes.com', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '26213 Hauk Street', 'Truro', 'K3L7Z3', '242099899', 'Media Manager IV', '8/9/1998', '3/24/1970', '6/30/2000', 'Room 1786', '138-387-3592', '281-370-1130', 1, 5, 2, 4);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Jaymie', null, 'Syder', 'jsyderi@artisteer.com', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '2446 Mccormick Hill', 'Belleville', 'W9K4O1', '774849266', 'Staff Scientist', '2/11/2004', '11/28/1977', '9/11/2010', 'Room 1788', '319-989-3501', '598-608-5409', 1, 1, 1, 3);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Daniel', null, 'Richel', 'drichelj@cmu.edu', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '3744 Sauthoff Drive', 'Moncton', 'R9O1I9', '245818537', 'Occupational Therapist', '5/11/2001', '1/5/1981', '11/10/2003', '13th Floor', '350-109-7119', '997-917-7166', 1, 1, 2, 2);
-- timmy byway emp #3 supervisor with role #3 is in department #3, add 10 employees under supervision 
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Marissa', 'S', 'Guillerman', 'mguillermana@sogou.com', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '2892 Longview Road', 'Montreal', 'I4S4H9', '254858742', 'Developer III', '10/11/1988', '10/3/1970', '5/28/2002', 'Room 807', '162-850-9963', '506-873-3717', 1, 3, 3, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Bili', 'U', 'Mac', 'bmacb@eepurl.com', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '3978 Warrior Street', 'Toronto', 'M6L2S8', '444038125', 'Computer Systems Analyst II', '11/11/2001', '7/28/1980', '8/18/2000', '7th Floor', '902-316-8912', '506-905-2090', 1, 3, 3, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Tobi', 'T', 'Tuffrey', 'ttuffreyc@opensource.org', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '9 Dunning Junction', 'Vancouver', 'P2E2X5', '161275684', 'Environmental Tech', '11/11/1998', '4/14/1976', '11/8/1999', 'Suite 2', '591-147-0033', '506-927-1357', 1, 3, 3, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Cash', null, 'Grishanin', 'cgrishaninf@squidoo.com', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '4 Talmadge Junction', 'Whistler', 'C0O4S7', '361402559', 'Assistant Professor', '2/11/1999', '9/13/1972', '3/23/2013', 'Room 1189', '431-218-1922', '506-214-3876', 1, 3, 3, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Emily', 'L', 'Sanchez', 'mguillermana@sogou.com', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '292 Main Road', 'Markham', 'E4C4H9', '255158742', 'Developer I', '1/11/1990', '10/3/1970', '5/28/2002', 'Room 800', '506-850-9923', '902-873-3717', 1, 3, 3, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Billy', 'U', 'Mac', 'billyb@eepurl.com', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '178 Moon Street', 'Hamilton', 'E6L2S8', '144038125', 'Quality Assurance', '6/11/1992', '7/28/1971', '8/18/2000', '7th Floor', '467-916-8912', '902-905-2090', 1, 3, 3, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Harris', 'T', 'Tuff', 'ttuf@gmail.org', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '92 Dunn Crossing', 'Milton', 'X2E2X5', '160275684', 'Security', '11/11/1983', '4/14/1963', '11/8/1999', '6th Floor', '467-117-0033', '902-927-1357', 1, 3, 3, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Cameron', null, 'Gomez', 'cgrishaninf@squidoo.com', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '40 Bruce Street', 'Truro', 'K0O4S7', '961402559', 'Junior Dev', '7/11/1991', '9/13/1968', '3/23/2013', 'Room 119', '506-218-1922', '902-214-3876', 1, 3, 3, 5);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Mary', null, 'Guillerman', 'mguillermana@sogou.com', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '100 Longhorn Road', 'Montreal', 'X4S4H9', '954848742', 'Developer', '8/11/1994', '10/3/1972', '5/28/2002', 'Room 8047', '902-850-9923', '416-873-3717', 1, 3, 3, 3);
insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('William', null, 'Macmanaman', 'bmacb@eepurl.com', '0ccb43e14f0161749041a76c48c270c9416edc00dbd706bbcba80b04059d59ed', '38 Westminster Street', 'Moncton', 'E6E2S8', '924038125', 'Analyst', '11/11/2000', '7/28/1980', '8/18/2000', '7th Floor', '416-916-8912', '416-985-2090', 1, 3, 3, 5);
-- insert into Employee (FirstName, MiddleInitial, LastName, EmailAddress, HashedPassword, StreetAddress, City, PostalCode, [SIN], JobTitle, CompanyStartDate, DateOfBirth, JobStartDate, OfficeLocation, WorkPhoneNumber, CellPhoneNumber, StatusId, SupervisorEmpNumber, DepartmentId, RoleId) values ('Steve', null, 'Macmanaman', 'steveb@eepurl.com', '785e68a22eb81d9e942cbc7f2dc2f86d6ca7d5f3d1222413f9e74e78b6b68a74', '38 Westminster Street', 'Moncton', 'E6E2S8', '024502932', 'DevOps', '9/11/1998', '7/28/1997', '10/18/2002', '7th Floor', '416-900-8932', '416-985-2140', 1, 3, 3, 5);

GO

-- employee review 
IF OBJECT_ID('TotalAdmin.dbo.Review', 'U') IS NULL
	CREATE TABLE Review(
		ReviewId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		ReviewRatingId INT NOT NULL,
		Comment NVARCHAR(MAX) NOT NULL,
		ReviewDate DATETIME2(7) NOT NULL,
		IsRead BIT NOT NULL,
		EmployeeNumber INT NOT NULL,	
		SupervisorEmployeeNumber INT NOT NULL,
		CONSTRAINT FK_Rating_Review FOREIGN KEY (ReviewRatingId) REFERENCES ReviewRating(ReviewRatingId),
		CONSTRAINT FK_Employee_Review FOREIGN KEY (EmployeeNumber) REFERENCES Employee(EmployeeNumber),
		CONSTRAINT FK_Supervisor_Review FOREIGN KEY (SupervisorEmployeeNumber) REFERENCES Employee(EmployeeNumber)
	);
GO

-- review reminder table
IF OBJECT_ID('TotalAdmin.dbo.ReviewReminder', 'U') IS NULL
CREATE TABLE ReviewReminder (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    DaySent DATETIME2(7) NOT NULL
);

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
('2024-01-13', 3, 18),
('2023-08-03', 1, 11),
('2023-12-07', 1, 11),
('2023-05-11', 2, 11),
('2024-03-05', 2, 17),
('2023-01-20', 3, 12),
('2023-02-12', 3, 12),
('2023-05-29', 2, 12),
('2023-03-01', 3, 12);

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
		ModifiedReason NVARCHAR(100) NULL,
		PoNumber INT NOT NULL,
		ItemStatusId INT NOT NULL,
		[RowVersion] ROWVERSION NOT NULL
		CONSTRAINT FK_PurchaseOrder_Item FOREIGN KEY (PoNumber) REFERENCES PurchaseOrder(PoNumber),
		CONSTRAINT FK_Item_Status FOREIGN KEY (ItemStatusId) REFERENCES ItemStatus(ItemStatusId)
	);
GO
INSERT INTO Item ([Name], Quantity, [Description], Price, Justification, ItemLocation, RejectedReason, ModifiedReason, PoNumber, ItemStatusId)
VALUES
('Laptop Computers', 10, 'High-performance laptops for IT department', 1512.45, 'Upgrade outdated equipment', 'Main Office IT Room', NULL, NULL, 3, 1),
('Office Chairs', 25, 'Ergonomic chairs for new employees', 258.00, 'Improve workplace comfort', 'Executive Conference Room', NULL, NULL, 2, 1),
('Whiteboard/flipchart', 3, 'Facilitate brainstorming sessions and presentations', 58.08, 'Support collaborative work and visual communication in HR department', 'Warehouse - Office Supplies Section', NULL, NULL, 4, 1),
('Projectors', 3, 'Multimedia projectors for conference rooms', 799.00, 'Enhance presentation capabilities', 'Training Room', NULL, NULL, 3, 1),
('Printers', 8, 'High-volume printers for office use', 504.99, 'Replace old printers', 'Print Room', NULL, NULL, 4, 1),
('Headsets', 20, 'Noise-cancelling headsets for customer support', 158.85, 'Improve communication quality', 'Customer Service Desk', NULL, NULL, 5, 1),
('External Hard Drives', 15, '4TB portable hard drives for data backup', 89.99, 'Improve data security and storage', 'Data Center', NULL, NULL, 6, 1),
('Webcams', 30, 'HD webcams for video conferencing', 65.89, 'Enable remote collaboration', 'Warehouse', NULL, NULL, 7, 1),
('Monitors', 12, '27-inch LED monitors for workstations', 199.99, 'Replace outdated monitors', 'Warehouse - IT Equipment', NULL, NULL, 7, 1),
('Sony WH-1000XM4', 30, 'Sony WH-1000XM4: Industry-leading noise-canceling headphones with exceptional sound quality and long battery life', 349.99, 'Upgrade employee productivity and comfort with top-of-the-line noise-canceling headphones', 'Walmart Distribution Center', NULL, NULL, 7, 1),
('Smartphones', 20, 'Latest model smartphones for executives', 899.00, 'Upgrade to new devices', 'Warehouse - Mobile Devices', NULL, NULL, 8, 1),
('Tablets', 8, 'High-end tablets for sales team', 599.00, 'Enhance mobility and productivity', 'Sales Department', NULL, NULL, 8, 1),
('Document Scanners', 3, 'High-speed duplex document scanners for digitizing employee records', 799.99, 'Transition to paperless employee file management', 'HR File Room', NULL, NULL, 8, 1),
('Payroll Software', 1, 'Integrated payroll and HR management software', 14999.99, 'Streamline payroll processes and ensure compliance', 'HR Department', NULL, NULL, 9, 1),
('Virtual Machines', 1, 'Annual subscription for virtual machine hosting and management', 6999.99, 'Enable isolated dev environments and rapid provisioning', 'Online Service', NULL, NULL, 7, 1),
('Programmable Keyboards', 15, 'Customizable mechanical keyboards for developers', 149.99, 'Enhance coding experience and productivity', 'Development Lab', NULL, NULL, 10, 2),
('Virtual Event Platform', 1, 'Subscription for hosting virtual events, webinars, and live streams', 4999.00, 'Facilitate online marketing events and customer engagement', 'Online Service', NULL, NULL, 13, 2),
('API Access Subscription', 1, 'Annual subscription to a third-party API service', 1999.99, 'Integrate and utilize third-party services in development', 'Development Department', NULL, NULL, 13, 1),
('Graphic Design Software', 10, 'Professional-grade graphic design suite for creating marketing materials', 899.99, 'Enable in-house design capabilities and reduce outsourcing costs', 'Marketing Department', NULL, NULL, 11, 1),
('Social Media Management Tool', 1, 'All-in-one platform for managing social media campaigns and analytics', 3999.00, 'Streamline social media marketing efforts and track performance', 'Online Service', NULL, NULL, 12, 1),
('SSD Upgrades', 30, '1TB SSDs for faster storage and better performance', 199.99, 'Upgrade storage for improved speed and efficiency', 'Development Department', NULL, NULL, 14, 1),
('Training Programs', 5, 'Online training programs for new technologies and tools', 999.99, 'Enhance skills and knowledge of development team', 'Development Department', 'Not needed at this momment', NULL, 14, 3),
('Graphic Design Tablets', 5, 'Pen tablets for graphic design and illustration', 599.99, 'Improve precision and efficiency in graphic design tasks', 'Marketing Department', NULL, NULL, 15, 2),
('Lighting Kits', 4, 'Professional lighting kits for video shoots and photography', 399.99, 'Ensure high-quality lighting for marketing content', 'Marketing Department', NULL, NULL, 15, 2),
('Email Marketing Software', 1, 'Subscription to an email marketing automation platform', 799.99, 'Automate and optimize email marketing campaigns', 'Marketing Department', 'Was not approved by the CEO', NULL, 16, 3),
('SEO Tools', 1, 'Annual subscription to an SEO optimization platform', 899.99, 'Improve website visibility and search engine rankings', 'Marketing Department', NULL, NULL, 17, 2),
('Lighting Kits', 4, 'Professional lighting kits for video shoots and photography', 399.99, 'Ensure high-quality lighting for marketing content', 'Marketing Department', NULL, NULL, 18, 2),
('High-end Laptops', 5, 'Powerful laptops with dedicated GPUs for graphic design and video editing', 2499.99, 'Enable efficient creation and rendering of multimedia content', 'Marketing Department', NULL, NULL, 11, 1);
GO

-- insert reviews
-- employee 1
BEGIN
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1972-08-08', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1972-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1973-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1973-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1973-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1973-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1974-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1974-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1974-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1974-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1975-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1975-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1975-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1975-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1976-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1976-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1976-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1976-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1977-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1977-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1977-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1977-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1978-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1978-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1978-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1978-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1979-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1979-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1979-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1979-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1980-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1980-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1980-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1980-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1981-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1981-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1981-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1981-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1982-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1982-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1982-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1982-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1983-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1983-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1983-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1983-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1984-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1984-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1984-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1984-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1985-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1985-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1985-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1985-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1986-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1986-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1986-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1986-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1987-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1987-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1987-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1987-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1988-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1988-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1988-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1988-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1989-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1989-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1989-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1989-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1990-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1990-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1990-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1990-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1991-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1991-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1991-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1991-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1992-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1992-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1992-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1992-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1993-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1993-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1993-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1993-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1995-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1995-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1995-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1995-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1996-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1996-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1996-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1996-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1997-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1997-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1997-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1997-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1998-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1998-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1998-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1998-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1999-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1999-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2000-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2000-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2002-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2003-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2004-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2005-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2005-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2006-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2006-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2008-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2011-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2017-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2022-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2022-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2022-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-04-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-07-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-10-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2024-01-01', 0, 1, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2024-04-01', 0, 1, 1);
END
GO
-- employee 2
BEGIN
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1988-02-11', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1988-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1988-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1988-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1989-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1989-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1989-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1989-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1990-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1990-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1990-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1990-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1991-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1991-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1991-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1991-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1992-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1992-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1992-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1992-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1993-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1993-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1993-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1993-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1994-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1994-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1995-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1995-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1995-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1995-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1996-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1996-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1996-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1996-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1997-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1997-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1997-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1997-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1998-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1999-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2000-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2000-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2001-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2001-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2002-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2002-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2002-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2003-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2005-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2005-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2005-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2006-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2006-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2008-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2016-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2016-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2016-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2017-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2022-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-04-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-07-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-10-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2024-01-01', 0, 2, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2024-04-01', 0, 2, 1);
END
GO
-- employee 3
BEGIN
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-05-16', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-07-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2008-10-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-01-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-04-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-07-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-10-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-01-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-04-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-07-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-10-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2011-01-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-04-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2011-07-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2011-10-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-01-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-04-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-07-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-10-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-01-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-04-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-07-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-10-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-01-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-04-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-07-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-10-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-01-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-04-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-07-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-10-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-01-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-04-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-07-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-10-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-01-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-04-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2017-07-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-10-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-01-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-04-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-07-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-10-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-01-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-04-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-07-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-10-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-01-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-04-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-07-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-10-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-01-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-04-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-07-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-10-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-01-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-04-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-07-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-10-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-01-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-04-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-07-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-10-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2024-01-01', 0, 3, 1);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2024-04-01', 0, 3, 1);
END
GO

-- employee 9
BEGIN
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-02-04', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1998-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1998-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1999-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2000-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2002-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2002-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2003-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2003-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2003-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2005-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2005-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2005-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2005-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2006-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2008-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2008-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2011-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2011-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2016-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2017-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2017-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2022-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2022-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-04-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-07-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-10-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2024-01-01', 0, 9, 2);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2024-04-01', 0, 9, 2);
END
GO

-- employee 11
BEGIN
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1990-04-08', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1990-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1990-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1991-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1991-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1991-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1991-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1992-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1992-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1992-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1992-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1993-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1993-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1993-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1993-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1994-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1994-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1995-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1995-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1995-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1995-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1996-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1996-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1996-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1996-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1997-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1997-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1997-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1997-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1998-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1998-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1998-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1999-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1999-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2000-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2000-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2000-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2001-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2002-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2003-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2003-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2005-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2005-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2006-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2007-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2008-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2008-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2017-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2022-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-04-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-07-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-10-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2024-01-01', 0, 11, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2024-04-01', 0, 11, 4);
END
GO

-- employee 12
BEGIN
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-10-25', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2016-01-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-04-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-07-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-10-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2017-01-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-04-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-07-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-10-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-01-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-04-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-07-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-10-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-01-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-04-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-07-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-10-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-01-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-04-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-07-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-10-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-01-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-04-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-07-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-10-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-01-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-04-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-07-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2022-10-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-01-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-04-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-07-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-10-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2024-01-01', 0, 12, 4);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2024-04-01', 0, 12, 4);
END
GO

-- employee 13
BEGin
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1998-02-11', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1998-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1998-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1999-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1999-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2000-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2000-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2000-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2001-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2001-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2001-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2002-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2003-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2003-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2004-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2005-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2008-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2008-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2011-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2016-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2016-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2016-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2022-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-04-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-07-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-10-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2024-01-01', 0, 13, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2024-04-01', 0, 13, 5);
END
GO

-- employee 14
BEGin
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-08-09', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1999-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1999-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2000-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2000-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2000-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2000-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2001-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2002-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2002-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2003-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2005-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2005-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2005-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2006-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2007-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2007-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2017-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2022-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-04-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-07-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-10-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2024-01-01', 0, 14, 5);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2024-04-01', 0, 14, 5);
END
GO

-- employee 17
BEGIN
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1988-10-11', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1989-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1989-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1989-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1989-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1990-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1990-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1990-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1990-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1991-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1991-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1991-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1991-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1992-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1992-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1992-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1992-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1993-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1993-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1993-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1993-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1994-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1994-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1994-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1995-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1995-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1995-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1995-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1996-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1996-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1996-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1996-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1997-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1997-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1997-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1997-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1998-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1998-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1998-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1998-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2000-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2000-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2000-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2001-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2001-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2002-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2003-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2005-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2006-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2007-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2008-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2016-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2017-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-10-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-01-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-04-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-07-01', 0, 17, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-10-01', 0, 17, 3);
-- INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2024-01-01', 0, 17, 3);
-- INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2024-04-01', 0, 17, 3);
END
GO


-- employee 18
BEGIN
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-11-11', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2003-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2003-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2005-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2005-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2011-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2016-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2017-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2017-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-01-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-04-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-07-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-10-01', 0, 18, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2024-01-01', 0, 18, 3);
-- INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2024-04-01', 0, 18, 3);
END
GO

-- employee 19
BEGIN
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1978-11-11', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1979-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1979-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1979-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1979-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1980-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1980-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1980-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1980-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1981-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1981-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1981-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1981-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1982-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1982-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1982-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1982-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1983-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1983-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1983-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1983-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1984-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1984-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1984-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1984-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1985-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1985-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1985-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1985-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1986-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1986-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1986-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1986-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1987-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1987-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1987-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1987-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1988-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1988-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1988-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1988-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1989-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1989-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1989-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1989-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1990-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1990-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1990-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1990-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1991-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1991-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1991-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1991-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1992-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1992-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1992-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1992-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1993-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1993-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1993-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1993-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1994-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1995-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1995-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1995-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1995-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1996-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1996-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1996-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1996-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1997-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1997-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1997-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1997-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1998-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1999-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2000-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2000-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2001-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2005-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2006-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2007-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2007-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2007-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2011-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2011-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2016-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2016-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-10-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-01-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-04-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-07-01', 0, 19, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-10-01', 0, 19, 3);
-- INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2024-01-01', 0, 19, 3);
-- INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2024-04-01', 0, 19, 3);
END
GO

-- employee 20
BEGIN
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-02-11', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2000-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2000-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2001-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2002-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2004-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2004-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2005-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2006-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2006-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2007-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2007-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2008-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2008-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2017-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2022-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-04-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-07-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-10-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2024-01-01', 0, 20, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2024-04-01', 0, 20, 3);
END
GO

-- employee 21
BEGIN
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1990-01-11', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1990-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1990-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1990-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1991-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1991-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1991-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1991-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1992-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1992-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1992-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1992-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1993-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1993-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1993-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1993-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1994-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1994-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1994-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1995-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1995-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1995-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1995-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1996-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1996-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1996-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1996-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1997-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1997-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1997-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1997-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1998-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1998-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2000-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2001-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2002-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2004-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2004-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2005-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2005-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2006-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2007-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2007-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2007-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2008-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2008-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2016-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-01-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-04-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-07-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-10-01', 0, 21, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2024-01-01', 0, 21, 3);
END
GO

-- employee 22
BEGIN
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1992-06-11', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1992-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1992-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1993-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1993-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1993-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1993-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1994-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1994-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1995-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1995-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1995-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1995-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1996-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1996-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1996-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1996-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1997-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1997-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1997-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1997-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1998-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1998-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1999-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1999-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2000-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2000-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2000-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2003-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2004-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2005-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2005-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2005-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2007-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2008-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2011-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2016-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2017-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-04-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-07-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-10-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2024-01-01', 0, 22, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2024-04-01', 0, 22, 3);
END
GO

-- employee 23
BEGIN
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1983-11-11', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1984-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1984-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1984-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1984-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1985-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1985-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1985-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1985-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1986-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1986-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1986-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1986-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1987-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1987-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1987-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1987-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1988-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1988-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1988-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1988-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1989-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1989-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1989-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1989-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1990-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1990-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1990-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1990-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1991-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1991-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1991-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1991-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1992-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1992-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1992-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1992-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1993-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1993-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1993-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1993-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1994-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1994-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1994-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1995-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1995-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1995-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1995-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1996-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1996-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1996-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1996-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1997-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1997-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1997-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1997-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1998-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1998-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1999-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1999-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2000-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2000-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2000-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2001-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2001-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2003-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2004-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2005-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2005-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2007-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2007-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2011-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2016-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2022-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-04-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-07-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-10-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2024-01-01', 0, 23, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2024-04-01', 0, 23, 3);
END
GO

-- employee 24
BEGIN
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1991-07-11', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1991-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1992-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1992-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1992-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1992-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1993-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1993-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1993-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1993-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1994-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1994-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1995-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1995-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1995-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1995-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1996-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1996-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1996-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1996-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1997-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1997-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1997-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1997-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1998-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1998-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1998-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1998-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1999-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1999-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2000-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2000-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2002-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2004-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2004-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2005-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2005-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2008-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2008-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2011-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2016-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2017-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2019-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2022-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-01-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-04-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-07-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-10-01', 0, 24, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2024-01-01', 0, 24, 3);
-- INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2024-04-01', 0, 24, 3);
END
GO

-- employee 25
BEGIN
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1994-08-11', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1994-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1995-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1995-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1995-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1995-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1996-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1996-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1996-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1996-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1997-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1997-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1997-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1997-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1998-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1998-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1998-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '1998-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '1999-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '1999-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2000-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2000-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2002-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2002-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2004-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2005-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2005-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2005-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2005-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2006-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2006-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2008-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2009-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2011-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2011-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2014-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2016-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2016-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2017-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2017-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2017-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2018-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2018-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2022-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-01-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-04-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-07-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-10-01', 0, 25, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2024-01-01', 0, 25, 3);
END
GO

-- employee 26
BEGIN
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2000-11-11', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2001-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2001-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2001-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2002-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2002-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2002-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2003-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2003-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2003-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2003-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2004-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2004-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2005-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2005-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2006-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2006-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2006-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2007-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2007-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2008-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2008-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2009-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2009-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2010-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2010-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2010-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2011-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2011-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2011-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2012-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2012-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2012-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2013-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2013-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2013-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2014-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2014-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2015-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2015-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2015-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2016-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2016-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2017-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2017-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2018-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2019-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2019-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2020-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2020-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2020-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2021-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2021-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2021-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2022-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2022-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2022-10-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-01-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (1, 'Needs improvement', '2023-04-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (2, 'Good job', '2023-07-01', 0, 26, 3);
INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2023-10-01', 0, 26, 3);
-- INSERT INTO Review(ReviewRatingId, Comment, ReviewDate, IsRead, EmployeeNumber, SupervisorEmployeeNumber) VALUES (3, 'Excellent performance', '2024-01-01', 0, 26, 3);
END
GO