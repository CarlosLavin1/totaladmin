import { Component } from '@angular/core';
import { Department } from '../models/department';
import { DepartmentService } from '../services/department.service';
import { DepartmentListDto } from '../models/department-list-dto';

@Component({
  selector: 'app-list-departments',
  templateUrl: './list-departments.component.html',
  styleUrls: ['./list-departments.component.css']
})
export class ListDepartmentsComponent {
  departments: DepartmentListDto[] = [];

  constructor(private departmentService: DepartmentService) {}

  ngOnInit(): void {
    this.loadDepartments();
  }

  loadDepartments(): void {
    this.departmentService.getActiveDepartments().subscribe({
      next: (data) => this.departments = data,
      error: (err) => console.error('Failed to load departments', err)
    });
  }
}
