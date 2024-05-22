import { AfterViewInit, Component, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { PurchaseOrderService } from '../services/purchase-order.service';
import { ValidationError } from '../models/validationError';
import { Router, ActivatedRoute } from '@angular/router';
import { Observable, Subscription } from 'rxjs';
import { POSearchFiltersDTO } from '../models/posearch-filters-dto';
import { PODisplayDTO } from '../models/podisplay-dto';
import { SharedDataService } from '../services/shared-data.service';
import { AuthenticationService } from '../auth/services/authentication.service';
import { ItemDialogFormComponent } from '../create-item/item-dialog-form.component';


@Component({
  selector: 'app-purchase-order-search',
  templateUrl: './purchase-order-search.component.html',
  styleUrls: ['./purchase-order-search.component.css']
})
export class PurchaseOrderSearchComponent implements OnInit, OnDestroy, AfterViewInit {
  @ViewChild(ItemDialogFormComponent) modalDialog!: ItemDialogFormComponent;
  

  private subscriptions: Subscription[] = [];
  errors: string[] = [];

  validationErrors: ValidationError[] = [];
  public employeeNumber = localStorage.getItem('employeeNumber');

  searchResults: PODisplayDTO[] = [];
  private subscription: Subscription;

  searchForm: FormGroup = this.formBuilder.group({
    EmployeeNumber: [{value:'',  disabled: !this.checkRole()},  Validators.required],
    StartDate: [''],
    EndDate: [''],
    PONumber: ['']
  });


  constructor(
    private formBuilder: FormBuilder,
    private poService: PurchaseOrderService,
    private activatedRoute: ActivatedRoute,
    private router: Router,
    private sharedDataService: SharedDataService,
    private authService: AuthenticationService,
  ) {}


  ngOnInit(): void {
    if (!this.checkRole()) {
      this.searchForm.get('EmployeeNumber')?.disable();
    }

    this.activatedRoute.queryParams.subscribe(params => {
      const poNumber = params['PONumber'];
      this.searchForm.get('PONumber')?.setValue(poNumber);
    });
    this.searchForm.get('EmployeeNumber')?.setValue(this.employeeNumber);
  }

  ngAfterViewInit(): void {
    this.subscription = this.sharedDataService.data.subscribe(data => {
      if (data && data.autoSearch) {
        // Get the values
        this.searchForm.get('EmployeeNumber')?.setValue(data.EmployeeNumber);
        
        if (data.PONumber !== '') {
          this.searchForm.get('PONumber')?.setValue(data.PONumber);
        }

        this.onSubmit(); // Trigger the search
        console.log(data);
        
      }
    });

    console.log(this.sharedDataService);
    
  }

  ngOnDestroy(): void{
    this.subscription.unsubscribe();
  }


  onSubmit() {
    if (this.searchForm.valid) {
      const filter: POSearchFiltersDTO = {
        EmployeeNumber: this.searchForm.get('EmployeeNumber')?.value,
        StartDate: this.searchForm.get('StartDate')?.value ? new Date(this.searchForm.get('StartDate')?.value) : undefined,
        EndDate: this.searchForm.get('EndDate')?.value ? new Date(this.searchForm.get('EndDate')?.value) : undefined,
        PONumber: this.searchForm.get('PONumber')?.value
      };
      this.searchPO(filter);
      console.log(filter.EmployeeNumber + ' ' + filter.PONumber + ' ' + filter.StartDate + ' ' + filter.EndDate);
      
    }
  }

  private searchPO(filter: POSearchFiltersDTO) {
    this.errors = []

    const subscription = this.poService.SearchPurchaseOrders(filter)
      .subscribe({
        next: (results) => {
          this.searchResults = results || [];
          console.log(results.toString);
          console.log('the search results:');
          this.searchResults.forEach((result) => {
            if (results) {
              console.log(results);
            }
          });
        },
        error: (error) => {
          console.error('Error searching purchase orders:', error);
          console.log('Error object:', JSON.stringify(error, null, 2));
          this.errors = []
          this.searchResults = [];
          this.validationErrors = [];

          if (error.status === 404) {
            this.showErrorMessage('No purchase orders found matching the provided filters.');
          }
          else if (error.error.errors) {
            const validationErrors: ValidationError[] = error.error.errors;
            validationErrors.forEach((error) => {
              this.errors.push(error.description);
            });
          } else {
            this.errors.push(error.error);
          }
        }
      });
    this.subscriptions.push(subscription);
  }

  navigateToAddItem(poNumber: number) {
    this.sharedDataService.setPONumber(poNumber.toString(), false);

    this.router.navigate(['/items', { poNumber: poNumber }]);
  }
  
  navigateToUpdatePo(poNumber: number) {
    this.sharedDataService.setPONumber(poNumber.toString(), false);
    this.router.navigate(['/update-purchase-order', { poNumber: poNumber }]);
  }
  

  checkRole(): boolean {
    const userRole = this.authService.getRole();
    return userRole === 'Supervisor' || userRole === 'HR Supervisor';
  }
  
  showErrorMessage(message: string) {
    this.errors.push(message);
  }
}
