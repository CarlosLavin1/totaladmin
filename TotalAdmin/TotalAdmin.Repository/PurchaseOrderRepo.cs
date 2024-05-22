using DAL;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model.DTO;
using TotalAdmin.Model.Entities;
using TotalAdmin.Repository.Interfaces;
using TotalAdmin.Types;

namespace TotalAdmin.Repository
{
    public class PurchaseOrderRepo : IPurchaseOrderRepo
    {
        // Access the database from the Dal
        private readonly DataAccess db = new();


        /// <summary>
        /// Retrieves a list of purchase order detail results
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public async Task<List<POSearchResultsApiDTO>> GetPOSearchResults(int? id)
        {
            List<Parm> parms = new()
            {
                new Parm("@DepartmentId", SqlDbType.Int, id)
            };

            // Execute the stored procedure
            DataTable dt = await db.ExecuteAsync("spSearchPurchaseOrders", parms);

            // Return an empty list if no results
            if (dt.Rows.Count == 0)
                return [];

            // Convert into a list of DTO objects with only pending or under review puchase oders
            return dt.AsEnumerable()
                .Where(row => row["PO Status"].ToString() == "Pending" || row["PO Status"].ToString() == "Under Review")
                .Select(row => new POSearchResultsApiDTO
                {
                    PoNumber = Convert.ToInt32(row["PO Number"]),
                    CreationDate = Convert.ToDateTime(row["PO Creation Date"]),
                    SupervisorName = row["Supervisor Name"].ToString(),
                    Status = row["PO Status"].ToString()
                }).ToList();
        }


        /// <summary>
        /// Review a list of purchase orders by a specific employee number
        /// </summary>
        /// <param name="po"></param>
        /// <returns>A list of purchase orders of the specific employee</returns>
        public async Task<List<PurchaseOrder>> ReviewEmployeePO(int employeeNumber)
        {
            try
            {
                List<Parm> parms = new()
                {
                    new Parm("@EmployeeNumber", SqlDbType.Int, employeeNumber)
                };

                DataTable dt = await db.ExecuteAsync("spReviewEmployeePO", parms);

                List<PurchaseOrder> purchaseOrders = dt.AsEnumerable()
                    .GroupBy(row => row["PoNumber"]).Select(g =>
                    {
                        DataRow? firstRow = g.First();
                        int purchaseOrderNumber = Convert.ToInt32(firstRow["PoNumber"]);
                        string employeeName = GetEmployeeFullName(employeeNumber).Result;
                        string empSupervisorName = GetSupervisorFullNameForEmployee(employeeNumber).Result;
                        string empDepartmentName = GetEmployeeDepartmentByPONumber(purchaseOrderNumber).Result;
                        var purchaseOrder = new PurchaseOrder
                        {
                            PoNumber = purchaseOrderNumber,
                            CreationDate = Convert.ToDateTime(firstRow["CreationDate"]),
                            StatusId = Convert.ToInt32(firstRow["PurchaseOrderStatusId"]),
                            PurchaseOrderStatus = Convert.ToString(firstRow["PurchaseOrderStatus"]),
                            EmployeeName = employeeName,
                            EmployeeSupervisorName = empSupervisorName,
                            EmpDepartmentName = empDepartmentName,

                            Items = g.Select(row => new Item
                            {
                                ItemId = Convert.ToInt32(row["ItemId"] ?? 0),
                                Name = row["Name"].ToString() ?? "UnKnown",
                                Quantity = Convert.ToInt32(row["Quantity"]),
                                Description = row["Description"].ToString() ?? "UnKnown",
                                Price = Convert.ToDecimal(row["Price"]),
                                Justification = row["Justification"].ToString() ?? "UnKnown",
                                Location = row["ItemLocation"].ToString() ?? "UnKnown",
                                ItemStatus = row["ItemStatus"].ToString() ?? "UnKnown",
                                ModifiedReason = row["ModifiedReason"].ToString() ?? "UnKnown",
                                RejectedReason = row["RejectedReason"].ToString() ?? "UnKnown",
                                StatusId = Convert.ToInt32(row["ItemStatusId"])
                            }).ToList()
                        };


                        return purchaseOrder;
                    }).ToList();

                return purchaseOrders;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }

        /// <summary>
        /// Review a list of purchase orders by a specific department
        /// </summary>
        /// <param name="departmentId"></param>
        /// <returns>A list of purchase orders of the specific department</returns>
        public async Task<List<PurchaseOrder>> ReviewDepartmentPo(int departmentId)
        {
            try
            {
                List<Parm> parms = new()
                {
                    new Parm("@DepartmentId", SqlDbType.Int, departmentId)
                };

                DataTable dt = await db.ExecuteAsync("spReviewDepartmentPO", parms);

                List<PurchaseOrder> purchaseOrders = dt.AsEnumerable()
                    .GroupBy(row => row["PoNumber"]).Select(g =>
                    {
                        DataRow? firstRow = g.First();
                        int purchaseOrderNumber = Convert.ToInt32(firstRow["PoNumber"]);
                        string departmentName = GetEmployeeDepartmentByPONumber(purchaseOrderNumber).Result;
                        int employeeNumber = Convert.ToInt32(firstRow["EmployeeNumber"]);
                        string supervisorName = GetSupervisorFullNameForEmployee(employeeNumber).Result;
                        string employeeName = GetEmployeeFullName(employeeNumber).Result;


                        var purchaseOrder = new PurchaseOrder
                        {
                            PoNumber = purchaseOrderNumber,
                            CreationDate = Convert.ToDateTime(firstRow["CreationDate"]),
                            StatusId = Convert.ToInt32(firstRow["PurchaseOrderStatusId"]),
                            PurchaseOrderStatus = Convert.ToString(firstRow["PurchaseOrderStatus"]),
                            EmpDepartmentName = departmentName,
                            EmployeeSupervisorName = supervisorName,
                            EmployeeName = employeeName,
                            EmployeeNumber = employeeNumber,
                            RowVersion = (byte[]?)firstRow["RowVersion"],

                            Items = g.Select(row => new Item
                            {
                                ItemId = Convert.ToInt32(row["ItemId"] ?? 0),
                                Name = row["Name"].ToString() ?? "UnKnown",
                                Quantity = Convert.ToInt32(row["Quantity"]),
                                Description = row["Description"].ToString() ?? "UnKnown",
                                Price = Convert.ToDecimal(row["Price"]),
                                Justification = row["Justification"].ToString() ?? "UnKnown",
                                Location = row["ItemLocation"].ToString() ?? "UnKnown",
                                ItemStatus = row["ItemStatus"].ToString() ?? "UnKnown",
                                StatusId = Convert.ToInt32(row["ItemStatusId"]),
                                RowVersion = (byte[])row["RowVersion"],
                            }).ToList()
                        };

                        return purchaseOrder;
                    }).ToList();

                return purchaseOrders;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }

        /// <summary>
        /// Gets the detail of the purchase order based on the provided number
        /// </summary>
        /// <param name="poNumber"></param>
        /// <returns>Results of th epurchase order detail</returns>
        public async Task<PurchaseOrder> GetPurchaseOrderDetails(int poNumber)
        {
            try
            {
                PurchaseOrder? po = null;
                
                string sql = @"SELECT PurchaseOrder.*, 
	                                PurchaseOrderStatus.[Name] AS PurchaseOrderStatus
                                FROM PurchaseOrder 
	                                INNER JOIN
                                    PurchaseOrderStatus ON PurchaseOrder.PurchaseOrderStatusId = PurchaseOrderStatus.PoStatusId
                                WHERE PoNumber = @PoNumber";

                DataTable dt = await db.ExecuteAsync(sql, new List<Parm> { new Parm("@PoNumber", SqlDbType.Int, poNumber) }, CommandType.Text);

              
                if (dt.Rows.Count == 0)
                {
                    return po;
                }

                // Create a PurchaseOrder object from the result
                DataRow firstRow = dt.Rows[0];
                po = new PurchaseOrder
                {
                    PoNumber = Convert.ToInt32(firstRow["PoNumber"]),
                    CreationDate = Convert.ToDateTime(firstRow["CreationDate"]),
                    EmployeeSupervisorName = await GetSupervisorFullNameForEmployee(Convert.ToInt32(firstRow["EmployeeNumber"])),
                    FormattedPoNumber = "00001" + firstRow["PoNumber"].ToString().PadLeft(2, '0'),
                    StatusId = Convert.ToInt32(firstRow["PurchaseOrderStatusId"]),
                    PurchaseOrderStatus = Convert.ToString(firstRow["PurchaseOrderStatus"]),
                };

                
                sql = "SELECT * FROM Item WHERE PoNumber = @PoNumber";

               
                dt = await db.ExecuteAsync(sql, new List<Parm> { new Parm("@PoNumber", SqlDbType.Int, poNumber) }, CommandType.Text);

                // Add the items to the PurchaseOrder object
                po.Items = dt.AsEnumerable().Select(row => new Item
                {
                    ItemId = Convert.ToInt32(row["ItemId"]),
                    Name = row["Name"].ToString() ?? "N/A",
                    Quantity = Convert.ToInt32(row["Quantity"]),
                    Description = row["Description"].ToString() ?? "N/A",
                    Price = Convert.ToDecimal(row["Price"]),
                    Justification = row["Justification"].ToString() ?? "N/A",
                    Location = row["ItemLocation"].ToString() ?? "N/A",
                    StatusId = Convert.ToInt32(row["ItemStatusId"])
                }).ToList();

                return po;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }


        /// <summary>
        /// Used to close a purchase order based on the PONumber
        /// </summary>
        /// <param name="PONumber"></param>
        /// <returns>Returns the updated po status</returns>
        public async Task<PurchaseOrder> ClosePO(int PONumber)
        {
            try
            {
                // Fetch the current RowVersion of the purchase order
                string sql = "SELECT RowVersion FROM PurchaseOrder WHERE PONumber = @PONumber";
                byte[] rowVersion = (byte[])await db.ExecuteScalarAsync
                    (sql, new List<Parm> { new Parm("@PONumber", SqlDbType.Int, PONumber) }, CommandType.Text);


                List<Parm> parms = new()
                {
                    new Parm("@PONumber", SqlDbType.Int, PONumber),
                    new Parm("@RowVersion", SqlDbType.Timestamp,rowVersion)
                };


                // Execute the stored procedure
                await db.ExecuteNonQueryAsync("spClosePO", parms, CommandType.StoredProcedure);

                // Fetch the updated purchase orders
                DataTable dt = await db.ExecuteAsync("spClosePO", parms, CommandType.StoredProcedure);

                // Get the employee's email
                string employeeEmail = await GetEmployeeEmail(PONumber);

                if (dt.Rows.Count > 0)
                {
                    DataRow firstRow = dt.Rows[0];
                    PurchaseOrder po = new PurchaseOrder
                    {
                        PoNumber = Convert.ToInt32(firstRow["PoNumber"]),
                        EmployeeEmail = employeeEmail,
                        FormattedPoNumber = "00001" + firstRow["PoNumber"].ToString().PadLeft(2, '0')
                    };

                    return po;
                }
                else
                {
                    throw new Exception("Purchase order not found");
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }

        public async Task UpdatePurchaseOrder(int id)
        {
            try
            {
                List<Parm> parms = new()
                {
                    new Parm("@PONumber", SqlDbType.Int, id),
                    new Parm("@NewStatusId", SqlDbType.Int, 2), // status for "under review"
                };

                string sql = "UPDATE PurchaseOrder SET PurchaseOrderStatusId = @NewStatusId WHERE PONumber = @PONumber";
                await db.ExecuteNonQueryAsync(sql, parms, CommandType.Text);
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }



        /// <summary>
        /// Adds a new purchase order along with its items
        /// </summary>
        /// <param name="po"></param>
        /// <returns>The added purchase order with updated properties</returns>
        /// <exception cref="DataException"></exception>
        public async Task<PurchaseOrder> AddPoAsync(PurchaseOrder po)
        {
            try
            {
                // Fetch all items from the database
                var allItems = await GetAllItems();


                // Merge items with the same properties
                var (mergedItems, hasMergeOccurred) =
                    await MergeItems(allItems, (po.Items ?? new List<Item>()).ToList());


                // Check if a merge has occurred
                if (hasMergeOccurred)
                {
                    // If a merge has occurred, set the flag
                    po.HasMergeOccurred = true;
                }

                // Filter out the existing items from the mergedItems list
                var newItems = mergedItems
                    .Where(item => !allItems
                    .Any(existingItem => existingItem.ItemId == item.ItemId))
                    .ToList();

                // Check if newItems list is empty
                if (!newItems.Any())
                {
                    // return the PurchaseOrder object as is
                    return po;
                }

                // Create a DataTable for the PO items
                var poItemsTable = await CreatePoItemsDataTableAsync(newItems);

                Debug.WriteLineIf(hasMergeOccurred, poItemsTable);
                List<Parm> parms = new()
                {
                    new("@PoNumber", SqlDbType.Int, po.PoNumber, 0, ParameterDirection.Output),
                    new("@RowVersion", SqlDbType.Timestamp, po.RowVersion, 0, ParameterDirection.Output),
                    new("@CreationDate", SqlDbType.DateTime2, po.CreationDate, 7),
                    new("@PurchaseOrderStatusId", SqlDbType.Int, po.StatusId),
                    new("@EmployeeNumber", SqlDbType.Int, po.EmployeeNumber),
                    new("@POItems", SqlDbType.Structured, poItemsTable)
                };

                Debug.WriteLine(parms);
                if (await db.ExecuteNonQueryAsync("spAddPurchaseOrder", parms) > 0)
                {
                    // Get the PO number as an integer
                    int poNumberInt = po.PoNumber = (int?)parms.FirstOrDefault(p => p.Name == "@PoNumber")!.Value ?? 0;

                    // Assign the PO number to the PurchaseOrder object
                    po.PoNumber = poNumberInt;

                    po.RowVersion = (byte[]?)parms.FirstOrDefault(p => p.Name == "@RowVersion")!.Value;
                }
                else
                {
                    throw new DataException("There was an issue adding the record to the database.");
                }

                return po;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }

        /// <summary>
        /// Modifies employess Purchase Order based on the given id and the pos
        /// </summary>
        /// <param name="id"></param>
        /// <param name="po"></param>
        /// <returns>The purchase orders Updated</returns>
        public async Task<PurchaseOrder> UpdatePurchaseOrder(int id, PurchaseOrder po)
        {
            try
            {
                // Fetch all items from the database
                var allItems = await GetAllItems();

                // Merge items with the same properties
                var (mergedItems, hasMergeOccurred) =
                    await MergeItems(allItems, (po.Items ?? new List<Item>()).ToList(), true);

                // Check if a merge has occurred
                if (hasMergeOccurred)
                    po.HasMergeOccurred = true; // set the flag


                // Filter out the existing items from the mergedItems list
                var updatedItems = mergedItems
                    .Where(item => allItems
                    .Any(existingItem => existingItem.ItemId == item.ItemId))
                    .ToList();

                // Check if updatedItems list is empty
                if (!updatedItems.Any())
                    return po; // return the PurchaseOrder object as is
              

                // Create a DataTable for the PO items
                var poItemsTable = await CreatePoItemsDataTableAsync(updatedItems);

                
                List<Parm> parms = new()
                {
                    new("@PoNumber", SqlDbType.Int, po.PoNumber),
                    new("@RowVersion", SqlDbType.Timestamp, po.RowVersion, 0, ParameterDirection.InputOutput),
                    new("@CreationDate", SqlDbType.DateTime2, po.CreationDate, 7),
                    new("@PurchaseOrderStatusId", SqlDbType.Int, po.StatusId),
                    new("@EmployeeNumber", SqlDbType.Int, po.EmployeeNumber),
                    new("@POItems", SqlDbType.Structured, poItemsTable)
                };

               
                if (await db.ExecuteNonQueryAsync("spUpdatePurchaseOrder", parms) > 0)
                    po.RowVersion = (byte[]?)parms.FirstOrDefault(p => p.Name == "@RowVersion")!.Value;
                else
                    throw new DataException("There was an issue updating the record in the database.");
               

                return po;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }

        /// <summary>
        /// Adds items to an existing purchase order
        /// </summary>
        /// <param name="poNumber"></param>
        /// <param name="item"></param>
        /// <returns>Returns the added item</returns>
        public async Task<bool> AddItemsToPurchaseOrderAsync(int poNumber, Item item)
        {
            try
            {

                // Create a DataTable for the PO items
                var poItemsTable = await CreateItemsDataTableAsync(item);

                List<Parm> parms = new()
                {
                    new("@PoNumber", SqlDbType.Int, poNumber),
                    new("@POItems", SqlDbType.Structured, poItemsTable)
                };

                // Execute the stored procedure
                int rowsAffected = await db.ExecuteNonQueryAsync("spAddItemsToPurchaseOrder", parms);

                return rowsAffected > 0;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }



        /// <summary>
        /// Searches for purchase orders based on provided filters
        /// </summary>
        /// <param name="filter"></param>
        /// <returns>A list of purchase orders that match the provided filters</returns>
        public async Task<List<PODisplayDTO>> SearchPurchaseOrders(POSearchFiltersDTO filter)
        {
            // map the parameters
            List<Parm> parms = new()
            {
                new Parm("@EmployeeNumber", SqlDbType.Int, filter.EmployeeNumber),
                new Parm("@StartDate", SqlDbType.DateTime2, filter.StartDate),
                new Parm("@EndDate", SqlDbType.DateTime2, filter.EndDate),
                new Parm("@PoNumber", SqlDbType.Int, filter.PONumber)
            };

            // Call the procedure and pass in the parameters
            DataTable dt = await db.ExecuteAsync("spGetEmployeePurchaseOrders", parms);

            // If no rows found return null
            if (dt.Rows.Count == 0)
                return null;


            var tasks = dt.AsEnumerable().Select(async row =>
            {
                // Get the "PO Number" row
                int poNumber = Convert.ToInt32(row["PO Number"]);

                // Calculate the subtotal, tax, and grand total
                decimal subtotal = await CalculateSubtotal(poNumber);
                decimal tax = CalculateTax(subtotal);
                decimal grandTotal = CalculateGrandTotal(subtotal, tax);


                // Create new display object
                return new PODisplayDTO
                {
                    PoNumber = poNumber,
                    CreationDate = Convert.ToDateTime(row["PO Creation Date"]),
                    Status = Convert.ToString(row["PO Status"]),
                    Subtotal = subtotal,
                    Tax = tax,
                    GrandTotal = grandTotal
                };
            });

            // Wait for all tasks to complete, collect and return the results in a list
            PODisplayDTO[]? results = await Task.WhenAll(tasks);

            return results.ToList();
        }

        public async Task<List<PurchaseOrder>> SearchPOForSupervisor(POSupervisorFiltersDTO filter)
        {
            try
            {
                // map the parameters
                List<Parm> parms = new()
                {
                    new Parm("@DepartmentId", SqlDbType.Int, filter.DepartmentId),
                    new Parm("@StartDate", SqlDbType.DateTime2, filter.StartDate),
                    new Parm("@EndDate", SqlDbType.DateTime2, filter.EndDate),
                    new Parm("@PoNumber", SqlDbType.Int, filter.PONumber),
                    new Parm("@Status", SqlDbType.Int, filter.Status),
                    new Parm("@EmployeeName", SqlDbType.NVarChar, filter.EmployeeName)
                };

                // Call the procedure and pass in the parameters
                DataTable dt = await db.ExecuteAsync("spGetSupervisorPurchaseOrders", parms);

                // If no rows found return null
                if (dt.Rows.Count == 0)
                    return null;

                var tasks = dt.AsEnumerable().Select(async row =>
                {
                    // Create new PurchaseOrder object
                    return new PurchaseOrder
                    {
                        PoNumber = Convert.ToInt32(row["PO Number"]),
                        CreationDate = Convert.ToDateTime(row["PO Creation Date"]),
                        PurchaseOrderStatus = row["PO Status"].ToString() ?? "Unkown",
                        EmployeeName = row["EmployeeName"].ToString() ?? "Unkown",
                        // Load the Items for this PurchaseOrder
                        Items = await LoadItemsForPurchaseOrder(Convert.ToInt32(row["PO Number"]))
                    };
                });

                // Wait for all tasks to complete and collect the results in a list
                PurchaseOrder[]? purchaseOrders = await Task.WhenAll(tasks);

                return purchaseOrders.ToList();
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }




        /// <summary>
        /// Get all the items
        /// </summary>
        /// <returns></returns>
        public async Task<List<Item>> GetAllItems()
        {
            try
            {
                string sql = "SELECT * FROM Item";
                DataTable dt = await db.ExecuteAsync(sql, null, CommandType.Text);

                return dt.AsEnumerable()
                    .Select(row => new Item
                    {
                        ItemId = Convert.ToInt32(row["ItemId"] ?? 0),
                        Name = row["Name"].ToString() ?? "UnKnown",
                        Quantity = Convert.ToInt32(row["Quantity"]),
                        Description = row["Description"].ToString() ?? "UnKnown",
                        Price = Convert.ToDecimal(row["Price"]),
                        Justification = row["Justification"].ToString() ?? "UnKnown",
                        Location = row["ItemLocation"].ToString() ?? "UnKnown",
                        StatusId = Convert.ToInt32(row["ItemStatusId"])
                    }).ToList();
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }

        /// <summary>
        /// Get a specific purchase order by its number
        /// </summary>
        /// <param name="poNumber">The number of the purchase order</param>
        /// <returns></returns>
        public async Task<PurchaseOrder> GetExistingPurchaseOrder(int poNumber)
        {
            try
            {
                string sql = @"SELECT p.*, i.*
                       FROM 
                            PurchaseOrder p
                       LEFT JOIN
                            Item i ON p.PoNumber = i.PoNumber
                       WHERE p.PoNumber = @PoNumber";

                List<Parm> parameters = new List<Parm> { new Parm("@PoNumber", SqlDbType.Int, poNumber) };
                DataTable dt = await db.ExecuteAsync(sql, parameters, CommandType.Text);

                PurchaseOrder purchaseOrder = null;
                foreach (DataRow row in dt.Rows)
                {
                    if (purchaseOrder == null)
                    {
                        purchaseOrder = new PurchaseOrder
                        {
                            PoNumber = Convert.ToInt32(row["PoNumber"]),
                            CreationDate = Convert.ToDateTime(row["CreationDate"]),
                            StatusId = Convert.ToInt32(row["PurchaseOrderStatusId"]),
                            EmployeeNumber = Convert.ToInt32(row["EmployeeNumber"]),
                            RowVersion = (byte[])row["RowVersion"],
                            Items = new List<Item>()
                        };
                    }

                    purchaseOrder.Items.Add(new Item
                    {
                        ItemId = Convert.ToInt32(row["ItemId"]),
                        Name = row["Name"].ToString(),
                        Quantity = Convert.ToInt32(row["Quantity"]),
                        Description = row["Description"].ToString(),
                        Price = Convert.ToDecimal(row["Price"]),
                        Justification = row["Justification"].ToString(),
                        Location = row["ItemLocation"].ToString(),
                        StatusId = Convert.ToInt32(row["ItemStatusId"]),
                    });
                }

                return purchaseOrder;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }


        public async Task<(int TotalItems, decimal GrandTotal)> GetOrderTotals(int poNumber)
        {
            try
            {
                List<Parm> parms = new() { new Parm("@PoNumber", SqlDbType.Int, poNumber) };
                string sql = @"
                            SELECT 
                                COUNT(Item.ItemId) AS TotalItems,
                                ISNULL(SUM(Item.Price * Item.Quantity), 0) AS GrandTotal
                            FROM Item
                            WHERE Item.PoNumber = @PoNumber";

                DataTable dt = await db.ExecuteAsync(sql, parms, CommandType.Text);

                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    int totalItems = Convert.ToInt32(row["TotalItems"]);
                    decimal grandTotal = Convert.ToDecimal(row["GrandTotal"]);

                    return (totalItems, grandTotal);
                }
                else
                {
                    throw new Exception($"No items found for purchase order number {poNumber}.");
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }


        #region [PRIVATE METHODS]

        /// <summary>
        /// Calculates the subtotal for a given purchase order
        /// </summary>
        /// <param name="poNumber"></param>
        /// <returns></returns>
        private async Task<decimal> CalculateSubtotal(int poNumber)
        {
            List<Parm> parms = new()
            {
                new Parm("@PoNumber", SqlDbType.Int, poNumber)
            };

            string sql = "SELECT Quantity, Price FROM Item WHERE PoNumber = @PoNumber";
            DataTable dt = await db.ExecuteAsync(sql, parms, CommandType.Text);

            decimal subtotal = 0;
            foreach (DataRow row in dt.Rows)
            {
                int quantity = Convert.ToInt32(row["Quantity"]);
                decimal price = Convert.ToDecimal(row["Price"]);
                subtotal += quantity * price;
            }

            return subtotal;
        }

        /// <summary>
        /// Calculates the tax for a given subtotal
        /// </summary>
        /// <param name="subtotal"></param>
        /// <returns>The calculated tax</returns>
        private decimal CalculateTax(decimal subtotal)
        {
            decimal taxRate = 0.05m; // 5% tax rate for example
            return subtotal * taxRate;
        }

        /// <summary>
        /// Calculates the grand total for a given subtotal and tax
        /// </summary>
        /// <param name="subtotal"></param>
        /// <param name="tax"></param>
        /// <returns>The calculated grand total</returns>
        private decimal CalculateGrandTotal(decimal subtotal, decimal tax)
        {
            return subtotal + tax;
        }

        /// <summary>
        ///  Gets the full name for a given employee number
        /// </summary>
        /// <param name="employeeNumber"></param>
        /// <returns></returns>
        /// <exception cref="Exception"></exception>
        private async Task<string> GetEmployeeFullName(int employeeNumber)
        {
            List<Parm> parms = new()
            {
                new Parm("@EmployeeNumber", SqlDbType.Int, employeeNumber)
            };

            string sql = "SELECT FirstName, LastName FROM Employee WHERE EmployeeNumber = @EmployeeNumber";
            DataTable dt = await db.ExecuteAsync(sql, parms, CommandType.Text);

            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                string firstName = row["FirstName"].ToString();
                string lastName = row["LastName"].ToString();
                return $"{firstName} {lastName}";
            }
            else
            {
                throw new Exception($"Employee with number {employeeNumber} not found.");
            }
        }

        /// <summary>
        /// Gets the full name of the supervisor for a given employee number
        /// </summary>
        /// <param name="employeeNumber"></param>
        /// <returns></returns>
        /// <exception cref="Exception"></exception>
        private async Task<string> GetSupervisorFullNameForEmployee(int employeeNumber)
        {
            // get supervisor number for the given employee
            List<Parm> parms = new()
            {
                new Parm("@EmployeeNumber", SqlDbType.Int, employeeNumber)
            };

            string sql = "SELECT SupervisorEmpNumber FROM Employee WHERE EmployeeNumber = @EmployeeNumber";
            DataTable dt = await db.ExecuteAsync(sql, parms, CommandType.Text);

            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                int supervisorNumber = Convert.ToInt32(row["SupervisorEmpNumber"]);

                // get the supervisor's full name using the GetEmployeeFullName method
                string supervisorFullName = await GetEmployeeFullName(supervisorNumber);
                return supervisorFullName;
            }
            else
            {
                throw new Exception($"Employee with number {employeeNumber} not found.");
            }
        }

        private async Task<string> GetEmployeeEmail(int poNumber)
        {
            // get supervisor number for the given employee
            List<Parm> parms = new()
            {
                new Parm("@PONumber", SqlDbType.Int, poNumber)
            };

            string sql = "SELECT po.*, e.EmailAddress FROM PurchaseOrder po JOIN Employee e ON po.EmployeeNumber = e.EmployeeNumber WHERE po.PoNumber = @PONumber";
            DataTable dt = await db.ExecuteAsync(sql, parms, CommandType.Text);

            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                string employeeEmail = Convert.ToString(row["EmailAddress"]);

                return employeeEmail; // Return the email address
            }
            else
            {
                throw new Exception($"Purchase order with number {poNumber} not found.");
            }
        }


        private async Task<ICollection<Item>> LoadItemsForPurchaseOrder(int poNumber)
        {
            try
            {
                // Define the parameters
                List<Parm> parms = new()
                {
                    new Parm("@PoNumber", SqlDbType.Int, poNumber)
                };

                string sql = "SELECT * FROM Item WHERE PoNumber = @PoNumber";

                // Call the procedure and pass in the parameters
                DataTable dt = await db.ExecuteAsync(sql, parms, CommandType.Text);

                // If no rows found return null
                if (dt.Rows.Count == 0)
                    return null;

                // Map the data table to a list of Item objects
                var items = dt.AsEnumerable().Select(row =>
                {
                    return new Item
                    {
                        ItemId = Convert.ToInt32(row["ItemId"]),
                        Name = row["Name"].ToString() ?? "N/A",
                        Quantity = Convert.ToInt32(row["Quantity"]),
                        Description = row["Description"].ToString() ?? "N/A",
                        Price = Convert.ToDecimal(row["Price"]),
                        Justification = row["Justification"].ToString() ?? "N/A",
                        Location = row["ItemLocation"].ToString() ?? "N/A",
                        RejectedReason = row["RejectedReason"].ToString(),
                        StatusId = Convert.ToInt32(row["ItemStatusId"])
                    };
                });

                // Return the list of items
                return items.ToList();
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }


        /// <summary>
        /// Get the department name for a given purchase order number
        /// </summary>
        /// <param name="poNumber"></param>
        /// <returns></returns>
        /// <exception cref="Exception"></exception>
        private async Task<string> GetEmployeeDepartmentByPONumber(int poNumber)
        {
            List<Parm> parms = new()
            {
                new Parm("@PoNumber", SqlDbType.Int, poNumber)
            };

            //  Retrieves the department name associated with a given PO number
            string sql = @"
                SELECT d.Name 
                FROM PurchaseOrder po 
                    JOIN Employee e ON po.EmployeeNumber = e.EmployeeNumber 
                    JOIN Department d ON e.DepartmentId = d.DepartmentId 
                WHERE po.PoNumber = @PoNumber";

            DataTable dt = await db.ExecuteAsync(sql, parms, CommandType.Text);

            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                var departmentName = row["Name"].ToString();
                return departmentName;
            }
            else
            {
                throw new Exception($"Purchase order with number {poNumber} not found.");
            }
        }

        private async Task<bool> UpdateItemAsync(Item item)
        {
            try
            {
                List<Parm> parms = new()
                {
                    new Parm("@ItemId", SqlDbType.Int, item.ItemId),
                    new Parm("@Quantity", SqlDbType.Int, item.Quantity),
                };

                string sql = "UPDATE Item SET Quantity = @Quantity WHERE ItemId = @ItemId";
                int rowsAffected = await db.ExecuteNonQueryAsync(sql, parms, CommandType.Text);

                return rowsAffected > 0;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }

        /// <summary>
        /// Merges new items with existing items based on their properties.
        /// If updating a PO it checks for status if pending or approve
        /// </summary>
        /// <param name="existingItems"></param>
        /// <param name="newItems"></param>
        /// <returns>A tuple containing the list of merged items and a boolean indicating if a merge has occurred</returns>
        private async Task<(List<Item>, bool)> MergeItems(List<Item> existingItems, List<Item> newItems, bool isUpdate = false)
        {
            var result = new List<Item>();
            bool hasMergeOccurred = false;

            // Loop over each new item
            foreach (var newItem in newItems)
            {
                // Find an existing item that matches the new item based on their properties
                var existingItem = existingItems.FirstOrDefault(item =>
                  (!isUpdate || item.ItemId == newItem.ItemId) &&
                  item.Name.ToLower().ToLowerInvariant().Trim() == newItem.Name.ToLower().ToLowerInvariant().Trim() &&
                  item.Description.ToLower().ToLowerInvariant().Trim() == newItem.Description.ToLower().ToLowerInvariant().Trim() &&
                  item.Price == newItem.Price &&
                  item.Justification.ToLower().ToLowerInvariant().Trim() == newItem.Justification.ToLower().ToLowerInvariant().Trim() &&
                  item.Location.ToLower().ToLowerInvariant().Trim() == newItem.Location.ToLower().ToLowerInvariant().Trim() &&
                  (!isUpdate || (item.StatusId != 2 && item.StatusId != 3))); // Check status only if it's an update operation

                if (existingItem != null)
                {
                    // If an existing item matches the new item sum the quantity
                    existingItem.Quantity += newItem.Quantity;
                    await UpdateItemAsync(existingItem);

                    // Add a new instance of Item with the same properties as the existing item
                    result.Add(CreateNewItemFromExisting(existingItem));


                    hasMergeOccurred = true;
                }
                else
                {
                    // If no matching existing item is found add copy of new item
                    result.Add(CreateNewItemFromExisting(newItem));
                }
            }

            return (result, hasMergeOccurred);
        }

        /// <summary>
        /// Creates a DataTable for the given list of items
        /// </summary>
        /// <param name="items"></param>
        /// <returns>A temporary DB representing the given list of items</returns>
        private Task<DataTable> CreatePoItemsDataTableAsync(List<Item> items)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ItemId", typeof(int));
            dt.Columns.Add("ItemName", typeof(string));
            dt.Columns.Add("ItemQty", typeof(int));
            dt.Columns.Add("ItemDesc", typeof(string));
            dt.Columns.Add("ItemPrice", typeof(decimal));
            dt.Columns.Add("ItemJust", typeof(string));
            dt.Columns.Add("ItemLoc", typeof(string));
            dt.Columns.Add("RejectedReason", typeof(string));
            dt.Columns.Add("ModifiedReason", typeof(string));
            dt.Columns.Add("ItemStatus", typeof(int));

            foreach (var item in items)
            {
                dt.Rows.Add(
                    item.ItemId,
                    item.Name,
                    item.Quantity,
                    item.Description,
                    item.Price,
                    item.Justification,
                    item.Location,
                    item.RejectedReason,
                    item.ModifiedReason,
                    item.StatusId);
            }

            Debug.WriteLine(dt.ToString());
            return Task.FromResult(dt);
        }


        /// <summary>
        /// Creates a DataTable for the given item
        /// </summary>
        /// <param name="items"></param>
        /// <returns>A temporary DB representing the given list of items</returns>
        private Task<DataTable> CreateItemsDataTableAsync(Item item)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ItemId", typeof(int));
            dt.Columns.Add("ItemName", typeof(string));
            dt.Columns.Add("ItemQty", typeof(int));
            dt.Columns.Add("ItemDesc", typeof(string));
            dt.Columns.Add("ItemPrice", typeof(decimal));
            dt.Columns.Add("ItemJust", typeof(string));
            dt.Columns.Add("ItemLoc", typeof(string));
            dt.Columns.Add("RejectedReason", typeof(string));
            dt.Columns.Add("ModifiedReason", typeof(string));
            dt.Columns.Add("ItemStatus", typeof(int));

            dt.Rows.Add(
                item.ItemId,
                item.Name,
                item.Quantity,
                item.Description,
                item.Price,
                item.Justification,
                item.Location,
                item.RejectedReason,
                item.ModifiedReason,
                item.StatusId);

            return Task.FromResult(dt);
        }

        private Item CreateNewItemFromExisting(Item existingItem)
        {
            return new Item
            {
                ItemId = existingItem.ItemId,
                Name = existingItem.Name,
                Quantity = existingItem.Quantity,
                Description = existingItem.Description,
                Price = existingItem.Price,
                Justification = existingItem.Justification,
                Location = existingItem.Location,
                RejectedReason = existingItem.RejectedReason,
                ModifiedReason = existingItem.ModifiedReason,
                ItemStatus = existingItem.ItemStatus,
                StatusId = existingItem.StatusId,
                RowVersion = existingItem.RowVersion,
            };
        }


        #endregion
    }
}
