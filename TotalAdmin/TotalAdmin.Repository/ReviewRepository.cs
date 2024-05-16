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

        public async Task<List<Review>> GetReviewsForEmployee(int employeeNumber)
        {
            List<Parm> parms = new()
            {
                new("@EmployeeNumber", SqlDbType.Int, employeeNumber),
            };
            DataTable dt = await db.ExecuteAsync("spGetReviewsForEmployee", parms);
            return dt.AsEnumerable().Select(row => PopulateReview(row)).ToList();
        }

        public Review ChangeReviewRead(int reviewId)
        {
            throw new NotImplementedException();
        }

        public async Task<List<Employee>> GetEmployeesDueForReviewForSupervisor(int supervisorEmployeeNumber)
        {
            List<Parm> parms = new()
            {
                new("@SupervisorEmployeeNumber", SqlDbType.Int, supervisorEmployeeNumber),
            };
            DataTable dt = await db.ExecuteAsync("spGetEmployeesDueForReviewForSupervisor", parms);
            return dt.AsEnumerable().Select(row => PopulateEmployee(row)).ToList();
        }

        public async Task<List<MissingReviewDTO>> GetEmployeesDueForReviewForSupervisorWithQuarter(int supervisorEmployeeNumber)
        {
            List<Parm> parms = new()
            {
                new("@SupervisorEmployeeNumber", SqlDbType.Int, supervisorEmployeeNumber),
            };
            DataTable dt = await db.ExecuteAsync("spGetEmployeesDueForReviewForSupervisor", parms);
            return dt.AsEnumerable().Select(row => PopulateReviewDTO(row)).ToList();
        }

        public void ReadReview(int reviewId)
        {
            List<Parm> parms = new()
            {
                new("@ReviewId", SqlDbType.Int, reviewId)
            };
            db.ExecuteNonQuery("spReadReview", parms);
        }

        public async Task<Review?> GetReviewById(int reviewId)
        {
            List<Parm> parms = new()
            {
                new("@ReviewId", SqlDbType.Int, reviewId),
            };
            DataTable dt = await db.ExecuteAsync("spGetReviewById", parms);
            if(dt.Rows.Count == 0)
                return null;
            return PopulateReview(dt.Rows[0]);
        }

        private Review PopulateReview(DataRow row)
        {
            return new Review()
            {
                Id = Convert.ToInt32(row["ReviewId"]),
                RatingId = Convert.ToInt32(row["ReviewRatingId"]),
                Comment = row["Comment"].ToString(),
                HasBeenRead = Convert.ToBoolean(row["IsRead"]),
                ReviewDate = Convert.ToDateTime(row["ReviewDate"]),
                EmployeeNumber = Convert.ToInt32(row["EmployeeNumber"]),
                SupervisorEmployeeNumber = Convert.ToInt32(row["SupervisorEmployeeNumber"])
            };
        }

        private Employee PopulateEmployee(DataRow row)
        {
            return new()
            {
                EmployeeNumber = Convert.ToInt32(row["EmployeeNumber"]),
                HashedPassword = (string)row["HashedPassword"],
                FirstName = row["FirstName"].ToString(),
                MiddleInitial = row["MiddleInitial"] != DBNull.Value ? Convert.ToChar(row["MiddleInitial"]) : '\0',
                LastName = row["LastName"].ToString(),
                RoleId = Convert.ToInt32(row["RoleId"]),
                WorkPhoneNumber = row["WorkPhoneNumber"].ToString(),
                OfficeLocation = row["OfficeLocation"].ToString(),
                JobTitle = row["JobTitle"].ToString(),
                DepartmentId = row["DepartmentId"] != DBNull.Value ? Convert.ToInt32(row["DepartmentId"]) : 0,
                DateOfBirth = Convert.ToDateTime(row["DateOfBirth"]),
                StreetAddress = row["StreetAddress"].ToString(),
                City = row["City"].ToString(),
                PostalCode = (string)row["PostalCode"],
                SupervisorEmployeeNumber = row["SupervisorEmpNumber"] != DBNull.Value ? Convert.ToInt32(row["SupervisorEmpNumber"]) : 0,
                SIN = row["SIN"].ToString(),
                CellPhoneNumber = row["CellPhoneNumber"].ToString(),
                Email = (string)row["EmailAddress"],
                SeniorityDate = (DateTime)row["CompanyStartDate"],
                JobStartDate = (DateTime)row["JobStartDate"],
                RetiredDate = row["RetiredDate"] != DBNull.Value ? (DateTime)row["RetiredDate"] : null,
                TerminatedDate = row["TerminatedDate"] != DBNull.Value ? (DateTime)row["TerminatedDate"] : null,
                StatusId = (int)row["StatusId"],
                RowVersion = (byte[])row["RowVersion"]
            };
        }

        private MissingReviewDTO PopulateReviewDTO(DataRow row)
        {
            return new MissingReviewDTO()
            {
                EmployeeNumber = Convert.ToInt32(row["EmployeeNumber"]),
                FirstName = row["FirstName"].ToString(),
                LastName = row["LastName"].ToString(),
                Year = Convert.ToInt32(row["Year"]),
                Quarter = Convert.ToInt32(row["Quarter"])
            };
        }
    }
}
