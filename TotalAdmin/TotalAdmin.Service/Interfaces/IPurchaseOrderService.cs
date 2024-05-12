using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model.DTO;
using TotalAdmin.Model.Entities;

namespace TotalAdmin.Service.Interfaces
{
    public interface IPurchaseOrderService
    {
        Task<PurchaseOrder> AddPurchaseOrder(PurchaseOrder purchaseOrder);
        Task<List<PurchaseOrder>> GetPurchaseOrdersForEmployee(int employeeNumber);
        Task<List<POSearchResultsApiDTO>> GetPuchaseOrdersForDepartment(int departmentId);
        Task<List<PODisplayDTO>> SearchPurchaseOrders(POSearchFiltersDTO filter);
        Task<bool> AddItem(int poNumber, Item item);
        Task<List<PurchaseOrder>> GetPurchaseOrdersForDepartment(int departmentId);
        Task<PurchaseOrder> ClosePO(int PONumber);
        Task UpdatePurchaseOrder(int id);
        Task<List<PurchaseOrder>> SearchPurchaseOrdersForSupervisor(POSupervisorFiltersDTO filter);
    }
}
