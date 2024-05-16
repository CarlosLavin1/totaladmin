import { Component, NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { PurchaseOrderSearchComponent } from './purchase-order-search/purchase-order-search.component';
import { LoginComponent } from './auth/login/login.component';
import { HomeComponent } from './home/home.component';
import { EmployeeCreateComponent } from './employee-create/employee-create.component';
import { AuthGuard } from './guards/auth.guard';
import { DepartmentCreateComponent } from './department-create/department-create.component';
import { CreatePurchaseOrderComponent } from './create-purchase-order/create-purchase-order.component';
import { UpdatePurchaseOrderComponent } from './update-purchase-order/update-purchase-order.component';
import { UnauthorizedComponent } from './unauthorized/unauthorized.component';
import { DepartmentUpdateComponent } from './department-update/department-update.component';
import { ItemDialogFormComponent } from './item-dialog-form/item-dialog-form.component';
import { ListDepartmentsComponent } from './list-departments/list-departments.component';
import { ModifyDepartmentComponent } from './modify-department/modify-department.component';
import { EmployeeSearchComponent } from './employee-search/employee-search.component';
import { EmployeeDetailsComponent } from './employee-details/employee-details.component';
import { UpdatePersonalInfoComponent } from './update-personal-info/update-personal-info.component';
import { EmployeeUpdateComponent } from './employee-update/employee-update.component';
import { ReviewDepartmentPOComponent } from './review-department-po/review-department-po.component';
import { SearchDepartmentPOComponent } from './search-department-po/search-department-po.component';
import { SupervisorDashboardComponent } from './supervisor-dashboard/supervisor-dashboard.component';

// for routing
const routes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'unauthorized', component: UnauthorizedComponent },
  { path: 'purchase-order-search', component: PurchaseOrderSearchComponent, canActivate: [AuthGuard] },
  { path: 'purchase-order', component: CreatePurchaseOrderComponent, canActivate: [AuthGuard] },
  { path: 'update-purchase-order', component: UpdatePurchaseOrderComponent, canActivate: [AuthGuard] },
  { path: 'items', component: ItemDialogFormComponent, canActivate: [ AuthGuard] },
  { path: 'review-department-po', component: ReviewDepartmentPOComponent, canActivate: [AuthGuard] },
  { path: 'search-department-po', component: SearchDepartmentPOComponent, canActivate: [AuthGuard], data: { roles: ['CEO', 'Supervisor']} },
  { path: 'supervisor-dashboard', component: SupervisorDashboardComponent, canActivate: [AuthGuard], data: { roles: ['CEO', 'Supervisor']} },
  { path: 'login', component: LoginComponent },
  { path: 'employee', component: EmployeeCreateComponent, canActivate: [AuthGuard], data: { roles: ['CEO', 'HR Employee']} },
  { path: 'department', component: DepartmentCreateComponent, canActivate: [AuthGuard], data: { roles: ['CEO', 'HR Employee']} },
  { path: 'update-department', component: DepartmentUpdateComponent, canActivate: [AuthGuard], data: { roles: ['CEO', 'Supervisor']} },
  { path: 'list-departments', component: ListDepartmentsComponent, canActivate: [AuthGuard], data: { roles: ['CEO', 'HR Employee']} },
  { path: 'modify-department/:id', component: ModifyDepartmentComponent, canActivate: [AuthGuard], data: { roles: ['CEO', 'HR Employee']} },
  { path: 'search-employee', component: EmployeeSearchComponent, canActivate: [AuthGuard], data: { roles: ['CEO', 'HR Employee']} },
  { path: 'employee-details/:id', component: EmployeeDetailsComponent, canActivate: [AuthGuard], data: { roles: ['CEO', 'HR Employee']} },
  { path: 'update-employee/:id', component: EmployeeUpdateComponent, canActivate: [AuthGuard], data: { roles: ['CEO', 'HR Employee']} },
  { path: 'update-personal-info/:id', component: UpdatePersonalInfoComponent, canActivate: [AuthGuard], data: { roles: ['CEO', 'Employee', 'HR Employee']} },
  { path: '**', redirectTo: '' },
]

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
  providers: [AuthGuard],
})
export class AppRoutingModule {}