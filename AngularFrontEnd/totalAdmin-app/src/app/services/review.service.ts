import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, catchError } from 'rxjs';
import { API_URL7161, SharedService } from './shared.service';
import { Review } from '../models/review';
import { Employee } from '../models/employee';
import { ReviewDTO } from '../models/review-dto';

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

    getEmployeesDueForReviewForSupervisor(supervisorEmployeeNumber: number): Observable<Employee[]> {
        return this.http.get<Employee[]>(`${API_URL7161}/review/due/${supervisorEmployeeNumber}`).pipe(catchError(super.handleError));
    }

    getEmployeesDueForReviewForSupervisorWithQuarter(supervisorEmployeeNumber: number): Observable<ReviewDTO[]> {
        return this.http.get<ReviewDTO[]>(`${API_URL7161}/review/pending/${supervisorEmployeeNumber}`).pipe(catchError(super.handleError));
    }

    getReviewsForEmployee(employeeNumber: number): Observable<Review[]>{
        return this.http.get<Review[]>(`${API_URL7161}/review/employee/${employeeNumber}`).pipe(catchError(super.handleError));
    }

    readReview(reviewId: number): Observable<any>{
        return this.http.get(`${API_URL7161}/review/read/${reviewId}`).pipe(catchError(super.handleError));
    }

    getReviewById(reviewId: number): Observable<Review>{
        return this.http.get<Review>(`${API_URL7161}/review/${reviewId}`).pipe(catchError(super.handleError));
    }
}