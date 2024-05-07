import { Component } from '@angular/core';
import { Subscription } from 'rxjs';
import { AuthenticationService } from './auth/services/authentication.service';
import { AuthStatus } from './models/auth-status';

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

  constructor(private authService: AuthenticationService) {}

  ngOnInit(): void {
    this.authService.autoAuthUser();

    this.userIsAuthenticated = this.authService.getIsAuthenticated();
    this.userName = this.authService.getUserName();
    this.role = this.authService.getRole() ?? '';
    console.log(this.role);

    this.authSubscription = this.authService.getAuthStatusListener().subscribe({
      next: (auth: AuthStatus) => {
        this.userIsAuthenticated = auth.authenticated;
        this.userName = auth.userName;
      },
    });
  }
  ngOnDestroy(): void {
    this.authSubscription.unsubscribe();
  }

  logOut() {
    this.userName = null;
    localStorage.removeItem('displayedItems'); // Clear displayedItems PO
    this.authService.logout();
  }
}
