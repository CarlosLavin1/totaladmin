import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { PurchaseOrder } from '../models/purchase-order';
import { Subscription } from 'rxjs';
import { PurchaseOrderService } from '../services/purchase-order.service';
import { SnackbarService } from '../services/snackbar.service';
import { AuthenticationService } from '../auth/services/authentication.service';
import { AuthStatus } from '../models/auth-status';
import { ValidationError } from '../models/validationError';
import { DepartmentService } from '../services/department.service';
import { ItemService } from '../services/item.service';
import { Item } from '../models/item';

@Component({
  selector: 'app-review-department-po',
  templateUrl: './review-department-po.component.html',
  styleUrls: ['./review-department-po.component.css']
})
export class ReviewDepartmentPOComponent implements OnInit {
  departmentForm: FormGroup;
  purchaseOrders: PurchaseOrder[] = [];
  errors: string[] = [];
  showCardBody: { [key: string]: boolean } = {};
  arrowState: { [key: string]: string } = {};
  showCloseButton: { [key: string]: boolean } = {};


  role: string;
  public userRole = localStorage.getItem('userRole');


  private formToShow: boolean;
  authSubscription: Subscription;

  constructor(
    private formBuilder: FormBuilder,
    public purchaseOrderService: PurchaseOrderService,
    private snackbarService: SnackbarService,
    private authService: AuthenticationService,
    private departmentService: DepartmentService,
    private itemService: ItemService
  ) {
    this.departmentForm = this.formBuilder.group({
      DepartmentId: ['', Validators.required]
    });
  }

  ngOnInit(): void {
    if (this.checkRole()) {
      const employeeNumber = localStorage.getItem('employeeNumber');
      if (employeeNumber) {
        this.departmentService.getDepartmentForEmployee(Number(employeeNumber)).subscribe(department => {
          this.loadPurchaseOrders(department.id);
        });
      }
    }

  }

  checkRole(): boolean {
    const userRole = this.authService.getRole();
    console.log('Checking role, userRole:', userRole);
    return userRole === 'Supervisor' || userRole === 'HR Employee' || userRole === 'HR Supervisor';
  }

  onSubmit(): void {
    if (this.departmentForm.valid) {
      const departmentId = this.departmentForm.get('DepartmentId')?.value;
      this.loadPurchaseOrders(departmentId);
    }
  }

  loadPurchaseOrders(departmentId: number): Subscription {
    let validationErrors: ValidationError[] = [];
    this.errors = [];


    return this.purchaseOrderService.ReviewDepartmentPO(departmentId)
      .subscribe({
        next: (purchaseOrders: PurchaseOrder[]) => {
          this.purchaseOrders = purchaseOrders;
          console.log('The purchase orders:');
          this.purchaseOrders.forEach((purchaseOrder) => {
            console.log(purchaseOrder);
            const allItemsProcessed = purchaseOrder.items.every(item => item.statusId !== 1);

            console.log("all ietm proccesed: " + allItemsProcessed);
            
            if (!this.showCloseButton[purchaseOrder.poNumber]) {
              this.showCloseButton[purchaseOrder.poNumber] = allItemsProcessed;
            }

            console.log('The item procssed is: ' + !this.showCloseButton[purchaseOrder.poNumber]);
            
          });
        },
        error: (error) => {
          console.error('Error retrieving purchase orders:', error);
          this.purchaseOrders = [];
          this.errors = [];
          if (error.status === 404) {
            this.showErrorMessage('No purchase orders found for the provided department ID.');
          } else if (error.error.errors) {
            validationErrors = error.error.errors;
            validationErrors.forEach((error) => {
              this.snackbarService.showSnackBar(error.description, 3000);
            });
          } else {
            this.snackbarService.showSnackBar(error.error.title, 3000);
          }
        }
      });
  }

  showErrorMessage(message: string) {
    this.errors.push(message);
  }

  toggleCardBody(poNumber: string, cardElement: HTMLElement) {
    this.showCardBody[poNumber] = !this.showCardBody[poNumber];
    this.arrowState[poNumber] = this.showCardBody[poNumber] ? '▼' : '▶';
    // When clicked, automatically scroll to card
    if (this.showCardBody[poNumber]) {
      setTimeout(() => {
        cardElement.scrollIntoView({ behavior: 'smooth' });
      }, 0);
    }
  }


  approveItem(itemId: number, poNumber: number) {
    this.showCloseButton[poNumber] = false;

    console.log('The close all button is: ' + this.showCloseButton[poNumber]);

    let item: Item = {
      itemId: itemId,
      statusId: 2,  // Approved status
      rejectedReason: null 
    };

    this.itemService.updateItem(item).subscribe({
      next: (res) => {
        console.log(res.message);
        // Refresh the data
        const employeeNumber = localStorage.getItem('employeeNumber');

        if (employeeNumber) {
          this.departmentService.getDepartmentForEmployee(Number(employeeNumber)).subscribe(department => {
            this.loadPurchaseOrders(department.id).add(() => {
              setTimeout(() => {
                this.snackbarService.showSnackBar('Item approved', 3000);


                // Check if this is the last item to be processed
                const po = this.purchaseOrders.find(po => po.poNumber === poNumber);

                if (po && po.statusId === 3) {
                  this.snackbarService.showSnackBar('Cannot change the status of items on a closed purchase order.', 3000);
                  return;
                }

                // Check if this is the first item to be processed
                if (po) {
                  console.log('Found PO:', po);

                  // Check if this is the first item to be processed
                  if (po.items[0].itemId === itemId) {
                    console.log('Updating PO status to under review');

                    // Update the PO status to under review
                    this.purchaseOrderService.updatePurchaseOrder(poNumber).subscribe(() => {
                      console.log('PO status updated');
                    });
                  }
                }

                // Check if this is the last item to be processed
                if (po && po.items.every(item => item.statusId !== 1)) {
                  console.log('Found PO:', po);


                  // Ask the supervisor if they want to close the PO
                  if (confirm('This is the last item to be processed. Do you want to close the purchase order?')) {
                    this.closePO(poNumber);
                    this.snackbarService.showSnackBar('Purchase order closed', 3000);
                  } else {
                    // show the close button
                    this.purchaseOrderService.showCloseButton[poNumber] = true;
                    console.log('The close all button is: ' + this.showCloseButton[poNumber]);
                    this.showCloseButton[poNumber] = true;
                    this.snackbarService.showSnackBar('Item cancelled. You can close item later by clicking ethier approve or deny again.', 4500);
                  }

                  this.showCloseButton[poNumber] = true;
                  console.log('The close all button is: ' + this.showCloseButton[poNumber]);
                }
              }, 0);
            });
          });
        }
      },
      error: (error) => {
        console.error(error);
      }
    });
  }


  denyItem(itemId: number, poNumber: number) {
    this.showCloseButton[poNumber] = false;
    const po = this.purchaseOrders.find(po => po.poNumber === poNumber);

    if (po && po.statusId === 3) {
      this.snackbarService.showSnackBar('Cannot change the status of items on a closed purchase order.', 3000);
      return;
    }

    // Prompt the user for a reason
    const reason = window.prompt('Please enter a reason for denying this item:');

    if (reason === null || reason.trim() === '') {

      this.snackbarService.showSnackBar('You must provide a reason to deny an item.', 3000);
      return;
    }

    // Item object
    let item: Item = {
      itemId: itemId,
      statusId: 3,  // Denied status
      rejectedReason: reason 
    };

    this.itemService.updateItem(item).subscribe({
      next: (res) => {
        console.log(res.message);
        // Refresh the data
        const employeeNumber = localStorage.getItem('employeeNumber');
        if (employeeNumber) {
          this.departmentService.getDepartmentForEmployee(Number(employeeNumber)).subscribe(department => {

            this.loadPurchaseOrders(department.id).add(() => {
              setTimeout(() => {
                this.snackbarService.showSnackBar('Item deined', 3000);

                // Check if this is the first item to be processed
                if (po) {
                  console.log('Found PO:', po);

                  // Check if this is the first item to be processed
                  if (po.items[0].itemId === itemId) {
                    console.log('Updating PO status to under review');

                    // Update the PO status to under review
                    this.purchaseOrderService.updatePurchaseOrder(poNumber).subscribe(() => {
                      console.log('PO status updated');
                    });
                  }
                }

                if (po && po.items.every(item => item.statusId !== 1)) {
                  // Update the PO status to under review
                  this.purchaseOrderService.updatePurchaseOrder(poNumber).subscribe();


                  // Ask the supervisor if they want to close the PO
                  if (confirm('This is the last item to be processed. Do you want to close the purchase order?')) {
                    this.closePO(poNumber);
                    this.snackbarService.showSnackBar('Purchase order closed', 3000);
                  } else {
                    // show the close button
                    // this.purchaseOrderService.showCloseButton[poNumber] = false;
                    this.showCloseButton[poNumber] = true;
                    this.snackbarService.showSnackBar('Item cancelled. You can close item later by clicking ethier approve or deny again.', 4500);
                  }

                  this.showCloseButton[poNumber] = true;
                }
              }, 0);
            });
          });
        }
      },
      error: (error) => {
        console.error(error);
        this.snackbarService.showSnackBar(error.error, 4500);
      }
    });
  }


  closePO(poNumber: number) {
    this.purchaseOrderService.closePO(poNumber).subscribe({
      next: (res) => {
        console.log('Purchase order closed:', res);

        const employeeNumber = localStorage.getItem('employeeNumber');
        if (employeeNumber) {
          this.departmentService.getDepartmentForEmployee(Number(employeeNumber)).subscribe(department => {
            this.loadPurchaseOrders(department.id);
          });
        }

      },
      error: (error) => {
        console.error(error);
      }
    });
  }

  allItemsProcessed(purchaseOrder: PurchaseOrder): boolean {
    return purchaseOrder.items.every(item => item.statusId !== 1);
  }
  

}
