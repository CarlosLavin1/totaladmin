import { Component, OnInit } from '@angular/core';
import { Chart, registerables, TooltipItem } from 'chart.js';
import { PurchaseOrder } from '../models/purchase-order';
import { Subscription } from 'rxjs';
import { PurchaseOrderService } from '../services/purchase-order.service';
import { SnackbarService } from '../services/snackbar.service';
import { AuthenticationService } from '../auth/services/authentication.service';
import { ItemService } from '../services/item.service';
import { DepartmentService } from '../services/department.service';
import { ValidationError } from '../models/validationError';
import { DatePipe } from '@angular/common';
Chart.register(...registerables)

@Component({
  selector: 'app-supervisor-dashboard',
  templateUrl: './supervisor-dashboard.component.html',
  styleUrls: ['./supervisor-dashboard.component.css']
})
export class SupervisorDashboardComponent implements OnInit {
  purchaseOrders: PurchaseOrder[] = [];
  errors: string[] = [];
  pendingReviews: number = 0;


  role: string;
  public userRole = localStorage.getItem('userRole');
  private authSubscription: Subscription;
  

  constructor(
    public purchaseOrderService: PurchaseOrderService,
    private snackbarService: SnackbarService,
    private authService: AuthenticationService,
    private departmentService: DepartmentService,
    private itemService: ItemService,
    private datePipe: DatePipe
  ) { }

  ngOnInit(): void {
    if (this.checkRole()) {
      const employeeNumber = localStorage.getItem('employeeNumber');
      if (employeeNumber) {
        this.departmentService.getDepartmentForEmployee(Number(employeeNumber)).subscribe(department => {
          this.loadPurchaseOrders(department.id);
        });
      }
    }
  }

  checkRole(): boolean {
    const userRole = this.authService.getRole();
    console.log('Checking role, userRole:', userRole);
    return userRole === 'Supervisor' || userRole === 'HR Employee' || userRole === 'HR Supervisor';
  }

  RenderChart(labels: string[], data: number[], formattedData: string[]) {
    const chart = new Chart("chart", {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: '# PO Exepenses',
          data: data,
          backgroundColor: [
            'rgba(255, 159, 64, 0.2)'
          ],
          borderColor: [
            'rgb(255, 159, 64)'
          ],
          borderWidth: 1
        }]
      },
      options: {
        scales: {
          y: {
            beginAtZero: true
          }
        },
        plugins: {
          tooltip: {
            callbacks: {
              label: function(context: TooltipItem<'bar'>) {
                var label = context.dataset.label || '';
  
                if (label) {
                  label += ': ';
                }
                label += formattedData[context.dataIndex];
                return label;
              }
            }
          }
        }
      }
    });
  }
  


  loadPurchaseOrders(departmentId: number): Subscription {
    let validationErrors: ValidationError[] = [];
    this.errors = [];


    return this.purchaseOrderService.ReviewDepartmentPO(departmentId)
      .subscribe({
        next: (purchaseOrders: PurchaseOrder[]) => {
          this.purchaseOrders = purchaseOrders;
          console.log(purchaseOrders);

          // Prepare the data for the chart
          const labels = this.purchaseOrders
          .map(po => this.datePipe.transform(po.creationDate, 'Y MMM d', 'en-CA'))
          .filter(label => label !== null) as string[];

          const data = this.purchaseOrders.map(po => po.totalExpenseAmt);

          const formattedData = this.purchaseOrders.map(po => {
            const formatter = new Intl.NumberFormat('en-CA', {
              style: 'currency',
              currency: 'CAD',
            });
            return formatter.format(po.totalExpenseAmt);
          });
          
          // Update the number of pending reviews
          this.pendingReviews = this.purchaseOrders.filter(po => po.purchaseOrderStatus === 'Pending').length

          // Render the chart with the data
          this.RenderChart(labels, data, formattedData);

          console.log('The purchase orders:');
          this.purchaseOrders.forEach((purchaseOrder) => {
            console.log(purchaseOrder);

          });
        },
        error: (error) => {
          console.error('Error retrieving purchase orders:', error);
          this.purchaseOrders = [];
          this.errors = [];

          if (error.status === 404) {
            this.showErrorMessage('No purchase orders found for the provided department ID.');
          } else if (error.error.errors) {
            validationErrors = error.error.errors;
            validationErrors.forEach((error) => {
              this.snackbarService.showSnackBar(error.description, 3000);
            });
          } else {
            this.snackbarService.showSnackBar(error.error.title, 3000);
          }
        }
      });
  }

  showErrorMessage(message: string) {
    this.errors.push(message);
  }

}
