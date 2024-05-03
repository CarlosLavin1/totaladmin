import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, catchError } from 'rxjs';
import { API_URL7161, SharedService } from './shared.service';

@Injectable({
  providedIn: 'root'
})
export class EmployeeService extends SharedService{

  constructor(private http: HttpClient) {
    super();
  }

  createEmployee(employeeData: any): Observable<any> {
    return this.http.post(`${API_URL7161}/employee`, employeeData).pipe(catchError(super.handleError));
  }
}
