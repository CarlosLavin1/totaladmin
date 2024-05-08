﻿using DAL;
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
                new("@DateOfBirth", SqlDbType.DateTime2, employee.DateOfBirth),
                new("@JobStartDate", SqlDbType.DateTime2, employee.JobStartDate),
                new("@OfficeLocation", SqlDbType.NVarChar, employee.OfficeLocation, 255),
                new("@WorkPhoneNumber", SqlDbType.NVarChar, employee.WorkPhoneNumber, 12),
                new("@CellPhoneNumber", SqlDbType.NVarChar, employee.CellPhoneNumber, 12),
                new("@IsActive", SqlDbType.Bit, employee.IsActive),
                new("@SupervisorEmpNumber", SqlDbType.Int, employee.SupervisorEmployeeNumber),
                new("@DepartmentId", SqlDbType.Int, employee.DepartmentId),
                new("@RoleId", SqlDbType.Int, employee.RoleId),
                new("@EmployeeNumber", SqlDbType.Int, employee.EmployeeNumber, 0, ParameterDirection.Output),
            };

            if (db.ExecuteNonQuery("spInsertEmployee", parms) > 0)
            {
                employee.EmployeeNumber = (int?)parms.FirstOrDefault(p => p.Name == "@EmployeeNumber")!.Value ?? 0;
            }
            else
            {
                throw new DataException("There was an issue adding the record to the database.");
            }

            return employee;
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
                new("@DateOfBirth", SqlDbType.DateTime2, employee.DateOfBirth),
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
                EmployeeNumber = Convert.ToInt32(row["EmployeeNumber"]),
                FirstName = row["FirstName"].ToString(),
                MiddleInitial = row["MiddleInitial"] != DBNull.Value ? Convert.ToChar(row["MiddleInitial"]) : '\0',
                LastName = row["LastName"].ToString(),
                DateOfBirth = Convert.ToDateTime(row["DateOfBirth"]),
                Email = row["EmailAddress"].ToString(),
                SupervisorEmployeeNumber = row["SupervisorEmpNumber"] != DBNull.Value ? Convert.ToInt32(row["SupervisorEmpNumber"]) : 0,
                DepartmentId = row["DepartmentId"] != DBNull.Value ? Convert.ToInt32(row["DepartmentId"]) : 0,
                RoleId = Convert.ToInt32(row["RoleId"])
            };
        }

        public Employee? GetEmployeeById(int id)
        {
            DataTable dt = db.Execute("spGetEmployeeById", new List<Parm> { new("@EmployeeNumber", SqlDbType.Int, id) });

            if (dt.Rows.Count == 0)
                return null;

            DataRow row = dt.Rows[0];

            return new Employee
            {
                EmployeeNumber = Convert.ToInt32(row["EmployeeNumber"]),
                FirstName = row["FirstName"].ToString(),
                MiddleInitial = row["MiddleInitial"] != DBNull.Value ? Convert.ToChar(row["MiddleInitial"]) : '\0',
                LastName = row["LastName"].ToString(),
                DateOfBirth = Convert.ToDateTime(row["DateOfBirth"]),
                Email = row["EmailAddress"].ToString(),
                SupervisorEmployeeNumber = row["SupervisorEmpNumber"] != DBNull.Value ? Convert.ToInt32(row["SupervisorEmpNumber"]) : 0,
                DepartmentId = row["DepartmentId"] != DBNull.Value ? Convert.ToInt32(row["DepartmentId"]) : 0,
                RoleId = Convert.ToInt32(row["RoleId"])
            };
        }

        public async Task<List<Employee>> GetEmployeeListAsync()
        {
            throw new NotImplementedException();
        }

        public async Task<int> GetEmployeesInDepartmentCountAsync(int department)
        {
            object? count = await db.ExecuteScalarAsync("spGetEmployeesInDepartment", new List<Parm> { new("@DepartmentId", SqlDbType.Int, department) });

            if (count == null)
                return 0;

            return (int)count;
        }

        public int GetEmployeesInDepartmentCount(int department)
        {
            object? count = db.ExecuteScalar("spGetEmployeesInDepartment", new List<Parm> { new("@DepartmentId", SqlDbType.Int, department) });

            if (count == null)
                return 0;

            return (int)count;
        }

        public async Task<List<EmployeeDetailDTO>> SearchEmployeesAsync(int department, int employeeNumber, string? lastName)
        {
            List<Parm> parms = new()
            {
                new("@EmployeeNumber", SqlDbType.Int, employeeNumber),
                new("@DepartmentId", SqlDbType.Int, department),
                new("@LastName", SqlDbType.NVarChar, lastName, 50),
            };

            DataTable dt = await db.ExecuteAsync("spSearchEmployees", parms);

            return dt.AsEnumerable().Select(row => PopulateEmployeeDetailDTO(row)).ToList();
        }

        public async Task<int> GetEmployeesForSupervisorCountAsync(int supervisor)
        {
            List<Parm> parms = new()
            {
                new("@SupervisorEmployeeNumber", SqlDbType.Int, supervisor)
            };
            object? count = await db.ExecuteScalarAsync("spGetEmployeesForSupervisorCount", parms);
            if (count == null)
                return 0;

            return (int)count;
        }

        public int GetEmployeesForSupervisorCount(int supervisor)
        {
            List<Parm> parms = new()
            {
                new("@SupervisorEmployeeNumber", SqlDbType.Int, supervisor)
            };
            object? count = db.ExecuteScalar("spGetEmployeesForSupervisorCount", parms);
            if (count == null)
                return 0;

            return (int)count;
        }

        public async Task<List<Employee>> GetSupervisors(int roleId, int departmentId)
        {
            List<Parm> parms = new()
            {
                new("@DepartmentId", SqlDbType.Int, departmentId),
                new("@RoleId", SqlDbType.Int, roleId),
            };

            DataTable dt = await db.ExecuteAsync("spGetSupervisors", parms);
            return dt.AsEnumerable().Select(row => PopulateEmployee(row)).ToList();
        }

        public async Task<List<EmployeeDetailDTO>> SearchEmployeeDirectory(int employeeNumber, string? lastName)
        {
            List<Parm> parms = new()
            {
                new("@EmployeeNumber", SqlDbType.Int, employeeNumber),
                new("@LastName", SqlDbType.NVarChar, lastName, 50),
            };
            DataTable dt = await db.ExecuteAsync("spSearchEmployeesDirectory", parms);
            return dt.AsEnumerable().Select(row => PopulateEmployeeDetailDTO(row)).ToList();
        }

        public async Task<EmployeeDetailDTO?> GetEmployeeDetailById(int? id)
        {
            List<Parm> parms = new()
            {
                new("@EmployeeNumber", SqlDbType.Int, id)
            };
            DataTable dt = await db.ExecuteAsync("spGetEmployeeById", parms);
            if (dt.Rows.Count == 0)
                return null;

            DataRow row = dt.Rows[0];

            return PopulateEmployeeDetailDTO(row);
        }

        public Employee UpdateEmployee(Employee employee)
        {
            return new();
        }

        //private methods
        private Employee PopulateEmployee(DataRow row)
        {
            return new()
            {
                EmployeeNumber = Convert.ToInt32(row["EmployeeNumber"]),
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
                SupervisorEmployeeNumber = row["SupervisorEmpNumber"] != DBNull.Value ? Convert.ToInt32(row["SupervisorEmpNumber"]) : 0,
            };
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

        private EmployeeDetailDTO PopulateEmployeeDetailDTO(DataRow row)
        {
            return new EmployeeDetailDTO
            (
                Convert.ToInt32(row["EmployeeNumber"]),
                row["FirstName"].ToString(),
                row["MiddleInitial"] != DBNull.Value ? Convert.ToChar(row["MiddleInitial"]) : '\0',
                row["LastName"].ToString(),
                row["StreetAddress"].ToString(),
                row["City"].ToString(),
                row["PostalCode"].ToString(),
                row["WorkPhoneNumber"].ToString(),
                row["CellPhoneNumber"].ToString(),
                row["EmailAddress"].ToString()
            );
        }
    }
}
