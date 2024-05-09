import { Component, Input } from '@angular/core';
import { Employee } from '../models/employee';
import { EmployeeDetailDTO } from '../models/employee-detail-dto';

@Component({
  selector: 'app-employee-details',
  templateUrl: './employee-details.component.html',
  styleUrls: ['./employee-details.component.css']
})
export class EmployeeDetailsComponent {
  @Input() employee: EmployeeDetailDTO;

  constructor() { }
}
