import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, catchError } from 'rxjs';
import { API_URL7161, SharedService } from './shared.service';
import { Review } from '../models/review';
import { Employee } from '../models/employee';

@Injectable({
  providedIn: 'root'
})
export class ReviewService extends SharedService{
    constructor(private http: HttpClient) { 
        super();
    }

    createReview(review: Review): Observable<Review> {
        return this.http.post<Review>(`${API_URL7161}/review`, review).pipe(catchError(super.handleError));
    }

    getEmployeesDueForReviewForSupervisor(supervisorEmployeeNumber: number): Observable<Employee> {
        return this.http.get<Employee>(`${API_URL7161}/review/due/${supervisorEmployeeNumber}`).pipe(catchError(super.handleError));
    }
}