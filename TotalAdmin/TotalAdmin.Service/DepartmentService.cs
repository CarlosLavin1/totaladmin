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
    public class DepartmentService : IDepartmentService
    {
        private readonly IDepartmentRepository repo;

        public DepartmentService(IDepartmentRepository repo)
        {
            this.repo = repo;
        }

        public async Task<List<DepartmentDisplayDTO>> GetActiveDepartments()
        {
            return await repo.GetActiveDepartmentsAsync();
        }

        public async Task<Department> AddDepartmentAsync(Department department)
        {
            if (ValidateDepartment(department))
                return await repo.AddDepartmentAsync(department);

            return department;
        }

        public Department AddDepartment(Department department)
        {
            if (ValidateDepartment(department))
                return repo.AddDepartment(department);

            return department;
        }

        public Department UpdateDepartment(Department department)
        {
            if (ValidateDepartmentUpdate(department))
                return repo.UpdateDepartment(department);

            return department;
        }

        public async Task<Department?> GetDepartmentForEmployeeAsync(int employeeNumber)
        {
            return await repo.GetDepartmentForEmployeeAsync(employeeNumber);
        }

        private bool ValidateDepartment(Department department)
        {
            // Validate Entity
            List<ValidationResult> results = new();
            Validator.TryValidateObject(department, new ValidationContext(department), results, true);

            foreach (ValidationResult e in results)
            {
                department.AddError(new(e.ErrorMessage, ErrorType.Model));
            }
            // validate invication date is not in the past
            // invocation date can be the same as the one in the database when updating
            if (department.InvocationDate != null && department.InvocationDate < DateTime.Now.Date)
                department.AddError(new("Invocation date cannot be in the past", ErrorType.Business));

            return !department.Errors.Any();
        }

        private bool ValidateDepartmentUpdate(Department department)
        {
            // Validate Entity
            List<ValidationResult> results = new();
            Validator.TryValidateObject(department, new ValidationContext(department), results, true);

            foreach (ValidationResult e in results)
            {
                department.AddError(new(e.ErrorMessage, ErrorType.Model));
            }
            // validate invication date is not in the past
            // invocation date can be the same as the one in the database when updating
            //if (department.InvocationDate != null && department.InvocationDate < DateTime.Now.Date)
            //    department.AddError(new("Invocation date cannot be in the past", ErrorType.Business));

            return !department.Errors.Any();
        }
    }
}
