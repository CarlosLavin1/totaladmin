import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, catchError } from 'rxjs';
import { API_URL7161, SharedService } from './shared.service';
import { Employee } from '../models/employee';
import { EmployeeDetailDTO } from '../models/employee-detail-dto';
import { EmployeeDetailsWithUnreadReviewsDTO } from '../models/EmployeeDetailsWithUnreadReviewsDTO';

@Injectable({
  providedIn: 'root'
})
export class EmployeeService extends SharedService{

  constructor(private http: HttpClient) { 
    super();
  }

  createEmployee(employeeData: Employee): Observable<Employee> {
    return this.http.post<Employee>(`${API_URL7161}/employee`, employeeData).pipe(catchError(super.handleError));
  }

  getSupervisors(roleId: number, departmentId: number): Observable<Employee[]>{
    return this.http.post<Employee[]>(`${API_URL7161}/employee/supervisors`, {roleId, departmentId}).pipe(catchError(super.handleError));
  }

  searchEmployees(lastName: string, employeeNumber: number): Observable<EmployeeDetailDTO[]>{
    return this.http.post<EmployeeDetailDTO[]>(`${API_URL7161}/employee/directory`, {lastName, employeeNumber}).pipe(catchError(super.handleError));
  }

  getEmployeeById(employeeNumber: number): Observable<Employee>{
    return this.http.get<Employee>(`${API_URL7161}/employee/${employeeNumber}`).pipe(catchError(super.handleError));
  }

  //update personal info
  updateEmployee(employeeNumber: number, employee: Employee): Observable<Employee>{
    return this.http.put<Employee>(`${API_URL7161}/employee/personal/${employeeNumber}`, employee).pipe(catchError(super.handleError));
  }

  //update employee
  employeeUpdate(employeeNumber: number, employee: Employee): Observable<Employee>{
    return this.http.put<Employee>(`${API_URL7161}/employee/${employeeNumber}`, employee).pipe(catchError(super.handleError));
  }

  countEmployeesBySupervisor(supervisorEmpNumber: number): Observable<number> {
    return this.http.get<number>(`${API_URL7161}/employee/count/${supervisorEmpNumber}`)
    .pipe(catchError(super.handleError));
  }

  getUnreadEmployeeReviewsByDepartment(departmentId: number): Observable<EmployeeDetailsWithUnreadReviewsDTO[]> {
    return this.http.get<EmployeeDetailsWithUnreadReviewsDTO[]>(`${API_URL7161}/employee/unread-reviews-by-department/${departmentId}`)
    .pipe(catchError(super.handleError));
  }
}
