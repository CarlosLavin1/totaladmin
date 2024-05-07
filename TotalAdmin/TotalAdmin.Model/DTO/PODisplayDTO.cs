using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TotalAdmin.Model.DTO
{
    public class PODisplayDTO
    {
        public int PoNumber { get; set; }
        public DateTime CreationDate { get; set; }
        public string Status { get; set; }
        public decimal Subtotal { get; set; }
        public decimal Tax { get; set; }
        public decimal GrandTotal { get; set; }
        public string FormattedPoNumber { get; set; }
    }
}
