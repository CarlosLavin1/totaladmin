import { Component, Input, OnChanges, OnDestroy, OnInit } from '@angular/core';
import { ReviewPurchaseOrderComponent } from '../review-purchase-order/review-purchase-order.component';
import { Subscription } from 'rxjs';
import { AuthenticationService } from '../auth/services/authentication.service';
import { CommonModule } from '@angular/common';

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

  constructor(
    private authService: AuthenticationService
  ) { }


  ngOnInit(): void {
    this.updateEmployeeDetails();

    this.userRole = this.authService.getRole(); 
    
    this.checkShowReviewComponent();
    this.authSubscription = this.authService.getAuthStatusListener().subscribe({
      next: (authStatus) => {
        this.checkShowReviewComponent();
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
    // const userRole = this.authService.getRole();
    // const isAllowedRole = userRole === 'Supervisor' || userRole === 'HR Employee';

    this.showReviewComponent = isAuthenticated
  }

  checkRole(): boolean {
    return this.userRole === 'Supervisor' || this.userRole === 'HR Employee' || this.userRole === 'HR Supervisor';
  }
}
