DROP DATABASE IF EXISTS HOTEL;

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
    FOREIGN KEY (id_area) REFERENCES area(id_area) );
    
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
CHECK (estado IN ('confirmada', 'cancelada', 'finalizada'));

-- Acá procedo a agregar todo el contenido de las tablas para darle algo de contexto a la base de datos. 
INSERT INTO area (nombre_area, descripcion) 
VALUES
('Recepción', 'Atención al huésped y gestión de reservas'),
('Reservas', 'Gestion de reservas de agencias y grupos'),
('Gerencia', 'Manejo general del hotel'),
('Administración', 'Gestión administrativa y financiera'),
('Housekeeping', 'Limpieza y mantenimiento de habitaciones'),
('Restaurante', 'Servicio de comidas y cafetería'),
('Mantenimiento', 'Infraestructura, ascensores y reparaciones');

INSERT INTO empleado (nombre, apellido, cargo, turno, id_area) 
VALUES
('Daniela', 'Simunovich', 'Recepcionista', 'Tarde', 1),
('Génesis', 'Sanchez', 'Mucama', 'Mañana', 3),
('Marcos', 'Paz', 'Mucama', 'Mañana', 3),
('Elena', 'Funes', 'Mucama', 'Tarde', 3),
('Sergio', 'Borjas', 'Cocinero', 'Tarde', 4),
('Sofía', 'Zárate', 'Moza', 'Mañana', 4),
('Hugo', 'Machado', 'Mozo', 'Tarde', 4),
('Edward', 'Montes', 'Recepcionista', 'Mañana', 1),
('Carlos', 'Pérez', 'Gerente', 'Completo', 2),
('Ana', 'Martínez', 'Mucama', 'Tarde', 3),
('Juan', 'López', 'Cocinero', 'Mañana', 4),
('Miguel', 'Yanez', 'Técnico', 'Noche', 5);

INSERT INTO huesped (nombre, apellido, documento, telefono, email)
 VALUES
 ('Ricardo', 'Darín', 'DNI101010', '1144445555', 'ricardito@cine.com'),
('Elena', 'Roger', 'DNI202020', '1155556666', 'elena@teatro.com'),
('Lionel', 'Messi', 'DNI101011', '1133334444', 'leomessi@inter.com'),
('Antonela', 'Roccuzzo', 'DNI222333', '1122223333', 'anto@mail.com'),
('Gustavo', 'Cerati', 'DNI333444', '1188889999', 'fuerza@natural.com'),
('Marta', 'Minujín', 'DNI444555', '1177778888', 'marta@arte.com'),
('Manu', 'Ginóbili', 'DNI555666', '1166667777', 'manu@spurs.com'),
('Tini', 'Stoessel', 'DNI666777', '1100001111', 'latini@musica.com'),
('Bizarrap', 'BZRP', 'DNI777888', '1199990000', 'biza@session.com'),
('María', 'Fernández', 'DNI123456', '1122334455', 'maria@mail.com'),
('Jorge', 'Rodríguez', 'DNI654321', '1199887766', 'jorge@mail.com'),
('Lucía', 'Santos', 'DNI789456', '1144556677', 'lucia@mail.com');

INSERT INTO habitacion (numero, piso, estado, precio_base, descripcion) 
VALUES
(103, 1, 'Disponible', 45000.00, 'Habitación estándar twin'),
(104, 1, 'Limpieza', 45000.00, 'Habitación estándar individual'),
(202, 2, 'Ocupada', 68000.00, 'Habitación superior doble'),
(203, 2, 'Disponible', 68000.00, 'Habitación superior doble'),
(302, 3, 'Ocupada', 95000.00, 'Suite presidencial'),
(303, 3, 'Disponible', 90000.00, 'Suite junior vista mar'),
(401, 4, 'Mantenimiento', 120000.00, 'Penthouse exclusivo'),
(402, 4, 'Disponible', 120000.00, 'Penthouse exclusivo'),
(101, 1, 'Disponible', 45000.00, 'Habitación estándar'),
(102, 1, 'Ocupada', 48000.00, 'Habitación estándar'),
(201, 2, 'Disponible', 65000.00, 'Habitación superior'),
(301, 3, 'Mantenimiento', 85000.00, 'Suite con vista');


INSERT INTO reserva (fecha_reserva, fecha_ingreso, fecha_salida, estado, id_huesped, id_habitacion) 
VALUES
('2026-01-10', '2026-02-01', '2026-02-05', 'finalizada', 4, 5),
('2026-02-15', '2026-03-01', '2026-03-10', 'finalizada', 5, 6),
('2026-03-01', '2026-03-15', '2026-03-20', 'finalizada', 6, 7),
('2026-04-01', '2026-05-20', '2026-05-25', 'confirmada', 7, 8),
('2026-04-10', '2026-06-10', '2026-06-15', 'confirmada', 8, 9),
('2026-05-05', '2026-07-01', '2026-07-10', 'confirmada', 9, 10),
('2026-05-10', '2026-08-15', '2026-08-20', 'confirmada', 10, 11),
('2026-01-01', '2026-01-05', '2026-01-10', 'cancelada', 11, 12),
('2026-05-01', '2026-05-10', '2026-05-15', 'confirmada',1 , 2),
('2026-04-20', '2026-05-01', '2026-05-05', 'finalizada', 2, 1),
('2026-04-22', '2026-05-10', '2026-05-15', 'confirmada', 3, 3),
('2026-04-25', '2026-06-01', '2026-06-03', 'cancelada', 2, 4 );

-- Consulta para visualizar todas las reservas cargadas y que estén bien creadas hasta ahora.
-- Obviamente hice lo mismo con todas, pero para que se vea una de ejemplo :)
SELECT * FROM reserva;


INSERT INTO pago (fecha_pago, monto, metodo_pago, id_reserva) 
VALUES
('2026-02-05', 180000.00, 'Efectivo', 5),
('2026-03-10', 432000.00, 'Tarjeta de Crédito', 6),
('2026-03-20', 325000.00, 'Transferencia', 7),
('2026-05-25', 340000.00, 'Mercadopago', 8),
('2026-06-15', 475000.00, 'Tarjeta de Débito', 9),
('2026-07-10', 810000.00, 'Transferencia', 10),
('2026-08-20', 600000.00, 'Efectivo', 11),
('2026-05-15', 225000.00, 'Tarjeta de Crédito', 12),
('2026-04-28', 560000.00, 'Mercadopago', 4),
('2026-05-02', 365000.00, 'Tarjeta de débito', 1),
('2026-05-01', 240000.00, 'Tarjeta de crédito', 2),
('2026-05-03', 325000.00, 'Transferencia', 3);

INSERT INTO servicio (nombre_servicio, descripcion, precio)
 VALUES
 ('Minibar', 'Consumo de bebidas en la habitación', 4500.00),
('Estacionamiento', 'Cochera privada cubierta', 7000.00),
('Spa & Sauna', 'Acceso al sector de relax', 15000.00),
('Traslado Aeropuerto', 'Servicio de transfer privado', 25000.00),
('Late Check-out', 'Salida después de las 11:00 hs', 12000.00),
('Early Check-in', 'Entrada antes de las 15:00 hs', 12000.00),
('Guía Turístico', 'Tour por el centro histórico', 18000.00),
('Cena Romántica', 'Menú de 3 pasos en terraza', 35000.00),
('Desayuno buffet', 'Servicio de desayuno en restaurante', 20000.00),
('Lavandería', 'Lavado y planchado de ropa', 5000.00);

INSERT INTO reserva_servicio (id_reserva, id_servicio) 
VALUES
(5, 5),
(6, 6), 
(7, 3),
(8, 4), 
(9, 7), 
(10, 8),
(11, 9), 
(12, 10),
(4, 1),
(4, 4),
(3, 1),
(3, 3),
(4, 2),
(1, 4),
(1, 1),
(2, 2);

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

-- SEGUNDA ENTREGA: Se agregaron nuevas inserciones de datos mediante actualización de las sentencias anteriores

-- Ahora vamos con las vistas!! 
-- Vista 1: La primera fue hecha para evitar la redundancia, es un resumen de cada reserva que combina 
-- los datos de Huesped y Habitación para ver bien quien entra y quien sale

CREATE OR REPLACE VIEW vista_resumen_reservas AS
SELECT 
    r.id_reserva,
    CONCAT(h.nombre, ' ', h.apellido) AS nombre_completo,
    hab.numero AS nro_habitacion,
    r.fecha_ingreso,
    r.fecha_salida,
    r.estado AS estado_reserva
FROM reserva r
JOIN huesped h ON r.id_huesped = h.id_huesped
JOIN habitacion hab ON r.id_habitacion = hab.id_habitacion;

-- Vista 2: Esta me parece crucial en el funcionamiento de cualquier hotel, ver qué esta pasando en cada habitación.
-- Se usó un ORDER BY para que se vea más prolijito (inserte emoji de brillito)

CREATE OR REPLACE VIEW vista_estado_habitaciones AS
SELECT 
    numero AS habitacion,
    piso,
    estado AS situacion_actual,
    descripcion
FROM habitacion
ORDER BY piso, numero;

-- Vista 3: Reporte de empleados de cada sector. Creo que funcionaría mucho para recursos humanos o gerencia.
-- Es una lista mas clara, sin IDs.

CREATE OR REPLACE VIEW vista_empleados_por_area AS
SELECT 
    e.nombre AS nombre_empleado, 
    e.apellido AS apellido_empleado, 
    e.cargo, 
    a.nombre_area AS sector,
    e.turno
FROM empleado e
JOIN area a ON e.id_area = a.id_area;

-- Ahora sin más preámbulos... Las funciones. 
-- Función 1: Calculadora de IVA que toma cualquier precio y lesuma el IVA (21%) ideal para sabr cuanto se le debe cobrar
-- a un huesped Argentino

DELIMITER //

CREATE FUNCTION fn_precio_con_iva(monto DECIMAL(10,2)) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SET total = monto * 1.21;
    RETURN total;
END //

DELIMITER ;

-- Función 2: Contador de Servicios, le pasas el número de reserva y te devuelve la cantidad de cuantos extras tiene

DELIMITER //

CREATE FUNCTION fn_contar_servicios(id_res INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;
    SELECT COUNT(*) INTO cantidad 
    FROM reserva_servicio 
    WHERE id_reserva = id_res;
    RETURN cantidad;
END //

DELIMITER ;

-- Probemos: 
SELECT fn_contar_servicios(4) AS cantidad_de_servicios;

SELECT 
    id_reserva, 
    estado, 
    fn_contar_servicios(id_reserva) AS total_items_consumidos
FROM reserva;

-- PROCEDIMIENTOS
-- Procedimiento 1: Actualizar estado de habitación
-- Permite que en una sola línea se cambie el estado de cada habitación como ´Ocupada´o ´Limpieza´

DELIMITER //

CREATE PROCEDURE sp_actualizar_estado_habitacion(
    IN p_numero_habitacion INT, 
    IN p_nuevo_estado VARCHAR(30)
)
BEGIN
    UPDATE habitacion 
    SET estado = p_nuevo_estado 
    WHERE numero = p_numero_habitacion;
END //

DELIMITER ;

-- Procedimiento 2: Eliminar un servicio
-- Cuando un servicio deje de ofrecerse, este procedimiento lo elimina del catálogo usando su ID

DELIMITER //

CREATE PROCEDURE sp_eliminar_servicio(IN p_id_servicio INT)
BEGIN
    DELETE FROM servicio WHERE id_servicio = p_id_servicio;
END //

DELIMITER ;

-- Probemos: 
-- Ejecución1:
CALL sp_actualizar_estado_habitacion(104, 'Disponible');

SELECT numero, estado FROM habitacion WHERE numero = 104;
-- Ejecución 2:
CALL sp_eliminar_servicio(10);
SELECT * FROM servicio WHERE id_servicio = 10;

-- TRIGGERS: 

-- Trigger 1: Un trigger que se activará solito cada vez que alguine use el procedimiento anterior para
-- cambiar el estado de una habitación

CREATE TABLE IF NOT EXISTS log_cambios_habitacion (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    numero_habitacion INT,
    estado_anterior VARCHAR(30),
    estado_nuevo VARCHAR(30),
    fecha_cambio DATETIME,
    usuario VARCHAR(50)
);

DELIMITER //

CREATE TRIGGER tr_log_habitacion
AFTER UPDATE ON habitacion
FOR EACH ROW
BEGIN
    INSERT INTO log_cambios_habitacion (numero_habitacion, estado_anterior, estado_nuevo, fecha_cambio, usuario)
    VALUES (OLD.numero, OLD.estado, NEW.estado, NOW(), USER());
END //

DELIMITER ;

-- Trigger 2: Registra cuando se da de alta un huesped nuevo

CREATE TABLE IF NOT EXISTS log_nuevos_huespedes (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    mensaje VARCHAR(200),
    fecha DATETIME
);

DELIMITER //

CREATE TRIGGER tr_nuevo_huesped
AFTER INSERT ON huesped
FOR EACH ROW
BEGIN
    INSERT INTO log_nuevos_huespedes (mensaje, fecha)
    VALUES (CONCAT('Se registró al huésped: ', NEW.nombre, ' ', NEW.apellido), NOW());
END //

DELIMITER ;

-- Prueba trigger 1:
CALL sp_actualizar_estado_habitacion(102, 'Disponible');
SELECT * FROM log_cambios_habitacion;

-- Prueba trigger 2: 
INSERT INTO huesped (nombre, apellido, documento) VALUES ('Pepito', 'Pérez', 'DNI999');
SELECT * FROM log_nuevos_huespedes;

-- Y listo!!! :)


