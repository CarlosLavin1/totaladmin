import { Component, OnDestroy, OnInit } from '@angular/core';
import { POSupervisorFiltersDTO } from '../models/posupervisor-filters-dto';
import { Subscription } from 'rxjs';
import { ValidationError } from '../models/validationError';
import { FormBuilder, FormGroup } from '@angular/forms';
import { PurchaseOrderService } from '../services/purchase-order.service';
import { ActivatedRoute, Router } from '@angular/router';
import { SharedDataService } from '../services/shared-data.service';
import { AuthenticationService } from '../auth/services/authentication.service';
import { DepartmentService } from '../services/department.service';
import { SnackbarService } from '../services/snackbar.service';
import { PurchaseOrder } from '../models/purchase-order';

@Component({
  selector: 'app-search-department-po',
  templateUrl: './search-department-po.component.html',
  styleUrls: ['./search-department-po.component.css']
})
export class SearchDepartmentPOComponent implements OnInit, OnDestroy {
  public departmentId: number;
  private subscriptions: Subscription[] = [];
  errors: string[] = [];

  validationErrors: ValidationError[] = [];
  public employeeNumber = localStorage.getItem('employeeNumber');

  searchResults: PurchaseOrder[] = [];
  private subscription: Subscription;

  searchForm: FormGroup = this.formBuilder.group({
    EmployeeName: [''],
    StartDate: [''],
    EndDate: [''],
    PONumber: [''],
    Status: ['pending'] 
  });

  // Define the mapping between status strings and integers
  status = {
    'pending': 1,
    'under review': 2,
    'closed': 3,
    'all': 4
  };

  constructor(
    private formBuilder: FormBuilder,
    private poService: PurchaseOrderService,
    private activatedRoute: ActivatedRoute,
    private router: Router,
    private sharedDataService: SharedDataService,
    private authService: AuthenticationService,
    private departmentService: DepartmentService,
    private snackbarService: SnackbarService
  ) { }


  ngOnInit(): void {
  }
  ngOnDestroy(): void {
  }

  onSubmit(): void {
    if (this.checkRole()) {

      if (this.employeeNumber) {
        this.departmentService.getDepartmentForEmployee(Number(this.employeeNumber)).subscribe(department => {

          this.departmentId = department.id;

          // Get the status from the form
          const status = this.searchForm.value.Status;

          // Check the status
          if (status === 'all') {
            // load all purchase orders
            this.loadPurchaseOrders(this.departmentId);
          } else {
            this.loadPurchaseOrders(this.departmentId); // load with filiters
          }
        });
      }
    }
  }

  checkRole(): boolean {
    const userRole = this.authService.getRole();
    console.log('Checking role, userRole:', userRole);
    return userRole === 'Supervisor' || userRole === 'HR Employee' || userRole === 'HR Supervisor';
  }

  loadPurchaseOrders(departmentId: number): Subscription {
    let validationErrors: ValidationError[] = [];
    this.errors = [];
    this.searchResults = [];

    // Get the search criteria from the form
    const searchCriteria = this.searchForm.value;

    if (searchCriteria.Status === 'all') {
      searchCriteria.Status = null;
    }  

    // Map the status string to an integer
    const statusInt = this.status[searchCriteria.Status as keyof typeof this.status];

    // Create a new object with the search criteria and department ID
    let filters: POSupervisorFiltersDTO = {
      ...searchCriteria,
      DepartmentId: departmentId
    };

    if (searchCriteria.Status !== null) {
      filters.Status = statusInt.toString();
    }


    return this.poService.SearchPurchaseOrdersForSupervisor(filters)
      .subscribe({
        next: (po) => {
          // Assign the returned purchase orders to the searchResults
          this.searchResults = po;

          console.log(this.searchResults);


          // If no purchase orders are returned, show an error message
          if (po.length === 0) {
            this.showErrorMessage('No purchase orders found for the provided search criteria.');
          }
        },
        error: (error) => {
          console.error('Error retrieving purchase orders:', error);

          this.errors = [];
          if (error.status === 404) {
            this.showErrorMessage('No purchase orders found');
          } else if (error.error.errors) {
            validationErrors = error.error.errors;

            validationErrors.forEach((error) => {
              this.showErrorMessage(error.description);
            });
          } else {
            this.showErrorMessage(error.error.title);
          }
        }
      });
  }

  showErrorMessage(message: string) {
    this.errors.push(message);
  }

}
