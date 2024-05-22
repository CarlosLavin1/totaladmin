import { Component, OnInit } from '@angular/core';
import { PurchaseOrder } from '../models/purchase-order';
import { FormArray, FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { PurchaseOrderService } from '../services/purchase-order.service';
import { SnackbarService } from '../services/snackbar.service';
import { ActivatedRoute, NavigationStart, Router } from '@angular/router';
import { SharedDataService } from '../services/shared-data.service';

@Component({
  selector: 'app-update-purchase-order',
  templateUrl: './update-purchase-order.component.html',
  styleUrls: ['./update-purchase-order.component.css']
})
export class UpdatePurchaseOrderComponent implements OnInit {
  purchaseOrderForm: FormGroup;
  purchaseOrder: PurchaseOrder | null = null;
  errors: string[] = [];

  public poNumber: string;
  validationErrors: any;

  public employeeNumber = localStorage.getItem('employeeNumber') || '';

  constructor(
    private formBuilder: FormBuilder,
    private poService: PurchaseOrderService,
    private snackBarService: SnackbarService,
    private router: Router,
    private route: ActivatedRoute,
    private sharedDataService: SharedDataService,
  ) {
    this.purchaseOrderForm = this.formBuilder.group({
      poNumber: [{ value: '', disabled: true }],
      creationDate: [{ value: new Date(), disabled: true }],
      employeeName: [{ value: '', disabled: true }],
      department: [{ value: '', disabled: true }],
      supervisorName: [{ value: '', disabled: true }],
      status: [{ value: '', disabled: true }],
      items: this.formBuilder.array([])
    });
  }


  ngOnInit(): void {
    this.sharedDataService.data.subscribe(data => {
      if (data && data.PONumber) {
        this.poNumber = data.PONumber;
        let formattedPoNumber = this.formatPoNumber(Number(this.poNumber));
        console.log('Retrieved PO Number:', this.poNumber);
        console.log('Retrieved PO Number:', formattedPoNumber);

        this.purchaseOrderForm.get('poNumber')?.setValue(formattedPoNumber);


        // Get the existing purchase order data
        this.poService.getExistingPurchaseOrder(Number(this.poNumber)).subscribe((poData) => {
          this.purchaseOrder = poData;
          this.initForm();

          this.purchaseOrderForm.get('creationDate')?.setValue(this.purchaseOrder?.creationDate);
          console.log('The ceration date is set to: ' + this.purchaseOrder?.creationDate);
        });


        // Get the employee details
        this.poService.ReviewEmployeePO(Number(this.employeeNumber)).subscribe((employeeData) => {
          // Check if any data is returned
          if (employeeData && employeeData.length > 0) {
            const firstPo = employeeData[0];
            this.purchaseOrderForm.get('employeeName')?.setValue(firstPo.employeeName);
            this.purchaseOrderForm.get('department')?.setValue(firstPo.empDepartmentName);
            this.purchaseOrderForm.get('supervisorName')?.setValue(firstPo.employeeSupervisorName);
            this.purchaseOrderForm.get('status')?.setValue(firstPo.purchaseOrderStatus);
          }
        });
      }
      else {
        this.router.navigateByUrl('/purchase-order-search');
      }
    });
  }

  formatPoNumber(poNumber: number): string {
    let formattedNumber = poNumber.toString().padStart(2, '0');
    return "00001" + formattedNumber;
  }


  get items(): FormArray {
    return this.purchaseOrderForm.get('items') as FormArray;
  }

  initForm(): void {
    if (this.purchaseOrder) {
      const itemsFormArray = this.formBuilder.array(
        this.purchaseOrder.items.map((item) => this.formBuilder.group({
          itemId: [item.itemId],
          name: [item.name, [Validators.required, Validators.minLength(3), Validators.maxLength(45)]],
          quantity: [item.quantity, [Validators.required, Validators.min(1)]],
          description: [item.description, [Validators.required, Validators.minLength(5)]],
          price: [item.price, [Validators.required, Validators.min(1)]],
          justification: [item.justification, [Validators.required, Validators.minLength(4)]],
          location: [item.location, [Validators.required, Validators.minLength(5)]],
          statusId: [item.statusId]
        }))
      );
      this.purchaseOrderForm.setControl('items', itemsFormArray);
    }
  }


  onSubmit(): void {
    if (this.purchaseOrderForm.valid && this.purchaseOrder) {
      const updatedPurchaseOrder = {
        ...this.purchaseOrder,
        items: this.purchaseOrderForm.get('items')?.value
      };


      this.poService.updatePO(Number(this.poNumber), updatedPurchaseOrder)
        .subscribe({
          next: (res: PurchaseOrder) => {

            this.router.navigateByUrl('/')

            setTimeout(() => {
              console.log('Succesfully added po');
              this.snackBarService.showSnackBar("Purchase order updated successfully", 0);

              this.snackBarService.dismissSnackBar();
            }, 5000);

            this.purchaseOrderForm.get('creationDate')?.setValue(new Date());
          },
          error: (err) => {
            this.errors = [];
            this.validationErrors = [];

            if (err.error.errors) {
              this.validationErrors = err.error.errors;
              this.validationErrors.forEach((error: any) => {
                this.showErrorMessage(error);
                // this.router.navigate(['/purchase-order-search']);
              });
            } else {
              const errorMessage = err.error || err.message;
              this.showErrorMessage(errorMessage);
            }
          }
        });
    } else {

      this.showErrorMessage('Please fill out all required fields before submitting the form.');
    }
  }

  showErrorMessage(message: string) {
    this.errors.push(message);
  }
}
