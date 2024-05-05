import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { DepartmentService } from '../services/department.service';
import { ActivatedRoute, Router } from '@angular/router';
import { Department } from '../models/department';
import { ValidationError } from '../models/validationError';
import { Subscription } from 'rxjs';
import { SnackbarService } from '../services/snackbar.service';

@Component({
  selector: 'app-department-create',
  templateUrl: './department-create.component.html',
  styleUrls: ['./department-create.component.css']
})
export class DepartmentCreateComponent {
  private departmentId: number;
  private subscriptions: Subscription[] = [];
  errors: string[] = [];

  departmentForm: FormGroup = this.formBuilder.group({
    name: ['', Validators.required],
    description: ['', Validators.required],
    invocationDate: ['', Validators.required]
  });

  constructor(
    private formBuilder: FormBuilder,
    private departmentService: DepartmentService,
    private router: Router,
    private activatedRoute: ActivatedRoute,
    private snackbarService: SnackbarService
  ) {}

  ngOnDestroy(): void {
    this.subscriptions.forEach((subscription) => subscription.unsubscribe());
  }

  onSubmit() {
    if(this.departmentForm.valid){
      this.errors = [];
      const department: Department = this.departmentForm.value;
      
      const subscription = this.departmentService.createDepartment(department).subscribe({
        next: () => {
          this.snackbarService.showSnackBar("Department added successfully", 0);
          setTimeout(() => {
            console.log('Succesfully added department');
            this.router.navigate(['']);
            this.snackbarService.dismissSnackBar();
          }, 1800);
        },
        error: (err) => {
          // if err.error.errors exists, then I know its returning a ValidationError array back
          if (err.error.errors) {
            const validationErrors: ValidationError[] = err.error.errors;
            validationErrors.forEach((error) => {
              this.errors.push(error.description);
            });
          } else {
            this.errors.push(err.error.title);
          }
        },
      });
      this.subscriptions.push(subscription);
    }
    
  }
}
