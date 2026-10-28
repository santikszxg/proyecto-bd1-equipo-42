USE Proyecto_Integrador_Farmacia; 
GO

-- ============================================================================
-- 1. FUNCIÓN ESCALAR: fn_CalcularDescuentoCliente
-- ============================================================================
CREATE OR ALTER FUNCTION dbo.fn_CalcularDescuentoCliente (
    @ID_Cliente INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @monto_acumulado DECIMAL(12,2) = 0.00;
    DECLARE @porcentaje_descuento DECIMAL(5,2) = 0.00;

    SELECT @monto_acumulado = ISNULL(SUM(Monto), 0.00)
    FROM dbo.COMPRA
    WHERE ID_Cliente = @ID_Cliente;

    IF @monto_acumulado > 500000.00
        SET @porcentaje_descuento = 10.00;
    ELSE IF @monto_acumulado > 200000.00
        SET @porcentaje_descuento = 5.00;
    ELSE
        SET @porcentaje_descuento = 0.00;

    RETURN @porcentaje_descuento;
END;
GO

-- Consulta de prueba para la función:
SELECT 
    ID_Cliente,
    [Obra social],
    dbo.fn_CalcularDescuentoCliente(ID_Cliente) AS PorcentajeDescuento
FROM dbo.CLIENTE;
GO

-- ============================================================================
-- 2. PROCEDIMIENTO ALMACENADO: sp_RegistrarVentaCompleta
-- ============================================================================
CREATE OR ALTER PROCEDURE dbo.sp_RegistrarVentaCompleta
    @ID_Cliente INT,
    @ID_Producto INT,
    @ID_Stock INT,               -- Identifica la sucursal/stock exacto
    @Cantidad INT,
    @Metodo_de_pago VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PrecioActual DECIMAL(10,2);
    DECLARE @Descuento DECIMAL(5,2);
    DECLARE @Subtotal DECIMAL(10,2);
    DECLARE @MontoFinal DECIMAL(10,2);
    DECLARE @StockDisponible INT;
    DECLARE @ID_Compra INT;
    DECLARE @Cod_ticket INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Obtener precio actual
        SELECT @PrecioActual = Precio
        FROM dbo.PRODUCTO
        WHERE ID_Producto = @ID_Producto;

        IF @PrecioActual IS NULL
            RAISERROR('El producto especificado no existe.', 16, 1);

        -- 2. Validar stock en la relación POSEE
        SELECT @StockDisponible = Cantidad_Productos
        FROM dbo.POSEE WITH (UPDLOCK)
        WHERE ID_Stock = @ID_Stock AND ID_Producto = @ID_Producto;

        IF @StockDisponible IS NULL OR @StockDisponible < @Cantidad
            RAISERROR('Stock insuficiente para realizar la venta.', 16, 1);

        -- 3. Calcular descuento e importes
        SET @Descuento = dbo.fn_CalcularDescuentoCliente(@ID_Cliente);
        SET @Subtotal = @Cantidad * @PrecioActual;
        SET @MontoFinal = @Subtotal * (1 - (@Descuento / 100.00));

        -- 4. Registrar en COMPRA
        INSERT INTO dbo.COMPRA (Monto, Metodo_de_pago, ID_Cliente)
        VALUES (@MontoFinal, @Metodo_de_pago, @ID_Cliente);

        SET @ID_Compra = SCOPE_IDENTITY();

        -- 5. Generar comprobante en ticket
        INSERT INTO dbo.ticket (Fecha, ID_Compra)
        VALUES (GETDATE(), @ID_Compra);

        SET @Cod_ticket = SCOPE_IDENTITY();

        -- 6. Registrar en Detalle_historico
        INSERT INTO dbo.Detalle_historico (ID_Producto, Cod_ticket, precio_unitario_historico)
        VALUES (@ID_Producto, @Cod_ticket, @PrecioActual);

        -- 7. Descontar stock en POSEE
        UPDATE dbo.POSEE
        SET Cantidad_Productos = Cantidad_Productos - @Cantidad
        WHERE ID_Stock = @ID_Stock AND ID_Producto = @ID_Producto;

        COMMIT TRANSACTION;

        PRINT 'Venta registrada con éxito. Ticket N°: ' + CAST(@Cod_ticket AS VARCHAR);

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

-- Ejemplo de ejecución para prueba:
-- EXEC dbo.sp_RegistrarVentaCompleta @ID_Cliente = 1, @ID_Producto = 1, @ID_Stock = 1, @Cantidad = 2, @Metodo_de_pago = 'Efectivo';
