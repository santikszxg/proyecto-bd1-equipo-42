/*              Caso de uso 3: Consulta de Negocio Avanzada
    Sucursales que tienen más de 30 unidades en stock, con su localidad y dirección. 
    Combina 3 tablas (SUCURSAL, UBICACION y POSEE) y filtra con HAVING.
*/
SELECT 
    S.ID_Sucursal, U.Localidad, U.direccion,
       SUM(PO.Cantidad_Productos) AS Unidades_en_stock
FROM SUCURSAL AS S
INNER JOIN UBICACION AS U ON S.Cod_Localizacion = U.Cod_Localizacion
INNER JOIN POSEE AS PO ON S.ID_Stock = PO.ID_Stock
GROUP BY S.ID_Sucursal, U.Localidad, U.direccion
HAVING SUM(PO.Cantidad_Productos) > 30
ORDER BY Unidades_en_stock DESC;
