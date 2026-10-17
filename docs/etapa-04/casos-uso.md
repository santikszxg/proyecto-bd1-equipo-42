# Etapa IV · Casos de Uso

En esta etapa se desarrollaron consultas SQL que responden a necesidades de información del sistema de gestión de farmacias. Cada caso de uso parte de una pregunta del negocio y la resuelve con una consulta sobre las tablas implementadas en la Etapa III. Las consultas se probaron con los datos de prueba del proyecto.

| Caso de uso | Qué resuelve | Técnicas aplicadas | Detalle |
|---|---|---|---|
| **1. Factura / Comprobante** | Encabezado y detalle de una venta, con subtotal por renglón y total. | `INNER JOIN` de 5 tablas, subconsulta, `SUM` | [comprobante.venta](comprobante.venta.md.txt) |
| **2. Reporte agregado** | Total vendido y cantidad de ventas por categoría de producto en un rango de fechas. | `GROUP BY`, `SUM`, `COUNT`, `BETWEEN` | [informe-ventas](informe-ventas.md.txt) |
| **3. Consulta de negocio avanzada** | Sucursales con más de 30 unidades en stock, con su localidad. | `INNER JOIN` de 3 tablas, `GROUP BY`, `HAVING` | [consulta-avanzada](consulta-avanzada.md.txt) |

**Requisito previo:** para calcular los subtotales se agregó la columna `Cantidad` a `DETALLE_HISTORICO` (valor por defecto 1), que se ejecuta una sola vez antes de las consultas:

```sql
ALTER TABLE DETALLE_HISTORICO ADD Cantidad INT NOT NULL DEFAULT 1;
```
