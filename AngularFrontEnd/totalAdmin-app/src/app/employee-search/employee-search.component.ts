import { Component } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { EmployeeDetailDTO } from '../models/employee-detail-dto';
import { EmployeeService } from '../services/employee.service';

@Component({
  selector: 'app-employee-search',
  templateUrl: './employee-search.component.html',
  styleUrls: ['./employee-search.component.css']
})
export class EmployeeSearchComponent {
  noResults: boolean = false;
  searchForm: FormGroup;
  employees: EmployeeDetailDTO[] = [];

  constructor(private fb: FormBuilder, private employeeService: EmployeeService) {
    this.searchForm = this.fb.group({
      lastName: '',
      employeeNumber: ''
    });
  }

  onSubmit(): void {
    const regex: RegExp = /^\d{8}$/;
    let { lastName, employeeNumber } = this.searchForm.value;
    // if empty make empNumber -1 if nonsense make empNumber -999
    if(employeeNumber == ''){
      employeeNumber = -1;
    } else if (!regex.test(employeeNumber)){
      employeeNumber = -999;
    } else{
      employeeNumber = +employeeNumber;
    }
    console.log(employeeNumber);
    this.employeeService.searchEmployees(lastName, employeeNumber).subscribe({
      next: (data) => {
        console.log(data);
        //this.employees = data; 
        this.employees = data.map(e => ({
          ...e,
          showDetails: false
        }));
        this.noResults = this.employees.length == 0
      },
      error: (err) => {console.error('Error fetching employees', err); this.noResults = true;}
    });
  }

  toggleDetails(index: number): void {
    this.employees[index].showDetails = !this.employees[index].showDetails;
  }
}
