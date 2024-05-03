using Microsoft.AspNetCore.Mvc;
using TotalAdmin.Model.DTO;
using TotalAdmin.Model.Entities;
using TotalAdmin.Service;

namespace TotalAdmin.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PurchaseOrderController : Controller
    {
        private readonly PurchaseOrderService service = new();
        

        // GET: api/PurchaseOrder?departmentId=1
        [HttpGet()]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<POSearchResultsApiDTO>>> GetPuchaseOrdersForDepartment(int? departmentId)
        {
            try
            {
                // Check if the departmentid is provided 
                if (departmentId.HasValue)
                {
                    // Call the service method to fetch the results
                    List<POSearchResultsApiDTO> po = await service.GetPuchaseOrdersForDepartment(departmentId.Value);

                    // Check if the purchase or is null or empty
                    if (po == null || !po.Any())
                    {
                        return NotFound("No Purchase Orders for that Department found.");
                    }

                    return Ok(po);
                }
                else
                {
                    // Handle the case when departmentId is null
                    return BadRequest("Department ID is required.");
                }
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");
            }
        }


        // GET: api/PurchaseOrder/Search
        [HttpGet("Search")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<List<PODisplayDTO>>> SearchPurchaseOrders([FromQuery] POSearchFiltersDTO filter)
        {
            try
            {
                // Check for the specific employee
                if (!filter.EmployeeNumber.HasValue)
                {
                    return BadRequest("EmployeeNumber is required.");
                }

                if (filter.StartDate.HasValue && filter.EndDate.HasValue && filter.StartDate > filter.EndDate)
                {
                    return BadRequest("StartDate cannot be later than EndDate.");
                }


                List<PODisplayDTO> purchaseOrders = await service.SearchPurchaseOrders(filter);

                if (purchaseOrders == null || !purchaseOrders.Any())
                {
                    return NotFound("Purchase orders not found matching the provided filters.");
                }

                return Ok(purchaseOrders);
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");
            }
        }


        // POST: api/PurchaseOrder
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<PurchaseOrder>> Create([FromBody] PurchaseOrder po)
        {
            try
            {
                po = await service.AddPurchaseOrder(po);

                if (po.Errors.Count != 0)
                    return BadRequest(po);

            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");
            }

            return Ok(po);
        }


        // GET: api/PurchaseOrder/Employee
        [HttpGet("Employee")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<List<PurchaseOrder>>> GetPurchaseOrdersForEmployee([FromQuery] int employeeNumber)
        {
            try
            {
                List<PurchaseOrder> purchaseOrders = await service.GetPurchaseOrdersForEmployee(employeeNumber);

                if (purchaseOrders == null || !purchaseOrders.Any())
                {
                    return NotFound("No purchase orders found for the provided employee.");
                }

                return Ok(purchaseOrders);
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");
            }
        }

    }
}
