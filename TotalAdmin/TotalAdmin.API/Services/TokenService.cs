﻿using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using TotalAdmin.API.Interfaces;
using TotalAdmin.Model;

namespace TotalAdmin.API.Services
{
    public class TokenService : ITokenService
    {
        private readonly IConfiguration _configuration;

        public TokenService(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        public string CreateToken(UserDTO user)
        {
            // Check if Jwt:Key is null or empty
            string? jwtKey = _configuration["Jwt:Key"];
            if (string.IsNullOrEmpty(jwtKey))
            {
                throw new InvalidOperationException("Jwt:Key is not configured.");
            }

            SymmetricSecurityKey key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey));

            //List of claims we will store in the token
            List<Claim> claims = new List<Claim>()
            {
                new Claim(JwtRegisteredClaimNames.UniqueName, user.Email ?? ""),
                new Claim(ClaimTypes.Role, user.RoleName ?? "")
            };

            //Create new credentials for signing the token
            SigningCredentials creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);

            //Describe the token. What goes inside
            SecurityTokenDescriptor tokenDescriptor = new SecurityTokenDescriptor()
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.Now.AddDays(7),
                SigningCredentials = creds
            };

            //Create a new token handler
            JwtSecurityTokenHandler tokenHandler = new JwtSecurityTokenHandler();

            //Create the token
            SecurityToken token = tokenHandler.CreateToken(tokenDescriptor);

            //Write the token and return
            return tokenHandler.WriteToken(token);

        }
    }
}
