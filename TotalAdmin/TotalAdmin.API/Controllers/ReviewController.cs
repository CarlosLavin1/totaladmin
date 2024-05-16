using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TotalAdmin.Model;
using TotalAdmin.Service;

namespace TotalAdmin.API.Controllers
{
    [Route("api/review")]
    [ApiController]
    public class ReviewController : Controller
    {
        private readonly IReviewService reviewService;

        public ReviewController(IReviewService reviewService)
        {
            this.reviewService = reviewService;
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

        [Authorize(Roles = "Employee")]
        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<Review>>> GetReviewsForEmployee(int id)
        {
            try
            {
                List<Review> reviews = await reviewService.GetReviewsForEmployee(id);

                return reviews;
            }
            catch (Exception e)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        [Authorize(Roles = "Employee")]
        [HttpPost("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<Review>>> ReadReview(int id)
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
    }
}
