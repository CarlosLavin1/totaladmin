using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model.DTO;
using TotalAdmin.Model.Entities;
using TotalAdmin.Repository;
using TotalAdmin.Types;

namespace TotalAdmin.Service
{
    public class ItemService
    {
        private readonly ItemRepository repo = new();


        /// <summary>
        /// Adds a new item to the system
        /// </summary>
        /// <param name="item"></param>
        /// <returns>The added item</returns>
        public async Task<Item> AddItem(Item item)
        {
            if (ValidateItem(item))
                return await repo.AddPoItemAsync(item);
            
            return item;
        }

        public async Task<Item> UpdateItem(Item item)
        {
            return await repo.UpdateItem(item);
        }

        public async Task<Item> GetById(int id)
        {
            return await repo.GetItemById(id);
        }

        private bool ValidateItem(Item item) 
        {
            // validate entity
            List<ValidationResult> results = new();
            bool isValid = Validator.TryValidateObject(item, new ValidationContext(item), results, true);

            foreach (ValidationResult e in results)
            {
                item.AddError(new ValidationError(e?.ErrorMessage ?? "null", ErrorType.Model));
            }

            return isValid;
        }

    }
}
