import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { EmployeeService } from '../services/employee.service';
import { Employee } from '../models/employee';

@Component({
  selector: 'app-employee-create',
  templateUrl: './employee-create.component.html',
  styleUrls: ['./employee-create.component.css']
})
export class EmployeeCreateComponent implements OnInit {
  employeeForm: FormGroup;

  constructor(private fb: FormBuilder, private employeeService: EmployeeService) {
    this.employeeForm = this.fb.group({
      firstName: ['', [Validators.required, Validators.maxLength(50)]],
      middleInitial: ['', Validators.maxLength(1)],
      lastName: ['', [Validators.required, Validators.maxLength(50)]],
      email: ['', [Validators.required, Validators.email, Validators.maxLength(255)]],
      hashedPassword: ['', [Validators.required, Validators.maxLength(255)]],
      streetAddress: ['', [Validators.maxLength(255)]],
      city: ['', [Validators.maxLength(50)]],
      postalCode: ['', [Validators.maxLength(50)]],
      sin: ['', [Validators.maxLength(9)]],
      jobTitle: ['', [Validators.maxLength(60)]],
      companyStartDate: ['', Validators.required],
      jobStartDate: ['', Validators.required],
      officeLocation: ['', [Validators.maxLength(255)]],
      workPhoneNumber: ['', [Validators.maxLength(12)]],
      cellPhoneNumber: ['', [Validators.maxLength(12)]],
      isActive: ['', Validators.required],
      supervisorEmpNumber: ['', Validators.required],
      departmentId: ['', Validators.required],
      roleId: ['', Validators.required]
    });
  }
  
  ngOnInit(): void {
  }

  onSubmit(): void {
    if (this.employeeForm.valid) {
      const employee: Employee = this.employeeForm.value;
      this.employeeService.createEmployee(employee).subscribe({
        next: (res) => console.log('Employee created', res),
        error: (err) => console.error('Error creating employee', err)
      });
    }
  }
}
