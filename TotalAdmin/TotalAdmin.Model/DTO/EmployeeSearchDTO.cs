using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TotalAdmin.Model
{
    public record EmployeeSearchDTO(int? Department, int? EmployeeNumber, string? LastName);
    public record EmployeeDirectorySearchDTO(int? EmployeeNumber, string? LastName);
}
