import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { Subject } from 'rxjs';
import { Login } from 'src/app/models/login';
import { AuthData } from 'src/app/models/auth-data';
import { AuthStatus } from 'src/app/models/auth-status';
import { API_URL, API_URL7161, SharedService } from 'src/app/services/shared.service';

@Injectable({
  providedIn: 'root',
})
export class AuthenticationService extends SharedService {
  private tokenTimer: string | number | NodeJS.Timeout | undefined;
  private isAuthenticated: boolean;
  private username: string | null;
  private token: string | null;
  private authStatusListener = new Subject<AuthStatus>();

  constructor(private httpClient: HttpClient, private router: Router) {
    super();
  }

  getAuthStatusListener() {
    return this.authStatusListener.asObservable();
  }

  getToken() {
    return this.token;
  }

  getIsAuthenticated() {
    return this.isAuthenticated;
  }

  getUserName() {
    return this.username;
  }

  public login(userName: string, password: string) {
    const authData: AuthData = {
      userName,
      password,
    };

    this.httpClient.post<Login>(`${API_URL7161}/login`, authData).subscribe({
      next: (response) => {
        this.token = response.token;

        if (!!this.token) {
          const expiresIn = response.expiresIn;
          console.log(expiresIn);

          this.setAuthTimer(expiresIn);
          this.username = response.userName;
          this.isAuthenticated = true;
          this.authStatusListener.next({ userName, authenticated: true });

          this.saveAuthData(
            this.token,
            new Date(new Date().getTime() + expiresIn * 1000),
            this.username
          );

          this.router.navigate(['/']);
        }
      },
      error: () => {
        this.authStatusListener.next({ userName: null, authenticated: false });
      },
    });
  }

  public logout() {
    this.token = null;
    this.username = null;
    this.isAuthenticated = false;
    this.authStatusListener.next({ userName: null, authenticated: false });
    this.router.navigate(['/']);
    clearTimeout(this.tokenTimer);
    this.clearAuthData();
  }

  public autoAuthUser() {
    const authData = this.getAuthData();

    if (!authData) return;

    const now = new Date();
    const expiresIn = authData!.expirationDate.getTime() - now.getTime();

    if (expiresIn > 0) {
      this.token = authData!.token;
      this.isAuthenticated = true;
      this.username = authData!.username;
      this.authStatusListener.next({
        userName: this.username,
        authenticated: true,
      });
      this.setAuthTimer(expiresIn / 1000);
    }
  }

  private setAuthTimer(expiresIn: number) {
    this.tokenTimer = setTimeout(() => {
      this.logout();
    }, expiresIn * 1000);
  }

  private getAuthData() {
    const token = localStorage.getItem('token');
    const expirationDate = localStorage.getItem('expiration');
    const username = localStorage.getItem('username');

    if (!token || !expirationDate) {
      return;
    }

    return { token, expirationDate: new Date(expirationDate), username };
  }

  private saveAuthData(token: string, expirationDate: Date, userName: string) {
    localStorage.setItem('token', token);
    localStorage.setItem('expiration', expirationDate.toISOString());
    localStorage.setItem('username', userName);
  }

  private clearAuthData() {
    localStorage.removeItem('token');
    localStorage.removeItem('expiration');
    localStorage.removeItem('username');
  }
}
