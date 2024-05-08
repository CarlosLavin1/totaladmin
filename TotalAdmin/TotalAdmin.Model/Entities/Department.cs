using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model.Entities;

namespace TotalAdmin.Model
{
    public class Department : BaseEntity
    {
        public int Id { get; set; }
        [Required]
        [StringLength(128, MinimumLength = 3)]
        public string? Name { get; set; }
        [Required]
        [StringLength(512)]
        public string? Description { get; set; }
        [Required]
        public DateTime? InvocationDate { get; set; }
        public byte[]? RowVersion { get; set; }
    }
}
