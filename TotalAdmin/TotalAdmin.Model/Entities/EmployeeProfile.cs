using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TotalAdmin.Model
{
    public class EmployeeProfile
    {
        public int Username { get; set; }
        public string? Password { get; set; }
        public bool IsActive { get; set; }
        public bool IsCEO { get; set; }
    }
}
