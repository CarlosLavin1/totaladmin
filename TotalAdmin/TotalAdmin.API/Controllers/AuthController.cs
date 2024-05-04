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
        private readonly ILoginService _loginService;

        public AuthController(ITokenService tokenService, ILoginService loginService)
        {
            this._tokenService = tokenService;
            this._loginService = loginService;
        }

        [HttpPost]
        public async Task<ActionResult<LoginOutputDTO>> Login(LoginCredentialsDTO login)
        {
            string username = login.Username;
            string password = login.Password;
            UserDTO? user = await _loginService.Login(username, password);

            if (user == null)
            {
                return Unauthorized("Invalid login credentials");
            }

            return new LoginOutputDTO(user.EmployeeNumber, user.Email, _tokenService.CreateToken(user), 7 * 24 * 60 * 60, user.RoleName);

        }
    }
}
