import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ApiResponse } from '../models/api-response.model';
import { Product } from '../models/product.model';
@Injectable({
  providedIn: 'root',
})
export class ProductService {
  productUrl = environment.apiUrl + '/products';

  constructor(private http: HttpClient) {}

  listProducts(): Observable<ApiResponse<Product[]>> {
    return this.http.get<ApiResponse<Product[]>>(this.productUrl);
  }

  searchProduct(searchUrl: string): Observable<ApiResponse<Product>> {
    let params = new HttpParams();
    params = params.append('search', searchUrl);

    return this.http.get<ApiResponse<Product>>(this.productUrl + '/search', {
      params,
    });
  }
}
