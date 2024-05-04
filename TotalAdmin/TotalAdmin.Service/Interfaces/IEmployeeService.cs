﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model;

namespace TotalAdmin.Service
{
    public interface IEmployeeService
    {
        Task<Employee> AddEmployeeAsync(Employee employee);
        Employee AddEmployee(Employee employee);
        Task<List<EmployeeDisplayDTO>> SearchEmployeesAsync(int department, int employeeNumber, string? lastName);
        Task<int> GetEmployeesInDepartmentCountAsync(int department);
        int GetEmployeesInDepartmentCount(int department);
        Task<int> GetEmployeesForSupervisorCountAsync(int supervisor);
        int GetEmployeesForSupervisorCount(int supervisor);
        Task<List<Employee>> GetSupervisors(int roleId, int departmentId);
    }
}
