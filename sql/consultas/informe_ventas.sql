/*              Caso de uso 2:  Reporte Agregado
    Total vendido y cantidad de ventas por categoría de producto en un rango de fechas. 
    Se agrupa por categoría porque en el modelo cada cajero tiene una sola compra asignada.
*/
SELECT 
    P.Tipo_de_producto AS Categoria,
        COUNT(*) AS Cantidad_de_ventas,
        SUM(DH.Cantidad * DH.Precio_unitario_Historico) AS Total_vendido
FROM DETALLE_HISTORICO AS DH
INNER JOIN PRODUCTO AS P ON DH.ID_Producto = P.ID_Producto
INNER JOIN TICKET   AS T ON DH.Cod_Ticket = T.Cod_Ticket
WHERE T.Fecha BETWEEN '2026-09-01' AND '2026-10-31'
GROUP BY P.Tipo_de_producto
ORDER BY Total_vendido DESC;
