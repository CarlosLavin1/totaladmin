﻿using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using TotalAdmin.Model;
using TotalAdmin.Service;

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
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<Department>> Create(Department department)
        {
            try
            {
                department = await departmentService.AddDepartment(department);

                if (department.Errors.Count != 0)
                    // return status 400
                    return BadRequest(department);

                return CreatedAtAction("Get", new { id = department.Id }, department);
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }
    }
}
