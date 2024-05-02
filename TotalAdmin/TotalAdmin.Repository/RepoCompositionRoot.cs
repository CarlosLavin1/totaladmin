using DAL;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TotalAdmin.Repository
{
    public static class RepoCompositionRoot
    {
        public static void RegisterDependencies(IServiceCollection services)
        {
            // Register DataAccess
            services.AddSingleton<IDataAccess, DataAccess>();

            // register repo interfaces and their implementations
            services.AddScoped<IDepartmentRepository, DepartmentRepository>();
            services.AddScoped<IEmployeeRepository, EmployeeRepository>();
            services.AddScoped<ILoginRepository, LoginRepository>();
        }
    }
}
