using Microsoft.AspNetCore.Mvc;
using TotalAdmin.Model.DTO;
using TotalAdmin.Service;

namespace TotalAdmin.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class EmailController : Controller
    {
        private readonly EmailService emailService = new();

        
        [HttpGet]
        public IActionResult Get()
        {
            EmailDTO testEmail = new EmailDTO
            {
                To = "totalAdminmail.com",
                From = "totalAdminmail.com",
                Subject = "Test Email",
                Body = ""
            };

            emailService.Send(testEmail);

            return Ok("Test email sent.");
        }

    }
}
