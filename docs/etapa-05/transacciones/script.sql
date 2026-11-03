DECLARE @id_cliente INT = 1;
DECLARE @id_producto INT = 1;
DECLARE @id_stock INT = 1;
DECLARE @cantidad INT = 1000; -- Modificar este valor para las pruebas (ej. 1 o 1000)
DECLARE @precio DECIMAL(10,2);
DECLARE @stock_actual INT;
DECLARE @id_compra INT;

-- Obtener precio y stock actual antes de iniciar
SELECT @precio = Precio FROM dbo.PRODUCTO WHERE ID_Producto = @id_producto;
SELECT @stock_actual = Cantidad_Productos FROM dbo.POSEE WHERE ID_Stock = @id_stock AND ID_Producto = @id_producto;

BEGIN TRANSACTION;

-- 1. Registrar venta
INSERT INTO dbo.COMPRA (Monto, Metodo_de_pago, ID_Cliente)
VALUES (@precio * @cantidad, 'Efectivo', @id_cliente);

SET @id_compra = SCOPE_IDENTITY();

-- 2. Registrar ticket
INSERT INTO dbo.TICKET (ID_compra) VALUES (@id_compra);

-- 3. Registrar detalle
INSERT INTO dbo.DETALLE_HISTORICO (ID_Producto, Cod_Ticket, Precio_unitario_Historico)
VALUES (@id_producto, SCOPE_IDENTITY(), @precio);

-- 4. Validar y descontar stock (Control de Atomicidad)
IF @stock_actual IS NULL OR @stock_actual < @cantidad
BEGIN
    -- Escenario Incorrecto: Falla la validación
    ROLLBACK TRANSACTION;
    PRINT 'ERROR: Stock insuficiente. Se ejecutó ROLLBACK. No quedó ningún registro parcial.';
END
ELSE
BEGIN
    -- Escenario Correcto: Pasa la validación
    UPDATE dbo.POSEE 
    SET Cantidad_Productos = Cantidad_Productos - @cantidad
    WHERE ID_Stock = @id_stock AND ID_Producto = @id_producto;

    COMMIT TRANSACTION;
    PRINT 'ÉXITO: Venta registrada y stock actualizado. Se ejecutó COMMIT.';
END
GO
-- Consultar estado final para verificar los resultados (AQUÍ ESTABA EL CAMBIO)
SELECT 
    (SELECT COUNT() FROM dbo.COMPRA) AS Total_Compras,
    (SELECT COUNT() FROM dbo.DETALLE_HISTORICO) AS Total_Detalles,
    (SELECT Cantidad_Productos FROM dbo.POSEE WHERE ID_Stock = 1 AND ID_Producto = 1) AS Stock_Ibuprofeno;
GODECLARE @id_cliente INT = 1;
DECLARE @id_producto INT = 1;
DECLARE @id_stock INT = 1;
DECLARE @cantidad INT = 5; -- Modificar este valor para las pruebas (ej. 1 o 1000)
DECLARE @precio DECIMAL(10,2);
DECLARE @stock_actual INT;
DECLARE @id_compra INT;

-- Obtener precio y stock actual antes de iniciar
SELECT @precio = Precio FROM dbo.PRODUCTO WHERE ID_Producto = @id_producto;
SELECT @stock_actual = Cantidad_Productos FROM dbo.POSEE WHERE ID_Stock = @id_stock AND ID_Producto = @id_producto;

BEGIN TRANSACTION;

-- 1. Registrar venta
INSERT INTO dbo.COMPRA (Monto, Metodo_de_pago, ID_Cliente)
VALUES (@precio * @cantidad, 'Efectivo', @id_cliente);

SET @id_compra = SCOPE_IDENTITY();

-- 2. Registrar ticket
INSERT INTO dbo.TICKET (ID_compra) VALUES (@id_compra);

-- 3. Registrar detalle
INSERT INTO dbo.DETALLE_HISTORICO (ID_Producto, Cod_Ticket, Precio_unitario_Historico)
VALUES (@id_producto, SCOPE_IDENTITY(), @precio);

-- 4. Validar y descontar stock (Control de Atomicidad)
IF @stock_actual IS NULL OR @stock_actual < @cantidad
BEGIN
    -- Escenario Incorrecto: Falla la validación
    ROLLBACK TRANSACTION;
    PRINT 'ERROR: Stock insuficiente. Se ejecutó ROLLBACK. No quedó ningún registro parcial.';
END
ELSE
BEGIN
    -- Escenario Correcto: Pasa la validación
    UPDATE dbo.POSEE 
    SET Cantidad_Productos = Cantidad_Productos - @cantidad
    WHERE ID_Stock = @id_stock AND ID_Producto = @id_producto;

    COMMIT TRANSACTION;
    PRINT 'ÉXITO: Venta registrada y stock actualizado. Se ejecutó COMMIT.';
END
GO
-- Consultar estado final para verificar los resultados (AQUÍ ESTABA EL CAMBIO)
SELECT 
    (SELECT COUNT() FROM dbo.COMPRA) AS Total_Compras,
    (SELECT COUNT() FROM dbo.DETALLE_HISTORICO) AS Total_Detalles,
    (SELECT Cantidad_Productos FROM dbo.POSEE WHERE ID_Stock = 1 AND ID_Producto = 1) AS Stock_Ibuprofeno;
GO
