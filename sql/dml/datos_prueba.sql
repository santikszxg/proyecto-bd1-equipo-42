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
VALUES (2, 1);
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
INSERT INTO TICKET (ID_compra) VALUES (1);

SELECT Cod_Ticket, Fecha, ID_compra FROM TICKET; -- verificar que Fecha tenga la fecha actual

-- CASO 8: Alta valida en DETALLE_HISTORICO (producto + ticket con precio historico)
-- Registra el precio del producto 1 en el ticket 1. 850.00 entra en DECIMAL(5,2).
-- Deberia insertarse sin errores.
INSERT INTO DETALLE_HISTORICO (ID_Producto, Cod_Ticket, Precio_unitario_Historico)
VALUES (1, 1, 850.00);

-- CASO 9: Precio fuera de rango en DETALLE_HISTORICO (DECIMAL(5,2))
-- DECIMAL(5,2) admite como maximo 999.99. Con 1500.50 deberia fallar con
-- "Arithmetic overflow error converting numeric to data type numeric".
-- Se usa un producto nuevo para no chocar con la PK del caso 8.
INSERT INTO PRODUCTO (Tipo_de_producto, Descripccion, Precio, Nombre)
VALUES ('Antibiotico', 'Caja x 14 capsulas', 1500.50, 'Amoxicilina');

INSERT INTO DETALLE_HISTORICO (ID_Producto, Cod_Ticket, Precio_unitario_Historico)
VALUES (2, 1, 1500.50);

-- CASO 10: Eliminar un registro padre que tiene hijos (integridad referencial)
-- El cliente 1 tiene la compra 1 asociada, asi que el DELETE deberia fallar
-- por conflicto con la restriccion FK_ID_Cliente.
DELETE FROM CLIENTE WHERE ID_Cliente = 1;
