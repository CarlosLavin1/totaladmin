using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TotalAdmin.Model
{
    public record UserDTO(int EmployeeNumber, string? FullName, string? Email, string? RoleName, string? WorkPhoneNumber);
}
