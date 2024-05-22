import { Component, Input, OnChanges, OnDestroy, OnInit } from '@angular/core';
import { ReviewPurchaseOrderComponent } from '../review-purchase-order/review-purchase-order.component';
import { Subscription } from 'rxjs';
import { AuthenticationService } from '../auth/services/authentication.service';
import { ReviewDepartmentPOComponent } from '../review-department-po/review-department-po.component';


@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit, OnDestroy, OnChanges {
  employeeNumber = localStorage.getItem('employeeNumber');
  showReviewComponent: boolean;
  authSubscription: Subscription;
  userRole: string | null;
  showReviewDepartmentComponent: boolean;

  constructor(
    private authService: AuthenticationService
  ) { }


  ngOnInit(): void {
    this.updateEmployeeDetails();

    this.userRole = this.authService.getRole(); 
    
    this.checkShowReviewComponent();
    this.checkShowReviewDepartmentComponent();

    this.authSubscription = this.authService.getAuthStatusListener().subscribe({
      next: (authStatus) => {
        this.checkShowReviewComponent();
        this.checkShowReviewDepartmentComponent();
      },
    });
    this.checkRole()
  }
  
  ngOnDestroy(): void {
    this.authSubscription.unsubscribe();
  }

  ngOnChanges(): void {
    this.updateEmployeeDetails();
  }

  updateEmployeeDetails(): void {
    this.employeeNumber = localStorage.getItem('employeeNumber');
    this.userRole = this.authService.getRole();
  }

  checkShowReviewComponent() {
    const isAuthenticated = this.authService.getIsAuthenticated();
    const isEmployee = this.userRole === 'Employee';

    this.showReviewComponent = isAuthenticated && isEmployee;
  }

  checkShowReviewDepartmentComponent() {
    const isAuthenticated = this.authService.getIsAuthenticated();
    const isSupervisor = this.userRole === 'Supervisor' || this.userRole === 'HR Supervisor';

    this.showReviewDepartmentComponent = isAuthenticated && isSupervisor;
  }

  checkRole(): boolean {
    return this.userRole === 'Supervisor' || this.userRole === 'HR Employee' || this.userRole === 'HR Supervisor';
  }
}
