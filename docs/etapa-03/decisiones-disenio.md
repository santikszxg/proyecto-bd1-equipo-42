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



# Estructura de la Base de Datos: Proyecto Farmacia

## Tablas Independientes

Estas tablas no contienen claves foráneas.

* **`TIPO_DE_EMPLEADO`**: Tabla para el personal de la farmacia. 
  * Registra datos identificatorios (Nombre, Apellido).
  * Garantiza que no haya empleados duplicados aplicando una restricción única (`UNIQUE`) sobre el `DNI`.
  * Define la jornada laboral mediante `Hora_inicio` y `Hora_fin`.
* **`CLIENTE`**: Almacena a los compradores del establecimiento.
  * Los campos `Obra_social` y `Receta` aceptan valores nulos (`NULL`), contemplando que hay medicamentos de venta libre que no requieren receta médica y que el cliente puede no tener obra social.
* **`PRODUCTO`**: Constituye el catálogo de la farmacia. Define cada artículo por su nombre, tipo, descripción detallada y precio de venta.
* **`STOCK`**: Tabla diseñada para el control de inventario.
* **`HORARIO_ATENCION`**: Tabla que representa los turnos del personal de la sucursal.
* **`DIRECT_TECNICO`**: Registra los directores de la farmacia, detallando los periodos de gestión a través de fechas de inicio y finalización.
* **`UBICACION`**: Tabla que almacena las ubicaciones.

## Tablas Dependientes 

Estas tablas dependen de la existencia previa de registros en las tablas independientes para poder almacenar información.

* **`COMPRA`**: Registra las transacciones comerciales.
  * Almacena el `Monto` final y el `Metodo_de_pago`.
  * Establece una relación directa con el comprador mediante la clave foránea `ID_Cliente`, la cual hace referencia a la tabla `CLIENTE`.
