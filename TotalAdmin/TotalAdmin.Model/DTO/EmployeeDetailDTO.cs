using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TotalAdmin.Model
{
    public record EmployeeDetailDTO(int EmployeeNumber, string? FirstName, char? MiddleInitial, string? LastName, string? StreetAddress, string? City, string? PostalCode, string? WorkPhone, string? CellPhone, string? Email, string? JobTitle);
}
