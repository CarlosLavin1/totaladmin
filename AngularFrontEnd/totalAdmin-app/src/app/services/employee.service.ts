import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, catchError } from 'rxjs';
import { API_URL7161, SharedService } from './shared.service';
import { Employee } from '../models/employee';
import { EmployeeDetailDTO } from '../models/employee-detail-dto';

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
}
