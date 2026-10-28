# 1. Procedimientos y Funciones Almacenadas en SQL Server

Este módulo contiene la implementación de la función escalar y el procedimiento almacenado adaptados al modelo de base de datos de la farmacia.

---

## 1. Función Escalar: Calcular Descuento para Clientes Frecuentes

### Descripción
Determina el porcentaje de descuento a aplicar a un cliente según el historial de compras acumuladas en la tabla `COMPRA`.

### Reglas de Negocio:
* **Más de $500.000 acumulados:** 10% de descuento.
* **Más de $200.000 acumulados:** 5% de descuento.
* **Caso contrario:** 0% de descuento.

```sql
-- ============================================================================
-- 1. FUNCIÓN: dbo.fn_CalcularDescuentoCliente
-- Tabla involucrada: COMPRA (ID_Cliente, Monto)
-- ============================================================================

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
