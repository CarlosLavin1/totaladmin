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
            {
                // if the password is valid, hash it before sending it to the repo
                string password = employee.HashedPassword ?? "";
                employee.HashedPassword = PasswordUtil.HashToSHA256(password);
                return repo.AddEmployee(employee);
            }
                
            return employee;
        }

        public async Task<Employee> AddEmployeeAsync(Employee employee)
        {
            if (await ValidateEmployeeAsync(employee))
            {
                // if the password is valid, hash it before sending it to the repo
                string password = employee.HashedPassword ?? "";
                employee.HashedPassword = PasswordUtil.HashToSHA256(password); 
                return await repo.AddEmployeeAsync(employee);
            }
                
            return employee;
        }

        public async Task<List<EmployeeDisplayDTO>> SearchEmployeesAsync(int department, int employeeNumber, string? lastName)
        {
            return await repo.SearchEmployeesAsync(department, employeeNumber, lastName);
        }

        public async Task<List<Employee>> GetSupervisors(int roleId, int departmentId)
        {
            return await repo.GetSupervisors(roleId, departmentId);
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
            //validate employee is 16
            if (employee.DateOfBirth != null && employee.DateOfBirth >= DateTime.Today.AddYears(-16))
                employee.AddError(new("Employee must be at least 16 years of age", ErrorType.Model));

            // validate job start date is after seniority date
            if (employee.JobStartDate != null && employee.SeniorityDate != null && employee.JobStartDate >= employee.SeniorityDate)
                employee.AddError(new("Job start date cannot be before seniority date", ErrorType.Business));

            // validate supervisor does not already have 10 employees
            if (GetEmployeesForSupervisorCount(employee.SupervisorEmployeeNumber) >= 10)
                employee.AddError(new("Supervisor already has 10 employees, add another supervisor for this department", ErrorType.Business));

            //validate employee and supervisor have same department and roles match

            return !employee.Errors.Any();
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

            // validate supervisor does not already have 10 employees
            if (await GetEmployeesForSupervisorCountAsync(employee.SupervisorEmployeeNumber) >= 10)
                employee.AddError(new("Supervisor already has 10 employees, add another supervisor for this department", ErrorType.Business));

            return !employee.Errors.Any();
        }

        public async Task<int> GetEmployeesInDepartmentCountAsync(int department)
        {
            return await repo.GetEmployeesInDepartmentCountAsync(department);
        }

        public int GetEmployeesInDepartmentCount(int department)
        {
            return repo.GetEmployeesInDepartmentCount(department);
        }

        public async Task<int> GetEmployeesForSupervisorCountAsync(int supervisor)
        {
            return await repo.GetEmployeesForSupervisorCountAsync(supervisor);
        }

        public int GetEmployeesForSupervisorCount(int supervisor)
        {
            return repo.GetEmployeesForSupervisorCount(supervisor);
        }
    }
}
