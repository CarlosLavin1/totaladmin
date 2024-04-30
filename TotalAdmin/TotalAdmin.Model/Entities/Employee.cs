using System.ComponentModel.DataAnnotations;
using TotalAdmin.Model.Entities;

namespace TotalAdmin.Model
{
    public class Employee : BaseEntity
    {
        public int EmployeeNumber { get; set; }
        [Required]
        public string? FirstName { get; set; }
        public char? MiddleInitial { get; set; }
        [Required]
        public string? LastName { get; set; }
        public int Age { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public string? StreetAddress { get; set; }
        public string? PostalCode { get; set; }
        public string? City { get; set; }
        public string? SIN { get; set; }
        public DateTime? CurrentDate { get; set; }
        public string? WorkPhoneNumber { get; set; }
        public string? CellPhoneNumber { get; set; }
        public string? Email { get; set; }
        public DateTime? StartDate { get; set; }
        public int SupervisorEmployeeNumber { get; set; }
        public int DepartmentId { get; set; }
        public DateTime? JobStartDate { get; set; }
    }
}
