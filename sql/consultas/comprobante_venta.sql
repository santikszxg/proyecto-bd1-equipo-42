-------------------------------------------------------------------------------------------
/*            Caso de uso 1: Factura / Comprobante
    Consulta que consolida el encabezado y el detalle de una venta en un solo resultado. 
    Muestra una fila por cada producto del ticket, con los datos de la venta (ticket, fecha, 
    método de pago y obra social del cliente), el subtotal de cada renglón (cantidad × precio) 
    y el total de la venta, que se calcula con una subconsulta.
*/  

DECLARE @Ticket_buscado INT = 10; -- Para mayor legibilidad creamos una variable temporal

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
