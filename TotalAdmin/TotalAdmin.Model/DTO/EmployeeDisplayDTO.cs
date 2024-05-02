using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TotalAdmin.Model
{
    public class EmployeeDisplayDTO
    {
        public int EmployeeNumber { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? WorkPhone { get; set; }
        public string? OfficeLocation { get; set; }
        public string? JobTitle { get; set; }
    }
}
