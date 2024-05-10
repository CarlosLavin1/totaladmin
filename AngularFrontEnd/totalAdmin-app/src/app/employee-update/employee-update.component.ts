import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { EmployeeService } from '../services/employee.service';
import { DepartmentService } from '../services/department.service';
import { SnackbarService } from '../services/snackbar.service';
import { DepartmentListDto } from '../models/department-list-dto';
import { Employee } from '../models/employee';
import { Subscription } from 'rxjs';

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
      rowVersion: ''
    });
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

  loadEmployee(){
    const sub = this.employeeService.getEmployeeById(this.employeeNumber).subscribe(e => {
      console.log(e);
      this.employeeForm.patchValue(e);
    });
    this.subscriptions.push(sub);
  }

  onSubmit(){
    if (this.employeeForm.get('hashedPassword')?.dirty) {
      // password has been changed
      const newPassword = this.employeeForm.get('hashedPassword')?.value;
      // Send back the new password
      console.log('New password:', newPassword);
    } else {
      // If the password has not been changed
      // Send back the hashed password
      console.log('Hashed password:', this.hashedPassword);
    }
  }
}
