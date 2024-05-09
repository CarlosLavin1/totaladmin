import { Component } from '@angular/core';
import { Subscription } from 'rxjs';
import { Department } from '../models/department';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { DepartmentService } from '../services/department.service';
import { ActivatedRoute, Router } from '@angular/router';
import { SnackbarService } from '../services/snackbar.service';
import { ValidationError } from '../models/validationError';
import { AuthenticationService } from '../auth/services/authentication.service';

@Component({
  selector: 'app-department-update',
  templateUrl: './department-update.component.html',
  styleUrls: ['./department-update.component.css']
})
export class DepartmentUpdateComponent {
  private employeeNumber: number;
  private departmentId: number;
  private subscriptions: Subscription[] = [];
  errors: string[] = [];

  departmentForm: FormGroup = this.formBuilder.group({
    departmentId: 0,
    name: ['', Validators.required],
    description: ['', Validators.required],
    invocationDate: ['', Validators.required]
  });

  constructor(
    private formBuilder: FormBuilder,
    private departmentService: DepartmentService,
    private authService: AuthenticationService,
    private router: Router,
    private activatedRoute: ActivatedRoute,
    private snackbarService: SnackbarService
  ) {}

  ngOnInit(){
    this.employeeNumber = this.authService.getEmployeeNumber() ?? -1;
    this.loadDepartment();
  }

  ngOnDestroy(): void {
    this.subscriptions.forEach((subscription) => subscription.unsubscribe());
  }

  loadDepartment(){
     this.departmentService.getDepartmentForEmployee(this.employeeNumber).subscribe(d => {
      console.log(d);
      this.departmentForm.value.departmentId = d.departmentId;
      this.departmentForm.value.name = d.name;
      this.departmentForm.value.description = d.description;
      this.departmentForm.value.invocationDate = d.invocationDate;
     });
  }

  onSubmit() {
    if(this.departmentForm.valid){
      this.errors = [];
      const department: Department = this.departmentForm.value;
      
      const subscription = this.departmentService.updateDepartment(this.departmentId, department).subscribe({
        next: () => {
          this.snackbarService.showSnackBar("Department updated successfully", 0);
          setTimeout(() => {
            console.log('updated department');
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
