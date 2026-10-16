-- Casos de prueba de funcionamiento :
-----------------------------------------------------------------------------------
-- CASO 1: Alta valida de empleado y farmaceutico 
-- Deberia insertar ambos registros sin error. ID_Direct_Tecnico queda NULL.
INSERT INTO TIPO_DE_EMPLEADO (Nombre, Apellido, DNI, Hora_inicio, Hora_fin)
VALUES ('Ana', 'Pérez', 30123456, '08:00', '16:00');

INSERT INTO FARMACEUTICO (ID_Empleado, Matricula_profesional)
VALUES (1, 'MP-12345');

-- CASO 2: DNI duplicado (restriccion UNIQUE)
-- Deberia fallar por violacion de UQ_dni, ya que el DNI se inserto en el caso 1.
INSERT INTO TIPO_DE_EMPLEADO (Nombre, Apellido, DNI, Hora_inicio, Hora_fin)
VALUES ('Luis', 'Gómez', 30123456, '09:00', '17:00');

-- CASO 3: FK inexistente en COMPRA
-- El primer insert deberia fallar por FK_ID_Cliente (el cliente 999 no existe).
INSERT INTO COMPRA (Monto, Metodo_de_pago, ID_Cliente)
VALUES (1500.50, 'Efectivo', 999);

-- Luego se crea el cliente y se repite la compra, que ahora deberia funcionar.
INSERT INTO CLIENTE (Obra_social, Receta) VALUES ('OSDE', NULL);

INSERT INTO COMPRA (Monto, Metodo_de_pago, ID_Cliente)
VALUES (1500.50, 'Efectivo', 1);

-- CASO 4: Clave primaria compuesta duplicada en POSEE
-- El primer insert en POSEE funciona; el segundo falla por PK_ID_Stock_ID_Producto
-- porque el mismo producto no puede repetirse en el mismo stock.
INSERT INTO STOCK DEFAULT VALUES;

INSERT INTO PRODUCTO (Tipo_de_producto, Descripccion, Precio, Nombre)
VALUES ('Analgésico', 'Caja x 20 comprimidos', 850.00, 'Ibuprofeno');

INSERT INTO POSEE (ID_Stock, ID_Producto, Cantidad_Productos) VALUES (1, 1, 50);
INSERT INTO POSEE (ID_Stock, ID_Producto, Cantidad_Productos) VALUES (1, 1, 20);

-- CASO 5 : Alta valida de empleado cajero asociado a una compra
-- Crea un nuevo empleado (DNI distinto al del caso 1) y lo registra como CAJERO
-- vinculado a la compra 1, creada en el caso 3. Deberia insertarse sin errores.
INSERT INTO TIPO_DE_EMPLEADO (Nombre, Apellido, DNI, Hora_inicio, Hora_fin)
VALUES ('Marta', 'Suárez', 28456789, '12:00', '20:00');

INSERT INTO CAJERO (ID_Empleado, ID_Compra)
VALUES (3, 2); /* Solución del error: ID_Empleado = 2 e ID_Compra = 1 no existían */
-- CASO 6: Alta valida de proveedor y relacion N:M con producto (SUMINISTRA)
-- Crea una ubicacion, un proveedor asociado a ella y lo vincula con el producto 1.
-- Deberia insertarse sin errores (UBICACION ya fue ampliada a VARCHAR(40) con el ALTER).
INSERT INTO UBICACION (Localidad, direccion)
VALUES ('Rosario', 'Av. Pellegrini 1234');

INSERT INTO PROVEEDOR (Numero_de_telefono, Razon_social, Cod_Localizacion)
VALUES ('341-4111111', 'Droguería Central SA', 1);

INSERT INTO SUMINISTRA (ID_Proveedor, ID_Producto)
VALUES (1, 1);

-- CASO 7: Alta valida de TICKET usando el valor DEFAULT de la fecha
-- No se indica Fecha, asi que debe tomar GETDATE() automaticamente.
-- Se vincula a la compra 1 (creada en el caso 3). Deberia insertarse sin errores.
INSERT INTO TICKET (ID_compra) VALUES (2); /* Solución del error: ID_compra = 1 no existía */

SELECT Cod_Ticket, Fecha, ID_compra FROM TICKET; -- verificar que Fecha tenga la fecha actual

-- CASO 8: Alta valida en DETALLE_HISTORICO (producto + ticket con precio historico)
-- Registra el precio del producto 1 en el ticket 1. 850.00 entra en DECIMAL(5,2).
-- Deberia insertarse sin errores.
INSERT INTO DETALLE_HISTORICO (ID_Producto, Cod_Ticket, Precio_unitario_Historico)
VALUES (1, 3, 850.00); /* Solución del error: Cod_Ticket = 1 no existía */

-- CASO 9: Precio fuera de rango en DETALLE_HISTORICO (DECIMAL(5,2))
-- DECIMAL(5,2) admite como maximo 999.99. Con 1500.50 deberia fallar con
-- "Arithmetic overflow error converting numeric to data type numeric".
-- Se usa un producto nuevo para no chocar con la PK del caso 8.
INSERT INTO PRODUCTO (Tipo_de_producto, Descripccion, Precio, Nombre)
VALUES ('Antibiotico', 'Caja x 14 capsulas', 1500.50, 'Amoxicilina');

INSERT INTO DETALLE_HISTORICO (ID_Producto, Cod_Ticket, Precio_unitario_Historico)
VALUES (2, 3, 1500.50);/* Solución del error: Cod_Ticket = 1 no existía */
/* Antiguamente, la columna Precio_unitario_Historico estaba declarada como DECIMAL(5,2) 
y este error era visible, sin embargo ahora ya no puesto que alteramos dicha columna a 
DECIMAL(10,2) y este error desapareció*/

-- CASO 10: Eliminar un registro padre que tiene hijos (integridad referencial)
-- El cliente 1 tiene la compra 1 asociada, asi que el DELETE deberia fallar
-- por conflicto con la restriccion FK_ID_Cliente.
DELETE FROM CLIENTE WHERE ID_Cliente = 1;

-----------------------------------------------------------------------------------
-- Casos de prueba adicionales (Solo casos de Éxito para poblar BD):
-----------------------------------------------------------------------------------
-- CASO 11: Alta de dependencias faltantes y creación de una SUCURSAL
-- Se crean los registros necesarios para poder instanciar una sucursal física.
INSERT INTO HORARIO_ATENCION (Horario) VALUES ('08:00:00'); -- Cod_Horario 1

INSERT INTO DIRECT_TECNICO (Fecha_de_inicio, Fecha_de_finalizacion)
VALUES ('2024-01-01', '2026-12-31'); -- ID_Direct_Tecnico 1

INSERT INTO UBICACION (Localidad, direccion) 
VALUES ('Corrientes', 'Junín 1234'); -- Cod_Localizacion 2 (Asignada a la sucursal)

INSERT INTO STOCK DEFAULT VALUES; -- ID_Stock 2 (Exclusivo de esta sucursal)

-- Creamos la sucursal referenciando los IDs recién generados y el Empleado 1 (Ana)
INSERT INTO SUCURSAL (Cantidad_de_empleados, Num_Telefono, ID_Stock, Cod_Horario, ID_Empleado, ID_Direct_Tecnico, Cod_Localizacion)
VALUES (15, '379-4112233', 2, 1, 1, 1, 2);

-- CASO 12: Alta de personal de SEGURIDAD
-- Útil para tener variedad de roles en el padrón de empleados.
INSERT INTO TIPO_DE_EMPLEADO (Nombre, Apellido, DNI, Hora_inicio, Hora_fin)
VALUES ('Carlos', 'Gómez', 25333444, '20:00:00', '04:00:00'); -- ID_Empleado 4

INSERT INTO SEGURIDAD (ID_Empleado, credencial)
VALUES (4, 'SEG-LITORAL-001');

-- CASO 13: Alta de nuevos clientes para pruebas de "Obra Social"
-- Uno con PAMI y otro consumidor final (sin obra social).
INSERT INTO CLIENTE (Obra_social, Receta) VALUES ('PAMI', 'Receta Digital 9912'); -- ID_Cliente 2
INSERT INTO CLIENTE (Obra_social, Receta) VALUES (NULL, NULL); -- ID_Cliente 3

-- CASO 14: Más compras con distintos métodos de pago para pruebas de "Recaudación"
-- Compras asociadas a los nuevos clientes.
INSERT INTO COMPRA (Monto, Metodo_de_pago, ID_Cliente) 
VALUES (3200.00, 'Tarjeta de Crédito', 2); -- ID_Compra 3

INSERT INTO COMPRA (Monto, Metodo_de_pago, ID_Cliente) 
VALUES (1250.00, 'MercadoPago', 3); -- ID_Compra 4

-- CASO 15: Nuevos tickets y detalle histórico para reconstruir comprobantes
-- Vinculamos las compras 3 y 4 con sus respectivos tickets.
INSERT INTO TICKET (ID_compra) VALUES (3); -- Cod_Ticket 4 
INSERT INTO TICKET (ID_compra) VALUES (4); -- Cod_Ticket 5

-- Agregamos un producto nuevo para darle más variedad al catálogo
INSERT INTO PRODUCTO (Tipo_de_producto, Descripccion, Precio, Nombre)
VALUES ('Perfumería', 'Shampoo Anticaspa 400ml', 3200.00, 'Head & Shoulders'); -- ID_Producto 3

-- Generamos el detalle histórico de los tickets 4 y 5
INSERT INTO DETALLE_HISTORICO (ID_Producto, Cod_Ticket, Precio_unitario_Historico)
VALUES (3, 4, 3200.00); 

INSERT INTO DETALLE_HISTORICO (ID_Producto, Cod_Ticket, Precio_unitario_Historico)
VALUES (1, 5, 1250.00); -- Simulamos que el producto 1 (Ibuprofeno) se vendió a otro precio histórico

-- CASO 16: Carga de bajo stock para pruebas de "Alertas de Inventario"
-- Asociamos productos al Stock 2 de la sucursal con cantidades menores a 10.
INSERT INTO POSEE (ID_Stock, ID_Producto, Cantidad_Productos) VALUES (2, 3, 4);
INSERT INTO POSEE (ID_Stock, ID_Producto, Cantidad_Productos) VALUES (2, 2, 8);

-- CASO 17: Alta de proveedores en la misma localidad que la sucursal 
-- Útil para el caso de uso: "Ubicación de proveedores vs. Sucursales".
INSERT INTO UBICACION (Localidad, direccion) 
VALUES ('Corrientes', 'Av. 3 de Abril 450'); -- Cod_Localizacion 3

INSERT INTO PROVEEDOR (Numero_de_telefono, Razon_social, Cod_Localizacion)
VALUES ('379-4555666', 'Droguería Litoral SA', 3); -- ID_Proveedor 2

-- Vinculamos el nuevo proveedor a los productos 2 y 3 para testear la "Diversidad de catálogo"
INSERT INTO SUMINISTRA (ID_Proveedor, ID_Producto) VALUES (2, 2);
INSERT INTO SUMINISTRA (ID_Proveedor, ID_Producto) VALUES (2, 3);

-- 18. Ampliando Catálogos Base (Ubicaciones y Horarios)
-- Se agregan 7 ubicaciones nuevas (Total: ~10)
INSERT INTO UBICACION (Localidad, direccion) VALUES
('Córdoba', 'Av. Colón 300'),           -- Cod_Localizacion 4
('Mendoza', 'San Martín 1050'),         -- Cod_Localizacion 5
('Resistencia', 'Av. Alberdi 200'),     -- Cod_Localizacion 6
('Posadas', 'Bolívar 1920'),            -- Cod_Localizacion 7
('Salta', 'Mitre 55'),                  -- Cod_Localizacion 8
('CABA', 'Av. Santa Fe 3200'),          -- Cod_Localizacion 9
('La Plata', 'Calle 50 400');           -- Cod_Localizacion 10

-- Se agregan 7 horarios de atención (Total: ~8)
INSERT INTO HORARIO_ATENCION (Horario) VALUES
('09:00:00'), ('10:00:00'), ('00:00:00'), ('07:30:00'), 
('08:30:00'), ('12:00:00'), ('06:00:00'); -- Cod_Horario 2 al 8

-- Se agregan 7 mandatos de Directores Técnicos (Total: ~8)
INSERT INTO DIRECT_TECNICO (Fecha_de_inicio, Fecha_de_finalizacion) VALUES
('2023-05-01', '2025-05-01'), ('2024-02-15', '2026-02-15'), ('2022-10-10', '2024-10-10'),
('2024-06-01', '2027-06-01'), ('2023-11-20', '2025-11-20'), ('2024-03-01', '2026-03-01'),
('2021-01-01', '2025-01-01'); -- ID_Direct_Tecnico 2 al 8

-- 19. Clientes y Compras (Necesarias antes que los Cajeros debido a la estructura de tu BD)
-- Se agregan 7 clientes nuevos (Total: ~10)
INSERT INTO CLIENTE (Obra_social, Receta) VALUES
('Swiss Medical', 'Rec-001'), ('Galeno', 'Rec-002'), ('OSDE', NULL),
('Sancor Salud', 'Rec-003'), ('IAPOS', NULL), (NULL, 'Rec-004'), ('Medifé', NULL); 
-- ID_Cliente 4 al 10

-- Se agregan 7 compras nuevas asociadas a los nuevos clientes (Total: ~11)
INSERT INTO COMPRA (Monto, Metodo_de_pago, ID_Cliente) VALUES
(4500.00, 'Débito', 4),              -- ID_Compra 5
(8900.50, 'Efectivo', 5),            -- ID_Compra 6
(1200.00, 'Transferencia', 6),       -- ID_Compra 7
(5600.00, 'Tarjeta de Crédito', 7),  -- ID_Compra 8
(3400.00, 'MercadoPago', 8),         -- ID_Compra 9
(900.00, 'Efectivo', 9),             -- ID_Compra 10
(11500.00, 'Débito', 10);            -- ID_Compra 11

-- 20. Empleados y sus Roles Jerárquicos
-- Insertamos 15 empleados base de una sola vez (IDs asumidos del 5 al 19)
INSERT INTO TIPO_DE_EMPLEADO (Nombre, Apellido, DNI, Hora_inicio, Hora_fin) VALUES
('Laura', 'Bustos', 31222333, '08:00:00', '16:00:00'),   -- 5 (Farmacéutico)
('Diego', 'López', 32444555, '09:00:00', '17:00:00'),    -- 6 (Farmacéutico)
('Sofía', 'Ramos', 33555666, '14:00:00', '22:00:00'),    -- 7 (Farmacéutico)
('Javier', 'Silva', 34666777, '08:00:00', '16:00:00'),   -- 8 (Farmacéutico)
('Martina', 'Díaz', 35777888, '10:00:00', '18:00:00'),   -- 9 (Farmacéutico)
('Lucas', 'Romero', 36888999, '12:00:00', '20:00:00'),   -- 10 (Farmacéutico)
('Elena', 'Vega', 37999000, '08:00:00', '16:00:00'),     -- 11 (Farmacéutico)
('Pablo', 'Castro', 38111222, '16:00:00', '00:00:00'),   -- 12 (Cajero)
('Nadia', 'Luna', 39222333, '08:00:00', '16:00:00'),     -- 13 (Cajero)
('Tomas', 'Arias', 40333444, '14:00:00', '22:00:00'),    -- 14 (Cajero)
('Lucía', 'Paz', 41444555, '09:00:00', '17:00:00'),      -- 15 (Cajero)
('Mario', 'Ruiz', 42555666, '10:00:00', '18:00:00'),     -- 16 (Seguridad)
('Clara', 'Sosa', 43666777, '22:00:00', '06:00:00'),     -- 17 (Seguridad)
('Bruno', 'Mora', 44777888, '00:00:00', '08:00:00'),     -- 18 (Seguridad)
('Paola', 'Ríos', 45888999, '06:00:00', '14:00:00');     -- 19 (Seguridad)

-- Asignamos 7 roles de FARMACÉUTICO vinculados a Directores Técnicos
INSERT INTO FARMACEUTICO (ID_Empleado, Matricula_profesional, ID_Direct_Tecnico) VALUES
(5, 'MP-22334', 2), (6, 'MP-33445', 3), (7, 'MP-44556', 4),
(8, 'MP-55667', 5), (9, 'MP-66778', 6), (10, 'MP-77889', NULL), (11, 'MP-88990', NULL);

-- Asignamos roles de CAJERO vinculados a las compras creadas arriba
INSERT INTO CAJERO (ID_Empleado, ID_Compra) VALUES
(12, 5), (13, 6), (14, 7), (15, 8);

-- Asignamos roles de SEGURIDAD
INSERT INTO SEGURIDAD (ID_Empleado, credencial) VALUES
(16, 'SEG-002'), (17, 'SEG-003'), (18, 'SEG-004'), (19, 'SEG-005');

-- 21. Productos, Inventario y Proveedores
-- Se agregan 7 productos nuevos al catálogo (Total: ~10)
INSERT INTO PRODUCTO (Tipo_de_producto, Descripccion, Precio, Nombre) VALUES
('Medicamento', 'Paracetamol 500mg', 600.00, 'Tafirol'),       -- ID_Producto 4
('Medicamento', 'Loratadina 10mg', 1200.00, 'Aerotina'),       -- ID_Producto 5
('Insumo Médico', 'Termómetro digital', 3500.00, 'Termómetro'),-- ID_Producto 6
('Perfumería', 'Jabón de glicerina', 800.00, 'Veritas'),       -- ID_Producto 7
('Medicamento', 'Omeprazol 20mg', 2500.00, 'Danlox'),          -- ID_Producto 8
('Insumo Médico', 'Alcohol etílico 500ml', 950.00, 'Porta'),   -- ID_Producto 9
('Perfumería', 'Crema hidratante', 4200.00, 'Nivea');          -- ID_Producto 10

-- Generamos stocks independientes para las sucursales (Total: ~9)
INSERT INTO STOCK DEFAULT VALUES; -- 3
INSERT INTO STOCK DEFAULT VALUES; -- 4
INSERT INTO STOCK DEFAULT VALUES; -- 5
INSERT INTO STOCK DEFAULT VALUES; -- 6
INSERT INTO STOCK DEFAULT VALUES; -- 7
INSERT INTO STOCK DEFAULT VALUES; -- 8
INSERT INTO STOCK DEFAULT VALUES; -- 9

-- Se agregan 7 proveedores en distintas localidades (Total: ~9)
INSERT INTO PROVEEDOR (Numero_de_telefono, Razon_social, Cod_Localizacion) VALUES
('011-4555-1234', 'Droguería Suizo Argentina', 4), -- ID_Proveedor 3
('011-4333-9876', 'Droguería Monroe', 9),          -- ID_Proveedor 4
('0351-422-5555', 'Droguería del Sud', 4),         -- ID_Proveedor 5
('0341-488-7777', 'Kellerhoff', 1),                -- ID_Proveedor 6
('0261-499-1111', 'Droguería Mendoza', 5),         -- ID_Proveedor 7
('0387-411-2222', 'Norte Salud', 8),               -- ID_Proveedor 8
('0362-433-4444', 'Litoral Med', 6);               -- ID_Proveedor 9

-- Relacionamos Proveedores con Productos (SUMINISTRA)
INSERT INTO SUMINISTRA (ID_Proveedor, ID_Producto) VALUES
(3, 4), (3, 5), (4, 6), (4, 7), (5, 8), (5, 9), (6, 10), (7, 4), (8, 5), (9, 8);

-- Relacionamos el Stock con los Productos (POSEE)
INSERT INTO POSEE (ID_Stock, ID_Producto, Cantidad_Productos) VALUES
(3, 4, 100), (3, 5, 50), (4, 6, 10), (4, 7, 30), 
(5, 8, 40), (5, 9, 80), (6, 10, 15), (7, 4, 60), 
(8, 5, 25), (9, 8, 12);

-- 22. Sucursales
-- Se crean 7 sucursales entrelazando todo lo generado (Total: ~8)
INSERT INTO SUCURSAL (Cantidad_de_empleados, Num_Telefono, ID_Stock, Cod_Horario, ID_Empleado, ID_Direct_Tecnico, Cod_Localizacion) VALUES
(10, '0351-411-0000', 3, 2, 5, 2, 4),  -- SUCURSAL 2 (Córdoba)
(12, '0261-422-1111', 4, 3, 6, 3, 5),  -- SUCURSAL 3 (Mendoza)
(8,  '0362-433-2222', 5, 4, 7, 4, 6),  -- SUCURSAL 4 (Resistencia)
(14, '0376-444-3333', 6, 5, 8, 5, 7),  -- SUCURSAL 5 (Posadas)
(9,  '0387-455-4444', 7, 6, 9, 6, 8),  -- SUCURSAL 6 (Salta)
(20, '011-4666-5555', 8, 7, 10, 7, 9), -- SUCURSAL 7 (CABA)
(15, '0221-477-6666', 9, 8, 11, 8, 10);-- SUCURSAL 8 (La Plata)

-- 23. Tickets y Detalle de Compras Histórico
-- Registramos los comprobantes de las compras 5 a la 11
INSERT INTO TICKET (ID_compra) VALUES
(5), (6), (7), (8), (9), (10), (11); -- Cod_Ticket 6 al 12

-- Entrelazamos los tickets con los productos que se llevaron y el precio de ese momento
INSERT INTO DETALLE_HISTORICO (ID_Producto, Cod_Ticket, Precio_unitario_Historico) VALUES
(4, 6, 600.00), (5, 6, 1200.00),   -- El ticket 6 se llevó 2 productos
(6, 7, 3400.00), (7, 7, 800.00),   -- El ticket 7 se llevó 2 productos
(8, 8, 2500.00),                   -- Ticket 8
(9, 9, 900.00),                    -- Ticket 9
(10, 10, 4000.00), (4, 10, 550.00),-- El ticket 10 se llevó 2 productos a un precio menor al actual
(5, 11, 1150.00),                  -- Ticket 11
(8, 12, 2400.00);                  -- Ticketvin
