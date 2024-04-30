using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TotalAdmin.Model
{
    public class Department
    {
        public int DepartmentId { get; set; }
        public string? DepartmentName { get; set; }
        public string? DepartmentDescription { get; set; }
        public DateTime? InvocationDate { get; set; }
        public bool IsActive { get; set; }
    }
}
