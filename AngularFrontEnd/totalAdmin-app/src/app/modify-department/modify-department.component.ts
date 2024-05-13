import { Component } from '@angular/core';
import { Department } from '../models/department';
import { formatDate } from '@angular/common';
import { AuthenticationService } from '../auth/services/authentication.service';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { DepartmentService } from '../services/department.service';
import { ActivatedRoute, Router } from '@angular/router';
import { SnackbarService } from '../services/snackbar.service';
import { Subscription } from 'rxjs';
import { ValidationError } from '../models/validationError';

@Component({
  selector: 'app-modify-department',
  templateUrl: './modify-department.component.html',
  styleUrls: ['./modify-department.component.css']
})
export class ModifyDepartmentComponent {
  private employeeNumber: number;
  private departmentId: number;
  private subscriptions: Subscription[] = [];
  errors: string[] = [];

  departmentForm: FormGroup = this.formBuilder.group({
    id: 0,
    name: ['', Validators.required],
    description: ['', Validators.required],
    invocationDate: ['', Validators.required],
    rowVersion: ''
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
      this.departmentForm.patchValue({
        id: d.id,
        name: d.name,
        description: d.description,
        invocationDate: formattedDate,
        rowVersion: d.rowVersion
      });
    });
    this.subscriptions.push(sub);
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
          console.log(err);
          
          if (err.error.errors) {
            const validationErrors: ValidationError[] = err.error.errors;
            validationErrors.forEach((error) => {
              this.errors.push(error.description);
            });
          } else {
            this.errors.push(err.error); //this is for concurrency
          }
        },
      });
      this.subscriptions.push(subscription);
    }
    
  }
}
