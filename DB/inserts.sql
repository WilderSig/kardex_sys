-- Insertar datos iniciales para pruebas

-- Insertar tipos de movimiento (Ingreso, Salida, Transferencia)
INSERT INTO TipoMovimiento (nombre) VALUES ('Ingreso');
INSERT INTO TipoMovimiento (nombre) VALUES ('Salida');
INSERT INTO TipoMovimiento (nombre) VALUES ('Transferencia');

-- Insertar bodegas
INSERT INTO Bodega (nombre) VALUES ('Bodega Central');
INSERT INTO Bodega (nombre) VALUES ('Bodega Regional');

-- Insertar productos
INSERT INTO Producto (sku, descripcion, fecha_vencimiento) VALUES ('MED001', 'Medicamento para la gripe', '2026-12-31');
INSERT INTO Producto (sku, descripcion, fecha_vencimiento) VALUES ('MED002', 'Analgésico 500mg', '2025-11-30');

-- Insertar existencias iniciales en bodegas
INSERT INTO Existencia (bodega_id, producto_id, cantidad) VALUES (1, 1, 100); -- Bodega Central, Producto MED001
INSERT INTO Existencia (bodega_id, producto_id, cantidad) VALUES (2, 2, 50);  -- Bodega Regional, Producto MED002



-- Pruebas de movimientos
-- Movimiento de Ingreso (Agregar stock a Bodega Central para Producto MED001)
EXEC RegistrarMovimiento @tipo_movimiento_id = 1, @producto_id = 1, @bodega_origen_id = NULL, @bodega_destino_id = 1, @cantidad = 50;

-- Movimiento de Salida (Quitar stock de Bodega Central para Producto MED001)
EXEC RegistrarMovimiento @tipo_movimiento_id = 2, @producto_id = 1, @bodega_origen_id = 1, @bodega_destino_id = NULL, @cantidad = 20;

-- Movimiento de Transferencia (Mover stock de Bodega Central a Bodega Regional para Producto MED001)
EXEC RegistrarMovimiento @tipo_movimiento_id = 3, @producto_id = 1, @bodega_origen_id = 1, @bodega_destino_id = 2, @cantidad = 30;
