using DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model;
using TotalAdmin.Types;

namespace TotalAdmin.Repository
{
    public class ReviewRepository : IReviewRepository
    {
        private readonly IDataAccess db;

        public ReviewRepository(IDataAccess db)
        {
            this.db = db;
        }

        public Review CreateReview(Review review)
        {
            List<Parm> parms = new()
            {
                new("@ReviewId", SqlDbType.Int, review.Id, 0, ParameterDirection.Output),
                new("@RatingId", SqlDbType.Int, review.RatingId),
                new("@Comment", SqlDbType.NVarChar, review.Comment, int.MaxValue),
                new("@EmployeeNumber", SqlDbType.Int, review.EmployeeNumber),
                new("@SupervisorEmployeeNumber", SqlDbType.Int, review.SupervisorEmployeeNumber),
                new("@ReviewDate", SqlDbType.DateTime2, review.ReviewDate),
                new("@HasBeenRead", SqlDbType.Bit, 0),

            };
            if (db.ExecuteNonQuery("spInsertReview", parms) > 0)
            {
                review.Id = (int?)parms.FirstOrDefault(p => p.Name == "@ReviewId")!.Value ?? 0;
            }
            else
            {
                throw new DataException("There was an issue adding the record to the database.");
            }

            return review;
        }

        public Task<List<Review>> GetReviewsForEmployee(int employeeNumber)
        {
            throw new NotImplementedException();
        }

        public Review ChangeReviewRead(int reviewId)
        {
            throw new NotImplementedException();
        }
    }
}
