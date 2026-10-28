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


## 2. Triggers (Disparadores) en SQL Server

### ¿Qué son?
Los **triggers** son un tipo especial de procedimiento almacenado que se ejecuta automáticamente cuando ocurre un evento de modificación de datos (`INSERT`, `UPDATE` o `DELETE`) en una tabla o vista.

### ¿Por qué utilizarlos?
* **Auditoría e Historial:** Registran quién, cuándo y qué se modificó.
* **Integridad de Datos:** Garantizan el cumplimiento de reglas complejas que no se pueden resolver con simples restricciones `CHECK` o `FOREIGN KEY`.
* **Automatización:** Ejecutan acciones derivadas de forma transparente para el usuario final.

---

### Caso de Aplicación 1: Auditoría de Cambios de Precio en Productos

#### Problema de Negocio
El área comercial necesita auditar las modificaciones en los precios de los medicamentos para controlar aumentos, guardar la fecha exacta del cambio y registrar qué usuario realizó la modificación.

#### Solución Propuesta
Un trigger de tipo `AFTER UPDATE` sobre la tabla `PRODUCTO` que detecta si la columna `Precio` cambió y guarda un registro histórico en una tabla de auditoría.

#### 1. Creación de la Tabla de Auditoría
```sql
CREATE TABLE dbo.Auditoria_Precio_Producto (
    ID_Auditoria INT IDENTITY(1,1) PRIMARY KEY,
    ID_Producto INT NOT NULL,
    Precio_Anterior DECIMAL(10,2) NOT NULL,
    Precio_Nuevo DECIMAL(10,2) NOT NULL,
    Fecha_Modificacion DATETIME NOT NULL DEFAULT GETDATE(),
    Usuario VARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),
    FOREIGN KEY (ID_Producto) REFERENCES dbo.PRODUCTO(ID_Producto)
);
GO
