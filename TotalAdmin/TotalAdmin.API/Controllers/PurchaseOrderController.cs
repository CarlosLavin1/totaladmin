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
        private readonly EmailService _emailService;

        public PurchaseOrderController(IPurchaseOrderService s, EmailService emailService)
        {
            this.service = s;
            _emailService = emailService;
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

                    // Format the PO numbers
                    var response = po.Select(p => new POSearchResultsApiDTO
                    {
                        PoNumber = p.PoNumber,
                        CreationDate = p.CreationDate,
                        SupervisorName = p.SupervisorName,
                        Status = p.Status,
                        TotalItems = p.TotalItems,
                        GrandTotal = p.GrandTotal,
                        FormattedPoNumber = "00001" + p.PoNumber.ToString("D2")
                    }).ToList();

                    return Ok(response);
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

                if (filter.StartDate.HasValue && filter.EndDate.HasValue && filter.EndDate < filter.StartDate)
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

        // GET: api/PurchaseOrder/Supervisor
        [Authorize]
        [HttpGet("Supervisor/PurchaseOrders/Search")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<List<PurchaseOrder>>> SearchPurchaseOrdersForSupervisor([FromQuery] POSupervisorFiltersDTO filters)
        {
            try
            {
                // Check for the specific employee
                if (filters.DepartmentId == 0)
                {
                    return BadRequest("Department Id is required.");
                }

                if (filters.StartDate.HasValue && filters.EndDate.HasValue && filters.StartDate > filters.EndDate)
                {
                    return BadRequest("Start Date cannot be later than End Date.");
                }

                if (filters.StartDate.HasValue && filters.EndDate.HasValue && filters.EndDate < filters.StartDate)
                {
                    return BadRequest("End Date cannot be before Start Date.");
                }


                List<PurchaseOrder> purchaseOrders = await service.SearchPurchaseOrdersForSupervisor(filters);
                if (purchaseOrders == null || !purchaseOrders.Any())
                {
                    return NotFound("No purchase orders found for the provided filters.");
                }

                // Format the PO numbers and include all the purchase order details
                var response = purchaseOrders.Select(po => new PurchaseOrder
                {
                    PoNumber = po.PoNumber,
                    CreationDate = po.CreationDate,
                    EmployeeName = po.EmployeeName,
                    PurchaseOrderStatus = po.PurchaseOrderStatus,
                    Items = po.Items,
                    FormattedPoNumber = "00001" + po.PoNumber.ToString("D2"),
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

        // PUT: api/purchaseOrder/update/{id}
        [Authorize]
        [HttpPut("update/{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<PurchaseOrder>> Update(int id, [FromBody] PurchaseOrder po)
        {
            try
            {
                if (id <= 0)
                    return BadRequest("Invalid ID. ID must be greater than 0.");

                if (po == null)
                    return BadRequest("Purchase order cannot be null.");

                // Ensure the ID in the URL matches the ID in the body
                if (id != po.PoNumber)
                    return BadRequest("Mismatch between URL and body data.");

                po = await service.UpdatePurchaseOrder(id, po);

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

                return Ok(response);
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");
            }
        }


        // GET: api/PurchaseOrder/{poNumber}
        [Authorize]
        [HttpGet("get-existing-po/{poNumber}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<PurchaseOrder>> GetExistingPurchaseOrder(int poNumber)
        {
            try
            {
                if (poNumber <= 0)
                    return BadRequest("Invalid PO number. PO number must be greater than 0.");

                PurchaseOrder po = await service.GetExistingPurchaseOrder(poNumber);

                if (po == null)
                    return NotFound($"Purchase order with number {poNumber} not found.");


                return Ok(po);
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


        // GET: api/PurchaseOrder/Department
        [Authorize]
        [HttpGet("department/{departmentId}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<List<PurchaseOrder>>> GetPurchaseOrdersForDepartment([FromRoute] int departmentId)
        {
            try
            {
                List<PurchaseOrder> purchaseOrders = await service.GetPurchaseOrdersForDepartment(departmentId);

                if (purchaseOrders == null || !purchaseOrders.Any())
                {
                    return NotFound("No purchase orders found for the provided department.");
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

        // PUT: api/PurchaseOrder/ClosePO/{PONumber}
        [Authorize]
        [HttpPut("ClosePO/{PONumber}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<PurchaseOrder>> ClosePO(int PONumber)
        {
            try
            {
                PurchaseOrder po = await service.ClosePO(PONumber);

                if (po == null)
                {
                    return NotFound("Purchase order not found.");
                }

                // Send an email notification
                EmailDTO email = new EmailDTO
                {
                    To = po.EmployeeEmail, 
                    From = "totalAdmin@mail.com",
                    Subject = "Your PO request has been processed",
                    Body = $"Your purchase order (PO Number: {po.FormattedPoNumber}) has been closed and processed."
                };

                _emailService.Send(email);


                return Ok(po);
            }
            catch (Exception ex)
            {
                return Problem(ex.Message);
            }
        }


        // PUT: api/PurchaseOrder/{id}
        [Authorize]
        [HttpPut("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> UpdatePurchaseOrder(int id)
        {
            try
            {
                // Check if the id is valid
                if (id <= 0)
                    return BadRequest("Invalid purchase order number.");

                await service.UpdatePurchaseOrder(id);

                return Ok("Purchase order updated successfully.");
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator");
            }
        }
    }
}
