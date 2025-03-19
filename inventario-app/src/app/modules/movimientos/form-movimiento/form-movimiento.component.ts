// form-movimiento.component.ts
import { Component } from '@angular/core';
import { InventarioService } from 'src/app/services/inventario.service';

@Component({
  selector: 'app-form-movimiento',
  templateUrl: './form-movimiento.component.html',
  styleUrls: ['./form-movimiento.component.css']
})

export class FormMovimientoComponent {
  movimiento = {
    tipoMovimientoId: '',
    productoId: '',
    bodegaOrigenId: '',
    bodegaDestinoId: '',
    cantidad: 0
  };
  constructor(private inventarioService: InventarioService) { }

  registrarMovimiento() {
    this.inventarioService.registrarMovimiento(this.movimiento).subscribe({
      next: () => {
        alert('Movimiento registrado con éxito');
        this.limpiarFormulario();
      },
      error: (error) => {
        alert('Error al registrar movimiento: ' + error.message);
      }
    });
  }

  limpiarFormulario() {
    this.movimiento = { tipoMovimientoId: '', productoId: '', bodegaOrigenId: '', bodegaDestinoId: '', cantidad: 0 };
  }
}