import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

// Angular Material
import { MatTableModule } from '@angular/material/table';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';

import { ListaMovimientosComponent } from './lista-movimientos/lista-movimientos.component';
import { FormMovimientoComponent } from './form-movimiento/form-movimiento.component';
import { MatSortModule } from '@angular/material/sort';

@NgModule({
  declarations: [
    ListaMovimientosComponent,
    FormMovimientoComponent
  ],
  imports: [
    CommonModule,
    FormsModule,
    MatSortModule,
    MatTableModule,
    MatButtonModule,
    MatIconModule,
    MatFormFieldModule,
    MatInputModule,
    MatSelectModule
  ]
})
export class MovimientosModule { }
