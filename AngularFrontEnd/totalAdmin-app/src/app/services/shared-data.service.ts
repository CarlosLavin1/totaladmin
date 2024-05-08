import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
// Use to share data between different components 
export class SharedDataService {

  // holds the current value of the data
  private dataSrc = new BehaviorSubject<{ EmployeeNumber: string, PONumber: string } | null>(null);

  // the stream of data that can be listened to for updates
  data = this.dataSrc.asObservable();

  // Updates the current data
  setData(data: { EmployeeNumber: string, PONumber: string }) {
    this.dataSrc.next(data);
  }

  // clears the current data
  clearData() {
    this.dataSrc.next(null);
  }

  constructor() { }
}
