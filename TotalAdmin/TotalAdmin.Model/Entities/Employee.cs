using System.ComponentModel.DataAnnotations;
using TotalAdmin.Model.Entities;

namespace TotalAdmin.Model
{
    public class Employee : BaseEntity
    {
        public int EmployeeNumber { get; set; }
        [Required(ErrorMessage = "Password is required")]
        [RegularExpression("^(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+{}\\[\\]:;<>,.?\\/\\\\|-]).{6,}$", ErrorMessage = "Password must have 1 uppercase letter, 1 number, and 1 special character")]
        public string? HashedPassword { get; set;}
        [Required]
        [StringLength(50, MinimumLength = 2)]
        public string? FirstName { get; set; }
        public char? MiddleInitial { get; set; }
        [Required]
        [StringLength(50, MinimumLength = 3)]
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
        [Required(ErrorMessage = "Work phone number is required")]
        public string? WorkPhoneNumber { get; set; }
        [Required(ErrorMessage = "Cell phone number is required")]
        public string? CellPhoneNumber { get; set; }
        [Required]
        [EmailAddress]
        public string? Email { get; set; }
        [Required]
        public DateTime? SeniorityDate { get; set; }
        [Required(ErrorMessage = "Supervisor is required")]
        public int SupervisorEmployeeNumber { get; set; }
        [Required]
        public int DepartmentId { get; set; }
        [Required]
        public DateTime? JobStartDate { get; set; }
        [Required]
        public string? JobTitle { get; set; }
        [Required]
        public string? OfficeLocation { get; set; }
        public bool IsActive { get; set; }
        public int RoleId { get; set; }
        public int RowVersion { get; set; }
    }
}
