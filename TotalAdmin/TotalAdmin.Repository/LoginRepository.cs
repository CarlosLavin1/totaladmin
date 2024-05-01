using DAL;
using System.Data;
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
            DataTable dt = await db.ExecuteAsync("spLogin",
                new List<Parm>
                {
                    new Parm("@Email", SqlDbType.NVarChar, username, 255),
                    new Parm("@Password", SqlDbType.NVarChar, password, 255)
                });

            if (dt.Rows.Count == 0)
                return null;

            DataRow row = dt.Rows[0];

            return new UserDTO(
                (int)row["EmployeeNumber"],
                row["FullName"].ToString(),
                row["Email"].ToString(),
                row["RoleName"].ToString(),
                row["WorkPhone"].ToString()
                );
        }
    }
}
