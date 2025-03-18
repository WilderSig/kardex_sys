CREATE DATABASE KardexDB;
GO

USE KardexDB;
GO

-- Tabla de Bodega
CREATE TABLE Bodega (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

-- Tabla de Producto
CREATE TABLE Producto (
    id INT IDENTITY(1,1) PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT NOT NULL,
    fecha_vencimiento DATE NOT NULL
);

-- Tabla de Existencia
CREATE TABLE Existencia (
    id INT IDENTITY(1,1) PRIMARY KEY,
    bodega_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT DEFAULT 0,
    FOREIGN KEY (bodega_id) REFERENCES Bodega(id),
    FOREIGN KEY (producto_id) REFERENCES Producto(id)
);

-- Tabla de TipoMovimiento
CREATE TABLE TipoMovimiento (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Tabla de Movimiento
CREATE TABLE Movimiento (
    id INT IDENTITY(1,1) PRIMARY KEY,
    tipo_movimiento_id INT NOT NULL,
    producto_id INT NOT NULL,
    bodega_origen_id INT NULL,
    bodega_destino_id INT NULL,
    cantidad INT NOT NULL,
    fecha DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (tipo_movimiento_id) REFERENCES TipoMovimiento(id),
    FOREIGN KEY (producto_id) REFERENCES Producto(id),
    FOREIGN KEY (bodega_origen_id) REFERENCES Bodega(id),
    FOREIGN KEY (bodega_destino_id) REFERENCES Bodega(id)
);

COMMIT;