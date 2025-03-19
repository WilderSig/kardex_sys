import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ListaProductosComponent } from './modules/productos/lista-productos/lista-productos.component';
import { FormProductoComponent } from './modules/productos/form-producto/form-producto.component';
import { ListaMovimientosComponent } from './modules/movimientos/lista-movimientos/lista-movimientos.component';
import { FormMovimientoComponent } from './modules/movimientos/form-movimiento/form-movimiento.component';
import { ListaExistenciasComponent } from './modules/existencias/lista-existencias/lista-existencias.component';

const routes: Routes = [
  { path: 'productos', component: ListaProductosComponent },
  { path: 'productos/agregar', component: FormProductoComponent },
  { path: 'movimientos', component: ListaMovimientosComponent },
  { path: 'movimientos/agregar', component: FormMovimientoComponent },
  { path: 'existencias', component: ListaExistenciasComponent },
  { path: '**', redirectTo: 'productos', pathMatch: 'full' } // Redirección por defecto
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }

