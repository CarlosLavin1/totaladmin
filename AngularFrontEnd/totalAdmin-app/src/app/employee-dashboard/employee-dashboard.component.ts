import { Component } from '@angular/core';
import { PurchaseOrder } from '../models/purchase-order';
import { Subscription } from 'rxjs';
import { PurchaseOrderService } from '../services/purchase-order.service';
import { DatePipe } from '@angular/common';
import { Chart, TooltipItem } from 'chart.js';
import { AuthenticationService } from '../auth/services/authentication.service';
import { ValidationError } from '../models/validationError';
import { DepartmentService } from '../services/department.service';
import { EmployeeService } from '../services/employee.service';
import { ReviewService } from '../services/review.service';
import { SnackbarService } from '../services/snackbar.service';

@Component({
  selector: 'app-employee-dashboard',
  templateUrl: './employee-dashboard.component.html',
  styleUrls: ['./employee-dashboard.component.css']
})
export class EmployeeDashboardComponent {
  purchaseOrders: PurchaseOrder[] = [];
  errors: string[] = [];
  pendingReviews: number = 0;
  unreadEmployeReviews: number = 0;

  role: string;
  public userRole = localStorage.getItem('userRole');
  private authSubscription: Subscription;
  public employeeNumber = localStorage.getItem('employeeNumber');


  constructor(
    public purchaseOrderService: PurchaseOrderService,
    private snackbarService: SnackbarService,
    private authService: AuthenticationService,
    private departmentService: DepartmentService,
    private employeeService: EmployeeService,
    private datePipe: DatePipe,
    private reviewService: ReviewService
  ) { }

  ngOnInit(): void {
    if (this.checkRole()) {
      this.employeeNumber = localStorage.getItem('employeeNumber');

      if (this.employeeNumber) {

        this.reviewService.getReviewsForEmployee(Number(this.employeeNumber)).subscribe(employees => {
          this.pendingReviews = employees.length;
          this.loadPurchaseOrders(Number(this.employeeNumber));
        });

      }

      this.reviewService.getReviewsForEmployee(Number(this.employeeNumber)).subscribe(reviews => {
        this.unreadEmployeReviews = reviews.filter(review => !review.hasBeenRead).length;
        console.log(this.unreadEmployeReviews);
        
      });

    }
  }

  checkRole(): boolean {
    const userRole = this.authService.getRole();
    console.log('Checking role, userRole:', userRole);
    return userRole === 'Employee';
  }

  RenderChart(labels: string[], data: number[], formattedData: string[]) {
    const chart = new Chart("chart", {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: '# Total PO Exepenses',
          data: data ?? 0,
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
              label: function (context: TooltipItem<'bar'>) {
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


  loadPurchaseOrders(employeeNumber: number): Subscription {
    let validationErrors: ValidationError[] = [];
    this.errors = [];

    // Initialize an array with 12 zeros
    let monthlyExpenses = Array(12).fill(0);
    let monthlyLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return this.purchaseOrderService.ReviewEmployeePO(employeeNumber)
      .subscribe({
        next: (purchaseOrders: PurchaseOrder[]) => {
          this.purchaseOrders = purchaseOrders.map(po => {
            if (po.totalExpenseAmt === null || po.totalExpenseAmt === undefined) {
              po.totalExpenseAmt = 0;
            }
            return po;
          });

          // Update the monthlyExpenses array with the actual expenses
          this.purchaseOrders.forEach(po => {
            let month = new Date(po.creationDate).getMonth();
            monthlyExpenses[month] += po.totalExpenseAmt;
          });

          // Prepare the data for the chart
          const labels = monthlyLabels;
          const data = monthlyExpenses;

          const formattedData = monthlyExpenses.map(expense => {
            const formatter = new Intl.NumberFormat('en-CA',
              { style: 'currency', currency: 'CAD', });
            return formatter.format(expense);
          });

          // Render the chart with the data
          this.RenderChart(labels, data, formattedData);
        },
        error: (error) => {
          console.error('Error retrieving purchase orders:', error);
          this.purchaseOrders = [];
          this.errors = [];
          if (error.status === 404) {
            this.RenderChart(monthlyLabels, monthlyExpenses, monthlyExpenses.map(expense => expense.toString()));
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
