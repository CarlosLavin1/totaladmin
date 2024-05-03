using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TotalAdmin.Model.Entities
{
    public class Item : BaseEntity
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ItemId { get; set; }

        [Required(ErrorMessage = "Item name is required.")]
        [StringLength(45, MinimumLength = 3, ErrorMessage = "Item name must be between 3 and 45 characters.")]
        public string Name { get; set; }

        [Required(ErrorMessage = "Item quantity is required.")]
        [Range(1, int.MaxValue, ErrorMessage = "Item quantity must be greater than zero.")]
        public int Quantity { get; set; }

        [Required(ErrorMessage = "Item description is required.")]
        [MinLength(5, ErrorMessage = "Item description must be at least 5 characters.")]
        public string Description { get; set; }

        [Required(ErrorMessage = "Item price is required.")]
        [Range(0.01, double.MaxValue, ErrorMessage = "Item price must be greater than zero.")]
        public decimal Price { get; set; }

        [Required(ErrorMessage = "Item justification is required.")]
        [MinLength(4, ErrorMessage = "Item justification must be at least 4 characters.")]
        public string Justification { get; set; }

        [Required(ErrorMessage = "Item purchase location is required.")]
        [MinLength(5, ErrorMessage = "Item purchase location must be at least 5 characters.")]
        public string Location { get; set; }

        [Required(ErrorMessage = "Status is required.")]
        public int StatusId { get; set; }
        public int RowVersion { get; set; }

        [Required(ErrorMessage = "Purchase order number is required.")]
        public int PoNumber { get; set; }
    }
}
