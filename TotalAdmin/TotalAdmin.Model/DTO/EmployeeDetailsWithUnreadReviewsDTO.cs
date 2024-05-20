using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TotalAdmin.Model.DTO
{
    public class EmployeeDetailsWithUnreadReviewsDTO
    {
        public int NumberOfSupervisorEmployees { get; set; }
        public int UnreadReviewsCount { get; set; }
    }
}
