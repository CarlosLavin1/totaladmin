using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TotalAdmin.Model.Entities
{
    public class Item : BaseEntity
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int Quantiy { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public string Justification { get; set; }
        public string Location { get; set; }
        public int StatusId { get; set; }
        public int RowVersion { get; set; }
    }
}
