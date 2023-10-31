--  Script Viveros SQL

-- sudo -u postgres createdb viveros;
-- sudo -u postgres psql -d viveros;

CREATE TABLE Vivero (
    Latitud_vivero FLOAT CHECK (Latitud_vivero BETWEEN -90 AND 90),
    Longitud_vivero FLOAT CHECK (Longitud_vivero BETWEEN -180 AND 180),
    Nombre_vivero VARCHAR(100) NOT NULL,
    Productividad_vivero FLOAT CHECK (Productividad_vivero >= 0),
    PRIMARY KEY (Latitud_vivero, Longitud_vivero)
);

CREATE TABLE Zona (
    Latitud_zona FLOAT CHECK (Latitud_zona BETWEEN -90 AND 90),
    Longitud_zona FLOAT CHECK (Longitud_zona BETWEEN -180 AND 180),
    Latitud_vivero FLOAT,
    Longitud_vivero FLOAT,
    Nombre_zona VARCHAR(100) NOT NULL,
    Productividad_zona FLOAT CHECK (Productividad_zona >= 0),
    PRIMARY KEY (Latitud_zona, Longitud_zona),
    FOREIGN KEY (Latitud_vivero, Longitud_vivero) REFERENCES Vivero(Latitud_vivero, Longitud_vivero) ON DELETE CASCADE
);

CREATE TABLE Empleado (
    DNI_empleado VARCHAR(20) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Productividad_empleado FLOAT
);

CREATE TABLE ClienteTajinastePlus (
    NTelefono VARCHAR(20) PRIMARY KEY,
    Pedidos_totales INT NOT NULL,
    Volumen_mensual FLOAT NOT NULL,
    Bonificacion FLOAT GENERATED ALWAYS AS (CASE WHEN Volumen_mensual >= 100 THEN 0.1 ELSE 0 END) STORED
);

CREATE TABLE Pedido (
    ID_pedido INT PRIMARY KEY,
    NTelefono VARCHAR(20) REFERENCES ClienteTajinastePlus(NTelefono) ON DELETE SET NULL,
    DNI_empleado VARCHAR(20) REFERENCES Empleado(DNI_empleado) ON DELETE SET NULL,
    Fecha DATE NOT NULL,
    Volumen_compra FLOAT CHECK (Volumen_compra >= 0)
);

CREATE TABLE Destino (
    ID_destino INT PRIMARY KEY,
    DNI_empleado VARCHAR(20) REFERENCES Empleado(DNI_empleado) ON DELETE SET NULL,
    Latitud_zona FLOAT,
    Longitud_zona FLOAT,
    Fecha_inicial DATE NOT NULL,
    Fecha_final DATE,
    FOREIGN KEY (Latitud_zona, Longitud_zona) REFERENCES Zona(Latitud_zona, Longitud_zona) ON DELETE SET NULL
);

CREATE TABLE Producto (
    ID_producto INT PRIMARY KEY,
    Latitud_zona FLOAT,
    Longitud_zona FLOAT,
    Nombre VARCHAR(100) NOT NULL,
    Precio FLOAT NOT NULL,
    Stock INT NOT NULL,
    FOREIGN KEY (Latitud_zona, Longitud_zona) REFERENCES Zona(Latitud_zona, Longitud_zona) ON DELETE SET NULL
);


-- Inserciones:

INSERT INTO Vivero (Latitud_vivero, Longitud_vivero, Nombre_vivero, Productividad_vivero) VALUES
(28.1, -15.4, 'Vivero Tenerife Norte', 90.5),
(28.5, -16.2, 'Vivero Tenerife Sur', 85.3),
(28.3, -15.7, 'Vivero Tenerife Este', 88.2),
(28.2, -15.8, 'Vivero Tenerife Oeste', 80.6),
(28.4, -15.9, 'Vivero Tenerife Centro', 89.0);


INSERT INTO Zona (Latitud_zona, Longitud_zona, Latitud_vivero, Longitud_vivero, Nombre_zona, Productividad_zona) VALUES
(28.1, -15.4, 28.1, -15.4, 'Exterior Norte', 95.0),
(28.5, -16.2, 28.5, -16.2, 'Exterior Sur', 90.0),
(28.3, -15.7, 28.3, -15.7, 'Almacén Este', 85.0),
(28.2, -15.8, 28.2, -15.8, 'Almacén Oeste', 80.0),
(28.4, -15.9, 28.4, -15.9, 'Exterior Centro', 92.0);


INSERT INTO Empleado (DNI_empleado, Nombre, Productividad_empleado) VALUES
('12345678A', 'Juan', 88.5),
('23456789B', 'María', 90.2),
('34567890C', 'Carlos', 85.6),
('45678901D', 'Sara', 87.3),
('56789012E', 'Pedro', 86.9);


INSERT INTO ClienteTajinastePlus (NTelefono, Pedidos_totales, Volumen_mensual) VALUES
('600111222', 5, 105.5),
('600333444', 3, 95.0),
('600555666', 4, 110.0),
('600777888', 2, 80.0),
('600999000', 6, 120.0);


INSERT INTO Pedido (ID_pedido, NTelefono, DNI_empleado, Fecha, Volumen_compra) VALUES
(1, '600111222', '12345678A', '2023-11-01', 20.5),
(2, '600333444', '23456789B', '2023-11-02', 30.0),
(3, '600555666', '34567890C', '2023-11-03', 25.5),
(4, '600777888', '45678901D', '2023-11-04', 15.0),
(5, '600999000', '56789012E', '2023-11-05', 35.0);


INSERT INTO Destino (ID_destino, DNI_empleado, Latitud_zona, Longitud_zona, Fecha_inicial, Fecha_final) VALUES
(1, '12345678A', 28.1, -15.4, '2023-01-01', '2023-06-30'),
(2, '23456789B', 28.5, -16.2, '2023-02-01', '2023-07-31'),
(3, '34567890C', 28.3, -15.7, '2023-03-01', '2023-08-31'),
(4, '45678901D', 28.2, -15.8, '2023-04-01', '2023-09-30'),
(5, '56789012E', 28.4, -15.9, '2023-05-01', '2023-10-31');


INSERT INTO Producto (ID_producto, Latitud_zona, Longitud_zona, Nombre, Precio, Stock) VALUES
(1, 28.1, -15.4, 'Menta', 10.5, 100),
(2, 28.5, -16.2, 'Orquideas', 12.0, 80),
(3, 28.3, -15.7, 'Amapolas', 11.5, 90),
(4, 28.2, -15.8, 'Cactus', 9.5, 70),
(5, 28.4, -15.9, 'Aloe', 13.0, 110);


-- Eliminaciones:

-- Se eliminaran tambien todas las zonas asociadas a este vivero
DELETE FROM Vivero WHERE Nombre_vivero = 'Vivero Tenerife Norte';

-- Las claves ajenas de empleado en pedidos y destinos asociados a este empleado se pondran a NULL
DELETE FROM Empleado WHERE DNI_empleado = '12345678A';

-- Las claves ajenas de NTelefono en pedidos asociados a este cliente se pondran a NULL
DELETE FROM ClienteTajinastePlus WHERE NTelefono = '600111222';

-- Las claves ajenas de Latitud_zona y Longitud_zona en productos asociados a esta zona se pondran a NULL
DELETE FROM Zona WHERE Nombre_zona = 'Exterior Norte';

-- No pasa nada porque no hay claves ajenas que referencien a esta tabla
DELETE FROM Producto WHERE ID_producto = 1;
