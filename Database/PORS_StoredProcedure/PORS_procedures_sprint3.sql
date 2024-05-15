USE TotalAdmin
GO

-- A table-valued parameter to hold a temporary collection of items for a purchase order
IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name ='PoItemsTableType' AND is_table_type = 1)
BEGIN
	CREATE TYPE PoItemsTableType AS TABLE
		(ItemId INT,
		ItemName NVARCHAR(45),
		ItemQty INT,
		ItemDesc NTEXT,
		ItemPrice Money,
		ItemJust NVARCHAR(255),
		ItemLoc NVARCHAR(255),
		RejectedReason NVARCHAR(100),
		ModifiedReason NVARCHAR(100),
		ItemStatus INT)
END
GO



-- Stored procedure to create a PurchaseOrder
CREATE OR ALTER PROC [dbo].[spAddPurchaseOrder]
	@PoNumber INT OUTPUT,
	@RowVersion ROWVERSION OUTPUT,
	@CreationDate DATETIME2(7),
	@PurchaseOrderStatusId INT,
	@EmployeeNumber int,
	@POItems PoItemsTableType READONLY -- Contains rows of item thats part of the PO
AS

BEGIN
  BEGIN TRAN
	BEGIN TRY
		INSERT INTO PurchaseOrder(
			CreationDate,
			PurchaseOrderStatusId,
			EmployeeNumber)
		VALUES (
			@CreationDate,
			@PurchaseOrderStatusId,
			@EmployeeNumber)

		SET @PoNumber = SCOPE_IDENTITY();

		-- add the the new PO items data
		INSERT INTO Item
		([Name], Quantity, [Description], Price, Justification, ItemLocation, RejectedReason, ModifiedReason, PoNumber, ItemStatusId)
			SELECT ItemName, ItemQty, ItemDesc, ItemPrice, ItemJust, ItemLoc, RejectedReason, ModifiedReason, @PoNumber, ItemStatus FROM @POItems


			SET @RowVersion = (SELECT [RowVersion] FROM PurchaseOrder WHERE PoNumber = @PoNumber)
		COMMIT TRAN

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
				ROLLBACK TRAN
		;THROW
	END CATCH

END
GO


-- Stored procedure to modify a PurchaseOrder
CREATE OR ALTER PROC [dbo].[spUpdatePurchaseOrder]
	@PoNumber INT,
	@RowVersion ROWVERSION OUTPUT,
	@CreationDate DATETIME2(7),
	@PurchaseOrderStatusId INT,
	@EmployeeNumber int,
	@POItems PoItemsTableType READONLY -- Contains rows of item thats part of the PO
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
		
			-- Update the PurchaseOrder
			UPDATE PurchaseOrder
			SET 
				CreationDate = @CreationDate,
				PurchaseOrderStatusId = @PurchaseOrderStatusId,
				EmployeeNumber = @EmployeeNumber
			WHERE 
				PoNumber = @PoNumber AND
				[RowVersion] = @RowVersion;


			-- Update the PO items data
			UPDATE Item
			SET 
				[Name] = POItems.ItemName, 
				Quantity = POItems.ItemQty, 
				[Description] = POItems.ItemDesc, 
				Price = POItems.ItemPrice, 
				Justification = POItems.ItemJust, 
				ItemLocation = POItems.ItemLoc, 
				RejectedReason = POItems.RejectedReason, 
				ModifiedReason = POItems.ModifiedReason,
				ItemStatusId = POItems.ItemStatus
			FROM 
				@POItems AS POItems
			WHERE
				Item.PoNumber = @PoNumber AND Item.ItemId = POItems.ItemId


			IF @@ROWCOUNT = 0
			BEGIN
				-- No rows updated, possible RowVersion mismatch
				;THROW 50100, 'The record has been modified by another user since it was last fetched. Please refresh the page', 1;
			END

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
				ROLLBACK TRAN
		;THROW
	END CATCH
END
GO




-- Stored procedure to create a AddItems To a PurchaseOrder
CREATE OR ALTER PROC [dbo].[spAddItemsToPurchaseOrder]
	@PoNumber INT,
	@POItems PoItemsTableType READONLY -- Contains rows of item thats part of the PO
AS
BEGIN
  BEGIN TRAN
	BEGIN TRY
		-- add the new PO items data
		INSERT INTO Item
		([Name], Quantity, [Description], Price, Justification, ItemLocation, RejectedReason, PoNumber, ItemStatusId)
			SELECT ItemName, ItemQty, ItemDesc, ItemPrice, ItemJust, ItemLoc, RejectedReason, @PoNumber, ItemStatus FROM @POItems

		COMMIT TRAN

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
				ROLLBACK TRAN
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
			Employee S ON E.SupervisorEmpNumber = S.EmployeeNumber
		JOIN 
			PurchaseOrderStatus POS ON PO.PurchaseOrderStatusId = POS.PoStatusId
		JOIN
			Department D ON E.DepartmentId = D.DepartmentId
		WHERE 
			D.DepartmentId = @DepartmentId AND
			D.InvocationDate <= GETDATE()
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
			I.ItemStatusId,
			S.[Name] AS ItemStatus,
			PS.[Name] AS PurchaseOrderStatus
		FROM 
			PurchaseOrder PO
		INNER JOIN 
			Item I ON PO.PoNumber = I.PoNumber
		INNER JOIN 
			PurchaseOrderStatus PS ON PO.PurchaseOrderStatusId = PS.PoStatusId
		INNER JOIN
			ItemStatus S ON I.ItemStatusId = S.ItemStatusId
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

-- Review supervisor purchase in there department
CREATE OR ALTER PROC [DBO].[spReviewDepartmentPO]
    @DepartmentId INT
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
			I.ItemStatusId,
			S.[Name] AS ItemStatus,
			PS.[Name] AS PurchaseOrderStatus,
			E.EmployeeNumber
		FROM 
			PurchaseOrder PO
		INNER JOIN 
			Employee E ON PO.EmployeeNumber = E.EmployeeNumber
		INNER JOIN 
			Item I ON PO.PoNumber = I.PoNumber
		INNER JOIN 
			PurchaseOrderStatus PS ON PO.PurchaseOrderStatusId = PS.PoStatusId
		INNER JOIN
			ItemStatus S ON I.ItemStatusId = S.ItemStatusId
		WHERE 
			E.DepartmentId = @DepartmentId
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
			(@StartDate IS NULL OR PO.CreationDate >= @StartDate) AND
			(@EndDate IS NULL OR PO.CreationDate <= @EndDate) AND
			(@PoNumber IS NULL OR PO.PoNumber = @PoNumber)
		ORDER BY 
			PO.CreationDate DESC;
	END TRY
	BEGIN CATCH
		;THROW
	END CATCH
END
GO

-- Supervisor Searches employees purchase in department by id, start, end date, staus or name
CREATE OR ALTER PROC [DBO].[spGetSupervisorPurchaseOrders]
    @DepartmentId INT,
    @StartDate DATETIME2(7) = NULL,
    @EndDate DATETIME2(7) = NULL,
    @PoNumber INT = NULL,
    @Status INT = NULL,
    @EmployeeName NVARCHAR(255) = NULL
AS
BEGIN
    BEGIN TRY
        SELECT 
            PO.PoNumber AS 'PO Number', 
            PO.CreationDate AS 'PO Creation Date', 
            POS.[Name] AS 'PO Status',
            E.FirstName + ' ' + E.LastName AS 'EmployeeName'
        FROM 
            PurchaseOrder PO 
            JOIN Employee E ON PO.EmployeeNumber = E.EmployeeNumber
            JOIN PurchaseOrderStatus POS ON PO.PurchaseOrderStatusId = POS.PoStatusId
        WHERE 
            E.DepartmentId = @DepartmentId
            AND (@StartDate IS NULL OR PO.CreationDate >= @StartDate)
            AND (@EndDate IS NULL OR PO.CreationDate <= @EndDate)
            AND (@PoNumber IS NULL OR PO.PoNumber = @PoNumber)
            AND (@Status IS NULL OR PO.PurchaseOrderStatusId = @Status)
            AND (@EmployeeName IS NULL OR E.FirstName LIKE '%' + @EmployeeName + '%' OR E.LastName LIKE '%' + @EmployeeName + '%')
        ORDER BY 
            PO.CreationDate ASC;
    END TRY
    BEGIN CATCH
        ;THROW
    END CATCH
END
GO


GO
-- Updates the status of an item
CREATE OR ALTER PROC [DBO].[spUpdateItem]
	@ItemId INT,
    @NewStatusId INT,
    @Reason NVARCHAR(100) = NULL,
	@RowVersion ROWVERSION OUTPUT
AS
BEGIN
	BEGIN TRY

     SELECT @RowVersion = RowVersion FROM Item WHERE ItemId = @ItemId;

	   -- WAITFOR DELAY '00:00:04'; -- Delay the execution for to 4 seconds
		UPDATE Item SET 
			ItemStatusId  = @NewStatusId,
			RejectedReason = @Reason 
		WHERE 
			ItemId = @ItemId AND
			[RowVersion] = @RowVersion;

		IF @@ROWCOUNT = 0
			BEGIN
				;THROW 50110, 'The record has been modified by another user since it was last fetched. Please refresh the page', 1;
			END
		ELSE
            BEGIN
                SELECT * FROM Item WHERE ItemId = @ItemId;
         END

	END TRY
	BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;
        THROW;
    END CATCH
END
GO


GO
-- Sets the purchase order status to close based on the PoNumber
CREATE OR ALTER PROC [DBO].[spClosePO]
	@PONumber INT,
	@RowVersion ROWVERSION OUTPUT
AS
BEGIN
	BEGIN TRY

     SELECT @RowVersion = RowVersion FROM PurchaseOrder WHERE PONumber = @PONumber;

	 -- WAITFOR DELAY '00:00:03'; -- Delay the execution for to 2 seconds
		UPDATE PurchaseOrder SET 
			PurchaseOrderStatusId  = 3
		WHERE 
			PONumber = @PONumber AND
			[RowVersion] = @RowVersion;

		IF @@ROWCOUNT = 0
			BEGIN
				;THROW 50110, 'The record has been modified by another user since it was last fetched. Please refresh the page', 1;
			END
		ELSE
            BEGIN
                SELECT * FROM PurchaseOrder WHERE PONumber = @PONumber;
         END

	END TRY
	BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;
        THROW;
    END CATCH
END
GO

