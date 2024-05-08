using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model;

namespace TotalAdmin.Repository
{
    public interface IEmployeeRepository
    {
        Task<Employee?> GetEmployeeByIdAsync(int id);
        Employee? GetEmployeeById(int id);
        Task<List<Employee>> GetEmployeeListAsync();
        Task<Employee> AddEmployeeAsync(Employee employee);
        Employee AddEmployee(Employee employee);
        Task<List<EmployeeDetailDTO>> SearchEmployeesAsync(int department, int employeeNumber, string? name);
        Task<int> GetEmployeesInDepartmentCountAsync(int department);
        int GetEmployeesInDepartmentCount(int department);
        Task<int> GetEmployeesForSupervisorCountAsync(int supervisor);
        int GetEmployeesForSupervisorCount(int supervisor);
        Task<List<Employee>> GetSupervisors(int roleId, int departmentId);
        Task<List<EmployeeDetailDTO>> SearchEmployeeDirectory(int employeeNumber, string? lastName);
        Task<EmployeeDetailDTO?> GetEmployeeDetailById(int? id);
    }
}
