using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Repository;
using Microsoft.Extensions.DependencyInjection;
using TotalAdmin.Service.Interfaces;

namespace TotalAdmin.Service
{
    public static class ServiceCompositionRoot
    {
        public static void RegisterDependencies(IServiceCollection services)
        {
           
            // Register services interfaces and implementations
            services.AddScoped<IDepartmentService, DepartmentService>();
            services.AddScoped<IEmployeeService, EmployeeService>();
            services.AddScoped<ILoginService, LoginService>();
            services.AddScoped<IPurchaseOrderService, PurchaseOrderService>();
            services.AddScoped<IReviewService, ReviewService>();

            // Register repository dependencies
            RepoCompositionRoot.RegisterDependencies(services);

        }
    }
}
