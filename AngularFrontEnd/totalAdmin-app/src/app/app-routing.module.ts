import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { PurchaseOrderSearchComponent } from './purchase-order-search/purchase-order-search.component';

// for routing
const routes: Routes = [
  { path: 'purchase-order-search', component: PurchaseOrderSearchComponent },
]

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {}