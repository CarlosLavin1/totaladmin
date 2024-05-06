import { Component, OnInit } from '@angular/core';
import { FormArray, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { PurchaseOrder } from '../models/purchase-order';
import { PurchaseOrderService } from '../services/purchase-order.service';
import { SnackbarService } from '../services/snackbar.service';
import { ValidationError } from '../models/validationError';

@Component({
  selector: 'app-create-purchase-order',
  templateUrl: './create-purchase-order.component.html',
  styleUrls: ['./create-purchase-order.component.css']
})
export class CreatePurchaseOrderComponent implements OnInit {

  purchaseOrderForm: FormGroup;
  errors: string[] = [];
  employeeNumber = localStorage.getItem('employeeNumber');

  constructor(
    private formBuilder: FormBuilder,
    private poService: PurchaseOrderService,
    private snackBarService: SnackbarService
  ) {
    this.purchaseOrderForm = this.formBuilder.group({
      creationDate: [new Date().toISOString().split('T')[0]],
      items: this.formBuilder.array([])
    });
  }

  ngOnInit(): void {
    
  }

  get items(): FormArray {
    return this.purchaseOrderForm.get('items') as FormArray;
  }

  public addItem(): void {
    const itemGroup = this.formBuilder.group({
      name: ['', Validators.required],
      quantity: ['', Validators.required],
      description: ['', Validators.required],
      price: ['', Validators.required],
      justification: ['', Validators.required],
      location: ['', Validators.required],
      statusId: [1]
    });

    this.items.push(itemGroup);
  } 

  public onSubmit(): void {
    // Check if the items FormArray is empty
    if (this.items.controls.length === 0) {
      this.errors.push('Please add at least one item before submitting the form.');
      return;
    }


    if (this.purchaseOrderForm.valid) {
      const purchaseOrder = this.preparePurchaseOrderData();
      this.poService.addPurchaseOrder(purchaseOrder).subscribe({
        next: (res) => {
          console.log(res);

          this.snackBarService.showSnackBar("Purchase order added successfully", 0);
          setTimeout(() => {
            console.log('Succesfully added po');
            this.snackBarService.dismissSnackBar(); 
          }, 1800);
        },
        error:(err) => {
          console.log(err);
          if (err.error.errors) {
            const validationErrors: ValidationError[] = err.error.errors;
            validationErrors.forEach((error) => {
              this.errors.push(error.description);
            });
          } else {
            this.errors.push(err.error.title);
          }
        }
      });
    }
  }

  private preparePurchaseOrderData(): PurchaseOrder {
    const formValue = this.purchaseOrderForm.value;
    const purchaseOrder = new PurchaseOrder();

    // Get the creationDate from the form value
    purchaseOrder.creationDate = new Date(formValue.creationDate);

    // if no employee numbers not null parse it from local storage into an integer
    if (this.employeeNumber !== null) {
      purchaseOrder.employeeNumber = parseInt(this.employeeNumber, 10);
    } else {
      // Handle the case when employeeNumber is null
      purchaseOrder.employeeNumber = 0; 
    }
    
    // Set the creationDate to the current date
    purchaseOrder.creationDate = new Date()

    // Set the items from the form value
    purchaseOrder.items = formValue.items;

    purchaseOrder.statusId = 1;
    
    return purchaseOrder;
  }
  
}
