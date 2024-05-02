using System.ComponentModel.DataAnnotations;
using TotalAdmin.Model.Entities;

namespace TotalAdmin.Model
{
    public class Employee : BaseEntity
    {
        public int EmployeeNumber { get; set; }
        [Required] 
        public string? HashedPassword { get; set;}
        [Required]
        public string? FirstName { get; set; }
        public char? MiddleInitial { get; set; }
        [Required]
        public string? LastName { get; set; }
        [Required]
        public DateTime? DateOfBirth { get; set; }
        [Required]
        public string? StreetAddress { get; set; }
        [Required]
        [RegularExpression("/^[ABCEGHJ-NPRSTVXY]\\d[ABCEGHJ-NPRSTV-Z][ -]?\\d[ABCEGHJ-NPRSTV-Z]\\d$/", ErrorMessage = "Please enter a valid Canadian postal code")]
        public string? PostalCode { get; set; }
        [Required]
        public string? City { get; set; }
        [Required]
        [MaxLength(9, ErrorMessage = "SIN must be 9 digits")]
        public string? SIN { get; set; }
        [Required]
        public string? WorkPhoneNumber { get; set; }
        [Required]
        public string? CellPhoneNumber { get; set; }
        [Required]
        public string? Email { get; set; }
        [Required]
        public DateTime? SeniorityDate { get; set; }
        public int SupervisorEmployeeNumber { get; set; }
        [Required]
        public int DepartmentId { get; set; }
        [Required]
        public DateTime? JobStartDate { get; set; }
    }
}
