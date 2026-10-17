# Caso de uso 1 · Factura / Comprobante

## Objetivo
Obtener el comprobante de una venta en un solo resultado: los datos del encabezado (ticket, fecha, método de pago y obra social del cliente) junto con el detalle de los productos vendidos, el subtotal de cada renglón y el total de la venta.

## Consulta SQL

```sql
DECLARE @Ticket_buscado INT = 10;

SELECT 
    T.Cod_Ticket, 
    T.Fecha, 
    C.Metodo_de_pago, 
    CL.Obra_social,
    P.Nombre, 
    DH.Cantidad, 
    DH.Precio_unitario_Historico,
    DH.Cantidad * DH.Precio_unitario_Historico AS Subtotal,
       (SELECT 
            SUM(DH.Cantidad * DH.Precio_unitario_Historico)
        FROM DETALLE_HISTORICO AS DH
        WHERE Cod_Ticket = @Ticket_buscado) AS Total
FROM TICKET AS T
INNER JOIN COMPRA            AS C ON T.ID_compra = C.ID_Compra
INNER JOIN CLIENTE           AS CL ON C.ID_Cliente = CL.ID_Cliente
INNER JOIN DETALLE_HISTORICO AS DH ON T.Cod_Ticket = DH.Cod_Ticket
INNER JOIN PRODUCTO          AS P ON DH.ID_Producto = P.ID_Producto
WHERE T.Cod_Ticket = @Ticket_buscado;
```

## Conceptos aplicados

- **Variable (`DECLARE`):** `@Ticket_buscado` guarda el número de ticket que se quiere consultar. Para obtener otro comprobante solo se cambia ese valor.
- **Combinación interna (`INNER JOIN`):** une las tablas a través de sus claves primarias y foráneas, y devuelve solo las filas que tienen coincidencia en ambas tablas. Se recorre el camino `TICKET → COMPRA → CLIENTE` para el encabezado y `TICKET → DETALLE_HISTORICO → PRODUCTO` para el detalle.
- **Alias (`AS`):** nombres cortos para las tablas (`T`, `C`, `CL`, `DH`, `P`) que evitan repetir el nombre completo e indican de qué tabla sale cada columna.
- **Columna calculada:** el subtotal se obtiene multiplicando `Cantidad × Precio_unitario_Historico` en cada fila, y se le da nombre con `AS Subtotal`.
- **Subconsulta con función de agregado:** el total se calcula con un `SELECT` dentro del `SELECT` principal, que suma (`SUM`) los subtotales de todos los productos del ticket. Es una subconsulta mono-registro: devuelve un único valor, que se muestra en cada fila.
- **Filtro (`WHERE`):** limita el resultado a los registros del ticket buscado.

Se usa `Precio_unitario_Historico` y no el precio actual de `PRODUCTO`, para que el comprobante muestre el precio cobrado en el momento de la venta aunque después el precio haya cambiado.

## Resultado (ticket 10)

| Cod_Ticket | Fecha | Metodo_de_pago | Obra_social | Nombre | Cantidad | Precio_unitario_Historico | Subtotal | Total |
|---|---|---|---|---|---|---|---|---|
| 10 | 2026-10-16 | Débito | Medifé | Tafirol | 1 | 550.00 | 550.00 | 4550.00 |
| 10 | 2026-10-16 | Débito | Medifé | Nivea | 1 | 4000.00 | 4000.00 | 4550.00 |

Cada fila representa un renglón de la factura. Los datos del encabezado y el total se repiten en todas las filas porque pertenecen a la misma venta.
