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
    public class PurchaseOrderService
    {
        public readonly PurchaseOrderRepo repo = new();

        public async Task<PurchaseOrder> AddPurchaseOrder(PurchaseOrder purchaseOrder)
        {
            if (!ValidatePurchaseOrder(purchaseOrder))
            {
                // Add the purchase order using the repo method
                var addedPurchaseOrder = await repo.AddPoAsync(purchaseOrder);

                // Fetch all items from the database
                var allItems = await repo.GetAllItems();

                // Update the quantities in the addedPurchaseOrder
                addedPurchaseOrder = await UpdateQuantitiesInPurchaseOrder(addedPurchaseOrder);

                return addedPurchaseOrder;
            }

            return purchaseOrder;
        }



        public async Task<List<PurchaseOrder>> GetPurchaseOrdersForEmployee(int employeeNumber)
        {
            return await repo.ReviewEmployeePO(employeeNumber);
        }


        /// <summary>
        /// Fetehes all purchase order for a specific department
        /// </summary>
        /// <param name="departmentId"></param>
        /// <returns>A list of purchase order search results</returns>
        public async Task<List<POSearchResultsApiDTO>> GetPuchaseOrdersForDepartment(int departmentId)
        {
            return await repo.GetPOSearchResults(departmentId);
        }


        public async Task<List<PODisplayDTO>> SearchPurchaseOrders(POSearchFiltersDTO filter)
        {
            return await repo.SearchPurchaseOrders(filter);
        }


        private bool ValidatePurchaseOrder(PurchaseOrder po)
        {
            // validate entity
            List<ValidationResult> results = new();
            bool isValid = Validator.TryValidateObject(po, new ValidationContext(po), results, true);

            foreach (ValidationResult e in results)
            {
                po.AddError(new ValidationError(e?.ErrorMessage ?? "null", ErrorType.Model));
            }

            // Check if the purchase order has at least one item
            if (po.Items == null || !po.Items.Any())
            {
                // Add an error to the purchase order
                po.Errors.Add(new ValidationError("A purchase order requires at least one item in order to be created.", ErrorType.Business));
            }
            else
            {
                // Validate each item in the purchase order
                foreach (var item in po.Items)
                {
                    isValid = Validator.TryValidateObject(item, new ValidationContext(item), results, true);
                    if (!isValid)
                    {
                        foreach (ValidationResult e in results)
                        {
                            po.AddError(new ValidationError(e?.ErrorMessage ?? "null", ErrorType.Model));
                        }
                    }
                }
            }

            // Check if there are any errors in the Errors list
            if (po.Errors.Count == 0)
            {
                isValid = false;
            }
            else
            {
                isValid = true;
            }

            return isValid;
        }

        private async Task<PurchaseOrder> UpdateQuantitiesInPurchaseOrder(PurchaseOrder purchaseOrder)
        {
            // Fetch all items from the database
            var allItems = await repo.GetAllItems();

            // Update the quantities in the purchaseOrder
            foreach (var item in purchaseOrder.Items ?? new List<Item>())
            {
                var existingItem = allItems
                    .FirstOrDefault(eItem => eItem.Name == item.Name && eItem.Description == item.Description);

                if (existingItem != null)
                {
                    item.Quantity = existingItem.Quantity;
                }
            }

            return purchaseOrder;
        }

    }
}
