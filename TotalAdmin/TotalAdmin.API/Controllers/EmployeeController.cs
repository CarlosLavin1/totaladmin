﻿using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using TotalAdmin.Model;
using TotalAdmin.Model.DTO;
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

        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public ActionResult<Employee> Get(int id)
        {
            try
            {
                Employee? e = employeeService.GetEmployeeById(id);
                if (e == null) 
                    return NotFound();
                return Ok(e);
            }
            catch (Exception ex)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        [Authorize(Roles = "Supervisor, HR Employee, Employee")]
        [HttpPut("personal/{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public ActionResult<Employee> UpdatePersonalInfo(int id, Employee emp)
        {
            try
            {
                if (emp == null || id != emp.EmployeeNumber)
                    return BadRequest();

                emp = employeeService.UpdatePersonalInfo(emp);

                if (emp.Errors.Count > 0)
                    return BadRequest(emp);

                return emp;
            }
            catch (SqlException e)
            {
                return e.Number == 50100 ? BadRequest(e.Message) : BadRequest();
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }

        }

        [Authorize(Roles = "HR Employee")]
        [HttpPut("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public ActionResult<Employee> Update(int id, Employee emp)
        {
            try
            {
                if (emp == null || id != emp.EmployeeNumber)
                    return BadRequest();

                emp = employeeService.UpdateEmployee(emp);

                if (emp.Errors.Count > 0)
                    return BadRequest(emp);

                return emp;
            }
            catch (SqlException e)
            {
                return e.Number == 50100 ? BadRequest(e.Message) : BadRequest();
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }

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
        [HttpPost("search")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<EmployeeDetailDTO>>> SearchEmployees(EmployeeSearchDTO filters)
        {
            try
            {
                int department = filters.Department ?? 0;
                int employeeNumber = filters.EmployeeNumber ?? -999999999;
                string? lastName = filters.LastName;
                List<EmployeeDetailDTO> employees = await employeeService.SearchEmployeesAsync(department, employeeNumber,lastName);

                return employees;
            }
            catch (Exception e)
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

        [Authorize(Roles = "HR Employee")]
        [HttpPost("directory")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<EmployeeDetailDTO>>> SearchEmployeeDirectory(EmployeeDirectorySearchDTO filters)
        {
            try
            {
                // user story 37
                int employeeNumber = filters.EmployeeNumber ?? -1;
                string? lastName = filters.LastName;
                List<EmployeeDetailDTO> employees = await employeeService.SearchEmployeeDirectory(employeeNumber, lastName);

                return employees;
            }
            catch (Exception e)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        [Authorize(Roles = "Employee")]
        [HttpGet("detail/{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<EmployeeDetailDTO>> GetEmployeeDetail(int? id)
        {
            try
            {
                if (id == null)
                    return NotFound();
                EmployeeDetailDTO? employee = await employeeService.GetEmployeeDetailById(id);

                if (employee == null)
                    return NotFound();
                return employee;
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        [Authorize(Roles = "Supervisor, HR Employee")]
        [HttpGet("count/{supervisorEmpNumber}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<int>> CountEmployeesBySupervisorAsync(int supervisorEmpNumber)
        {
            try
            {
                int count = await employeeService.CountEmployeesBySupervisorAsync(supervisorEmpNumber);
                return Ok(count);
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        [Authorize(Roles = "Supervisor, HR Employee")]
        [HttpGet("unread-reviews-by-department/{departmentId}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<EmployeeDetailsWithUnreadReviewsDTO>>> GetUnreadEmployeeReviewsByDepartmentAsync(int departmentId)
        {
            try
            {
                List<EmployeeDetailsWithUnreadReviewsDTO> details = await employeeService.GetUnreadEmployeeReviewsByDepartment(departmentId);
                return Ok(details);
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }
    }
}
