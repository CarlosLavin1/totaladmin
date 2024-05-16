import { Component } from '@angular/core';
import { Review } from '../models/review';
import { ReviewService } from '../services/review.service';

@Component({
  selector: 'app-reviews-for-employee',
  templateUrl: './reviews-for-employee.component.html',
  styleUrls: ['./reviews-for-employee.component.css']
})
export class ReviewsForEmployeeComponent {
  employeeNumber: number;
  reviews: Review[] = [];

  constructor(
    private reviewService: ReviewService
  ){}

  onInit(){
    this.employeeNumber = Number(localStorage.getItem('employeeNumber'));
    this.loadReviews();
  }

  loadReviews(){
    this.reviewService.getReviewsForEmployee(this.employeeNumber).subscribe(r => {
      this.reviews = r;
    });
  }
}
