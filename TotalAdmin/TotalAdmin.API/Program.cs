using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using TotalAdmin.API.Interfaces;
using TotalAdmin.API.Services;
using TotalAdmin.Model;
using TotalAdmin.Service;

namespace TotalAdmin.API
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            builder.Services.AddControllers();

            // Register Dependencies 
            builder.Services.AddScoped<ITokenService, TokenService>();
            builder.Services.AddScoped<EmailService>();
            ServiceCompositionRoot.RegisterDependencies(builder.Services);

            // setup roles
            builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(options =>
            {
                string? jwtKey = builder.Configuration["Jwt:Key"];
                if (string.IsNullOrEmpty(jwtKey))
                {
                    throw new InvalidOperationException("Jwt:Key is not configured.");
                }

                options.TokenValidationParameters = new()
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey)),
                    ValidateIssuer = false,
                    ValidateAudience = false
                };
            });
            // configure auth with policy syntax
            builder.Services.AddAuthorization(options =>
            {
                options.AddPolicy("HR Supervisor", policy =>
                    policy.RequireRole("HR Supervisor"));
            });
            builder.Services.AddAuthorization(options =>
            {
                options.AddPolicy("Supervisor", policy =>
                    policy.RequireRole("Supervisor"));
            });
            builder.Services.AddAuthorization(options =>
            {
                options.AddPolicy("HR Employee", policy =>
                    policy.RequireRole("HR Employee"));
            });
            builder.Services.AddAuthorization(options =>
            {
                options.AddPolicy("Employee", policy =>
                    policy.RequireRole("Employee"));
            });
            builder.Services.AddAuthorization(options =>
            {
                options.AddPolicy("CEO", policy =>
                    policy.RequireRole("CEO"));
            });
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            // DISABLE MODEL ERRORS SO THAT WE CAN PASS OUR OWN ERRORS BACK
            builder.Services.Configure<ApiBehaviorOptions>(options =>
            {
                options.SuppressModelStateInvalidFilter = true;
            });

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseCors(policy =>
                policy
                .AllowAnyHeader()
                .AllowAnyMethod()
                .WithOrigins("*")
            );

            //app.UseHttpsRedirection();
            app.UseAuthentication();
            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}
