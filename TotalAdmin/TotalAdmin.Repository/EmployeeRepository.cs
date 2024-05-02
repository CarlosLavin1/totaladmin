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
    public class EmployeeRepository : IEmployeeRepository
    {
        private readonly IDataAccess db;

        public EmployeeRepository(IDataAccess db)
        {
            this.db = db;
        }

        public Employee AddEmployee(Employee employee)
        {
            throw new NotImplementedException();
        }

        public Employee? GetEmployeeById(int id)
        {
            DataTable dt = db.Execute("spGetEmployeeById", new List<Parm> { new("@EmployeeNumber", SqlDbType.Int, id) });

            if (dt.Rows.Count == 0)
                return null;

            DataRow row = dt.Rows[0];

            return new Employee
            {
                EmployeeNumber = Convert.ToInt32(row["RealtorId"]),
                FirstName = row["FirstName"].ToString(),
                MiddleInitial = Convert.ToChar(row["MiddleInitial"]),
                LastName = row["LastName"].ToString(),
                DateOfBirth = Convert.ToDateTime(row["DateOrBirth"]),
            };
        }

        public List<Employee> GetEmployeeList()
        {
            throw new NotImplementedException();
        }

        public List<EmployeeDisplayDTO> SearchEmployees(string? department, int employeeNumber, string? name)
        {
            throw new NotImplementedException();
        }
    }
}
