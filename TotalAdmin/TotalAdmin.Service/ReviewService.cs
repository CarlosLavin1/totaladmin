using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model;
using TotalAdmin.Repository;
using TotalAdmin.Types;

namespace TotalAdmin.Service
{
    public class ReviewService : IReviewService
    {
        private readonly IReviewRepository repo;

        public ReviewService(IReviewRepository repo)
        {
            this.repo = repo;
        }
        public Review CreateReview(Review review)
        {
            if (ValidateReview(review)) 
                return repo.CreateReview(review);
            return review;
        }

        public async Task<List<Employee>> GetEmployeesDueForReviewForSupervisor(int supervisorEmployeeNumber)
        {
            return await repo.GetEmployeesDueForReviewForSupervisor(supervisorEmployeeNumber);
        }

        public async Task<List<MissingReviewDTO>> GetEmployeesDueForReviewForSupervisorWithQuarter(int supervisorEmployeeNumber)
        {
            return await repo.GetEmployeesDueForReviewForSupervisorWithQuarter(supervisorEmployeeNumber);
        }

        public async Task<List<Review>> GetReviewsForEmployee(int employeeNumber)
        {
            return await repo.GetReviewsForEmployee(employeeNumber);
        }

        public void ReadReview(int reviewId)
        {
            repo.ReadReview(reviewId);
        }

        public async Task<Review?> GetReviewById(int reviewId)
        {
            return await repo.GetReviewById(reviewId);
        }

        private bool ValidateReview(Review review)
        {
            // Validate Entity
            List<ValidationResult> results = new();
            Validator.TryValidateObject(review, new ValidationContext(review), results, true);

            foreach (ValidationResult e in results)
            {
                review.AddError(new(e.ErrorMessage, ErrorType.Model));
            }

            // review cannot be in future
            if (review.ReviewDate > DateTime.Now)
                review.AddError(new ("Review date cannot be in the future", ErrorType.Model));

            return !review.Errors.Any();
        }
    }
}
