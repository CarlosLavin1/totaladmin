import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { PurchaseOrderSearchComponent } from './purchase-order-search/purchase-order-search.component';
import { PurchaseOrderListComponent } from './purchase-order-list/purchase-order-list.component';

// for routing
const routes: Routes = [
  { path: 'purchase-order-search', component: PurchaseOrderSearchComponent },
  { path: 'purchase-order/:poNumber', component: PurchaseOrderListComponent },
]

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {}