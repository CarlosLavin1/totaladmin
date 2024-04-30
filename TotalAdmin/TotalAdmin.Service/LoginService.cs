using TotalAdmin.Model;
using TotalAdmin.Repository;

namespace TotalAdmin.Service
{
    public class LoginService
    {
        private readonly LoginRepository repo;

        public LoginService(LoginRepository repo)
        {
            this.repo = repo;
        }

        public async Task<UserDTO?> Login(string username, string password)
        {
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
                return null;

            password = PasswordUtil.HashToSHA256(password);

            return await repo.Login(username, password);
        }
    }
}
