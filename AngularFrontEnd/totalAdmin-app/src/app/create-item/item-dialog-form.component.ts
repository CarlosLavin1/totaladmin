import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { PurchaseOrderService } from '../services/purchase-order.service';
import { Item } from '../models/item';
import { ActivatedRoute, Router } from '@angular/router';
import { SharedDataService } from '../services/shared-data.service';
import { ValidationError } from '../models/validationError';
import { PurchaseOrder } from '../models/purchase-order';
import { SnackbarService } from '../services/snackbar.service';

@Component({
  selector: 'app-item-dialog-form',
  templateUrl: './item-dialog-form.component.html',
  styleUrls: ['./item-dialog-form.component.css']
})
export class ItemDialogFormComponent implements OnInit {
  public validationErrors: ValidationError[] = [];
  public errors: string[] = [];
  public itemForm: FormGroup;
  public poNumber: string;
  public employeeNumber = localStorage.getItem('employeeNumber') || '';
  public purchaseOrder: PurchaseOrder | null;
  public submitted = false;
  
  
  constructor(
    private formBuilder: FormBuilder,
    private purchaseOrderService: PurchaseOrderService,
    private activatedRoute: ActivatedRoute,
    private sharedDataService: SharedDataService,
    private router: Router,
    private snackBarService: SnackbarService
  ) {
    this.itemForm = this.formBuilder.group({
      name: ['', [Validators.required, Validators.minLength(3), Validators.maxLength(45)]],
      quantity: ['', [Validators.required, Validators.min(1)]],
      description: ['', [Validators.required, Validators.minLength(5)]],
      price: ['', [Validators.required, Validators.min(1)]],
      justification: ['', [Validators.required, Validators.minLength(4)]],
      location: ['', [Validators.required, Validators.minLength(5)]],
      statusId: [1]
    });
  }
  
  ngOnInit(): void {
    this.sharedDataService.data.subscribe(data => {
      if (data && data.PONumber) {
        this.poNumber = data.PONumber;
        console.log('Retrieved PO Number:', this.poNumber);
      }
      else {
        this.router.navigateByUrl('/');
      }
    });
    
  }
  

  onSubmit(): void {
    this.errors = []; 
    this.submitted = true;
    
    if (this.itemForm.valid) {
      const item: Item = this.itemForm.value;
      this.purchaseOrderService.AddItemsToPurchaseOrder(Number(this.poNumber), item)

        .subscribe({
          next: (res: Item) => {
            this.itemForm.reset();
            this.router.navigateByUrl('/')
            this.submitted = false;
            
            this.snackBarService.showSnackBar("Purchase order updated successfully", 0);
            setTimeout(() => {
              console.log('Succesfully uupdated po');

              this.snackBarService.dismissSnackBar();
            }, 5000);
          },
          error: (err) => {
            this.submitted = false
            this.errors = [];
            this.validationErrors = [];
  
            if (err.error.errors) {
              this.validationErrors = err.error.errors;
              this. validationErrors.forEach((error) => {
                this.validationErrors.push(error);
              });
            } else {
              const errorMessage = err.error || err.message;
              this.errors.push(errorMessage);
            }
          }
        });
    }
  }

  resetSubmitted(): void {
    this.submitted = false;
  }
  
}
