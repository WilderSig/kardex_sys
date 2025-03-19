import { Component } from '@angular/core';
import { InventarioService } from 'src/app/services/inventario.service';

@Component({
  selector: 'app-form-producto',
  templateUrl: './form-producto.component.html',
  styleUrls: ['./form-producto.component.css']
})
export class FormProductoComponent {
  producto = { sku: '', descripcion: '', fechaVencimiento: '' };

  constructor(private inventarioService: InventarioService) { }


  agregarProducto() {
    if (!this.producto.sku || !this.producto.descripcion || !this.producto.fechaVencimiento) {
      alert('Todos los campos son obligatorios');
      return;
    }
    this.inventarioService.addProducto(this.producto).subscribe({
      next: (response: any) => {
        if (response && response.message === "Producto registrado correctamente.") {
          alert(`Producto agregado con éxito`);
          this.limpiarFormulario();
        } else {
          alert('Hubo un problema al agregar el producto.');
        }
      },
      error: (error) => {
        console.error('Error en la API:', error);
        alert('Error al agregar producto: ' + error.message);
      }
    });
  }

  limpiarFormulario() {
    this.producto = { sku: '', descripcion: '', fechaVencimiento: '' };
  }
}