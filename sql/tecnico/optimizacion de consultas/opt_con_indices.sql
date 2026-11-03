USE Proyecto_Integrador_Farmacia;
GO

/* =================================================================================
   ETAPA V - TEMA: OPTIMIZACIÓN DE CONSULTAS A TRAVÉS DE ÍNDICES
   Equipo: 42
   Script: indices_optimizacion.sql
   ================================================================================= */

-- PARTE 1: Creación de tabla adaptada al histórico de ventas de la farmacia
IF OBJECT_ID('dbo.HISTORIAL_VENTAS_FARMACIA', 'U') IS NOT NULL
    DROP TABLE dbo.HISTORIAL_VENTAS_FARMACIA;
GO

CREATE TABLE dbo.HISTORIAL_VENTAS_FARMACIA (
    ID_Venta BIGINT IDENTITY(1,1),
    Fecha_Venta DATE NOT NULL,
    ID_Sucursal INT NOT NULL,
    Monto_Total DECIMAL(12,2) NOT NULL,
    Metodo_Pago VARCHAR(20) NOT NULL
);
GO

-- PARTE 2: Carga masiva de 1.000.000 de registros mediante CTE
SET NOCOUNT ON;
GO

PRINT 'Iniciando carga de 1.000.000 registros...';
GO

WITH CTE_Numeros AS (
    SELECT TOP (1000000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
    CROSS JOIN sys.objects c
)
INSERT INTO dbo.HISTORIAL_VENTAS_FARMACIA (Fecha_Venta, ID_Sucursal, Monto_Total, Metodo_Pago)
SELECT 
    -- Distribución aleatoria de fechas entre 2021-01-01 y 2026-10-31
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 2130, '2021-01-01'),
    -- Sucursales entre 1 y 10
    (ABS(CHECKSUM(NEWID())) % 10) + 1,
    -- Monto entre 500 y 15.000
    ROUND((RAND(CHECKSUM(NEWID())) * 14500) + 500, 2),
    -- Métodos de pago alternados
    CASE ABS(CHECKSUM(NEWID())) % 4
        WHEN 0 THEN 'Efectivo'
        WHEN 1 THEN 'Débito'
        WHEN 2 THEN 'Crédito'
        ELSE 'MercadoPago'
    END
FROM CTE_Numeros;
GO

-- Verificación de volumen de datos
SELECT COUNT(*) AS Cantidad_Registros_Cargados FROM dbo.HISTORIAL_VENTAS_FARMACIA;
GO

-- Activar métricas de I/O y Tiempo para todas las pruebas
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

/* =================================================================================
   PRUEBA 1 (Caso Ineficiente/Sin Índice): Búsqueda por rango de fechas
   Resultado esperado: Table Scan (recorrido completo de páginas en el Heap).
   ================================================================================= */
SELECT 
    ID_Venta, 
    Fecha_Venta, 
    ID_Sucursal, 
    Monto_Total
FROM dbo.HISTORIAL_VENTAS_FARMACIA
WHERE Fecha_Venta BETWEEN '2024-01-01' AND '2024-01-31';
GO

/* =================================================================================
   PARTE 3: Creación de Índice Agrupado (Clustered Index) sobre Fecha_Venta
   ================================================================================= */
CREATE CLUSTERED INDEX IX_HistorialVentas_Fecha
ON dbo.HISTORIAL_VENTAS_FARMACIA (Fecha_Venta);
GO

/* =================================================================================
   PRUEBA 2 (Caso Exitoso con Clustered Index): Repetición de consulta
   Resultado esperado: Clustered Index Seek (acceso directo por árbol B+).
   ================================================================================= */
SELECT 
    ID_Venta, 
    Fecha_Venta, 
    ID_Sucursal, 
    Monto_Total
FROM dbo.HISTORIAL_VENTAS_FARMACIA
WHERE Fecha_Venta BETWEEN '2024-01-01' AND '2024-01-31';
GO

-- Eliminamos el índice agrupado para probar la alternativa de índice con cobertura
DROP INDEX IX_HistorialVentas_Fecha ON dbo.HISTORIAL_VENTAS_FARMACIA;
GO

/* =================================================================================
   PARTE 4: Creación de Índice No Agrupado con Cobertura (Covering Index)
   Se indexa el filtro (Fecha_Venta) e incluye las columnas solicitadas en el SELECT.
   ================================================================================= */
CREATE NONCLUSTERED INDEX IX_HistorialVentas_Fecha_Cobertura
ON dbo.HISTORIAL_VENTAS_FARMACIA (Fecha_Venta)
INCLUDE (ID_Venta, ID_Sucursal, Monto_Total);
GO

/* =================================================================================
   PRUEBA 3 (Caso Altamente Optimizado con Cobertura): Consulta cubierta
   Resultado esperado: Index Seek puro, sin Table/Key Lookup.
   ================================================================================= */
SELECT 
    ID_Venta, 
    Fecha_Venta, 
    ID_Sucursal, 
    Monto_Total
FROM dbo.HISTORIAL_VENTAS_FARMACIA
WHERE Fecha_Venta BETWEEN '2024-01-01' AND '2024-01-31';
GO

/* =================================================================================
   PRUEBA 4 (Caso Fallido / Antipatrón: Pérdida de SARGabilidad por uso de funciones)
   Demuestra cómo una mala práctica de programación anula el índice disponible:
   Aplicar YEAR() o MONTH() fuerza un Index Scan en lugar de Index Seek.
   ================================================================================= */
SELECT 
    ID_Venta, 
    Fecha_Venta, 
    ID_Sucursal, 
    Monto_Total
FROM dbo.HISTORIAL_VENTAS_FARMACIA
WHERE YEAR(Fecha_Venta) = 2024 AND MONTH(Fecha_Venta) = 1;
GO

/* =================================================================================
   PRUEBA 5 (Caso Fallido de DDL: Intento de crear dos índices Clustered)
   SQL Server solo admite un índice Clustered por tabla física.
   ================================================================================= */
-- Este bloque generará el Error 1902 intencionalmente como prueba técnica de restricción
BEGIN TRY
    CREATE CLUSTERED INDEX IX_Prueba_Error_1 ON dbo.HISTORIAL_VENTAS_FARMACIA (ID_Venta);
    CREATE CLUSTERED INDEX IX_Prueba_Error_2 ON dbo.HISTORIAL_VENTAS_FARMACIA (ID_Sucursal);
END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS NumeroError,
        ERROR_MESSAGE() AS MensajeError;
END CATCH;
GO

-- Desactivar estadísticas
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO
