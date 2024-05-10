using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model.Entities;

namespace TotalAdmin.Model.DTO
{
    public class POSearchResultsApiDTO
    {
        public int PoNumber { get; set; }
        public DateTime CreationDate { get; set; }
        public string? SupervisorName { get; set; }
        public string? Status { get; set; }

        public int TotalItems { get; set; }

        public decimal GrandTotal {  get; set; }
        public string FormattedPoNumber { get; set; }
    }
}
