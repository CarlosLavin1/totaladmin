import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { EmployeeService } from '../services/employee.service';
import { Employee } from '../models/employee';
import { DepartmentListDto } from '../models/department-list-dto';
import { DepartmentService } from '../services/department.service';
import { Router } from '@angular/router';
import { ValidationError } from '../models/validationError';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-employee-create',
  templateUrl: './employee-create.component.html',
  styleUrls: ['./employee-create.component.css']
})
export class EmployeeCreateComponent {
  private employeeNumber: number;
  departments: DepartmentListDto[] = [];
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
    isActive: [true, Validators.required],
    supervisorEmployeeNumber: ['', Validators.required],
    departmentId: ['', Validators.required],
    roleId: ['', Validators.required]
  });

  constructor(private router: Router, private formBuilder: FormBuilder, private employeeService: EmployeeService, private departmentService: DepartmentService) {
    
  }
  
  ngOnInit(): void {
    this.departmentService.getActiveDepartments().subscribe((depts) => {
      this.departments = depts;
    });
  }

  ngOnDestroy() {
    this.subscriptions.forEach((subscription) => subscription.unsubscribe());
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
          setTimeout(() => {
            console.log('Succesfully added employee');
            this.router.navigate(['']);
          }, 1000);
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
