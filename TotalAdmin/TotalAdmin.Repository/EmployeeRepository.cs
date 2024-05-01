using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model;

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

        public Employee GetEmployeeById(int id)
        {
            throw new NotImplementedException();
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
