using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model;

namespace TotalAdmin.Service
{
    public interface ILoginService
    {
        Task<UserDTO?> Login(string username, string password);
    }
}
