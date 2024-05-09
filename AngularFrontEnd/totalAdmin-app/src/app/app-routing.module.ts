import { Component, NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { PurchaseOrderSearchComponent } from './purchase-order-search/purchase-order-search.component';
import { LoginComponent } from './auth/login/login.component';
import { HomeComponent } from './home/home.component';
import { EmployeeCreateComponent } from './employee-create/employee-create.component';
import { AuthGuard } from './guards/auth.guard';
import { DepartmentCreateComponent } from './department-create/department-create.component';
import { CreatePurchaseOrderComponent } from './create-purchase-order/create-purchase-order.component';
import { UnauthorizedComponent } from './unauthorized/unauthorized.component';
import { DepartmentUpdateComponent } from './department-update/department-update.component';
import { ItemDialogFormComponent } from './item-dialog-form/item-dialog-form.component';

// for routing
const routes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'unauthorized', component: UnauthorizedComponent },
  { path: 'purchase-order-search', component: PurchaseOrderSearchComponent, canActivate: [AuthGuard] },
  { path: 'purchase-order', component: CreatePurchaseOrderComponent, canActivate: [AuthGuard] },
  { path: 'items', component: ItemDialogFormComponent },
  { path: 'login', component: LoginComponent },
  { path: 'employee', component: EmployeeCreateComponent, canActivate: [AuthGuard], data: { roles: ['CEO', 'HR Employee']} },
  { path: 'department', component: DepartmentCreateComponent, canActivate: [AuthGuard], data: { roles: ['CEO', 'HR Employee']} },
  { path: 'update-department', component: DepartmentUpdateComponent, canActivate: [AuthGuard], data: { roles: ['CEO', 'Supervisor']} },
  { path: '**', redirectTo: '' },
]

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
  providers: [AuthGuard],
})
export class AppRoutingModule {}