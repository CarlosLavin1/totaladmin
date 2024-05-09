using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model;

namespace TotalAdmin.Repository
{
    public interface IDepartmentRepository
    {
        Task<List<DepartmentDisplayDTO>> GetActiveDepartmentsAsync();
        Task<Department> AddDepartmentAsync(Department department);
        Department AddDepartment(Department department);
        Task<Department?> GetDepartmentForEmployeeAsync(int employeeNumber);
        Department? GetDepartmentForEmployee(int employeeNumber);
        Department UpdateDepartment(Department department);
        Task<Department?> GetDepartmentById(int id);
        DateTime? GetOldInvocationDate(int departmentId);
    }
}
