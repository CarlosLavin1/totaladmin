using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using TotalAdmin.Model;
using TotalAdmin.Service;
using Microsoft.AspNetCore.Authorization;

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

        [Authorize(Roles = "CEO")]
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
    }
}
