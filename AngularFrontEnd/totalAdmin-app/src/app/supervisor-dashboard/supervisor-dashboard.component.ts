import { Component, OnInit } from '@angular/core';
import { Chart, registerables, TooltipItem } from 'chart.js';
import { PurchaseOrder } from '../models/purchase-order';
import { Subscription } from 'rxjs';
import { PurchaseOrderService } from '../services/purchase-order.service';
import { SnackbarService } from '../services/snackbar.service';
import { AuthenticationService } from '../auth/services/authentication.service';
import { DepartmentService } from '../services/department.service';
import { ValidationError } from '../models/validationError';
import { ReviewService } from '../services/review.service';
import { EmployeeService } from '../services/employee.service';
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
  unreadEmployeReviews: number = 0;
  numOfpendingPurchaseOrders: number = 0;
  numOfEmployeesSupervising: number = 0;


  role: string;
  public userRole = localStorage.getItem('userRole');
  public employeeNumber = localStorage.getItem('employeeNumber');


  constructor(
    public purchaseOrderService: PurchaseOrderService,
    private snackbarService: SnackbarService,
    private authService: AuthenticationService,
    private departmentService: DepartmentService,
    private employeeService: EmployeeService,
    private reviewService: ReviewService
  ) { }

  ngOnInit(): void {
    if (this.checkRole()) {
      this.employeeNumber = localStorage.getItem('employeeNumber');
      if (this.employeeNumber) {
        this.employeeService.getEmployeeById(Number(this.employeeNumber)).subscribe(employee => {

          const supervisorEmployeeNumber = employee.supervisorEmployeeNumber;
          const loggedInSupervisorNumber = this.employeeNumber;
          const supervisorDepartmentId = employee.departmentId;
          console.log('Department is: ' + supervisorDepartmentId);
          
          
          console.log('The supervisor number is: ' + supervisorEmployeeNumber);
          this.fetchPendingAndUnreadReviews(Number(loggedInSupervisorNumber));

          
          this.employeeService.getUnreadEmployeeReviewsByDepartment(supervisorDepartmentId).subscribe(details => {
            console.log(details);
            // the total number of unread reviews by summing up the unreadReviewsCount
            this.unreadEmployeReviews = details.reduce((sum, detail) => sum + detail.unreadReviewsCount, 0); 
            console.log('Number of unread employee reviews is: ' + this.unreadEmployeReviews);
          });
          this.employeeService.countEmployeesBySupervisor(supervisorEmployeeNumber).subscribe(count => {
            this.numOfEmployeesSupervising = count;
            console.log('Number of employees supervising is: ' + this.numOfEmployeesSupervising);
          });
        });
        this.departmentService.getDepartmentForEmployee(Number(this.employeeNumber)).subscribe(department => {
          this.loadPurchaseOrders(department.id);
        });
      }
    }
  }

  fetchPendingAndUnreadReviews(supervisorEmployeeNumber: number): void {
    this.reviewService.getEmployeesDueForReviewForSupervisor(supervisorEmployeeNumber).subscribe(employees => {
      this.pendingReviews = employees.length;
      console.log(this.pendingReviews);

      
      employees.forEach(emp => {
        this.reviewService.getReviewsForEmployee(emp.employeeNumber).subscribe(reviews => {
          
          this.unreadEmployeReviews += reviews.filter(review => !review.hasBeenRead).length;
          console.log(this.unreadEmployeReviews);
        });
      });
    });
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
          label: '# Total PO Exepenses',
          data: data,
          backgroundColor: [
            'rgba(255, 159, 64, 0.2)'
          ],
          borderColor: [
            'rgb(255, 159, 64)'
          ],
          borderWidth: 1
        },]
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



  loadPurchaseOrders(departmentId: number): Subscription {
    let validationErrors: ValidationError[] = [];
    this.errors = [];

    // Initialize an array with 12 zeros
    let monthlyExpenses = Array(12).fill(0);
    let monthlyLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return this.purchaseOrderService.ReviewDepartmentPO(departmentId)
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

          // Count the number of pending purchase orders
          this.numOfpendingPurchaseOrders = this.purchaseOrders.filter(po => po.purchaseOrderStatus === 'Pending').length;
          console.log('Number of pending po is: ' + this.numOfpendingPurchaseOrders);
          

          // Prepare the data for the chart
          const labels = monthlyLabels;
          const data = monthlyExpenses;
          const formattedData = monthlyExpenses.map(expense => {
            const formatter = new Intl.NumberFormat('en-CA', { style: 'currency', currency: 'CAD', });
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
