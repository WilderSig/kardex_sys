import { Component, OnInit } from '@angular/core';
import { InventarioService } from 'src/app/services/inventario.service';
import { MatTableDataSource } from '@angular/material/table';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-lista-existencias',
  templateUrl: './lista-existencias.component.html',
  styleUrls: ['./lista-existencias.component.css']
})
export class ListaExistenciasComponent implements OnInit {
  displayedColumns: string[] = ['bodega', 'cantidad'];
  dataSource = new MatTableDataSource<any>();
  productoId: number | null = null;

  constructor(private inventarioService: InventarioService) { }

  ngOnInit(): void { }

  consultarExistencias() {
    if (this.productoId === null || isNaN(Number(this.productoId))) {
      alert('Ingrese un ID de producto válido');
      return;
    }
    this.inventarioService.getExistencias(this.productoId).subscribe(data => {
      this.dataSource.data = data;
    }, error => {
      alert('No se encontraron existencias para el producto');
    });
  }
}