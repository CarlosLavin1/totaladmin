import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { EmployeeService } from '../services/employee.service';
import { DepartmentService } from '../services/department.service';
import { SnackbarService } from '../services/snackbar.service';
import { DepartmentListDto } from '../models/department-list-dto';
import { Employee } from '../models/employee';
import { Subscription } from 'rxjs';
import { ValidationError } from '../models/validationError';
import { AuthenticationService } from '../auth/services/authentication.service';
import { formatDate } from '@angular/common';
import { sha256 } from 'js-sha256';

@Component({
  selector: 'app-update-personal-info',
  templateUrl: './update-personal-info.component.html',
  styleUrls: ['./update-personal-info.component.css']
})
export class UpdatePersonalInfoComponent {
  employeeNumber: number;
  departments: DepartmentListDto[] = [];
  supervisors: Employee[] = [];
  subscriptions: Subscription[] = [];
  errors: string[] = []
  hashedPassword: string;

  employeeForm: FormGroup; 

  constructor(
    private router: Router, 
    private formBuilder: FormBuilder, 
    private employeeService: EmployeeService, 
    private departmentService: DepartmentService,
    private snackBarService: SnackbarService,
    private activatedRoute: ActivatedRoute,
    private authService: AuthenticationService
  ) {}

  ngOnInit(){
    this.employeeForm = this.formBuilder.group({
      employeeNumber: '',
      firstName: ['', [Validators.required, Validators.maxLength(50)]],
      middleInitial: ['', Validators.maxLength(1)],
      lastName: ['', [Validators.required, Validators.maxLength(50)]],
      email: ['', [Validators.required, Validators.maxLength(255)]],
      hashedPassword: [this.hashedPassword, [Validators.required, Validators.maxLength(255)]],
      streetAddress: ['', [Validators.required, Validators.maxLength(255)]],
      city: ['', [Validators.required, Validators.maxLength(50)]],
      postalCode: ['', [Validators.required, Validators.maxLength(50)]],
      sin: ['', [Validators.required, Validators.maxLength(9)]],
      jobTitle: ['', [Validators.required, Validators.maxLength(60)]],
      seniorityDate: ['', Validators.required],
      jobStartDate: ['', Validators.required],
      dateOfBirth: ['', Validators.required],
      officeLocation: ['', [Validators.required, Validators.maxLength(255)]],
      workPhoneNumber: ['', [Validators.required, Validators.maxLength(12)]],
      cellPhoneNumber: ['', [Validators.required, Validators.maxLength(12)]],
      statusId: [1, Validators.required],
      supervisorEmployeeNumber: ['', Validators.required],
      departmentId: ['', Validators.required],
      roleId: ['', Validators.required],
      rowVersion: '',
      oldPassword: '',
      newPassword: ['', [Validators.minLength(6)]],
      confirmPassword: ''
    }, { validator: this.passwordMatchValidator });
    //this.employeeNumber = this.authService.getEmployeeNumber() ?? -1;
    const idParam = this.activatedRoute.snapshot.paramMap.get('id');
    if (idParam != null) {
      this.employeeNumber = +idParam;
      if (!isNaN(this.employeeNumber)) {
        this.loadEmployee();
      } else {
        this.router.navigate(['']);
      }
    }

    const sub = this.departmentService.getActiveDepartments().subscribe((depts) => {
      this.departments = depts;
    });
    this.subscriptions.push(sub);
  }

  passwordMatchValidator(fg: FormGroup): { [s: string]: boolean } | null {
    const newPassword = fg.get('newPassword')?.value;
    const confirmPassword = fg.get('confirmPassword')?.value;
    if (newPassword !== confirmPassword && newPassword) {
      return { 'passwordMismatch': true };
    }
    return null;
  }

  ngOnDestroy() {
    this.subscriptions.forEach((subscription) => subscription.unsubscribe());
  }

  loadEmployee(){
    const sub = this.employeeService.getEmployeeById(this.employeeNumber).subscribe(e => {
      console.log(e);
      this.employeeForm.patchValue(e);
    });
    this.subscriptions.push(sub);
  }

  onSubmit() {
    const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\$\@\$!\%\*?&])[A-Za-z\d\$\@\$\!\%\*?&]{6,}$/;
    if(this.employeeForm.valid){
      this.errors = [];
      const employee: Employee = this.employeeForm.value;
      console.log(employee);
      const oldPasswordInput = sha256(this.employeeForm.get('oldPassword')?.value);
      const hashedPassword = this.employeeForm.get('hashedPassword')?.value;
      const newPassword = this.employeeForm.get('newPassword')?.value;
      const confirmPassword = this.employeeForm.get('confirmPassword')?.value;
      // compare old pass to existing
      console.log((this.employeeForm.get('oldPassword')?.value.length == 0 && newPassword.length == 0 && confirmPassword.length == 0));
      if((this.employeeForm.get('oldPassword')?.value.length == 0 && newPassword.length == 0 && confirmPassword.length == 0)){
        const subscription = this.employeeService.updateEmployee(this.employeeNumber, employee).subscribe({
          next: () => {
            this.snackBarService.showSnackBar("Personal Info Updated Successfully", 0);
            setTimeout(() => {
              console.log('updated personal info');
              this.router.navigate(['']);
              this.snackBarService.dismissSnackBar();
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
        return;
      }
      if (hashedPassword == oldPasswordInput) {
        if(!passwordRegex.test(newPassword)){
          console.error('new password is too weak');
          this.errors.push("New password is too weak, please include 1 uppercase letter, 1 number, and 1 special character");
          return;
        }
        console.log('Old password is correct. Proceeding with update.');
        employee.hashedPassword = sha256(newPassword);

        const subscription = this.employeeService.updateEmployee(this.employeeNumber, employee).subscribe({
          next: () => {
            this.snackBarService.showSnackBar("Personal Info Updated Successfully", 0);
            setTimeout(() => {
              console.log('updated personal info');
              this.router.navigate(['']);
              this.snackBarService.dismissSnackBar();
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
      } else {
        console.error('Old password does not match.');
        this.errors.push("Old password is incorrect");
      }
    }
  }
}
