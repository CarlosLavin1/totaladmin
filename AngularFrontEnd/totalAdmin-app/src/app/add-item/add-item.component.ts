import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ItemService } from '../services/item.service';
import { ActivatedRoute, Router } from '@angular/router';
import { Item } from '../models/item';
import { ValidationError } from '../models/validationError';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-add-item',
  templateUrl: './add-item.component.html',
  styleUrls: ['./add-item.component.css']
})
export class AddItemComponent {
  private subscriptions: Subscription[] = [];
  validationErrors: ValidationError[] = [];
  errors: string[] = [];


  itemForm: FormGroup = this.formBuilder.group({
    name: ['', Validators.required],
    quantity: ['', Validators.required],
    description: ['', Validators.required],
    price: ['', Validators.required],
    justification: ['', Validators.required],
    location: ['', Validators.required],
    statusId: ['', Validators.required],
    poNumber: ['', Validators.required]
  });

  constructor(
    private formBuilder: FormBuilder,
    private itemService: ItemService,
    private router: Router,
    private activatedRoute: ActivatedRoute
  ) {}

  ngOnDestroy(): void {
    this.subscriptions.forEach((subscription) => subscription.unsubscribe());
  }

  onSubmit() {
    if(this.itemForm.valid){
      this.errors = [];
      this.validationErrors = [];

      const item: Item = this.itemForm.value;

      const subscription = this.itemService.addItem(item).subscribe({
        next: () => {
          console.log('Successfully added item');
          this.itemForm.reset();
        },
        error: (err) => {
          if (err.error.errors) {
            const validationErrors: ValidationError[] = err.error.errors;
            validationErrors.forEach((error) => {
              this.errors.push(error.description);
            });
          } else {
            this.errors.push(err.error.title);
          }
        },
      });
      this.subscriptions.push(subscription);
    }
  }
}
