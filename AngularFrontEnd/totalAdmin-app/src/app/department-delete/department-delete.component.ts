import { Component } from '@angular/core';
import { Department } from '../models/department';
import { DepartmentService } from '../services/department.service';
import { FormBuilder } from '@angular/forms';
import { AuthenticationService } from '../auth/services/authentication.service';
import { ActivatedRoute, Router } from '@angular/router';
import { SnackbarService } from '../services/snackbar.service';
import { formatDate } from '@angular/common';
import { Subscription } from 'rxjs';
import { ValidationError } from '../models/validationError';

@Component({
  selector: 'app-department-delete',
  templateUrl: './department-delete.component.html',
  styleUrls: ['./department-delete.component.css']
})
export class DepartmentDeleteComponent {
  department: Department;
  departmentId: number;
  invocationDate: string;
  private subscriptions: Subscription[] = [];
  errors: string[] = [];

  constructor(private formBuilder: FormBuilder,
    private departmentService: DepartmentService,
    private authService: AuthenticationService,
    private router: Router,
    private activatedRoute: ActivatedRoute,
    private snackbarService: SnackbarService
  ){}

  ngOnInit(){
    const idParam = this.activatedRoute.snapshot.paramMap.get('id');
    if (idParam != null) {
      this.departmentId = +idParam;
      if (!isNaN(this.departmentId)) {
        this.loadDepartment();
      } else {
        this.router.navigate(['']);
      }
    }
  }

  ngOnDestroy(): void {
    this.subscriptions.forEach((subscription) => subscription.unsubscribe());
  }

  loadDepartment(){
    const sub = this.departmentService.getDepartmentById(this.departmentId).subscribe(d => {
      this.departmentId = d.id;
      console.log(d);
      const formattedDate = formatDate(d.invocationDate, 'yyyy-MM-dd', 'en-US');
      this.invocationDate = formattedDate;
    });
    this.subscriptions.push(sub);
  }

  onDeleteDepartment(){
    const s = this.departmentService.deleteDepartment(this.departmentId).subscribe({
      next: () => {
        this.snackbarService.showSnackBar("Department deleted successfully", 0);
        setTimeout(() => {
          this.router.navigate(['/list-departments']);
          this.snackbarService.dismissSnackBar();
        }, 1800);
      },
      error: (err) => {
        // if err.error.errors exists, then I know its returning a ValidationError array back
        console.log(err);
        
        if (err.error.errors) {
          const validationErrors: ValidationError[] = err.error.errors;
          validationErrors.forEach((error) => {
            this.errors.push(error.description);
          });
        } else {
          this.errors.push(err.error); 
        }
      },
    });
    this.subscriptions.push(s);
  }
}
