using DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model;
using TotalAdmin.Types;

namespace TotalAdmin.Repository
{
    public class DepartmentRepository : IDepartmentRepository
    {
        private readonly IDataAccess db;

        public DepartmentRepository(IDataAccess db)
        {
            this.db = db;
        }

        public async Task<List<DepartmentDisplayDTO>> GetActiveDepartmentsAsync()
        {
            DataTable dt = await db.ExecuteAsync("spGetActiveDepartments");
            return dt.AsEnumerable().Select(row => new DepartmentDisplayDTO(Convert.ToInt32(row["DepartmentId"]), row["Name"].ToString())).ToList();
        }

        public Department AddDepartment(Department department)
        {
            List<Parm> parms = new()
            {
                new("@DepartmentId", SqlDbType.Int, department.Id, 0, ParameterDirection.Output),
                new("@Name", SqlDbType.NVarChar, department.Name, 128),
                new("@Description", SqlDbType.NVarChar, department.Description, 512),
                new("@InvocationDate", SqlDbType.DateTime2, department.InvocationDate),
            };

            if (db.ExecuteNonQuery("spInsertDepartment", parms) > 0)
            {
                department.Id = (int?)parms.FirstOrDefault(p => p.Name == "@DepartmentId")!.Value ?? 0;
            }
            else
            {
                throw new DataException("There was an issue adding the record to the database.");
            }

            return department;
        }

        public async Task<Department> AddDepartmentAsync(Department department)
        {
            List<Parm> parms = new()
            {
                new("@Name", SqlDbType.NVarChar, department.Name, 128),
                new("@Description", SqlDbType.NVarChar, department.Description, 512),
                new("@InvocationDate", SqlDbType.DateTime2, department.InvocationDate),
                new("@DepartmentId", SqlDbType.Int, department.Id, 0, ParameterDirection.Output),
            };

            if (await db.ExecuteNonQueryAsync("spInsertDepartment", parms) > 0)
            {
                department.Id = (int?)parms.FirstOrDefault(p => p.Name == "@DepartmentId")!.Value ?? 0;
            }
            else
            {
                throw new DataException("There was an issue adding the record to the database.");
            }

            return department;
        }

        public async Task<Department?> GetDepartmentForEmployeeAsync(int employeeNumber)
        {
            List<Parm> parms = new()
            {
                new("@EmployeeNumber", SqlDbType.Int, employeeNumber)
            };
            DataTable dt = await db.ExecuteAsync("spGetDepartmentForEmployee", parms);
            if (dt.Rows.Count == 0)
                return null;
            DataRow row = dt.Rows[0];
            return new Department
            {
                Id = Convert.ToInt32(row["DepartmentId"]),
                Name = Convert.ToString(row["Name"]),
                Description = Convert.ToString(row["Description"]),
                InvocationDate = Convert.ToDateTime(row["InvocationDate"]),
                RowVersion = (byte[])row["RowVersion"]
            };
        }

        public Department? GetDepartmentForEmployee(int employeeNumber)
        {
            List<Parm> parms = new()
            {
                new("@EmployeeNumber", SqlDbType.Int, employeeNumber)
            };
            DataTable dt = db.Execute("spGetDepartmentForEmployee", parms);
            if (dt.Rows.Count == 0)
                return null;
            DataRow row = dt.Rows[0];
            return new Department
            {
                Id = Convert.ToInt32(row["DepartmentId"]),
                Name = Convert.ToString(row["Name"]),
                Description = Convert.ToString(row["Description"]),
                InvocationDate = Convert.ToDateTime(row["InvocationDate"]),
                RowVersion = (byte[])row["RowVersion"]
            };
        }

        public Department UpdateDepartment(Department department)
        {
            List<Parm> parms = new()
            {
                new("@DepartmentId", SqlDbType.Int, department.Id),
                new("@Name", SqlDbType.NVarChar, department.Name, 128),
                new("@Description", SqlDbType.NVarChar, department.Description, 512),
                new("@InvocationDate", SqlDbType.DateTime2, department.InvocationDate),
                new("@RowVersion", SqlDbType.Timestamp, department.RowVersion),
            };
            db.ExecuteNonQuery("spUpdateDepartment", parms);
            return department;
        }
    }
}
