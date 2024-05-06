import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms'; 
import { PurchaseOrder } from '../models/purchase-order';
import { PurchaseOrderService } from '../services/purchase-order.service';
import { SnackbarService } from '../services/snackbar.service';
import { ValidationError } from '../models/validationError';

@Component({
  selector: 'app-review-purchase-order',
  templateUrl: './review-purchase-order.component.html',
  styleUrls: ['./review-purchase-order.component.css']
})
export class ReviewPurchaseOrderComponent implements OnInit {
    purchaseOrders: PurchaseOrder[] = [];
    employeeForm: FormGroup; 
    errors: string[] = [];

    constructor(
      private formBuilder: FormBuilder, 
      private purchaseOrderService: PurchaseOrderService,
      private snackbarService: SnackbarService
    ) {
      this.employeeForm = this.formBuilder.group({ 
        EmployeeNumber: ['', [Validators.required, Validators.pattern(/^\d{8}$/)]]
      });
    }

    ngOnInit() {
    }

    
    onSubmit() {
      if (this.employeeForm.valid) {
        const employeeNumber = this.employeeForm.get('EmployeeNumber')?.value;

        this.purchaseOrderService.ReviewEmployeePO(employeeNumber)
          .subscribe({
            next: (purchaseOrders: PurchaseOrder[]) => {

              this.purchaseOrders = purchaseOrders;

              console.log('The purchase orders:');

              this.purchaseOrders.forEach((purchaseOrder) => {
                console.log(purchaseOrder);
              });
            },
            error: (error) => {
              console.error('Error retrieving purchase orders:', error);
              this.purchaseOrders = [];
              this.errors = [];


              if (error.status === 404) {
                this.snackbarService.showSnackBar('No purchase orders found for the provided employee number.', 3000);
              } 
              else if (error.error.errors) {
                const validationErrors: ValidationError[] = error.error.errors;

                validationErrors.forEach((error) => {
                  this.snackbarService.showSnackBar(error.description, 3000);
                });
              } else {
                this.snackbarService.showSnackBar(error.error.title, 3000);
              }
            }
          });
      }
    }

    
}
