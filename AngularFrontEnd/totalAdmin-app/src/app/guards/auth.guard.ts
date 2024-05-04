import { Injectable } from '@angular/core';
import {
  ActivatedRouteSnapshot,
  Router,
  RouterStateSnapshot,
} from '@angular/router';
import { Observable } from 'rxjs';
import { AuthenticationService } from '../auth/services/authentication.service';

@Injectable()
export class AuthGuard {
  constructor(
    private authService: AuthenticationService,
    private router: Router
  ) {}

  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ): boolean | Observable<boolean> | Promise<boolean> {
    const isAuth = this.authService.getIsAuthenticated();

    if (!isAuth) {
      this.router.navigate(['/login']);
      return false;
    }

    const requiredRoles = route.data['roles'] as Array<string>;
    const userRole = this.authService.getRole() ?? ''; 

    // Check if the user's role is one of the required roles
    const hasAuthorization = requiredRoles ? requiredRoles.includes(userRole) : true;

    if (!hasAuthorization) {
      this.router.navigate(['/unauthorized']); 
      return false;
    }

    return isAuth;
  }
}