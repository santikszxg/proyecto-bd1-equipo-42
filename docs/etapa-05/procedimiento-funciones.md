# 1. Procedimientos y Funciones Almacenadas

## 1.1. Función Escalar: Calcular Descuento para Clientes Frecuentes

**Propósito:** Determinar el porcentaje de descuento asignado a un cliente en función de sus compras acumuladas en la tabla `COMPRA`.

```sql
CREATE FUNCTION dbo.fn_CalcularDescuentoCliente (
    @ID_Cliente INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @monto_acumulado DECIMAL(12,2) = 0.00;
    DECLARE @porcentaje_descuento DECIMAL(5,2) = 0.00;

    -- Acumular el total gastado por el cliente en la tabla COMPRA
    SELECT @monto_acumulado = ISNULL(SUM(Monto), 0.00)
    FROM dbo.COMPRA
    WHERE ID_Cliente = @ID_Cliente;

    -- Aplicar reglas de negocio
    IF @monto_acumulado > 500000.00
        SET @porcentaje_descuento = 10.00;
    ELSE IF @monto_acumulado > 200000.00
        SET @porcentaje_descuento = 5.00;
    ELSE
        SET @porcentaje_descuento = 0.00;

    RETURN @porcentaje_descuento;
END;
GO
