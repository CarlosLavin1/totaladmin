USE TotalAdmin
GO

-- Stored procedure to create a PurchaseOrder
CREATE OR ALTER PROC [dbo].[spAddPurchaseOrder]
	@PoNumber INT OUTPUT,
	@CreationDate DATETIME2(7),
	@RowVersion INT,
	@PurchaseOrderStatusId INT,
	@EmployeeNumber int
AS

BEGIN
	BEGIN TRY
		INSERT INTO PurchaseOrder(
			CreationDate,
			[RowVersion],
			PurchaseOrderStatusId,
			EmployeeNumber)
		VALUES (
			@CreationDate,
			@RowVersion,
			@PurchaseOrderStatusId,
			@EmployeeNumber)

		SET @PoNumber = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH

END
GO



GO
CREATE OR ALTER PROC [dbo].[spAddItem]
	@ItemId INT OUTPUT,
	@Name NVARCHAR(45),
	@Quantity INT,
	@Description NTEXT,
	@Price Money,
	@Justification NVARCHAR(255),
	@ItemLocation NVARCHAR(255),
	@RowVerison int,
	@PoNumber int,
	@StatusId int
AS

BEGIN
	BEGIN TRY
		INSERT INTO Item ([Name], Quantity, [Description], Price, Justification, ItemLocation, [RowVersion], PoNumber, ItemStatusId)
		VALUES (@Name, @Quantity, @Description, @Price, @Justification, @ItemLocation, @RowVerison, @PoNumber, @StatusId)
		SET @PoNumber = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO

GO
-- Search purchase orders based on the @DepartmentId id
CREATE OR ALTER PROC [DBO].[spSearchPurchaseOrders]
    @DepartmentId INT
AS
BEGIN
	BEGIN TRY
		SELECT 
			PO.PoNumber AS 'PO Number', 
			PO.CreationDate AS 'PO Creation Date', 
			E.FirstName + ' ' + E.LastName AS 'Supervisor Name', 
			POS.[Name] AS 'PO Status'
		FROM 
			PurchaseOrder PO
		JOIN 
			Employee E ON PO.EmployeeNumber = E.EmployeeNumber
		JOIN 
			PurchaseOrderStatus POS ON PO.PurchaseOrderStatusId = POS.PoStatusId
		JOIN
			Department D ON E.DepartmentId = D.DepartmentId
		WHERE 
			D.DepartmentId = @DepartmentId AND
			(POS.[Name] = 'Pending' OR POS.[Name] = 'Under Review')
		ORDER BY 
			PO.CreationDate ASC;
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO


GO
-- Review employees purchase orders by the employee number
CREATE OR ALTER PROC [DBO].[spReviewEmployeePO]
    @EmployeeNumber INT
AS
BEGIN
	BEGIN TRY
		SELECT 
			PO.PoNumber, 
			PO.CreationDate, 
			PO.PurchaseOrderStatusId,
			I.ItemId,
			I.[Name],
			I.Quantity,
			I.[Description],
			I.Price,
			I.Justification,
			I.ItemLocation,
			I.ItemStatusId
		FROM 
			PurchaseOrder PO
		INNER JOIN 
			Item I ON PO.PoNumber = I.PoNumber
		WHERE 
			PO.EmployeeNumber = @EmployeeNumber
		ORDER BY 
			PO.CreationDate DESC;
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO


GO
-- Search employees purchase orders by the employee number, po number, start and end date
CREATE OR ALTER PROC [DBO].[spGetEmployeePurchaseOrders]
    @EmployeeNumber INT,
    @StartDate DATETIME2(7) = NULL,
    @EndDate DATETIME2(7) = NULL,
    @PoNumber INT = NULL
AS
BEGIN
	BEGIN TRY
		SELECT 
			PO.PoNumber AS 'PO Number', 
			PO.CreationDate AS 'PO Creation Date', 
			POS.[Name] AS 'PO Status'
		FROM 
			PurchaseOrder PO
		JOIN 
			Employee E ON PO.EmployeeNumber = E.EmployeeNumber
		JOIN 
			PurchaseOrderStatus POS ON PO.PurchaseOrderStatusId = POS.PoStatusId
		WHERE 
			E.EmployeeNumber = @EmployeeNumber AND
			(PO.CreationDate >= ISNULL(@StartDate, PO.CreationDate)) AND
			(PO.CreationDate <= ISNULL(@EndDate, PO.CreationDate)) AND
			(PO.PoNumber = ISNULL(@PoNumber, PO.PoNumber))
		ORDER BY 
			PO.CreationDate DESC;
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO
