using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model.DTO;
using TotalAdmin.Model.Entities;

namespace TotalAdmin.Repository.Interfaces
{
    public interface IPurchaseOrderRepo
    {
        Task<List<POSearchResultsApiDTO>> GetPOSearchResults(int? id);
        Task<List<PurchaseOrder>> ReviewEmployeePO(int employeeNumber);
        Task<PurchaseOrder> AddPoAsync(PurchaseOrder po);
        Task<List<PODisplayDTO>> SearchPurchaseOrders(POSearchFiltersDTO filter);
        Task<List<Item>> GetAllItems();
        Task<bool> AddItemsToPurchaseOrderAsync(int poNumber, Item item);
        Task<(int TotalItems, decimal GrandTotal)> GetOrderTotals(int poNumber);
        Task<List<PurchaseOrder>> ReviewDepartmentPo(int departmentId);
        Task<PurchaseOrder> ClosePO(int PONumber);
        Task UpdatePurchaseOrder(int id);
        Task<List<PurchaseOrder>> SearchPOForSupervisor(POSupervisorFiltersDTO filters);
        Task<PurchaseOrder> UpdatePurchaseOrder(int id, PurchaseOrder po);
        Task<PurchaseOrder> GetExistingPurchaseOrder(int poNumber);
        Task<PurchaseOrder> GetPurchaseOrderDetails(int poNumber);
    }
}
