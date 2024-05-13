using DAL;
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
                };


                // Execute the stored procedure and get the result
                DataTable dt = await db.ExecuteAsync("spUpdateItem", parms);

                // Map the result to an Item object
                Item updatedItem = new Item();
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    updatedItem.ItemId = Convert.ToInt32(row["ItemId"]);
                    updatedItem.Name = Convert.ToString(row["Name"]);
                    updatedItem.Quantity = Convert.ToInt32(row["Quantity"]);
                    updatedItem.Description = Convert.ToString(row["Description"]);
                    updatedItem.Price = Convert.ToDecimal(row["Price"]);
                    updatedItem.Justification = Convert.ToString(row["Justification"]);
                    updatedItem.Location = Convert.ToString(row["ItemLocation"]);
                    updatedItem.RejectedReason = Convert.ToString(row["RejectedReason"]);
                    updatedItem.StatusId = Convert.ToInt32(row["ItemStatusId"]);
                    updatedItem.RowVersion = (byte[])row["RowVersion"];
                }

                return updatedItem;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }
    }
}
