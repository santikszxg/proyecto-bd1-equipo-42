# Explicación Detallada de la Consulta SQL (Caso de Uso 2)

## Contexto y Objetivo

Esta consulta genera un **reporte agregado de ventas**, con el objetivo de calcular el **total vendido (en monto acumulado)** y la **cantidad total de registros/ventas** por **categoría de producto** dentro de un período de tiempo específico (septiembre y octubre de 2026).

```
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

```

## Desglose 

### 1. `FROM` y `INNER JOIN` (Origen de Datos y Relaciones)

En esta fase se especifica de dónde proceden los datos y cómo se vinculan las 3 tablas involucradas (`DETALLE_HISTORICO`, `PRODUCTO` y `TICKET`):

* **`FROM DETALLE_HISTORICO AS DH`**:

  * Establece la tabla de detalle transaccional `DETALLE_HISTORICO` (alias `DH`) como punto de partida. Esta tabla contiene los ítems vendidos, las cantidades y los precios registrados al momento de la venta.

* **`INNER JOIN PRODUCTO AS P ON DH.ID_Producto = P.ID_Producto`**:

  * Vincula cada detalle de venta con la información general del producto mediante la clave `ID_Producto`.

  * Sirve para obtener el atributo `Tipo_de_producto` (categoría).

* **`INNER JOIN TICKET AS T ON DH.Cod_Ticket = T.Cod_Ticket`**:

  * Combina cada ítem vendido con la cabecera de la transacción en la tabla `TICKET` (alias `T`) usando el código del ticket (`Cod_Ticket`).

  * Permite acceder a los datos generales de la transacción, como la fecha de emisión.

### 2. `WHERE` (Filtrado de Registros Pre-agrupamiento)

```
WHERE T.Fecha BETWEEN '2026-09-01' AND '2026-10-31'

```

* Filtra todas las ventas evaluando la columna `Fecha` de la tabla `TICKET`.

* Utiliza el operador `BETWEEN` para restringir la consulta a las transacciones realizadas **entre el 1 de septiembre de 2026 y el 31 de octubre de 2026** (ambas fechas inclusive).

* Este filtro se aplica **antes** de realizar cualquier cálculo de agregación o agrupamiento.

### 3. `GROUP BY` (Agrupamiento por Categoría)

```
GROUP BY P.Tipo_de_producto

```

* Clasifica las filas resultantes del filtro anterior en grupos homogéneos según el `Tipo_de_producto` (categoría).

* Todas las líneas de detalle pertenecientes a una misma categoría (por ejemplo, *Lácteos*, *Bebidas*, *Limpieza*) se consolidan en un único grupo sobre el cual se aplican las funciones de agregación.

### 4. `SELECT` (Proyección de Columnas y Operaciones Agregadas)

```
SELECT 
    P.Tipo_de_producto AS Categoria,
    COUNT(*) AS Cantidad_de_ventas,
    SUM(DH.Cantidad * DH.Precio_unitario_Historico) AS Total_vendido

```

Define los datos de salida calculados para cada categoría:

* **`P.Tipo_de_producto AS Categoria`**: Muestra la categoría del producto con el alias `Categoria`.

* **`COUNT(*) AS Cantidad_de_ventas`**:

  * Cuenta el número total de registros/líneas de venta dentro de esa categoría en el rango de fechas seleccionado.

  * Se asigna el alias `Cantidad_de_ventas`.

* **`SUM(DH.Cantidad * DH.Precio_unitario_Historico) AS Total_vendido`**:

  * Multiplica en cada línea la cantidad de unidades vendidas (`DH.Cantidad`) por el precio registrado al momento de la transacción (`DH.Precio_unitario_Historico`).

  * La función `SUM()` acumula el subtotal de todas las líneas para obtener el **monto monetario total recaudado por categoría**.

  * Se asigna el alias `Total_vendido`.

### 5. `ORDER BY` (Ordenamiento del Reporte)

```
ORDER BY Total_vendido DESC;

```

* Ordena los resultados según la columna calculada `Total_vendido`.

* **`DESC` (Descendente)**: Ubica al inicio del reporte la categoría que generó mayores ingresos y al final la de menor facturación.

## Flujo de Ejecución 

1. **`FROM` & `JOIN`**: Se combinan los detalles históricos, la información de productos y las fechas de los tickets.

2. **`WHERE`**: Se conservan únicamente las transacciones dentro del rango `'2026-09-01'` al `'2026-10-31'`.

3. **`GROUP BY`**: Se agrupan los registros filtrados según la categoría (`Tipo_de_producto`).

4. **`SELECT`**: Se calcula el conteo de ítems (`COUNT`) y la suma total vendida (`SUM`), renombrando las columnas con aliases representativos.

5. **`ORDER BY`**: Se ordenan las categorías de mayor a menor según el ingreso acumulado.
