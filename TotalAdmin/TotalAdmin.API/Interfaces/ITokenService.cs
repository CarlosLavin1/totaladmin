using TotalAdmin.Model;

namespace TotalAdmin.API.Interfaces
{
    public interface ITokenService
    {
        string CreateToken(UserDTO user);
    }
}
