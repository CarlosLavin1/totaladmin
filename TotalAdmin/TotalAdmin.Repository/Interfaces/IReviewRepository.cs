using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model;

namespace TotalAdmin.Repository
{
    public interface IReviewRepository
    {
        Review CreateReview(Review review);
        Review ChangeReviewRead(int reviewId);
        Task<List<Review>> GetReviewsForEmployee(int employeeNumber); 
    }
}
