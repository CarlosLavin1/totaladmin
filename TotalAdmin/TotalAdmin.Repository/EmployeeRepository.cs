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

        public async Task<Employee> AddEmployeeAsync(Employee employee)
        {
            List<Parm> parms = new()
            {
                new("@FirstName", SqlDbType.NVarChar, employee.FirstName, 50),
                new("@MiddleInitial", SqlDbType.Char, employee.MiddleInitial, 1),
                new("@LastName", SqlDbType.NVarChar, employee.LastName, 50),
                new("@Email", SqlDbType.NVarChar, employee.Email, 255),
                new("@HashedPassword", SqlDbType.NVarChar, employee.HashedPassword, 255),
                new("@StreetAddress", SqlDbType.NVarChar, employee.StreetAddress, 255),
                new("@City", SqlDbType.NVarChar, employee.City, 50),
                new("@PostalCode", SqlDbType.NVarChar, employee.PostalCode, 50),
                new("@SIN", SqlDbType.NVarChar, employee.SIN, 9),
                new("@JobTitle", SqlDbType.NVarChar, employee.JobTitle, 60),
                new("@CompanyStartDate", SqlDbType.DateTime2, employee.SeniorityDate),
                new("@JobStartDate", SqlDbType.DateTime2, employee.JobStartDate),
                new("@OfficeLocation", SqlDbType.NVarChar, employee.OfficeLocation, 255),
                new("@WorkPhoneNumber", SqlDbType.NVarChar, employee.WorkPhoneNumber, 12),
                new("@CellPhoneNumber", SqlDbType.NVarChar, employee.CellPhoneNumber, 12),
                new("@IsActive", SqlDbType.Bit, employee.IsActive),
                new("@SupervisorEmpNumber", SqlDbType.Int, employee.SupervisorEmployeeNumber),
                new("@DepartmentId", SqlDbType.Int, employee.DepartmentId),
                new("@RoleId", SqlDbType.Int, employee.RoleId),
                new("@EmployeeNumber", SqlDbType.Decimal, employee.EmployeeNumber, 0, ParameterDirection.Output),
            };

            if (await db.ExecuteNonQueryAsync("spInsertEmployee", parms) > 0)
            {
                employee.EmployeeNumber = (int?)parms.FirstOrDefault(p => p.Name == "@EmployeeNumber")!.Value ?? 0;
            }
            else
            {
                throw new DataException("There was an issue adding the record to the database.");
            }

            return employee;
        }

        public async Task<Employee?> GetEmployeeByIdAsync(int id)
        {
            DataTable dt = await db.ExecuteAsync("spGetEmployeeById", new List<Parm> { new("@EmployeeNumber", SqlDbType.Int, id) });

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

        public async Task<List<Employee>> GetEmployeeListAsync()
        {
            throw new NotImplementedException();
        }

        public async Task<List<EmployeeDisplayDTO>> SearchEmployeesAsync(int department, int employeeNumber, string? lastName)
        {
            List<Parm> parms = new()
            {
                new("@EmployeeNumber", SqlDbType.Int, employeeNumber),
                new("@DepartmentId", SqlDbType.Int, department),
                new("@LastName", SqlDbType.NVarChar, lastName, 50),
            };

            DataTable dt = await db.ExecuteAsync("spSearchEmployees", parms);

            return dt.AsEnumerable().Select(row => PopulateEmployeeDisplayDTO(row)).ToList();
        }

        private EmployeeDisplayDTO PopulateEmployeeDisplayDTO(DataRow row)
        {
            return new EmployeeDisplayDTO
            {
                 EmployeeNumber = Convert.ToInt32(row["EmployeeNumber"]),
                 FirstName = row["FirstName"].ToString(),
                 LastName = row["LastName"].ToString(),
                 WorkPhone = row["WorkPhoneNumber"].ToString(),
                 OfficeLocation = row["OfficeLocation"].ToString(),
                 JobTitle = row["JobTitle"].ToString(),
            };
        }
    }
}
