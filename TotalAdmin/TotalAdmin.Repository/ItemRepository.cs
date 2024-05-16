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
                    new Parm("@RowVersion", SqlDbType.Timestamp, i.RowVersion, 0, ParameterDirection.Output)
                };

                // Execute the stored procedure and check the result
                int results = await db.ExecuteNonQueryAsync("spUpdateItem", parms);
                if (results == -1)
                {
                    // Concurrency conflict occurred
                    i.AddError(new ValidationError("The record has been modified by another user since it was last fetched. Please refresh the page", ErrorType.Model));
                }

                return i;
            }
            catch (SqlException ex) when (ex.Message.Contains("The record has been modified by another user since it was last fetched. Please refresh the page"))
            {
                // Concurrency conflict occurred
                i.AddError(new ValidationError(ex.Message, ErrorType.Model));
                return i;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }
    }
}
