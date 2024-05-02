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
        Task<List<Employee>> GetEmployeeListAsync();
        Task<Employee> AddEmployeeAsync(Employee employee);
        Task<List<EmployeeDisplayDTO>> SearchEmployeesAsync(int department, int employeeNumber, string? name);
    }
}
