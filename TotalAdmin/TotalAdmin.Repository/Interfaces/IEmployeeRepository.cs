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
        Employee? GetEmployeeById(int id);
        List<Employee> GetEmployeeList();
        Employee AddEmployee(Employee employee);
        List<EmployeeDisplayDTO> SearchEmployees(string? department, int employeeNumber, string? name);
    }
}
