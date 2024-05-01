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
    }
}
