import { Component } from '@angular/core';
import { Subscription } from 'rxjs';
import { AuthenticationService } from './auth/services/authentication.service';
import { AuthStatus } from './models/auth-status';
import { ReviewService } from './services/review.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'TotalAdmin';
  userIsAuthenticated: boolean;
  authSubscription: Subscription;
  userName: string | null;
  role: string;
  employeeNumber: any;

  constructor(private authService: AuthenticationService, private reviewService: ReviewService) {}

  ngOnInit(): void {
    this.authService.autoAuthUser();

    this.userIsAuthenticated = this.authService.getIsAuthenticated();
    this.userName = this.authService.getUserName();
    this.role = this.authService.getRole() ?? '';
    this.employeeNumber = this.authService.getEmployeeNumber();
    console.log(this.role);

    this.authSubscription = this.authService.getAuthStatusListener().subscribe({
      next: (auth: AuthStatus) => {
        this.userIsAuthenticated = auth.authenticated;
        this.userName = auth.userName;
      },
    });

    // send reminders on startup
    this.reviewService.sendReminders().subscribe({
      error: err =>{
        console.log(err);
      } 
    });
  }
  ngOnDestroy(): void {
    this.authSubscription.unsubscribe();
  }

  logOut() {
    this.userName = null;
    localStorage.removeItem('displayedItems'); // Clear displayedItems PO
    localStorage.removeItem('employeeNumber');
    localStorage.removeItem('userRole');
    this.authService.logout();
  }
}
