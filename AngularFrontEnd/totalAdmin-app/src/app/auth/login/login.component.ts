import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Subscription } from 'rxjs';
import { AuthenticationService } from '../services/authentication.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {
  loginForm: FormGroup = this.formBuilder.group({
    username: ['', Validators.required],
    password: ['', Validators.required],
  });

  private authStatusSubscription: Subscription;

  hide: boolean = true;
  progress: boolean = false;
  errors: string[] = [];

  constructor(
    private formBuilder: FormBuilder,
    private authService: AuthenticationService
  ) {}

  ngOnInit(): void {
    this.authStatusSubscription = this.authService
      .getAuthStatusListener()
      .subscribe((authStatus: { authenticated: any }) => {
        if (!authStatus.authenticated)
          this.errors.push('Invalid credentials, please use your employee number and password');

        this.progress = false;
      });
  }

  ngOnDestroy(): void {
    this.authStatusSubscription.unsubscribe();
  }

  onSubmit() {
    this.errors = [];
    this.progress = true;
    this.authService.login(
      this.loginForm.get('username')?.value,
      this.loginForm.get('password')?.value
    );
  }
}
