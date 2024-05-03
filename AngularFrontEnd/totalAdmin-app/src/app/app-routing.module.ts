import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { PurchaseOrderSearchComponent } from './purchase-order-search/purchase-order-search.component';
import { LoginComponent } from './auth/login/login.component';
import { HomeComponent } from './home/home.component';
import { EmployeeCreateComponent } from './employee-create/employee-create.component';
import { AuthGuard } from './guards/auth.guard';

// for routing
const routes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'purchase-order-search', component: PurchaseOrderSearchComponent },
  { path: 'login', component: LoginComponent },
  { path: 'employee', component: EmployeeCreateComponent, canActivate: [AuthGuard] },
]

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
  providers: [AuthGuard],
})
export class AppRoutingModule {}