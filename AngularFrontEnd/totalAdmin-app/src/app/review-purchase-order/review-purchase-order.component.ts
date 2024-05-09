import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { PurchaseOrder } from '../models/purchase-order';
import { PurchaseOrderService } from '../services/purchase-order.service';
import { SnackbarService } from '../services/snackbar.service';
import { ValidationError } from '../models/validationError';
import { MatDialogModule } from '@angular/material/dialog';
import { AuthenticationService } from '../auth/services/authentication.service';
import { Subscription } from 'rxjs';
import { AuthStatus } from '../models/auth-status';

@Component({
  selector: 'app-review-purchase-order',
  templateUrl: './review-purchase-order.component.html',
  styleUrls: ['./review-purchase-order.component.css']
})
export class ReviewPurchaseOrderComponent implements OnInit {
  purchaseOrders: PurchaseOrder[] = [];
  employeeForm: FormGroup;
  errors: string[] = [];
  showCardBody: { [key: string]: boolean } = {};
  arrowState: { [key: string]: string } = {};

  role: string;
  public userRole = localStorage.getItem('userRole');
  public employeeNumber = localStorage.getItem('employeeNumber');
  
  private formToShow: boolean;
  authSubscription: Subscription;
  
  

  constructor(
    private formBuilder: FormBuilder,
    private purchaseOrderService: PurchaseOrderService,
    private snackbarService: SnackbarService,
    private authService: AuthenticationService
  ) {
    this.employeeForm = this.formBuilder.group({
      EmployeeNumber: ['', [Validators.required, Validators.pattern(/^\d{8}$/)]]
    });

    this.authSubscription = this.authService.getAuthStatusListener().subscribe({
      next: (auth: AuthStatus) => {
        this.formToShow = this.checkRole();
        console.log('Auth status changed, formToShow:', this.formToShow);
      },
    });
  }

  ngOnInit() {
    this.employeeForm.get('EmployeeNumber')?.setValue(this.employeeNumber);
    this.loadPurchaseOrders(Number(this.employeeNumber)); 
    console.log('OnInit, userRole:', this.userRole);
    this.formToShow = this.checkRole();
    console.log('Showing the form to show: ' + this.formToShow);
    
  }

  ngOnDestroy(): void {
    this.authSubscription.unsubscribe();
  }



  onSubmit() {
    if (this.employeeForm.valid) {
      const employeeNumber = this.employeeForm.get('EmployeeNumber')?.value;

      this.loadPurchaseOrders(employeeNumber);
    }
  }

  get showSearchForm(): boolean {
    return this.formToShow;
  }

  checkRole(): boolean {
    const userRole = this.authService.getRole();
    console.log('Checking role, userRole:', userRole);
    return userRole === 'Supervisor' || userRole === 'HR Employee' || userRole === 'HR Supervisor';
  }


  loadPurchaseOrders(employeeNumber: number) {
    let validationErrors: ValidationError[] = [];
    this.errors = [];

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
            this.showErrorMessage('No purchase orders found for the provided employee number.');
          }
          else if (error.error.errors) {
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

    // When cicked automatically scroll to card
    if (this.showCardBody[poNumber]) {
      setTimeout(() => {
        cardElement.scrollIntoView({ behavior: 'smooth' });
      }, 80); 
    }
  }
}


