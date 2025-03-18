
-------------------------------------------------------------------
-- Procedimiento almacenado para actualizar el saldo de existencias
-------------------------------------------------------------------


IF OBJECT_ID('ActualizarSaldoExistencias', 'P') IS NOT NULL
    DROP PROCEDURE ActualizarSaldoExistencias;
GO
CREATE PROCEDURE ActualizarSaldoExistencias 
    @producto_id INT,
    @bodega_origen_id INT = NULL,
    @bodega_destino_id INT = NULL,
    @tipo_movimiento_id INT,
    @cantidad INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @tipo_ingreso INT = (SELECT id FROM TipoMovimiento WHERE nombre = 'Ingreso');
    DECLARE @tipo_salida INT = (SELECT id FROM TipoMovimiento WHERE nombre = 'Salida');
    DECLARE @tipo_transferencia INT = (SELECT id FROM TipoMovimiento WHERE nombre = 'Transferencia');
    
    -- Si es un ingreso, sumamos la cantidad a la bodega destino
    IF @tipo_movimiento_id = @tipo_ingreso
    BEGIN
        UPDATE Existencia 
        SET cantidad = cantidad + @cantidad
        WHERE producto_id = @producto_id AND bodega_id = @bodega_destino_id;
    END
    
    -- Si es una salida, restamos la cantidad de la bodega origen
    ELSE IF @tipo_movimiento_id = @tipo_salida
    BEGIN
        UPDATE Existencia 
        SET cantidad = cantidad - @cantidad
        WHERE producto_id = @producto_id AND bodega_id = @bodega_origen_id;
    END
    
    -- Si es una transferencia, restamos de la bodega origen y sumamos a la bodega destino
    ELSE IF @tipo_movimiento_id = @tipo_transferencia
    BEGIN
        UPDATE Existencia 
        SET cantidad = cantidad - @cantidad
        WHERE producto_id = @producto_id AND bodega_id = @bodega_origen_id;
        
        UPDATE Existencia 
        SET cantidad = cantidad + @cantidad
        WHERE producto_id = @producto_id AND bodega_id = @bodega_destino_id;
    END
END;
GO


--------------------------------------------------------------------------
-- Procedimiento almacenado para registrar movimientos de entrada y salida
--------------------------------------------------------------------------
IF OBJECT_ID('RegistrarMovimiento', 'P') IS NOT NULL
    DROP PROCEDURE RegistrarMovimiento;
GO
CREATE PROCEDURE RegistrarMovimiento 
    @tipo_movimiento_id INT,
    @producto_id INT,
    @bodega_origen_id INT = NULL,
    @bodega_destino_id INT = NULL,
    @cantidad INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validar que el tipo de movimiento sea válido
    IF NOT EXISTS (SELECT 1 FROM TipoMovimiento WHERE id = @tipo_movimiento_id)
    BEGIN
        RAISERROR('Tipo de movimiento no válido.', 16, 1);
        RETURN;
    END
    
    -- Registrar el movimiento
    INSERT INTO Movimiento (tipo_movimiento_id, producto_id, bodega_origen_id, bodega_destino_id, cantidad, fecha)
    VALUES (@tipo_movimiento_id, @producto_id, @bodega_origen_id, @bodega_destino_id, @cantidad, GETDATE());
    
    -- Actualizar saldo de existencias
    EXEC ActualizarSaldoExistencias @producto_id, @bodega_origen_id, @bodega_destino_id, @tipo_movimiento_id, @cantidad;
END;
GO


