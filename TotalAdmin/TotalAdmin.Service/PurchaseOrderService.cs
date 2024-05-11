using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model.DTO;
using TotalAdmin.Model.Entities;
using TotalAdmin.Repository;
using TotalAdmin.Repository.Interfaces;
using TotalAdmin.Service.Interfaces;
using TotalAdmin.Types;

namespace TotalAdmin.Service
{
    public class PurchaseOrderService : IPurchaseOrderService
    {
        private readonly IPurchaseOrderRepo repo;

        public PurchaseOrderService(IPurchaseOrderRepo repo)
        {
            this.repo = repo;
        }

        public async Task<PurchaseOrder> AddPurchaseOrder(PurchaseOrder purchaseOrder)
        {
            if (!ValidatePurchaseOrder(purchaseOrder))
            {
                // Add the purchase order using the repo method
                var addedPurchaseOrder = await repo.AddPoAsync(purchaseOrder);

                if (addedPurchaseOrder.HasMergeOccurred)
                    // Update the quantities in the addedPurchaseOrder
                    addedPurchaseOrder = await UpdateQuantitiesInPurchaseOrder(addedPurchaseOrder);

                return addedPurchaseOrder;
            }

            return purchaseOrder;
        }

        /// <summary>
        /// Adds item to an existing purchase order.
        /// </summary>
        /// <param name="poNumber"></param>
        /// <param name="items"></param>
        /// <returns>True if the items were added otherwise false</returns>
        public async Task<bool> AddItem(int poNumber, Item item)
        {
            if (!ValidateItem(item))
                return false;
          
           await repo.AddItemsToPurchaseOrderAsync(poNumber, item);
           return true;
        }


        public async Task<List<PurchaseOrder>> GetPurchaseOrdersForEmployee(int employeeNumber)
        {
            return await repo.ReviewEmployeePO(employeeNumber);
        }

        public async Task<List<PurchaseOrder>> GetPurchaseOrdersForDepartment(int departmentId)
        {
            return await repo.ReviewDepartmentPo(departmentId);
        }

        public async Task<PurchaseOrder> ClosePO(int PONumber)
        {
            return await repo.ClosePO(PONumber);
        }

        public async Task UpdatePurchaseOrder(int id)
        {
            await repo.UpdatePurchaseOrder(id);
        }


        /// <summary>
        /// Fetehes all purchase order for a specific department
        /// </summary>
        /// <param name="departmentId"></param>
        /// <returns>A list of purchase order search results</returns>
        public async Task<List<POSearchResultsApiDTO>> GetPuchaseOrdersForDepartment(int departmentId)
        {
            var pos = await repo.GetPOSearchResults(departmentId);

            foreach (var po in pos)
            {
                var (totalItems, grandTotal) = await repo.GetOrderTotals(po.PoNumber);
                po.TotalItems = totalItems;
                po.GrandTotal = grandTotal;
            }

            return pos;
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


        private bool ValidateItem(Item item)
        {
            List<ValidationResult> results = new();
            bool isValid = Validator.TryValidateObject(item, new ValidationContext(item), results, true);
            if (!isValid)
            {
                foreach (ValidationResult e in results)
                {
                    item.AddError(new ValidationError(e?.ErrorMessage ?? "null", ErrorType.Model));
                }
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
