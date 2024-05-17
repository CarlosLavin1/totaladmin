import { Component } from '@angular/core';
import { Employee } from '../models/employee';
import { ReviewService } from '../services/review.service';
import { ReviewDTO } from '../models/review-dto';

@Component({
  selector: 'app-employees-due-for-review',
  templateUrl: './employees-due-for-review.component.html',
  styleUrls: ['./employees-due-for-review.component.css']
})
export class EmployeesDueForReviewComponent {
  employees: ReviewDTO[];
  supervisorEmpNumber: number;

  constructor(
    private reviewService: ReviewService
  ){}

  ngOnInit(): void {
    this.supervisorEmpNumber = Number(localStorage.getItem('employeeNumber'));
    console.log(this.supervisorEmpNumber);
    this.loadEmployees();
  }

  loadEmployees(): void{
    this.reviewService.getEmployeesDueForReviewForSupervisorWithQuarter(this.supervisorEmpNumber).subscribe({
      next: (data) => {
        this.employees = data;
        console.log(data);
        
      },
      error: (err) => console.error('Failed to load employee list', err)
    });
  }
}
