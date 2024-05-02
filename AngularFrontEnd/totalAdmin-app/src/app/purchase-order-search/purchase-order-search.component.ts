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
  private employeNum: number;
  private subscriptions: Subscription[] = [];
  errors: string[] = [];

  validationErrors: ValidationError[] = [];

  searchResults: PODisplayDTO[] = [];

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
    }
  }

  private searchPO(filter: POSearchFiltersDTO) {
    const subscription = this.poService.SearchPurchaseOrders(filter)
      .subscribe({
        next: (results) => {
          this.searchResults = results;
        },
        error: (error) => {
          console.error('Error searching purchase orders:', error);
          // Handle error
          if (error.error.errors) {
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
}
