## Mejora del modelo: 

### Problemas de la versión anterior
- `CONTIENE` y `DETALLE_DE_COMPRA` guardaban casi lo mismo (qué producto va en qué compra), lo que generaba **información duplicada** y riesgo de inconsistencias.
- El precio de la venta quedaba mezclado con datos de la compra (fecha, cantidad), sin separar la compra del comprobante.

### Cómo lo soluciona la nueva versión
- **`TICKET`**: representa el comprobante de una compra, con su propia fecha (`DEFAULT GETDATE()`).
- **`DETALLE_HISTORICO`**: une producto y ticket (PK compuesta `ID_Producto + Cod_Ticket`) y guarda `Precio_unitario_Historico`, el precio **al momento de la venta**. Si `PRODUCTO.Precio` cambia, los tickets viejos conservan su valor real.
- Una sola tabla intermedia reemplaza a las dos anteriores, eliminando la redundancia.

### Mejora general
El modelo queda más normalizado, sin duplicación y con trazabilidad de precios: `COMPRA → TICKET → DETALLE_HISTORICO → PRODUCTO`.

### Cambio en `STOCK`: incorporación de `Lote`
- En la versión 1, `STOCK` solo tenía su identificador, por lo que no aportaba información propia: funcionaba únicamente como contenedor al que se asociaban productos mediante `POSEE`.
- En la versión 2, al agregar `Lote`, cada registro de stock queda identificado por el lote al que pertenece. Esto permite **trazar el origen y la tanda de los productos**, algo clave en una farmacia.
- Con el lote se puede controlar mejor el

### Cambio en `SEGURIDAD`: incorporación de `Credencial`
- La versión 1 no guardaba ningún dato propio del empleado de seguridad.
- La versión 2 agrega `Credencial` como atributo **opcional**, lo que permite registrar habilitaciones o autorizaciones del personal de seguridad sin obligar a completarlas.
