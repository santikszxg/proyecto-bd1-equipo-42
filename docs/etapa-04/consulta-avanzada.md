
## Contexto y Objetivo

Esta consulta es una **consulta de negocio avanzada** cuyo objetivo principal es identificar las **sucursales que disponen de un stock global mayor a 30 unidades de productos**, mostrando además información clave sobre su ubicación geográfica (localidad y dirección).

```
/*           Caso de uso 3: Consulta de Negocio Avanzada
    Sucursales que tienen más de 30 unidades en stock, con su localidad y dirección. 
    Combina 3 tablas (SUCURSAL, UBICACION y POSEE) y filtra con HAVING.
*/
SELECT 
    S.ID_Sucursal, 
    U.Localidad, 
    U.direccion,
    SUM(PO.Cantidad_Productos) AS Unidades_en_stock
FROM SUCURSAL AS S
INNER JOIN UBICACION AS U ON S.Cod_Localizacion = U.Cod_Localizacion
INNER JOIN POSEE AS PO ON S.ID_Stock = PO.ID_Stock
GROUP BY S.ID_Sucursal, U.Localidad, U.direccion
HAVING SUM(PO.Cantidad_Productos) > 30
ORDER BY Unidades_en_stock DESC;

```

## Desglose :

### 1. `FROM` y `INNER JOIN` (Origen de Datos y Relaciones)

Define de dónde se obtienen los datos y cómo se vinculan las entidades involucradas:

* **`FROM SUCURSAL AS S`**: Inicia la consulta desde la tabla principal `SUCURSAL`, asignándole el alias `S`.

* **`INNER JOIN UBICACION AS U ON S.Cod_Localizacion = U.Cod_Localizacion`**:

  * Realiza una combinación interna con la tabla `UBICACION` (alias `U`).

  * Asocia cada sucursal con su respectiva ubicación geográfica mediante la clave foránea/primaria `Cod_Localizacion`.

* **`INNER JOIN POSEE AS PO ON S.ID_Stock = PO.ID_Stock`**:

  * Combina la tabla intermedia o relación `POSEE` (alias `PO`), la cual almacena las cantidades de productos asociadas al inventario/stock.

  * Se enlaza usando el identificador común `ID_Stock`.

### 2. `GROUP BY` (Agrupamiento)

```
GROUP BY S.ID_Sucursal, U.Localidad, U.direccion

```

* Agrupa las filas resultantes por cada combinación única de **ID de sucursal**, **localidad** y **dirección**.

* Es indispensable incluir todas las columnas que no usan funciones de agregación en la cláusula `SELECT`, permitiendo calcular el total de stock individualizado por sucursal.

### 3. `SELECT` (Proyección de Columnas y Agregación)

```
SELECT 
    S.ID_Sucursal, 
    U.Localidad, 
    U.direccion,
    SUM(PO.Cantidad_Productos) AS Unidades_en_stock

```

Define la información final que se mostrará en el reporte:

* **`S.ID_Sucursal`**: Identificador único de la sucursal.

* **`U.Localidad`**: Ciudad o municipio donde está ubicada la sucursal.

* **`U.direccion`**: Dirección física del establecimiento.

* **`SUM(PO.Cantidad_Productos) AS Unidades_en_stock`**:

  * `SUM(...)`: Función de agregación que suma la cantidad total de productos contenidos en los registros asociados al stock de dicha sucursal.

  * `AS Unidades_en_stock`: Asigna un alias representativo a la columna calculada.

### 4. `HAVING` (Filtrado del Grupo Agregado)

```
HAVING SUM(PO.Cantidad_Productos) > 30

```

* A diferencia de `WHERE` (que filtra filas individuales antes de agrupar), `HAVING` aplica filtros **sobre los resultados agrupados o calculados**.

* Evalúa la suma total calculada por `SUM()` y descarta cualquier sucursal cuyo inventario acumulado sea menor o igual a 30 unidades.

### 5. `ORDER BY` (Ordenamiento Final)

```
ORDER BY Unidades_en_stock DESC;

```

* Ordena el resultado de la consulta según el total de stock (`Unidades_en_stock`).

* **`DESC` (Descendente)**: Muestra primero aquellas sucursales con **mayor** volumen de productos en inventario.

##  Resumen:

1. **`FROM` / `JOIN`**: Se juntan las tablas `SUCURSAL`, `UBICACION` y `POSEE`.

2. **`GROUP BY`**: Se organizan las filas asociadas a una misma sucursal y su dirección.

3. **`HAVING`**: Se descartan las sucursales cuya suma de productos sea $\le 30$.

4. **`SELECT`**: Se calculan los datos finales e identificadores que se mostrarán.

5. **`ORDER BY`**: Se ordena el listado final de mayor a menor según las unidades de stock.
