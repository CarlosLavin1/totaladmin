using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model;
using TotalAdmin.Types;

namespace TotalAdmin.Service
{
    public interface IDepartmentService
    {
        Task<List<DepartmentDisplayDTO>> GetActiveDepartments();
        Task<List<DepartmentDisplayDTO>> GetAllDepartmentsAsync();
        Task<Department> AddDepartmentAsync(Department department);
        Department AddDepartment(Department department);
        Department UpdateDepartment(Department department);
        Task<Department?> GetDepartmentForEmployeeAsync(int employeeNumber);
        Task<Department?> GetDepartmentById(int id);
        DateTime? GetOldInvocationDate(int departmentId);
        bool DeleteDepartment(int departmentId);
    }
}
