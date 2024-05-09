using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using TotalAdmin.Model;
using TotalAdmin.Service;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Data.SqlClient;

namespace TotalAdmin.API.Controllers
{
    [Route("api/department")]
    [ApiController]
    public class DepartmentController : Controller
    {
        private readonly IDepartmentService departmentService;

        public DepartmentController(IDepartmentService departmentService)
        {
            this.departmentService = departmentService;
        }

        [HttpGet("employee/{id}")]
        public async Task<ActionResult<Department>> GetDepartmentForEmployee(int id)
        {
            try
            {
                Department? d = await departmentService.GetDepartmentForEmployeeAsync(id);
                if (d == null)
                    return NotFound();
                return Ok(d);
            }
            catch (Exception e)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Department>> GetDepartmentById(int id)
        {
            try
            {
                Department? d = await departmentService.GetDepartmentById(id);
                if (d == null)
                    return NotFound();
                return Ok(d);
            }
            catch (Exception e)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        [Authorize(Roles = "Employee, HR Employee")]
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<DepartmentDisplayDTO>>> GetActiveDepartments()
        {
            try
            {
                List<DepartmentDisplayDTO> departments = await departmentService.GetActiveDepartments();

                return departments;
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        [Authorize(Roles = "HR Employee")]
        [HttpPost]
        //[ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public ActionResult<Department> Create(Department department)
        {
            try
            {
                department = departmentService.AddDepartment(department);

                if (department.Errors.Count != 0)
                    // return status 400
                    return BadRequest(department);

                // this returns get route for newly created department
                //return CreatedAtAction("Get", new { id = department.Id }, department);
                return Ok(department);
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        [Authorize(Roles = "Supervisor, HR Employee")]
        [HttpPut("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public ActionResult<Department> Update(int id, Department department)
        {
            try
            {
                if (department == null || id != department.Id)
                    return BadRequest();

                department = departmentService.UpdateDepartment(department);

                if (department.Errors.Count > 0)
                    return BadRequest(department);

                return department;
            }
            catch(SqlException e)
            {
                return e.Number == 50100 ? BadRequest(e.Message) : BadRequest();
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }

        }
    }
}
