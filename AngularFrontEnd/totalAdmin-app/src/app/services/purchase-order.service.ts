import { Injectable } from '@angular/core';
import { API_URL, SharedService } from './shared.service';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, catchError } from 'rxjs';
import { POSearchFiltersDTO } from '../models/posearch-filters-dto';
import { PODisplayDTO } from '../models/podisplay-dto';
import { PurchaseOrder } from '../models/purchase-order';
import { Item } from '../models/item';


@Injectable({
  providedIn: 'root'
})
export class PurchaseOrderService extends SharedService {
  showCloseButton: { [key: string]: boolean } = {};
  
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
    return this.http
      .post<PurchaseOrder>(`${API_URL}/purchaseOrder`, purchaseOrder)
      .pipe(catchError(super.handleError));
  }

  public ReviewEmployeePO(employeeNumber: number): Observable<PurchaseOrder[]> {
    const options = {
      params: new HttpParams().set('employeeNumber', employeeNumber.toString())
    };

    return this.http
      .get<PurchaseOrder[]>(`${API_URL}/PurchaseOrder/Employee`, options)
      .pipe(catchError(super.handleError));
  }

  public ReviewDepartmentPO(departmentId: number): Observable<PurchaseOrder[]> {
    return this.http
      .get<PurchaseOrder[]>(`${API_URL}/PurchaseOrder/department/${departmentId}`)
      .pipe(catchError(super.handleError));
  }


  public AddItemsToPurchaseOrder(poNumber: number, item: Item): Observable<any> {
    return this.http
      .post(`${API_URL}/PurchaseOrder/AddItems?poNumber=${poNumber}`, item, { responseType: 'text' })
      .pipe(catchError(super.handleError));
  }

  public closePO(poNumber: number): Observable<PurchaseOrder> {
    return this.http
        .put<PurchaseOrder>(`${API_URL}/PurchaseOrder/ClosePO/${poNumber}`,
        {}, { responseType: 'json' })
        .pipe(catchError(super.handleError));
  }


}
