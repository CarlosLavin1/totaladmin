import { Injectable } from '@angular/core';
import { API_URL, SharedService } from './shared.service';
import { HttpClient, HttpParams  } from '@angular/common/http';
import { Observable, catchError } from 'rxjs';
import { POSearchFiltersDTO } from '../models/posearch-filters-dto';
import { PODisplayDTO } from '../models/podisplay-dto';
import { PurchaseOrder } from '../models/purchase-order';


@Injectable({
  providedIn: 'root'
})
export class PurchaseOrderService extends SharedService {

  constructor(private http: HttpClient) {
    super();
  }

  // End point to get the purchase orders
  public SearchPurchaseOrders(filter: POSearchFiltersDTO): Observable<PODisplayDTO[]> {
    const options = { 
      params: new HttpParams()
        .set('EmployeeNumber', filter.EmployeeNumber.toString())
        .set('StartDate', filter.StartDate ? filter.StartDate.toISOString() : '')
        .set('EndDate', filter.EndDate ? filter.EndDate.toISOString() : '')
    };
    console.log(options.params.toString());
    return this.http
      .get<PODisplayDTO[]>(`${API_URL}/PurchaseOrder/Search`, options)
      .pipe(catchError(super.handleError));
  }

  public addPurchaseOrder(purchaseOrder: PurchaseOrder): Observable<PurchaseOrder> {
    return this.http.post<PurchaseOrder>(`${API_URL}/purchaseOrder`,
    purchaseOrder).pipe(catchError(super.handleError));
  }
  
}
