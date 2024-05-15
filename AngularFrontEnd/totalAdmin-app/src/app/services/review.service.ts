import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, catchError } from 'rxjs';
import { API_URL7161, SharedService } from './shared.service';
import { Review } from '../models/review';

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
}