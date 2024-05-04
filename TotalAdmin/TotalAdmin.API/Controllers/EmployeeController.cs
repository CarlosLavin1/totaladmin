using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using TotalAdmin.Model;
using TotalAdmin.Service;
using TotalAdmin.Types;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace TotalAdmin.API.Controllers
{
    [Route("api/employee")]
    [ApiController]
    public class EmployeeController : Controller
    {
        private readonly IEmployeeService employeeService;

        public EmployeeController(IEmployeeService employeeService)
        {
            this.employeeService = employeeService;
        }

        [Authorize(Roles = "HR Employee")]
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public ActionResult<Employee> Create(Employee employee)
        {
            try
            {
                employee = employeeService.AddEmployee(employee);

                if (employee.Errors.Count != 0)
                    // return status 400
                    return BadRequest(employee);

                //return CreatedAtAction("Get", new { id = employee.EmployeeNumber }, employee);
                return Ok(employee);
                // duplicate SIN will throw a unique constraint violation exception from the stored proc
            }
            catch (SqlException e)
            {
                if(e.Number == 2627 || e.Number == 2601)
                {
                    employee.AddError(new("SIN already exists in the database", ErrorType.Business));
                    return BadRequest(employee);
                } else
                {
                    employee.AddError(new("An internal error has occurred, please refresh the page", ErrorType.Business));
                    return BadRequest(employee);
                }
            }
            catch (Exception e)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        [Authorize(Roles = "Employee")]
        [HttpGet("search")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<EmployeeDisplayDTO>>> SearchEmployees(EmployeeSearchDTO filters)
        {
            try
            {
                int department = filters.Department ?? 0;
                int employeeNumber = int.TryParse(Convert.ToString(filters.EmployeeNumber), out _) && Convert.ToString(filters.EmployeeNumber ?? 0).Length == 8 ? filters.EmployeeNumber ?? 0 : 0;
                string? lastName = filters.LastName;
                List<EmployeeDisplayDTO> employees = await employeeService.SearchEmployeesAsync(department, employeeNumber,lastName);

                return employees;
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        [Authorize(Roles = "HR Employee")]
        [HttpPost("supervisors")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<Employee>>> GetSupervisors(SupervisorSearchDTO supervisorSearchDTO)
        {
            try
            {
                List<Employee> employees = await employeeService.GetSupervisors(supervisorSearchDTO.RoleId, supervisorSearchDTO.DepartmentId);

                return employees;
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }
    }
}
