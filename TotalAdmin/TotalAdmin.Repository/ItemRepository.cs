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

        public async Task<bool> UpdateItem(int itemId, int newItemStatus, string? reason = null)
        {
            try
            {
                List<Parm> parms = new()
                {
                    new Parm("@ItemId", SqlDbType.Int, itemId),
                    new Parm("@NewStatusId", SqlDbType.Int, newItemStatus),
                    new Parm("@Reason", SqlDbType.NVarChar, reason),
                };

                string sql = "UPDATE Item SET ItemStatusId  = @NewStatusId, RejectedReason = @Reason WHERE ItemId = @ItemId";
                int rowsAffected = await db.ExecuteNonQueryAsync(sql, parms, CommandType.Text);

                return rowsAffected > 0;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.Message);
                throw;
            }
        }
    }
}
