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

        [Authorize(Roles = "HR Employee")]
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public ActionResult<Department> Create(Review review)
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
            catch (Exception)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }
    }
}
