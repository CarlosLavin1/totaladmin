using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TotalAdmin.Model.Entities
{
    public class PurchaseOrder : BaseEntity
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int PoNumber { get; set; }

        [Display(Name = "Creation Date")]
        [Required(ErrorMessage = "Please enter a Creation date.")]
        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0: yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        public DateTime CreationDate { get; set; }

        [ConcurrencyCheck]
        public byte[]? RowVersion { get; set; }

        [Display(Name = "Employee Number")]
        [Required(ErrorMessage = "Please select a employee.")]
        public int EmployeeNumber { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeSupervisorName { get; set; }
        public string EmpDepartmentName { get; set; }
        public string PurchaseOrderStatus { get; set; }

        [Display(Name = "Status")]
        [Required(ErrorMessage = "Please select a status.")]
        public int StatusId { get; set; }

        // Navigation property
        public ICollection<Item>? Items { get; set; }
        public bool HasMergeOccurred { get; set; }
        public string FormattedPoNumber { get; set; }
        public string EmployeeEmail { get; set; }

        // Derived properties
        public decimal Subtotal => Items?.Sum(item => item.Subtotal) ?? 0;
        public decimal Tax => Items?.Sum(item => item.Tax) ?? 0;
        public decimal GrandTotal => Items?.Sum(item => item.GrandTotal) ?? 0;
    }
}
