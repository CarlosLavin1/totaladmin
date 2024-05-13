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
import { sha256 } from 'js-sha256';
import { formatDate } from '@angular/common';

@Component({
  selector: 'app-employee-update',
  templateUrl: './employee-update.component.html',
  styleUrls: ['./employee-update.component.css']
})
export class EmployeeUpdateComponent {
  employeeNumber: number;
  departments: DepartmentListDto[] = [];
  supervisors: Employee[] = [];
  subscriptions: Subscription[] = [];
  errors: string[] = []
  hashedPassword: string;
  loadingData: boolean = true;
  oldJobTitle: string = '';
  oldJobStartDate: string = '';

  employeeForm: FormGroup; 

  constructor(
    private router: Router, 
    private formBuilder: FormBuilder, 
    private employeeService: EmployeeService, 
    private departmentService: DepartmentService,
    private snackBarService: SnackbarService,
    private activatedRoute: ActivatedRoute
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
      retiredDate: '',
      terminatedDate: '',
      statusId: ['', Validators.required],
      supervisorEmployeeNumber: ['', Validators.required],
      departmentId: ['', Validators.required],
      roleId: ['', Validators.required],
      rowVersion: '',
      newPassword: ''
    });
    //this.employeeNumber = this.authService.getEmployeeNumber() ?? -1;
    const idParam = this.activatedRoute.snapshot.paramMap.get('id');
    if (idParam != null) {
      this.employeeNumber = +idParam;
      if (!isNaN(this.employeeNumber)) {
        this.loadingData = true;
        this.loadEmployee();
        this.loadingData = false;
      } else {
        this.router.navigate(['']);
      }
    }

    const sub = this.departmentService.getActiveDepartments().subscribe((depts) => {
      this.departments = depts;
    });
    this.subscriptions.push(sub);

    this.employeeForm.get('roleId')!.valueChanges.subscribe(roleId => {
      this.updateSupervisors();
    });

    this.employeeForm.get('departmentId')!.valueChanges.subscribe(departmentId => {
      this.updateSupervisors();
    });

    this.employeeForm.get('jobTitle')?.valueChanges.subscribe(() => {
      if (!this.loadingData && this.employeeForm.get('jobTitle')?.dirty && this.employeeForm.get('jobTitle')?.value != this.oldJobTitle) { 
        const today = formatDate(new Date(), 'yyyy-MM-dd', 'en-US');
        this.employeeForm.get('jobStartDate')?.setValue(today);
      } else if (this.employeeForm.get('jobTitle')?.value == this.oldJobTitle){
        this.employeeForm.get('jobStartDate')?.setValue(this.oldJobStartDate);
      }
    });

    this.onStatusChange();
  }

  private onStatusChange() {
    const sub = this.employeeForm.get('statusId')?.valueChanges.subscribe(status => {
      if (status == '2') { // Retired
        this.employeeForm.get('retiredDate')?.setValidators([Validators.required]);
        this.employeeForm.get('terminatedDate')?.clearValidators();
      } else if (status == '3') { // Terminated
        this.employeeForm.get('terminatedDate')?.setValidators([Validators.required]);
        this.employeeForm.get('retiredDate')?.clearValidators();
      } else {
        this.employeeForm.get('retiredDate')?.clearValidators();
        this.employeeForm.get('terminatedDate')?.clearValidators();
      }
      this.employeeForm.get('retiredDate')?.updateValueAndValidity();
      this.employeeForm.get('terminatedDate')?.updateValueAndValidity();
    });
    this.subscriptions.push(sub!);
  }

  ngOnDestroy() {
    this.subscriptions.forEach((subscription) => subscription.unsubscribe());
  }

  updateSupervisors() {
    const roleId = this.employeeForm.get('roleId')!.value;
    const departmentId = this.employeeForm.get('departmentId')!.value;
    if (roleId && departmentId) {
      // get relevant supervisors from service
      const roleIdInt: number = +roleId;
      const departmentIdInt: number = +departmentId;
      console.log('supervisors updated role: ' + roleIdInt + ' department: ' + departmentIdInt)
      this.employeeService.getSupervisors(roleIdInt, departmentIdInt).subscribe(supervisors => {
        this.supervisors = supervisors;
      });
    }
  }

  loadEmployee(){
    const sub = this.employeeService.getEmployeeById(this.employeeNumber).subscribe(e => {
      console.log(e);
      const formattedSeniorityDate = formatDate(e.seniorityDate, 'yyyy-MM-dd', 'en-US');
      const formattedJobStartDate = formatDate(e.jobStartDate, 'yyyy-MM-dd', 'en-US');
      const formattedDateOfBirth = formatDate(e.dateOfBirth, 'yyyy-MM-dd', 'en-US');
      let formattedRetiredDate = null;
      let formattedTerminatedDate = null;
      if(e.retiredDate != null)
        formattedRetiredDate = formatDate(e.retiredDate!, 'yyyy-MM-dd', 'en-US');
      if(e.terminatedDate != null)
        formattedTerminatedDate = formatDate(e.terminatedDate!, 'yyyy-MM-dd', 'en-US');
      e.dateOfBirth = formattedDateOfBirth;
      e.jobStartDate = formattedJobStartDate;
      e.seniorityDate = formattedSeniorityDate;
      e.terminatedDate = formattedTerminatedDate;
      e.retiredDate = formattedRetiredDate;
      // disable picker if retired
      if (e.statusId == 2) {
        this.employeeForm.get('statusId')?.disable();
        this.employeeForm.get('retiredDate')?.disable();
      }
      // set old job title and job start date
      this.oldJobStartDate = formattedJobStartDate;
      this.oldJobTitle = e.jobTitle;

      this.employeeForm.patchValue(e);
    });
    this.subscriptions.push(sub);
  }

  async onSubmit(){
    const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\$\@\$!\%\*?&])[A-Za-z\d\$\@\$\!\%\*?&]{6,}$/;
    
    if(this.employeeForm.valid){
      this.errors = [];
      const employee: Employee = this.employeeForm.value;
      employee.statusId = this.employeeForm.get('statusId')?.value;
      employee.retiredDate = this.employeeForm.get('retiredDate')?.value;
      console.log(employee);
      if (this.employeeForm.get('newPassword')?.value != '') {
        // password has been changed
        const newPassword = this.employeeForm.get('newPassword')?.value;
        //check password constraints
        if(!passwordRegex.test(newPassword)){
          console.error('new password is too weak');
          this.errors.push("New password is too weak, please include 1 uppercase letter, 1 number, and 1 special character");
          return;
        }
        // Send back the new password as hashed
        employee.hashedPassword = sha256(newPassword);
        const subscription = this.employeeService.employeeUpdate(this.employeeNumber, employee).subscribe({
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
        // If the password has not been changed
        // Send back the old hashed password
        const subscription = this.employeeService.employeeUpdate(this.employeeNumber, employee).subscribe({
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
              this.errors.push(err.error);
            }
          },
        });
        this.subscriptions.push(subscription);
      }
    }
  }
}
