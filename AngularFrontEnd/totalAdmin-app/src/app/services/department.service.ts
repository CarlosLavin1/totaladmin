import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { API_URL7161, SharedService } from './shared.service';
import { Department } from '../models/department';
import { Observable, catchError } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class DepartmentService extends SharedService{

  constructor(private http: HttpClient) { super(); }

  createDepartment(department: Department): Observable<Department> {
    return this.http.post<Department>(`${API_URL7161}/department`, department).pipe(catchError(super.handleError));
  }
}
