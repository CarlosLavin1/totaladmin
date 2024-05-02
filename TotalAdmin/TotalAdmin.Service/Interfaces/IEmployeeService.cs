using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model;

namespace TotalAdmin.Service
{
    public interface IEmployeeService
    {
        Task<Employee> AddEmployeeAsync(Employee employee);
        Task<List<EmployeeDisplayDTO>> SearchEmployeesAsync(int department, int employeeNumber, string? lastName);
    }
}
