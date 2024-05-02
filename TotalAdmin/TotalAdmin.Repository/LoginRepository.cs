using DAL;
using System.Data;
using System.Text.RegularExpressions;
using TotalAdmin.Model;
using TotalAdmin.Types;

namespace TotalAdmin.Repository
{
    public class LoginRepository : ILoginRepository
    {
        private readonly IDataAccess db;

        public LoginRepository(IDataAccess db)
        {
            this.db = db;
        }

        public async Task<UserDTO?> Login(string username, string password)
        {
            // check if username is a valid employee number
            if (!Regex.IsMatch(username, @"^\d{8}$"))
                return null;
            // convert to int, this will remove leading zeroes
            int employeeNumber = int.Parse(username);

            DataTable dt = await db.ExecuteAsync("spLogin",
                new List<Parm>
                {
                    new Parm("@EmployeeNumber", SqlDbType.Int, employeeNumber),
                    new Parm("@HashedPassword", SqlDbType.NVarChar, password, 255)
                });

            if (dt.Rows.Count == 0)
                return null;

            DataRow row = dt.Rows[0];

            return new UserDTO(
                (int)row["EmployeeNumber"],
                row["FullName"].ToString(),
                row["EmailAddress"].ToString(),
                row["RoleName"].ToString(),
                row["WorkPhoneNumber"].ToString()
                );
        }
    }
}
