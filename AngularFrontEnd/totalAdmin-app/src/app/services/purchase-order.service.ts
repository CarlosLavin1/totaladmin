import { Injectable } from '@angular/core';
import { API_URL, SharedService } from './shared.service';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, catchError } from 'rxjs';
import { POSearchFiltersDTO } from '../models/posearch-filters-dto';
import { PODisplayDTO } from '../models/podisplay-dto';
import { PurchaseOrder } from '../models/purchase-order';
import { Item } from '../models/item';
import { POSupervisorFiltersDTO } from '../models/posupervisor-filters-dto';


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

  public updatePurchaseOrder(id: number): Observable<any> {
    return this.http
      .put(`${API_URL}/PurchaseOrder/${id}`, {}, { responseType: 'text' })
      .pipe(catchError(super.handleError));
  }

  public SearchPurchaseOrdersForSupervisor(filters: POSupervisorFiltersDTO): Observable<PurchaseOrder[]> {
    const options = {
      params: new HttpParams()
        .set('DepartmentId', filters.DepartmentId.toString())
        .set('StartDate', filters.StartDate ? new Date(filters.StartDate).toISOString() : '')
        .set('EndDate', filters.EndDate ? new Date(filters.EndDate).toISOString() : '')
        .set('PoNumber', filters.PONumber ? filters.PONumber.toString() : '')
        .set('Status', filters.Status ? filters.Status : 'pending')
        .set('EmployeeName', filters.EmployeeName ? filters.EmployeeName : '')
    };

    return this.http
      .get<PurchaseOrder[]>(`${API_URL}/PurchaseOrder/Supervisor/PurchaseOrders/Search`, options)
      .pipe(catchError(super.handleError));
  }

  public updatePO(id: number, purchaseOrder: PurchaseOrder): Observable<PurchaseOrder> {
    return this.http
      .put<PurchaseOrder>(`${API_URL}/purchaseOrder/update/${id}`, purchaseOrder)
      .pipe(catchError(super.handleError));
  }

  getExistingPurchaseOrder(poNumber: number): Observable<PurchaseOrder> {
    return this.http.get<PurchaseOrder>(`${API_URL}/purchaseOrder/get-existing-po/${poNumber}`);
  }

  
}
