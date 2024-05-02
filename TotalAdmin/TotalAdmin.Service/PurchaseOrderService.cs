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
            if (ValidatePurchaseOrder(purchaseOrder))
                return await repo.AddAsync(purchaseOrder);

            return purchaseOrder;
        }
       
        public async Task<List<PurchaseOrder>> GetPurchaseOrdersForEmployee(int employeeNumber)
        {
            return await repo.ReviewEmployeePO(employeeNumber);
        }

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

            return isValid;
        }
    }
}
