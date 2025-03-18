
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
    
    -- Si es un ingreso, sumamos la cantidad a la bodega destino
    IF @tipo_movimiento_id = 1
    BEGIN
        IF EXISTS (SELECT 1 FROM Existencia WHERE producto_id = @producto_id AND bodega_id = @bodega_destino_id)
        BEGIN
            UPDATE Existencia 
            SET cantidad = cantidad + @cantidad
            WHERE producto_id = @producto_id AND bodega_id = @bodega_destino_id;
        END
        ELSE
        BEGIN
            INSERT INTO Existencia (bodega_id, producto_id, cantidad) 
            VALUES (@bodega_destino_id, @producto_id, @cantidad);
        END
    END
    
    -- Si es una salida, restamos la cantidad de la bodega origen
    ELSE IF @tipo_movimiento_id = 2
    BEGIN
        IF EXISTS (SELECT 1 FROM Existencia WHERE producto_id = @producto_id AND bodega_id = @bodega_origen_id)
        BEGIN
            DECLARE @stock_actual INT;
            SELECT @stock_actual = cantidad FROM Existencia WHERE producto_id = @producto_id AND bodega_id = @bodega_origen_id;
            
            IF @stock_actual >= @cantidad
            BEGIN
                UPDATE Existencia 
                SET cantidad = cantidad - @cantidad
                WHERE producto_id = @producto_id AND bodega_id = @bodega_origen_id;
            END
            ELSE
            BEGIN
                RAISERROR('No hay suficiente stock en la bodega origen.', 16, 1);
                RETURN;
            END
        END
        ELSE
        BEGIN
            RAISERROR('No existe registro de este producto en la bodega origen.', 16, 1);
            RETURN;
        END
    END
    
    -- Si es una transferencia, restamos de la bodega origen y sumamos a la bodega destino
    ELSE IF @tipo_movimiento_id = 3
    BEGIN
        IF EXISTS (SELECT 1 FROM Existencia WHERE producto_id = @producto_id AND bodega_id = @bodega_origen_id)
        BEGIN
            DECLARE @stock_actual_transferencia INT;
            SELECT @stock_actual_transferencia = cantidad FROM Existencia WHERE producto_id = @producto_id AND bodega_id = @bodega_origen_id;
            
            IF @stock_actual_transferencia >= @cantidad
            BEGIN
                UPDATE Existencia 
                SET cantidad = cantidad - @cantidad
                WHERE producto_id = @producto_id AND bodega_id = @bodega_origen_id;
                
                IF EXISTS (SELECT 1 FROM Existencia WHERE producto_id = @producto_id AND bodega_id = @bodega_destino_id)
                BEGIN
                    UPDATE Existencia 
                    SET cantidad = cantidad + @cantidad
                    WHERE producto_id = @producto_id AND bodega_id = @bodega_destino_id;
                END
                ELSE
                BEGIN
                    INSERT INTO Existencia (bodega_id, producto_id, cantidad) 
                    VALUES (@bodega_destino_id, @producto_id, @cantidad);
                END
            END
            ELSE
            BEGIN
                RAISERROR('No hay suficiente stock en la bodega origen para la transferencia.', 16, 1);
                RETURN;
            END
        END
        ELSE
        BEGIN
            RAISERROR('No existe registro de este producto en la bodega origen.', 16, 1);
            RETURN;
        END
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
    
    -- Registrar el movimiento
    INSERT INTO Movimiento (tipo_movimiento_id, producto_id, bodega_origen_id, bodega_destino_id, cantidad, fecha)
    VALUES (@tipo_movimiento_id, @producto_id, @bodega_origen_id, @bodega_destino_id, @cantidad, GETDATE());
    
    -- Actualizar saldo de existencias
    EXEC ActualizarSaldoExistencias @producto_id, @bodega_origen_id, @bodega_destino_id, @tipo_movimiento_id, @cantidad;

     -- Asegurar que al menos una fila fue insertada
    IF @@ROWCOUNT > 0
        RETURN 1;
    ELSE
        RETURN 0;
END;
GO


