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
    public class DepartmentService
    {
        private readonly DepartmentRepository repo;

        public DepartmentService(DepartmentRepository repo)
        {
            this.repo = repo;
        }

        public async Task<List<DepartmentDisplayDTO>> GetActiveDepartments()
        {
            return await repo.GetActiveDepartmentsAsync();
        }

        public async Task<Department> AddDepartment(Department department)
        {
            if (ValidateDepartment(department))
                return await repo.AddDepartmentAsync(department);

            return department;
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

            return department.Errors.Any();
        }
    }
}
