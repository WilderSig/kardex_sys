import { Component, OnInit } from '@angular/core';
import { InventarioService } from 'src/app/services/inventario.service';
import { MatTableDataSource } from '@angular/material/table';

@Component({
  selector: 'app-lista-productos',
  templateUrl: './lista-productos.component.html',
  styleUrls: ['./lista-productos.component.css']
})
export class ListaProductosComponent implements OnInit {
  displayedColumns: string[] = ['sku', 'descripcion', 'fechaVencimiento'];
  dataSource = new MatTableDataSource<any>();

  constructor(private inventarioService: InventarioService) { }

  ngOnInit(): void {
    this.inventarioService.getProductos().subscribe(data => {
      this.dataSource.data = data;
    });
  }
}