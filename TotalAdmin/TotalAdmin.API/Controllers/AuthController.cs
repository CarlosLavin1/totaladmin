using Microsoft.AspNetCore.Mvc;
using TotalAdmin.API.Interfaces;
using TotalAdmin.Model;
using TotalAdmin.Service;

namespace TotalAdmin.API.Controllers
{
    [Route("api/login")]
    [ApiController]
    public class AuthController : Controller
    {
        private readonly ITokenService _tokenService;
        private readonly LoginService _loginService;

        public AuthController(ITokenService tokenService, LoginService loginService)
        {
            this._tokenService = tokenService;
            this._loginService = loginService;
        }

        [HttpPost]
        public async Task<ActionResult<LoginOutputDTO>> Login(string username, string password)
        {
            UserDTO? user = await _loginService.Login(username, password);

            if (user == null)
            {
                return Unauthorized("Invalid login");
            }

            return new LoginOutputDTO(user.EmployeeNumber, user.Email, _tokenService.CreateToken(user), 7 * 24 * 60 * 60);

        }
    }
}
