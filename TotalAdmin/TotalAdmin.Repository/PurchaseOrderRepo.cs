using DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model.DTO;
using TotalAdmin.Model.Entities;
using TotalAdmin.Types;

namespace TotalAdmin.Repository
{
    public class PurchaseOrderRepo
    {
        // Access the database from the Dal
        private readonly DataAccess db = new();



        public async Task<List<POSearchResultsApiDTO>> GetPOSearchResults(int? id)
        {
            List<Parm> parms = new()
            {
                new Parm("@DepartmentId", SqlDbType.Int, id)
            };

            DataTable dt = await db.ExecuteAsync("spSearchPurchaseOrders", parms);

            if (dt.Rows.Count == 0)
                return [];

            return dt.AsEnumerable().Select(row => new POSearchResultsApiDTO
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
            List<Parm> parms = new()
            {
                new Parm("@EmployeeNumber", SqlDbType.Int, employeeNumber)
            };


            DataTable dt = await db.ExecuteAsync("spReviewEmployeePO", parms);


            List<PurchaseOrder> purchaseOrders = dt.AsEnumerable()
                .GroupBy(row => row["PoNumber"]).Select(g =>
            {
                DataRow? firstRow = g.First();
                var purchaseOrder = new PurchaseOrder
                {
                    PoNumber = Convert.ToInt32(firstRow["PoNumber"]),
                    CreationDate = Convert.ToDateTime(firstRow["CreationDate"]),
                    StatusId = Convert.ToInt32(firstRow["StatusId"]),

                    Items = g.Select(row => new Item
                    {
                        Id = Convert.ToInt32(row["ItemId"]),
                        Name = row["ItemName"].ToString(),
                        Quantity = Convert.ToInt32(row["ItemQuantity"]),
                        Description = row["ItemDescription"].ToString(),
                        Price = Convert.ToDecimal(row["ItemPrice"]),
                        Justification = row["ItemJustification"].ToString(),
                        Location = row["ItemLocation"].ToString(),
                        StatusId = Convert.ToInt32(row["ItemStatusId"])
                    }).ToList()
                };

                // todo add calculation

                return purchaseOrder;
            }).ToList();

            return purchaseOrders;
        }
    

        public async Task<PurchaseOrder> AddAsync(PurchaseOrder po)
        {
            List<Parm> parms = new()
            {
                new("@PoNumber", SqlDbType.Int, po.PoNumber, 0, ParameterDirection.Output),
                new("@CreationDate", SqlDbType.DateTime2, po.CreationDate, 7),
                new("@RowVersion", SqlDbType.Int, po.RowVersion),
                new("@PurchaseOrderStatusId", SqlDbType.Int, po.StatusId),
                new("@EmployeeNumber", SqlDbType.Int, po.EmployeeNumber)
            };

            if (await db.ExecuteNonQueryAsync("spAddPurchaseOrder", parms) > 0)
            {
                //po.PoNumber = (int)parms.Where(p => p.Name == "@PoNumber").FirstOrDefault().Value;
                po.PoNumber = (int?)parms.FirstOrDefault(p => p.Name == "@PoNumber")!.Value ?? 0;
            }
            else
            {
                throw new DataException("There was an issue adding the record to the database.");
            }

            return po;
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


    }
}
