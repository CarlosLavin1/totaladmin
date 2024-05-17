import { Component, OnInit } from '@angular/core';
import { ReviewService } from '../services/review.service';
import { ActivatedRoute, Router } from '@angular/router';
import { Review } from '../models/review';
import { EmployeeService } from '../services/employee.service';

@Component({
  selector: 'app-review-details',
  templateUrl: './review-details.component.html',
  styleUrls: ['./review-details.component.css']
})
export class ReviewDetailsComponent implements OnInit{
  reviewId: number;
  review: Review;
  supervisorName: string;

  constructor(
    private reviewService: ReviewService,
    private activatedRoute: ActivatedRoute,
    private router: Router,
    private employeeService: EmployeeService
  ){}

  ngOnInit(){
    // set reviewId
    const idParam = this.activatedRoute.snapshot.paramMap.get('id');
    if (idParam != null) {
      this.reviewId = +idParam;
      if (isNaN(this.reviewId)) {
        this.router.navigate(['']);
      } 
    }
    this.reviewService.readReview(this.reviewId).subscribe({});
    this.reviewService.getReviewById(this.reviewId).subscribe(r => {
      this.review = r;
    });

    this.employeeService.getEmployeeById(this.review.supervisorEmployeeNumber).subscribe({
      next: data => {
        this.supervisorName = data.firstName + ' ' + data.lastName;
      }
    })
  }

  getRating(rating: number): string{
    if(rating == 1)
      return 'Below Expectations';
    else if (rating == 2)
      return 'Meets Expecatations';
    else if (rating == 3)
      return 'Exceeds Expecatations';
    return '';
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
