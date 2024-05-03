import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

// import { AppRoutingModule } from './app-routing.module';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';


import { HTTP_INTERCEPTORS, HttpClientModule } from '@angular/common/http';

import { AppComponent } from './app.component';
import { PurchaseOrderSearchComponent } from './purchase-order-search/purchase-order-search.component';
import { AppRoutingModule } from './app-routing.module';
import { LoginComponent } from './auth/login/login.component';
import { ErrorsComponent } from './shared/errors/errors.component';
import { ActivityComponent } from './shared/activity/activity.component';
import { HomeComponent } from './home/home.component';
import { EmployeeCreateComponent } from './employee-create/employee-create.component';
import { DepartmentCreateComponent } from './department-create/department-create.component';
import { AuthInterceptor } from './interceptors/auth.interceptor';
import { AddItemComponent } from './add-item/add-item.component';

@NgModule({
  declarations: [
    AppComponent,
    PurchaseOrderSearchComponent,
    LoginComponent,
    ErrorsComponent,
    ActivityComponent,
    HomeComponent,
    EmployeeCreateComponent,
    DepartmentCreateComponent,
    AddItemComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
  ],
  providers: [
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthInterceptor,
      multi: true,
    },
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
