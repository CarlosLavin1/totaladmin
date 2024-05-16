using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TotalAdmin.Model
{
    public class MissingReviewDTO
    {
        public int EmployeeNumber { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public int Year { get; set; }
        public int Quarter { get; set; }
    }
}
