import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { PurchaseOrderService } from '../services/purchase-order.service';
import { ValidationError } from '../models/validationError';
import { Router, ActivatedRoute } from '@angular/router';
import { Observable, Subscription } from 'rxjs';
import { POSearchFiltersDTO } from '../models/posearch-filters-dto';
import { PODisplayDTO } from '../models/podisplay-dto';

@Component({
  selector: 'app-purchase-order-search',
  templateUrl: './purchase-order-search.component.html',
  styleUrls: ['./purchase-order-search.component.css']
})
export class PurchaseOrderSearchComponent {
  private subscriptions: Subscription[] = [];
  errors: string[] = [];

  validationErrors: ValidationError[] = [];
  public employeeNumber = localStorage.getItem('employeeNumber');

  searchResults: PODisplayDTO[] = [];
  private subscription: Subscription;

  searchForm: FormGroup = this.formBuilder.group({
    EmployeeNumber: ['', Validators.required],
    StartDate: [''],
    EndDate: [''],
    PONumber: ['']
  });


  constructor(
    private formBuilder: FormBuilder,
    private poService: PurchaseOrderService,
    private activatedRoute: ActivatedRoute,
    private router: Router,

  ) { }

  ngOnInit(): void {
    this.activatedRoute.queryParams.subscribe(params => {
      const poNumber = params['PONumber'];
      this.searchForm.get('PONumber')?.setValue(poNumber);
    });

    this.searchForm.get('EmployeeNumber')?.setValue(this.employeeNumber);
  }

  ngOnDestory(): void{
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
            console.log(result);
          });
        },
        error: (error) => {
          console.error('Error searching purchase orders:', error);
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
            this.errors.push(error.error.title);
          }
        }
      });
    this.subscriptions.push(subscription);
  }

  showErrorMessage(message: string) {
    this.errors.push(message);
  }
}
