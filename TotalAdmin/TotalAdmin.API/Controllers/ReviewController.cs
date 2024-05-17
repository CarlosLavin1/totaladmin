using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TotalAdmin.Model;
using TotalAdmin.Model.DTO;
using TotalAdmin.Service;

namespace TotalAdmin.API.Controllers
{
    [Route("api/review")]
    [ApiController]
    public class ReviewController : Controller
    {
        private readonly IReviewService reviewService;
        private readonly EmailService _emailService;

        public ReviewController(IReviewService reviewService, EmailService emailService)
        {
            this.reviewService = reviewService;
            _emailService = emailService;
        }

        [Authorize(Roles = "Supervisor")]
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public ActionResult<Review> Create(Review review)
        {
            try
            {
                review = reviewService.CreateReview(review);

                if (review.Errors.Count != 0)
                    // return status 400
                    return BadRequest(review);

                // this returns get route for newly created department
                return Ok(review);
            }
            catch (Exception e)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        [Authorize(Roles = "Supervisor")]
        [HttpGet("due/{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<Employee>>> GetEmployeesDueForReviewForSupervisor(int id)
        {
            try
            {
                List<Employee> employees = await reviewService.GetEmployeesDueForReviewForSupervisor(id);

                return employees;
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        [Authorize(Roles = "Supervisor")]
        [HttpGet("pending/{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<MissingReviewDTO>>> GetEmployeesDueForReviewForSupervisorWithQuarter(int id)
        {
            try
            {
                List<MissingReviewDTO> employees = await reviewService.GetEmployeesDueForReviewForSupervisorWithQuarter(id);

                return employees;
            }
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        [Authorize(Roles = "Employee")]
        [HttpGet("employee/{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<Review>>> GetReviewsForEmployee(int id)
        {
            try
            {
                List<Review> reviews = await reviewService.GetReviewsForEmployee(id);

                return Ok(reviews);
            }
            catch (Exception e)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        [Authorize(Roles = "Employee")]
        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<Review>> GetReview(int id)
        {
            try
            {
                Review? r = await reviewService.GetReviewById(id);

                return r != null ? Ok(r) : BadRequest();
            }
            catch (Exception e)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        [Authorize(Roles = "Employee, Supervisor")]
        [HttpGet("read/{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public ActionResult ReadReview(int id)
        {
            try
            {
                reviewService.ReadReview(id);

                return Ok();
            }
            catch (Exception e)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        [HttpGet("reminders")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult> SendReminders()
        {
            try
            {
                DateTime? last = await reviewService.GetLastReminderDate();
                if (last == null || last.Value.Date < DateTime.Today)
                {
                    reviewService.SendReminders();
                    EmailDTO email = new EmailDTO
                    {
                        To = "",
                        From = "totalAdmin@mail.com",
                        Subject = "Your PO request has been processed",
                        Body = $"Your purchase order (PO Number:) has been closed and processed."
                    };

                    _emailService.Send(email);
                    return Ok();
                }    

                return BadRequest();
            }
            catch (Exception e)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }
    }
}
