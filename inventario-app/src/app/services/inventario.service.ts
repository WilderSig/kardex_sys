import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class InventarioService {
  private apiUrl = 'http://localhost:5145/api/inventario';

  constructor(private http: HttpClient) { }

  // Obtener productos
  getProductos(): Observable<any> {
    return this.http.get(`${this.apiUrl}/producto`);
  }

  addProducto(producto: any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/producto`, producto, {
      headers: { 'Content-Type': 'application/json' },
      responseType: 'json' as 'json'
    });
  }

  // Registrar movimiento
  registrarMovimiento(movimiento: any): Observable<any> {
    return this.http.post(`${this.apiUrl}/movimiento`, movimiento);
  }

  // Consultar existencias
  getExistencias(productoId: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/existencias/${productoId}`);
  }

  getMovimientos(): Observable<any> {
    return this.http.get(`${this.apiUrl}/movimiento`);
  }
}
