using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Repository;
using Microsoft.Extensions.DependencyInjection;

namespace TotalAdmin.Service
{
    public static class ServiceCompositionRoot
    {
        public static void RegisterDependencies(IServiceCollection services)
        {

            // Register services interfaces and implementations
            services.AddScoped<IDepartmentService, DepartmentService>();
            services.AddScoped<ILoginService, LoginService>();

            // Register repository dependencies
            RepoCompositionRoot.RegisterDependencies(services);

        }
    }
}
