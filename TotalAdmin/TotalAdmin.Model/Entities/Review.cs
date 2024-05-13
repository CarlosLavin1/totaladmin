using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TotalAdmin.Model 
{ 
    public class Review
    {
        public int Id { get; set; }
        public string? Rating { get; set; }
        public string? Comment { get; set; }
        public int Quarter { get; set; }
        public DateTime? Date { get; set; }
        public int EmployeeNumber { get; set; }
        public int SupervisorEmployeeNumber { get; set; }
    }
}
