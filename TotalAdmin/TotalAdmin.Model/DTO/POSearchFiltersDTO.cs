using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TotalAdmin.Model.DTO
{
    public class POSearchFiltersDTO
    {
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? PONumber { get; set; }
        public int? EmployeeNumber { get; set; }
      
    }
}
