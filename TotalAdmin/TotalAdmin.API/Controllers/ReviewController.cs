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
                    // loop through all supervisors and get employees due for review and send that list
                    List<Employee> supervisors = reviewService.GetSupervisorEmails();
                    EmailDTO email;
                    foreach(Employee e in supervisors)
                    {
                        string to = e.Email ?? "supervisors@mail.com";
                        List <Employee> employees = await reviewService.GetEmployeesDueForReviewForSupervisor(e.EmployeeNumber);
                        string employeeList = "The following employee reviews are due for the current quarter:\n\n";
                        foreach (Employee employee in employees)
                            employeeList += $"{employee.LastName}, {employee.FirstName}\n";
                        // add hr employee emails if after 30 since start of quarter
                        if (isAfter30DaysInQuarter())
                        {
                            List<Employee> hrEmployees = reviewService.GetHREmployeeEmails();
                            foreach(Employee hrEmployee in hrEmployees)
                                to += $", {hrEmployee.Email}";
                        }

                        email = new EmailDTO
                        {
                            To = to,
                            From = "totalAdmin@mail.com",
                            Subject = "Your employee reviews are due",
                            Body = employeeList
                        };
                        if(employees.Count > 0)
                            _emailService.Send(email);
                    }
                    return Ok();
                }    

                return BadRequest();
            }
            catch (Exception e)
            {
                return Problem(title: "An internal error has occurred. Please contact the system administrator.");
            }
        }

        private bool isAfter30DaysInQuarter()
        {
            DateTime today = DateTime.Today;
            DateTime startOfQuarter;

            // Determine the start date of the current quarter
            if (today.Month >= 1 && today.Month <= 3)
            {
                    startOfQuarter = new DateTime(today.Year, 1, 1); // Q1
            }
            else if (today.Month >= 4 && today.Month <= 6)
            {
                    startOfQuarter = new DateTime(today.Year, 4, 1); // Q2
                }
            else if (today.Month >= 7 && today.Month <= 9)
            {
                    startOfQuarter = new DateTime(today.Year, 7, 1); // Q3
            }
            else
            {
                startOfQuarter = new DateTime(today.Year, 10, 1); // Q4
            }

            // Add 30 days to the start date of the current quarter
            DateTime thirtyDaysAfterStartOfQuarter = startOfQuarter.AddDays(30);

            // Check if today is 30 days after the start of the current quarter
            return today >= thirtyDaysAfterStartOfQuarter;
        }
    }
}
