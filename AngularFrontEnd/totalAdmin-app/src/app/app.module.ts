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
import { UnauthorizedComponent } from './unauthorized/unauthorized.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { CreatePurchaseOrderComponent } from './create-purchase-order/create-purchase-order.component';
import { ReviewPurchaseOrderComponent } from './review-purchase-order/review-purchase-order.component';
import { DepartmentUpdateComponent } from './department-update/department-update.component';
import { ItemDialogFormComponent } from './create-item/item-dialog-form.component';
import { ListDepartmentsComponent } from './list-departments/list-departments.component';
import { ModifyDepartmentComponent } from './modify-department/modify-department.component';
import { EmployeeSearchComponent } from './employee-search/employee-search.component';
import { EmployeeDetailsComponent } from './employee-details/employee-details.component';
import { UpdatePersonalInfoComponent } from './update-personal-info/update-personal-info.component';
import { EmployeeUpdateComponent } from './employee-update/employee-update.component';
import { ReviewDepartmentPOComponent } from './review-department-po/review-department-po.component';
import { SearchDepartmentPOComponent } from './search-department-po/search-department-po.component';
import { SupervisorDashboardComponent } from './supervisor-dashboard/supervisor-dashboard.component';
import { DatePipe } from '@angular/common';
import { DepartmentDeleteComponent } from './department-delete/department-delete.component';
import { UpdatePurchaseOrderComponent } from './update-purchase-order/update-purchase-order.component';
import { ReviewCreateComponent } from './review-create/review-create.component';
import { EmployeesDueForReviewComponent } from './employees-due-for-review/employees-due-for-review.component';
import { ReviewsForEmployeeComponent } from './reviews-for-employee/reviews-for-employee.component';
import { ReviewDetailsComponent } from './review-details/review-details.component';
import { EmployeeDashboardComponent } from './employee-dashboard/employee-dashboard.component';




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
    UnauthorizedComponent,
    CreatePurchaseOrderComponent,
    ReviewPurchaseOrderComponent,
    DepartmentUpdateComponent,
    ItemDialogFormComponent,
    ListDepartmentsComponent,
    ModifyDepartmentComponent,
    EmployeeSearchComponent,
    EmployeeDetailsComponent,
    UpdatePersonalInfoComponent,
    EmployeeUpdateComponent,
    ReviewDepartmentPOComponent,
    SearchDepartmentPOComponent,
    SupervisorDashboardComponent,
    DepartmentDeleteComponent,
    UpdatePurchaseOrderComponent,
    ReviewCreateComponent,
    EmployeesDueForReviewComponent,
    ReviewsForEmployeeComponent,
    ReviewDetailsComponent,
    EmployeeDashboardComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    BrowserAnimationsModule, 
    MatSnackBarModule
  ],
  providers: [
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthInterceptor,
      multi: true,
    },
    DatePipe
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
