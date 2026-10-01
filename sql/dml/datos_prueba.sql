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
