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
        Task<List<Employee>> GetEmployeesDueForReviewForSupervisorForPrevQuarter(int supervisorEmployeeNumber);
        Task<List<Employee>> GetEmployeesDueForReviewForSupervisor(int supervisorEmployeeNumber);
        Task<List<MissingReviewDTO>> GetEmployeesDueForReviewForSupervisorWithQuarter(int supervisorEmployeeNumber);
        void ReadReview(int reviewId);
        Task<Review?> GetReviewById(int reviewId);
        void SendReminders();
        Task<DateTime?> GetLastReminderDate();
        List<Employee> GetSupervisorEmails();
        List<Employee> GetHREmployeeEmails();
    }
}
