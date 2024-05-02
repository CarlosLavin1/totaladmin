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

        public Employee AddEmployee(Employee employee)
        {
            if (ValidateEmployee(employee))
                return repo.AddEmployee(employee);

            return employee;
        }

        public async Task<Employee> AddEmployeeAsync(Employee employee)
        {
            if (await ValidateEmployeeAsync(employee))
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
            // validate job start date is after seniority date
            if (employee.JobStartDate != null && employee.SeniorityDate != null && employee.JobStartDate >= employee.SeniorityDate)
                employee.AddError(new("Job start date cannot be before seniority date", ErrorType.Business));

            // validate department does not already have 10 employees
            if (GetEmployeesInDepartmentCount(employee.DepartmentId) == 0)
                employee.AddError(new("Department already has 10 employees", ErrorType.Business));

            return employee.Errors.Any();
        }

        private async Task<bool> ValidateEmployeeAsync(Employee employee)
        {
            // Validate Entity
            List<ValidationResult> results = new();
            Validator.TryValidateObject(employee, new ValidationContext(employee), results, true);

            foreach (ValidationResult e in results)
            {
                employee.AddError(new(e.ErrorMessage, ErrorType.Model));
            }
            // validate job start date is after seniority date
            if (employee.JobStartDate != null && employee.SeniorityDate != null && employee.JobStartDate >= employee.SeniorityDate)
                employee.AddError(new("Job start date cannot be before seniority date", ErrorType.Business));

            // validate department does not already have 10 employees
            if (await GetEmployeesInDepartmentCountAsync(employee.DepartmentId) == 0)
                employee.AddError(new("Department already has 10 employees", ErrorType.Business));

            return employee.Errors.Any();
        }

        public async Task<int> GetEmployeesInDepartmentCountAsync(int department)
        {
            return await repo.GetEmployeesInDepartmentCountAsync(department);
        }

        public int GetEmployeesInDepartmentCount(int department)
        {
            return repo.GetEmployeesInDepartmentCount(department);
        }
    }
}
