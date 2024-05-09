using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TotalAdmin.Model.DTO;
using TotalAdmin.Model.Entities;
using TotalAdmin.Service;
using TotalAdmin.Service.Interfaces;

namespace TotalAdmin.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PurchaseOrderController : Controller
    {
        private readonly IPurchaseOrderService service;

        public PurchaseOrderController(IPurchaseOrderService s)
        {
            this.service = s;
        }


        // GET: api/PurchaseOrder?departmentId=1
        [Authorize]
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
        [Authorize]
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
                    return BadRequest("Start Date cannot be later than End Date.");
                }

                if (filter.StartDate.HasValue && filter.EndDate.HasValue && filter.StartDate < filter.EndDate)
                {
                    return BadRequest("End Date cannot be before than Start Date.");
                }



                List<PODisplayDTO> purchaseOrders = await service.SearchPurchaseOrders(filter);

                if (purchaseOrders == null || !purchaseOrders.Any())
                {
                    return NotFound("Purchase orders not found matching the provided filters.");
                }

                var response = purchaseOrders.Select(po => new PODisplayDTO
                {
                    PoNumber = po.PoNumber,
                    CreationDate = po.CreationDate,
                    Status = po.Status,
                    Subtotal = po.Subtotal,
                    Tax = po.Tax,
                    GrandTotal = po.GrandTotal,
                    FormattedPoNumber = "00001" + po.PoNumber.ToString("D2")
                }).ToList();


                return Ok(response);
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");
            }
        }


        // POST: api/purchaseOrder
        [Authorize]
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<PurchaseOrder>> Create([FromBody] PurchaseOrder po)
        {
            try
            {
                if (po == null) 
                    return BadRequest("Purchase order cannot be null.");


                po = await service.AddPurchaseOrder(po);

                if (po.Errors.Count != 0)
                    return BadRequest(po);


                string formattedNumber = po.PoNumber.ToString("D2");


                // Create the formatted PO number
                string formattedPoNumber = "00001" + formattedNumber;

                var response = new
                {
                    PurchaseOrder = po,
                    FormattedPoNumber = formattedPoNumber
                };

                return CreatedAtAction(nameof(Create), response);
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");
            }
        }

        [Authorize]
        [HttpPost("AddItems")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> AddItemsToPurchaseOrder(int poNumber, [FromBody] Item item)
        {
            try
            {
                if (poNumber <= 0)
                    return BadRequest("Invalid purchase order number.");

                if (item == null)
                    return BadRequest("Items cannot be null or empty.");

                bool result = await service.AddItem(poNumber, item);

                if (result)
                    return Ok("Items added successfully.");
                else
                    return BadRequest("Failed to add items to the purchase order.");
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");
            }
        }


        // GET: api/PurchaseOrder/Employee
        [Authorize]
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

                // Format the PO numbers and include all the purchase order details
                var response = purchaseOrders.Select(po => new PurchaseOrder
                {
                    PoNumber = po.PoNumber,
                    CreationDate = po.CreationDate,
                    RowVersion = po.RowVersion,
                    EmployeeNumber = po.EmployeeNumber,
                    EmployeeName = po.EmployeeName,
                    EmployeeSupervisorName = po.EmployeeSupervisorName,
                    EmpDepartmentName = po.EmpDepartmentName,
                    PurchaseOrderStatus = po.PurchaseOrderStatus,
                    StatusId = po.StatusId,
                    Items = po.Items,
                    HasMergeOccurred = po.HasMergeOccurred,
                    FormattedPoNumber = "00001" + po.PoNumber.ToString("D2"),
                }).ToList();

                return Ok(response);
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");
            }
        }

    }
}
