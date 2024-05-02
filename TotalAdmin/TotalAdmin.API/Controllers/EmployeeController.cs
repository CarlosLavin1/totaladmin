﻿using Microsoft.AspNetCore.Mvc;
using TotalAdmin.Model;
using TotalAdmin.Service;

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

        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<Employee>> Create(Employee employee)
        {
            try
            {
                employee = await employeeService.AddEmployeeAsync(employee);

                if (employee.Errors.Count != 0)
                    // return status 400
                    return BadRequest(employee);

                return CreatedAtAction("Get", new { id = employee.EmployeeNumber }, employee);
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        [HttpGet("search")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<EmployeeDisplayDTO>>> SearchEmployees(EmployeeSearchDTO filters)
        {
            try
            {
                int department = filters.Department ?? 0;
                int employeeNumber = filters.EmployeeNumber ?? 0;
                string? lastName = filters.LastName;
                List<EmployeeDisplayDTO> employees = await employeeService.SearchEmployeesAsync(department, employeeNumber,lastName);

                return employees;
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }
    }
}
