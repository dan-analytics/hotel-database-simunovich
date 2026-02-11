CREATE DATABASE IF NOT EXISTS HOTEL;
USE HOTEL;

-- Distintos sectores del hotel, como recepción, administración o restaurante. Se usa para organizar a los empleados por area.
CREATE TABLE area (
    id_area INT AUTO_INCREMENT PRIMARY KEY,
    nombre_area VARCHAR(100) NOT NULL,
    descripcion VARCHAR(100) NOT NULL
);

-- La información del personal del hotel. Cada empleado está asociado a un área, lo que permite saber qué función cumple.
CREATE TABLE empleado (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    cargo VARCHAR(50),
    turno VARCHAR(30),
    id_area INT,
    FOREIGN KEY (id_area) REFERENCES area(id_area)
    );
    
   -- datos de las personas que se alojan en el hotel. Se relaciona con la reserva para identificar quien realiza cada estadía.
   CREATE TABLE huesped (
    id_huesped INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    documento VARCHAR(20) UNIQUE,
    telefono VARCHAR(20),
    email VARCHAR(100)
);

-- Permite manejar su número, piso, estado y precio base, y se asocia a la reserva para indicar dónde se aloja un huésped.
CREATE TABLE habitacion (
    id_habitacion INT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL UNIQUE,
    piso INT NOT NULL,
    estado VARCHAR(30) NOT NULL,
	precio_base DECIMAL(10,2) NOT NULL,
    descripcion VARCHAR(100)
);

-- Es la estadía del huésped en el hotel. Relaciona al huésped con una habitación en un período de tiempo determinado y permite asociar servicios y pagos.
CREATE TABLE reserva (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    fecha_reserva DATE NOT NULL,
    fecha_ingreso DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    estado VARCHAR(30) NOT NULL,
    id_huesped INT NOT NULL,
    id_habitacion INT NOT NULL,
    FOREIGN KEY (id_huesped) REFERENCES huesped(id_huesped),
    FOREIGN KEY (id_habitacion) REFERENCES habitacion(id_habitacion)
);

-- Sirve para llevar el control del monto abonado, la fecha y el método de pago utilizado por reserva.
CREATE TABLE pago (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago VARCHAR(50) NOT NULL,
    id_reserva INT NOT NULL,
    FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva)
);

-- Extras que ofrece el hotel, como desayuno  buffet, lavandería o cafetería. Con su respectiva descripcion. 
CREATE TABLE servicio (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre_servicio VARCHAR(100) NOT NULL,
    descripcion VARCHAR(150),
    precio DECIMAL(10,2) NOT NULL
);

-- Acá relaciono las reservas con los servicios contratados. Para manejar los casos en los que una reserva puede tener varios servicios y 
-- un servicio puede usarse en distintas reservas.
CREATE TABLE reserva_servicio (
    id_reserva INT NOT NULL,
    id_servicio INT NOT NULL,
    PRIMARY KEY (id_reserva, id_servicio),
    FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva),
    FOREIGN KEY (id_servicio) REFERENCES servicio(id_servicio)
);

-- Acá valido que la fecha de salida sea posterior a la fecha de ingreso.
ALTER TABLE reserva
ADD CONSTRAINT chk_fechas CHECK (fecha_salida > fecha_ingreso);

-- Acá limito los estados posibles de una reserva, solo uno por reserva para que tenga sentido. 
ALTER TABLE reserva
ADD CONSTRAINT chk_estado_reserva
CHECK (estado IN ('confirmada', 'cancelada', 'finalizada')

);

-- Acá procedo a agregar todo el contenido de las tablas para darle algo de contexto a la base de datos. 
INSERT INTO area (nombre_area, descripcion) 
VALUES
('Recepción', 'Atención al huésped y gestión de reservas'),
('Administración', 'Gestión administrativa y financiera'),
('Housekeeping', 'Limpieza y mantenimiento de habitaciones'),
('Restaurante', 'Servicio de comidas y cafetería'),
('Mantenimiento', 'Infraestructura, ascensores y reparaciones'
);

INSERT INTO empleado (nombre, apellido, cargo, turno, id_area) 
VALUES
('Laura', 'Gómez', 'Recepcionista', 'Mañana', 1),
('Carlos', 'Pérez', 'Gerente', 'Completo', 2),
('Ana', 'Martínez', 'Mucama', 'Tarde', 3),
('Juan', 'López', 'Cocinero', 'Mañana', 4),
('Miguel', 'Ruiz', 'Técnico', 'Noche', 5

);

INSERT INTO huesped (nombre, apellido, documento, telefono, email)
 VALUES
('María', 'Fernández', 'DNI123456', '1122334455', 'maria@mail.com'),
('Jorge', 'Rodríguez', 'DNI654321', '1199887766', 'jorge@mail.com'),
('Lucía', 'Santos', 'DNI789456', '1144556677', 'lucia@mail.com'

);

INSERT INTO habitacion (numero, piso, estado, precio_base, descripcion) 
VALUES
(101, 1, 'Disponible', 45000.00, 'Habitación estándar'),
(102, 1, 'Ocupada', 48000.00, 'Habitación estándar'),
(201, 2, 'Disponible', 65000.00, 'Habitación superior'),
(301, 3, 'Mantenimiento', 85000.00, 'Suite con vista'

);

INSERT INTO reserva (
    fecha_reserva,
    fecha_ingreso,
    fecha_salida,
    estado,
    id_huesped,
    id_habitacion
) VALUES (
    '2026-05-01',
    '2026-05-10',
    '2026-05-15',
    'confirmada',
    1,
    2
);


INSERT INTO reserva (
    fecha_reserva,
    fecha_ingreso,
    fecha_salida,
    estado,
    id_huesped,
    id_habitacion
) VALUES
('2026-04-20', '2026-05-01', '2026-05-05', 'finalizada', 1, 1),
('2026-04-22', '2026-05-10', '2026-05-15', 'confirmada', 2, 3),
('2026-04-25', '2026-06-01', '2026-06-03', 'cancelada', 3, 4
);

-- Consulta para visualizar todas las reservas cargadas y que estén bien creadas hasta ahora.
-- Obviamente hice lo mismo con todas, pero para que se vea una de ejemplo :)
SELECT * FROM reserva;


INSERT INTO pago (fecha_pago, monto, metodo_pago, id_reserva) 
VALUES
('2024-05-01', 240000.00, 'Tarjeta de crédito', 7),
('2024-05-03', 325000.00, 'Transferencia', 9
);

INSERT INTO servicio (nombre_servicio, descripcion, precio)
 VALUES
('Desayuno buffet', 'Servicio de desayuno en restaurante', 8000.00),
('Lavandería', 'Lavado y planchado de ropa', 6000.00),
('Room Service', 'Servicio a la habitación', 10000.00),
('Cafetería', 'Bebidas calientes y snacks', 5000.00
);

INSERT INTO reserva_servicio (id_reserva, id_servicio) 
VALUES
(7, 1),
(7, 4),
(8, 1),
(8, 3),
(9, 2),
(9, 4),
(10, 1),
(10, 2
);

-- -- Alias utilizados en las siguientes consultas:
-- r --> referencia a la tabla reserva
-- rs --> referencia a la tabla reserva_servicio
-- s --> referencia a la tabla servicio
-- h --> referencia a la tabla huesped

-- Consulta que calcula el total gastado en servicios extras por cada reserva
SELECT
    r.id_reserva,
    SUM(s.precio) AS total_servicios
FROM reserva r
JOIN reserva_servicio rs ON r.id_reserva = rs.id_reserva
JOIN servicio s ON rs.id_servicio = s.id_servicio
GROUP BY r.id_reserva
;

-- Consulta que muestra el total de servicios por reserva junto a su estado
SELECT
    r.id_reserva,
    r.estado,
    SUM(s.precio) AS total_servicios
FROM reserva r
JOIN reserva_servicio rs ON r.id_reserva = rs.id_reserva
JOIN servicio s ON rs.id_servicio = s.id_servicio
GROUP BY r.id_reserva, r.estado
;

-- Consulta que calcula el total gastado en servicios por cada huésped. Sirve como histórico de consumos totales históricos. 
SELECT
    h.id_huesped,
    h.nombre,
    h.apellido,
    SUM(s.precio) AS total_servicios
FROM huesped h
JOIN reserva r ON h.id_huesped = r.id_huesped
JOIN reserva_servicio rs ON r.id_reserva = rs.id_reserva
JOIN servicio s ON rs.id_servicio = s.id_servicio
GROUP BY h.id_huesped, h.nombre, h.apellido
;

-- Acá se cuenta cuántos servicios tiene cada reserva por ID con COUNT, JOIN Y GOUP BY
SELECT
    r.id_reserva,
    COUNT(rs.id_servicio) AS cantidad_servicios
FROM reserva r
JOIN reserva_servicio rs ON r.id_reserva = rs.id_reserva
GROUP BY r.id_reserva
;

-- Esta consulta nos muestra solo las reservas con más de un servicio contratado usando COUNT 
SELECT
    r.id_reserva,
    COUNT(rs.id_servicio) AS cantidad_servicios
FROM reserva r
JOIN reserva_servicio rs ON r.id_reserva = rs.id_reserva
GROUP BY r.id_reserva
HAVING COUNT(rs.id_servicio) > 1
;

-- Acá vemos el detalle de servicios contratados por cada reserva usando JOIN
SELECT
    r.id_reserva,
    s.nombre_servicio AS servicio,
    s.precio
FROM reserva r
JOIN reserva_servicio rs ON r.id_reserva = rs.id_reserva
JOIN servicio s ON rs.id_servicio = s.id_servicio
ORDER BY r.id_reserva
;


