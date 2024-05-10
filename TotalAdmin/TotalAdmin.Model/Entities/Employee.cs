using System.ComponentModel.DataAnnotations;
using TotalAdmin.Model.Entities;

namespace TotalAdmin.Model
{
    public class Employee : BaseEntity
    {
        public int EmployeeNumber { get; set; }
        [Required(ErrorMessage = "Password is required")]
        [IgnoreRegexIfTrue(true)]
        //[RegularExpression("^(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+{}\\[\\]:;<>,.?\\/\\\\|-]).{6,}$", ErrorMessage = "Password must have 1 uppercase letter, 1 number, and 1 special character")]
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
        [RegularExpression("^[ABCEGHJKLMNPRSTVWXYZabceghjklmnprstvwxyz]\\d[ABCEGHJKLMNPRSTVWXYZabceghjklmnprstvwxyz][ -]?\\d[ABCEGHJKLMNPRSTVWXYZabceghjklmnprstvwxyz]\\d$", ErrorMessage = "Please enter a valid Canadian postal code")]
        public string? PostalCode { get; set; }
        [Required]
        public string? City { get; set; }
        [Required]
        [RegularExpression("^\\d{9}$", ErrorMessage = "SIN must be a 9 digit number")]
        public string? SIN { get; set; }
        [Required(ErrorMessage = "Work phone number is required")]
        [RegularExpression("^\\(?([0-9]{3})\\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$", ErrorMessage = "Please enter a valid phone number")]
        public string? WorkPhoneNumber { get; set; }
        [Required(ErrorMessage = "Cell phone number is required")]
        [RegularExpression("^\\(?([0-9]{3})\\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$", ErrorMessage = "Please enter a valid phone number")]
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
        public DateTime? RetiredDate { get; set; }
        public DateTime? TerminatedDate { get; set; }
        public int StatusId { get; set; }
        public int RoleId { get; set; }
        public byte[]? RowVersion { get; set; }
    }
}
