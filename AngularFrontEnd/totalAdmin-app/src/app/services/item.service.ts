import { Injectable } from '@angular/core';
import { API_URL, SharedService } from './shared.service';
import { HttpClient } from '@angular/common/http';
import { Item } from '../models/item';
import { catchError, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ItemService extends SharedService {

  constructor(private http: HttpClient) {
    super();
  }

  public addItem(item: any): Observable<any> {
    return this.http
      .post<Item>(`${API_URL}/item`, item)
      .pipe(catchError(super.handleError));
  }

  public updateItem(item: Item): Observable<any> {
    return this.http
      .patch(`${API_URL}/item/${item.itemId}/${item.statusId}/${item.rejectedReason}/${item.quantity}/${item.price}/${item.description}/${item.location}/${item.modifiedReason}`, item)
      .pipe(catchError(super.handleError));
  }

  public getItemById(id: number): Observable<Item> {
    return this.http
      .get<Item>(`${API_URL}/item/${id}`)
      .pipe(catchError(super.handleError));
  }
}
