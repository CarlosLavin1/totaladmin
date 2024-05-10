import { Component, OnInit } from '@angular/core';
import { FormArray, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { PurchaseOrder } from '../models/purchase-order';
import { PurchaseOrderService } from '../services/purchase-order.service';
import { SnackbarService } from '../services/snackbar.service';
import { ValidationError } from '../models/validationError';
import { Item } from '../models/item';
import { MatDialogModule } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { SharedDataService } from '../services/shared-data.service';


@Component({
  selector: 'app-create-purchase-order',
  templateUrl: './create-purchase-order.component.html',
  styleUrls: ['./create-purchase-order.component.css']
})
export class CreatePurchaseOrderComponent implements OnInit {

  public purchaseOrderForm: FormGroup;
  public errors: string[] = [];
  public displayedItems: Item[] = [];
  public hasValidationErrors: boolean = false;
  public purchaseOrderCreated: boolean = false;
  public validationErrors: ValidationError[] = [];


  public employeeNumber = localStorage.getItem('employeeNumber') || '';
  public purchaseOrder: PurchaseOrder | null;

  constructor(
    private formBuilder: FormBuilder,
    private poService: PurchaseOrderService,
    private snackBarService: SnackbarService,
    private router: Router,
    private sharedDataService: SharedDataService
  ) {
    this.purchaseOrderForm = this.formBuilder.group({
      creationDate: [new Date().toISOString().split('T')[0]],
      items: this.formBuilder.array([])
    });
  }

  ngOnInit(): void {
    this.displayedItems = JSON.parse(localStorage.getItem('displayedItems') || '[]');  // Load from local storage
    this.addItem();
  }

  ngOnDestory(): void {
  }

  get items(): FormArray {
    return this.purchaseOrderForm.get('items') as FormArray;
  }

  public addItem(): void {
    this.errors = [];

    if (this.items.length > 0 && this.items.at(this.items.length - 1).invalid) {
      return;
    }


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

    // Reset the items FormArray after adding a new item
    this.purchaseOrderForm.setControl('items', this.formBuilder.array(this.items.controls));
  }

  public onItemRemove(index: number): void {
    this.items.removeAt(index);
  }

  public onSubmit(): void {
    this.errors = [];
    this.displayedItems = [];
    this.hasValidationErrors = false;

    console.log('Form Value:', this.purchaseOrderForm.value);

    // Check if the items FormArray is empty
    if (this.items.controls.length === 0 || this.items.at(this.items.length - 1).invalid) {
      this.errors.push('Please add at least one item before submitting the form.');
      return;
    }

    
    if (this.purchaseOrderForm.valid) {

      const purchaseOrder = this.preparePurchaseOrderData();

      this.poService.addPurchaseOrder(purchaseOrder).subscribe({
        next: (res: PurchaseOrder) => {
          console.log('Server Response:', res);
          this.purchaseOrder = res;
          this.purchaseOrderCreated = true;


          // Store the data in the shared service
          const data = {
            EmployeeNumber: this.employeeNumber,
            PONumber: res.formattedPoNumber ? res.formattedPoNumber : '',
            autoSearch: true
          };
          this.sharedDataService.setData(data);
          console.log('Shared data:', data);


          // Navigate to the purchase order details page
          this.router.navigate(['/purchase-order-search']);

          console.log('Server Response:', res);

          // Update the displayedItems array with the items from the server response
          if (Array.isArray((res as any).purchaseOrder.items)) {
            this.displayedItems = [...this.displayedItems, ...(res as any).purchaseOrder.items];

            localStorage.setItem('displayedItems', JSON.stringify(this.displayedItems));  // Save to local storage
            console.log("The displayed items: ", this.displayedItems);
          }


          this.hasValidationErrors = false;
          console.log("The ITEMS response are: : " + res.items);

          // Clear the fields of the items form
          this.items.controls.forEach(item => {
            item.reset();
            item.get('statusId')?.setValue(1);
          });

          this.snackBarService.showSnackBar("Purchase order added successfully", 0);
          setTimeout(() => {
            console.log('Succesfully added po');
            console.log("Valdation erros is:" + this.hasValidationErrors);

            this.snackBarService.dismissSnackBar();
          }, 5000);
        },
        error: (err) => {
          this.hasValidationErrors = true;

          console.log(err);

          if (err.error.errors) {

            this.validationErrors = err.error.errors;

            this.validationErrors.forEach((error) => {
              this.errors.push(error.description);
            });
          } else {
            this.errors.push(err.error.title);
          }
        }
      });
    } else {
      this.hasValidationErrors = true;
    }
  }

  public allItemsValid(): boolean {
    return this.items.controls.every(item => item.valid);
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

    purchaseOrder.formattedPoNumber?.valueOf

    purchaseOrder.statusId = 1;

    return purchaseOrder;
  }
}
