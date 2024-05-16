import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Subscription } from 'rxjs';
import { ReviewService } from '../services/review.service';
import { ActivatedRoute, Router } from '@angular/router';
import { Review } from '../models/review';
import { ValidationError } from '../models/validationError';
import { SnackbarService } from '../services/snackbar.service';

@Component({
  selector: 'app-review-create',
  templateUrl: './review-create.component.html',
  styleUrls: ['./review-create.component.css']
})
export class ReviewCreateComponent {
  subscriptions: Subscription[] = [];
  errors: string[] = []
  reviewForm: FormGroup;
  supervisorEmployeeNumber: number; // get from logged in supervisor
  employeeNumber: number // get from param

  constructor(
    private fb: FormBuilder,
    private reviewService: ReviewService,
    private router: Router,
    private snackBarService: SnackbarService,
    private activatedRoute: ActivatedRoute
  ) {}

  ngOnInit(): void {
    this.reviewForm = this.fb.group({
      ratingId: [null, Validators.required],
      comment: ['', Validators.required],
      reviewDate: ['', Validators.required],
      hasBeenRead: [false]
    });

    this.supervisorEmployeeNumber = Number(localStorage.getItem('employeeNumber'));

    const idParam = this.activatedRoute.snapshot.paramMap.get('id');
    if (idParam != null) {
      this.employeeNumber = +idParam;
      if (isNaN(this.employeeNumber)) {
        this.router.navigate(['']);
      } 
    }
  }

  onSubmit(): void {
    if (this.reviewForm.valid) {
      const review = {
        ...this.reviewForm.value,
        employeeNumber: this.employeeNumber,
        supervisorEmployeeNumber: this.supervisorEmployeeNumber,
        hasBeenRead: false
      }
      console.log(review);
      
      this.reviewService.createReview(review).subscribe({
        next: (res) => {
          console.log(res);
          this.snackBarService.showSnackBar("Review created successfully", 0);
          setTimeout(() => {
            console.log('Succesfully created review');
            this.router.navigate(['']);
            this.snackBarService.dismissSnackBar(); 
          }, 1800);
        },
        error: (err) => {
          console.log(err);
          if (err.error.errors) {
            const validationErrors: ValidationError[] = err.error.errors;
            validationErrors.forEach((error) => {
              this.errors.push(error.description);
            });
          } else {
            this.errors.push(err.error.title);
          }
        }
      });
    }
  }
}
