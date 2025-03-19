// lista-movimientos.component.ts
import { Component, OnInit } from '@angular/core';
import { InventarioService } from 'src/app/services/inventario.service';
import { MatTableDataSource } from '@angular/material/table';

@Component({
  selector: 'app-lista-movimientos',
  templateUrl: './lista-movimientos.component.html',
  styleUrls: ['./lista-movimientos.component.css']
})

export class ListaMovimientosComponent implements OnInit {
  displayedColumns: string[] = ['tipoMovimiento', 'producto', 'bodegaOrigen', 'bodegaDestino', 'cantidad', 'fecha'];
  dataSource = new MatTableDataSource<any>();

  constructor(private inventarioService: InventarioService) { }

  ngOnInit(): void {
    this.inventarioService.getMovimientos().subscribe(data => {
      this.dataSource.data = data;
    });
  }
}


