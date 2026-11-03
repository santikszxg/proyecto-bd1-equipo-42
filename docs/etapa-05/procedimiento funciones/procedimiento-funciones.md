# Procedimientos y Funciones Almacenadas

En el proyecto integrador de la farmacia se implementaron una función escalar y un procedimiento almacenado en SQL Server, con el objetivo de centralizar la lógica de negocio relacionada con el cálculo de descuentos, el registro de ventas y la actualización del stock.

## 1. Función escalar: `dbo.fn_CalcularDescuentoCliente`

### Objetivo

Esta función permite calcular el porcentaje de descuento que le corresponde a un cliente en función del monto acumulado de sus compras. De esta manera, se busca premiar a los clientes frecuentes mediante descuentos automáticos.

### Funcionamiento

La función recibe como parámetro el identificador del cliente (`@ID_Cliente`) y consulta la tabla `COMPRA` para obtener la suma de los montos de todas sus compras registradas.

A partir del monto acumulado, aplica las siguientes reglas de negocio:

- Si el monto acumulado supera los $500.000, corresponde un descuento del 10%.
- Si el monto acumulado supera los $200.000, corresponde un descuento del 5%.
- Si no se cumple ninguna de las condiciones anteriores, no se aplica ningún descuento.

La función devuelve el porcentaje de descuento calculado como un valor decimal. Además, utiliza `ISNULL` para considerar que un cliente sin compras registradas tiene un monto acumulado de $0.

### Uso

Se realiza una consulta sobre la tabla `CLIENTE` para mostrar el identificador del cliente, su obra social y el porcentaje de descuento que le corresponde. Para ello, se invoca la función mediante `dbo.fn_CalcularDescuentoCliente(ID_Cliente)`.

Esta implementación permite reutilizar el cálculo del descuento sin tener que repetir las mismas condiciones en distintas consultas o procedimientos.

## 2. Procedimiento almacenado: `dbo.sp_RegistrarVentaCompleta`

### Objetivo

Este procedimiento permite registrar una venta completa mediante una única ejecución, centralizando las operaciones necesarias para registrar la compra, generar su ticket, guardar el precio histórico del producto y actualizar el stock disponible.

De esta manera, se evita que el usuario tenga que ejecutar manualmente múltiples consultas para completar una venta.

### Parámetros de entrada

El procedimiento recibe los siguientes parámetros:

- `@ID_Cliente`: identifica al cliente que realiza la compra.
- `@ID_Producto`: identifica al producto vendido.
- `@ID_Stock`: identifica el registro de stock correspondiente a la sucursal.
- `@Cantidad`: indica la cantidad de unidades que se desean vender.
- `@Metodo_de_pago`: especifica el método de pago utilizado.

### Funcionamiento

El procedimiento realiza las siguientes operaciones en orden:

1. **Obtener el precio actual:** consulta la tabla `PRODUCTO` para recuperar el precio del producto seleccionado. Si el producto no existe, se genera un error.

2. **Validar el stock disponible:** consulta la tabla `POSEE` para comprobar que exista stock suficiente del producto en el registro correspondiente. Se utiliza `UPDLOCK` para ayudar a evitar conflictos cuando varias operaciones intentan modificar el mismo stock simultáneamente.

3. **Calcular el descuento y el importe final:** invoca la función `dbo.fn_CalcularDescuentoCliente` para obtener el descuento correspondiente al cliente. Luego calcula el subtotal multiplicando el precio unitario por la cantidad y aplica el porcentaje de descuento para determinar el monto final de la compra.

4. **Registrar la compra:** inserta un registro en la tabla `COMPRA`, almacenando el monto final, el método de pago y el identificador del cliente.

5. **Generar el ticket:** inserta un registro en la tabla `ticket`, asociado a la compra recién creada, y guarda la fecha de emisión del comprobante.

6. **Guardar el precio histórico:** registra en la tabla `Detalle_historico` el producto vendido, el ticket correspondiente y el precio unitario vigente al momento de la venta. Esto permite conservar el precio histórico aunque el precio del producto se modifique posteriormente.

7. **Actualizar el stock:** descuenta de la tabla `POSEE` la cantidad de unidades vendidas, dejando actualizado el stock disponible.

8. **Confirmar la operación:** si todas las operaciones finalizan correctamente, se confirma la transacción mediante `COMMIT TRANSACTION` y se informa que la venta fue registrada con éxito.

### Manejo de errores y transacciones

El procedimiento utiliza una estructura `TRY...CATCH` y una transacción para mantener la consistencia de los datos.

Si ocurre un error durante el registro de la venta, se ejecuta `ROLLBACK TRANSACTION` para revertir las operaciones realizadas dentro de la transacción. Posteriormente, se devuelve el mensaje del error.

De esta manera, se busca evitar que una venta quede registrada parcialmente, por ejemplo, con una compra creada pero sin su correspondiente ticket o sin la actualización del stock.

### Ejemplo de ejecución

Para probar el procedimiento, se puede ejecutar la siguiente instrucción, utilizando identificadores existentes en la base de datos:

```sql
EXEC dbo.sp_RegistrarVentaCompleta
    @ID_Cliente = 1,
    @ID_Producto = 1,
    @ID_Stock = 1,
    @Cantidad = 2,
    @Metodo_de_pago = 'Efectivo';
```

En este ejemplo se intenta registrar una venta de dos unidades de un producto para el cliente identificado con el ID 1, utilizando el stock identificado con el ID 1 y pagando en efectivo.

## 3. Beneficios de la implementación

La incorporación de esta función y este procedimiento almacenado aporta los siguientes beneficios al sistema de gestión de la farmacia:

- **Reutilización de la lógica de negocio:** el cálculo de descuentos se implementa una sola vez y puede utilizarse desde distintas consultas o procedimientos.
- **Centralización de las reglas de negocio:** los criterios para otorgar descuentos y registrar ventas quedan definidos dentro de la base de datos.
- **Automatización de las operaciones:** una sola ejecución permite registrar la compra, generar el ticket, guardar el precio histórico y actualizar el stock.
- **Integridad y consistencia de los datos:** el uso de transacciones permite confirmar todas las operaciones o revertirlas ante un error.
- **Conservación de la información histórica:** se guarda el precio unitario vigente al momento de la venta, independientemente de posibles modificaciones futuras del precio del producto.
- **Control del stock:** se verifica la disponibilidad de los productos antes de realizar la venta y se descuenta la cantidad vendida al finalizar las operaciones.

