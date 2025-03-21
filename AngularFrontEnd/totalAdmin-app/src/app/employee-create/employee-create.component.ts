import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { EmployeeService } from '../services/employee.service';
import { Employee } from '../models/employee';
import { DepartmentListDto } from '../models/department-list-dto';
import { DepartmentService } from '../services/department.service';
import { Router } from '@angular/router';
import { ValidationError } from '../models/validationError';
import { Subscription } from 'rxjs';
import { SnackbarService } from '../services/snackbar.service';

@Component({
  selector: 'app-employee-create',
  templateUrl: './employee-create.component.html',
  styleUrls: ['./employee-create.component.css']
})
export class EmployeeCreateComponent {
  private employeeNumber: number;
  departments: DepartmentListDto[] = [];
  supervisors: Employee[] = [];
  subscriptions: Subscription[] = [];
  errors: string[] = []

  employeeForm: FormGroup = this.formBuilder.group({
    firstName: ['', [Validators.required, Validators.maxLength(50)]],
    middleInitial: ['', Validators.maxLength(1)],
    lastName: ['', [Validators.required, Validators.maxLength(50)]],
    email: ['', [Validators.required, Validators.maxLength(255)]],
    hashedPassword: ['', [Validators.required, Validators.maxLength(255)]],
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
    roleId: ['', Validators.required]
  });

  constructor(
    private router: Router, 
    private formBuilder: FormBuilder, 
    private employeeService: EmployeeService, 
    private departmentService: DepartmentService,
    private snackBarService: SnackbarService) {
    
  }
  
  ngOnInit(): void {
    this.departmentService.getActiveDepartments().subscribe((depts) => {
      this.departments = depts;
    });

    // Listen to changes in role and department
    this.employeeForm.get('roleId')!.valueChanges.subscribe(roleId => {
      this.updateSupervisors();
    });

    this.employeeForm.get('departmentId')!.valueChanges.subscribe(departmentId => {
      this.updateSupervisors();
    });
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

  onSubmit(): void {
    const formValue = {
      ...this.employeeForm.value,
      supervisorEmpNumber: +this.employeeForm.value.supervisorEmpNumber,
      departmentId: +this.employeeForm.value.departmentId,
      roleId: +this.employeeForm.value.roleId
    };

    if (this.employeeForm.valid) {
      this.errors = [];
      //const employee: Employee = this.employeeForm.value;
      const employee: Employee = formValue;
      console.log(employee);
      this.employeeService.createEmployee(employee).subscribe({
        next: (res) => {
          console.log(res);
          this.snackBarService.showSnackBar("Employee added successfully", 0);
          setTimeout(() => {
            console.log('Succesfully added employee');
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
