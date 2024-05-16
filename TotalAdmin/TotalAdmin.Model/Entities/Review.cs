using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model.Entities;

namespace TotalAdmin.Model 
{ 
    public class Review : BaseEntity
    {
        public int Id { get; set; }
        [Required]
        public int RatingId { get; set; }
        [Required]
        public string? Comment { get; set; }
        public bool HasBeenRead { get; set; }
        [Required]
        public DateTime? ReviewDate { get; set; }
        public int EmployeeNumber { get; set; }
        public int SupervisorEmployeeNumber { get; set; }
    }
}
