import { Component, OnInit } from '@angular/core';
import { ProductService } from 'src/app/services/product.service';
import { Product } from 'src/app/models/product.model';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss'],
})
export class DashboardComponent implements OnInit {
  timeOut = null;
  product: Product;
  isSearching = false;
  errorMsg = '';
  cardContent = '';
  constructor(private productService: ProductService) {}

  ngOnInit(): void {
  }

  onInput(event: string) {
    if (event) {
      clearTimeout(this.timeOut);
      this.timeOut = setTimeout(() => {
        this.searchProduct(event);
      }, 500);
    }
  }

  searchProduct(event: string) {
    this.errorMsg = '';
    this.cardContent = '';
    if (this.isValidUrl(event)) {
      this.isSearching = true;
      this.productService.searchProduct(event).subscribe(
        (res) => {
          if (res && res.success) {
            this.product = res.data;
          } else {
            this.cardContent = res.message;
            this.product = null;
          }
          this.isSearching = false;
        },
        (err) => {
          this.isSearching = false;
          this.errorMsg = err.error.message;
          this.product = null;
        }
      );
    } else {
      this.errorMsg = 'Url must be a hamro bazar product url';
    }
  }

  isValidUrl(url: string): boolean {
    return /https:\/\/hamrobazaar.com\/(.*).html/.test(url);
  }
}
