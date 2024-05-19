using DAL;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model.Entities;
using TotalAdmin.Types;

namespace TotalAdmin.Repository
{
    public class ItemRepository
    {
        private readonly DataAccess db = new();


        /// <summary>
        /// Adds a new purchase order items
        /// </summary>
        /// <param name="item"></param>
        /// <returns></returns>
        /// <exception cref="DataException"></exception>
        public async Task<Item> AddPoItemAsync(Item item)
        {
            List<Parm> parms = new()
            {
                new("@ItemId", SqlDbType.Int, item.ItemId, 0, ParameterDirection.Output),
                new("@Name", SqlDbType.NVarChar, item.Name, 45),
                new("@Quantity", SqlDbType.Int, item.Quantity),
                new("@Description", SqlDbType.NText, item.Description),
                new("@Price", SqlDbType.Money, item.Price),
                new("@Justification", SqlDbType.NVarChar, item.Justification, 255),
                new("@ItemLocation", SqlDbType.NVarChar, item.Location, 255),
                new("@StatusId", SqlDbType.Int, item.StatusId)
            };

            if (await db.ExecuteNonQueryAsync("spAddItem", parms) > 0)
            {
                item.ItemId = (int?)parms.FirstOrDefault(p => p.Name == "@ItemId")!.Value ?? 0;
            }
            else
            {
                throw new DataException("There was an issue adding the item to the database.");
            }

            return item;
        }

        public async Task<Item> UpdateItem(Item i)
        {
            try
            {
                List<Parm> parms = new()
                {
                    new Parm("@ItemId", SqlDbType.Int, i.ItemId),
                    new Parm("@NewStatusId", SqlDbType.Int, i.StatusId),
                    new Parm("@Reason", SqlDbType.NVarChar, i.RejectedReason),
                    new Parm("@Quantity", SqlDbType.Int, i.Quantity),
                    new Parm("@Price", SqlDbType.Decimal, i.Price),
                    new Parm("@Description", SqlDbType.NVarChar, i.Description),
                    new Parm("@Location", SqlDbType.NVarChar, i.Location),
                    new Parm("@ModifiedReason", SqlDbType.NVarChar, i.ModifiedReason),
                    new Parm("@RowVersion", SqlDbType.Timestamp, i.RowVersion, 0, ParameterDirection.InputOutput)
                };

                // Execute the stored procedure and check the result
                int results = await db.ExecuteNonQueryAsync("spUpdateItem", parms);
                if (results > 0)
                    i.RowVersion = (byte[]?)parms.FirstOrDefault(p => p.Name == "@RowVersion")!.Value;
                else
                    throw new DataException("There was an issue updating the record in the database.");

                return i;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }

        public async Task<Item> GetItemById(int id)
        {
            try
            {
                string sql = "SELECT * FROM Item WHERE ItemId = @ID";

                List<Parm> parms = new() 
                {
                    new Parm("@ID", SqlDbType.Int, id)
                };

                DataTable dt = await db.ExecuteAsync(sql, parms, CommandType.Text);

                Item? item = null;

                foreach (DataRow row in dt.Rows)
                {
                    if (item == null)
                    {
                        item = new Item
                        {
                            ItemId = Convert.ToInt32(row["ItemId"]),
                            Name = Convert.ToString(row["Name"]),
                            Quantity = Convert.ToInt32(row["Quantity"]),
                            Description = Convert.ToString(row["Description"]),
                            Price = Convert.ToDecimal(row["Price"]),
                            Justification = Convert.ToString(row["Justification"]),
                            Location = Convert.ToString(row["ItemLocation"]),
                            RejectedReason = row["RejectedReason"] as string,
                            ModifiedReason = row["ModifiedReason"] as string,
                            StatusId = Convert.ToInt32(row["ItemStatusId"]),
                            RowVersion = (byte[])row["RowVersion"]
                        };
                    }
                }

                return item;
            }
            catch(Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }
    }
}
