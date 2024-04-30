using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace TotalAdmin.Service
{
    internal static class PasswordUtil
    {
        public static string HashToSHA256(string input)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                //byte[] saltedPassword = salt.Concat(Encoding.UTF8.GetBytes(input)).ToArray();
                byte[] hashBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(input));
                return BitConverter.ToString(hashBytes).Replace("-", "").ToLower();
            }
        }
    }
}
