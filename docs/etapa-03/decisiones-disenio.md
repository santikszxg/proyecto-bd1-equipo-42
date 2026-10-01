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
* **`SUCURSAL`**: Representa las sedes físicas de la farmacia y centraliza la operatividad del negocio.
  * Almacena datos propios como la `Cantidad_de_empleados` y el `Num_Telefono`.
  * Se vincula con el inventario a través de la clave foránea `ID_Stock` referenciando a `STOCK`.
  * Asocia los esquemas de trabajo mediante `Cod_Horario` referenciando a `HORARIO_ATENCION`.
  * Identifica al personal asignado y a la dirección técnica mediante `ID_Empleado` hacia `TIPO_DE_EMPLEADO` e `ID_Direct_Tecnico` hacia `DIRECT_TECNICO`.
  * Establece la ubicación geográfica de la sede mediante `Cod_Localizacion` referenciando a `UBICACION`.
* **`FARMACEUTICO`**: Subtipo o rol especializado derivado de la entidad general de empleados.
  * Hereda la clave primaria a través de `ID_Empleado`, actuando conjuntamente como clave foránea vinculada a `TIPO_DE_EMPLEADO`.
  * Garantiza la autenticidad e irrepetibilidad del profesional aplicando una restricción única (`UNIQUE`) sobre `Matricula_profesional`.
  * Admite valores nulos (`NULL`) en la clave foránea `ID_Direct_Tecnico` referenciando a `DIRECT_TECNICO`, contemplando que no todo farmacéutico ejerce el rol de director técnico.
* **`CAJERO`**: Subtipo de empleado asignado a las operaciones de caja y facturación.
  * Comparte la identidad del trabajador vinculando `ID_Empleado` como clave primaria y foránea hacia `TIPO_DE_EMPLEADO`.
  * Mantiene una relación con las transacciones comerciales mediante la clave foránea `ID_Compra` referenciando a `COMPRA`.
* **`SEGURIDAD`**: Subtipo de empleado destinado a las tareas de vigilancia y custodia del establecimiento.
  * Modela la especialización del personal tomando `ID_Empleado` simultáneamente como clave primaria y foránea referenciando a `TIPO_DE_EMPLEADO`.
* **`DETALLE_DE_COMPRA`**: Tabla asociativa e histórica que desglosa los artículos adquiridos en cada transacción.
  * Resuelve la relación de muchos a muchos conectando transacciones y catálogo mediante las claves foráneas `ID_Compra` hacia `COMPRA` e `ID_Producto` hacia `PRODUCTO`.
  * Preserva el valor de venta al momento de emitir la operación mediante `Historial_de_precio_uni`.
  * Define una regla por defecto (`DEFAULT 1`) para el campo `Cantidad_del_producto`.
  * Registra la fecha de la transacción asociada al movimiento.
* **`PROVEEDOR`**: Registra las entidades comerciales encargadas del abastecimiento de la farmacia.
  * Contiene datos de identificación y contacto como `Razon_social` y `Numero_de_telefono`.
  * Determina la radicación del proveedor mediante la clave foránea `Cod_Localizacion`, la cual hace referencia a la tabla `UBICACION`.
* **`POSEE`**: Tabla intermedia que representa la relación de N : M.
  * Registra la cantidad de productos de un tipo que posee un stock mediante `Cantidad_Stock`.
  * Tabla intermedia que conectan a las tablas `STOCK` y `PRODUCTO` tomando como clave primaria y foranea los campos de `ID_Stock` e `ID_Producto`.
*  **`CONTIENE`**: Tabla la cual hacia una mala representación en un inicio con el anterior modelo relacional.
  *  Resuelve una relación de muchos a muchos, conectando las tablas de `PRODUCTO` y `COMPRA` mediante el uso de las claves foráneas referenciadas mediante el `ID_Producto` y `ID_Compra`.
* **`SUMINISTRA`**: Tabla intermedia que representa la relacion N : M.
  * Resuelve la relacion de muchos a muchos mediante la conexion en la clave foranea y primaria referenciada por el campo `ID_Proveedor` e `ID_Producto`.
  * Tabla intermedia que conecta a las tablas `PROVEEDOR` y `PRODUCTO`.

# Cambios Realizados

## Eliminacion De Tablas

Se realizaron la eliminacion de 2 tablas

* Se realizo la eliminación completa de la tabla `CONTIENE` ya que no hacia una correcta representacion al modelo. Al no tener datos previamente cargados, simplemente realizamos la operacion `DROP`.
* Se realizo la eliminación completa de la tabla `DETALLE_DE_COMPRA` ya que no hacia una correcta representacion al modelo. Al no tener datos previamente cargados, simplemente realizamos la operacion `DROP` nuevamente.

## Creacion De Tablas

Se realización al creación de 2 tablas nuevas.

* **`TICKET`**: Representa el ticket el cual es generado mediante la colaboración de una compra especifica que se registra. Tabla independiente.
  * Registra la fecha en la cual se realizó la compra mediante le campo `Fecha`.
  * Representa una relación mediante una clave foránea con la tabla `COMPRA` mediante el campo `ID_Compra`.
  * Tiene como clave primaria un auto incremental representada en la columna `Cod_Ticket`.
* **`DETALLE_HISTORICO`**: Representa el detalle historico sobre el precio unitario de un producto. Tabla independiente.
  * Contine la representación del precio unitario de un producto del tipo de dato `DECIMAL` la cual representa hasta cinco espacios para la parte entera y dos para la parte decimal.
  * Claves primarias y foraneas representada por las columnas `ID_Producto` y `Cod_Ticket`.
 
 ## Otros Cambios Realizados

 * Cambiar la cantidad del `varchar` de la tabla ubicacion:
  * `Localidad`: representacion a 40 caracteres.
  * `Dirección`: representación a 40 caracteres.
* cambios con `check` y `default` sobre la tabla `POSEE`:
  * Se añadió la restriccion `DEFAULT`, el cual permite que se registre siempre al menos una unidad de productos
  * Se añadio la restriccion `CHECK` la cual comprueba que la cantidad de productos registrados no sean menor a 0.
* Detalle historico agrandar la parte entera del decimal:
  * Se agrando la cantidad de decimales enteros 5 --> 10.
* carga de campos nuevos en tablas `SEGURIDAD` y `STOCK`:
  *  Agregacion atributo `lote` a la tabla `STOCK` y su restricción `DEFAULT` para siempre tener una fecha.
* Agregacion atributo opcional: 
  * `credencial` a la tabla `SEGURIDAD`.
* Modificaciones en los tipos de datos de la tabla tipo de `EMPLEADO`:
  * Modificacion de la columna `Hora_fin` y  `Hora_inicio` a `TIME(0)`
* Modificaciones en los tipos de datos de la tabla horario de `ATENCION`:
  * Modificacion de la columna `Horario` a `TIME(0)`
* Modificaciones en los tipos de datos de la tabla director `TECNICO`:
  * Modificaciones en los campos `Fecha_de_inicio` y `Fecha_de_finalizacion` a `DATE`. 
   
  
