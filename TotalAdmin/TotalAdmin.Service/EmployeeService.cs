using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model;
using TotalAdmin.Repository;
using TotalAdmin.Types;

namespace TotalAdmin.Service
{
    public class EmployeeService : IEmployeeService
    {
        private readonly IEmployeeRepository repo;

        public EmployeeService(IEmployeeRepository repo)
        {
            this.repo = repo;
        }

        public async Task<Employee> AddEmployeeAsync(Employee employee)
        {
            if (ValidateEmployee(employee))
                return await repo.AddEmployeeAsync(employee);

            return employee;
        }

        public async Task<List<EmployeeDisplayDTO>> SearchEmployeesAsync(int department, int employeeNumber, string? lastName)
        {
            return await repo.SearchEmployeesAsync(department, employeeNumber, lastName);
        }

        private bool ValidateEmployee(Employee employee)
        {
            // Validate Entity
            List<ValidationResult> results = new();
            Validator.TryValidateObject(employee, new ValidationContext(employee), results, true);

            foreach (ValidationResult e in results)
            {
                employee.AddError(new(e.ErrorMessage, ErrorType.Model));
            }

            return employee.Errors.Any();
        }
    }
}
