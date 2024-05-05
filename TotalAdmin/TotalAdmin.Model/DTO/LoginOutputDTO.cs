using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TotalAdmin.Model
{
    public record LoginOutputDTO(int EmployeeNumber, string? Email, string? Token, int ExpiresIn, string? Role);
}
