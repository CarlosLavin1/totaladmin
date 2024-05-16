import { Component, OnInit } from '@angular/core';
import { Review } from '../models/review';
import { ReviewService } from '../services/review.service';

@Component({
  selector: 'app-reviews-for-employee',
  templateUrl: './reviews-for-employee.component.html',
  styleUrls: ['./reviews-for-employee.component.css']
})
export class ReviewsForEmployeeComponent implements OnInit {
  employeeNumber: number;
  reviews: Review[] = [];

  constructor(
    private reviewService: ReviewService
  ){}

  ngOnInit(){
    this.employeeNumber = Number(localStorage.getItem('employeeNumber'));
    console.log('emp number: ' + this.employeeNumber);
    this.loadReviews();
  }

  loadReviews(){
    this.reviewService.getReviewsForEmployee(this.employeeNumber).subscribe({
      next: data => {
        this.reviews = data;
        console.log(data);
      }
    });
  }

  getFormattedDate(date: string | Date): string {
    const reviewDate = new Date(date);
    const year = reviewDate.getFullYear();
    const month = reviewDate.getMonth() + 1; // getMonth() is zero-based

    let quarter: string;
    if (month >= 1 && month <= 3) {
      quarter = 'Q1';
    } else if (month >= 4 && month <= 6) {
      quarter = 'Q2';
    } else if (month >= 7 && month <= 9) {
      quarter = 'Q3';
    } else {
      quarter = 'Q4';
    }

    return `${year} ${quarter}`;
  }
}
