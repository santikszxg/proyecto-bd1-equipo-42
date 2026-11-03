# Manejo de Transacciones

## 1. Implementación de las transacciones

Para controlar las operaciones relacionadas con una venta necesitamos agrupar todas las consultas que modifican nuestra base de datos dentro de una misma transacción.

En nuestro caso, buscamos garantizar que el registro de una compra, la generación de su ticket, el almacenamiento del detalle histórico y el descuento del stock se realicen correctamente.

Para esto utilizamos tres instrucciones principales:

1. `BEGIN TRANSACTION`: inicia el bloque de operaciones que queremos controlar.
2. `COMMIT TRANSACTION`: confirma todos los cambios realizados cuando la operación se completa correctamente.
3. `ROLLBACK TRANSACTION`: cancela todos los cambios realizados si ocurre un problema durante el proceso.

De esta manera evitamos que una venta quede registrada parcialmente y mantenemos la integridad de los datos.

## 2. Manejo de la transacción

Para realizar una venta correctamente seguimos una secuencia de pasos:

1. **Declaración de variables:** primero declaramos las variables necesarias para almacenar el ID del cliente, producto, stock, cantidad a comprar, precio, stock actual e ID de la compra generada.

2. **Obtención de datos:** antes de iniciar la transacción consultamos el precio del producto y la cantidad disponible en stock.

3. **Inicio de la transacción:** utilizamos `BEGIN TRANSACTION` para comenzar a agrupar todas las operaciones relacionadas con la venta.

4. **Registro de la compra:** insertamos un nuevo registro en la tabla `COMPRA`, calculando el monto total mediante la multiplicación del precio unitario por la cantidad solicitada.

5. **Obtención del ID de compra:** utilizamos `SCOPE_IDENTITY()` para recuperar el identificador generado automáticamente en la inserción anterior y almacenarlo en la variable `@id_compra`.

6. **Registro del ticket:** insertamos un nuevo registro en la tabla `TICKET`, relacionándolo con la compra que acabamos de generar.

7. **Registro del detalle histórico:** insertamos el producto vendido en `DETALLE_HISTORICO`, almacenando su identificador, el código del ticket y su precio unitario histórico.

8. **Validación del stock:** comprobamos si el stock actual es suficiente para realizar la venta:
   - Si `@stock_actual IS NULL`, significa que no se encontró un registro de stock para ese producto.
   - Si `@stock_actual < @cantidad`, significa que no hay unidades suficientes para completar la venta.

9. **Control de la transacción:** dependiendo del resultado de la validación:
   - Si no hay stock suficiente, ejecutamos `ROLLBACK TRANSACTION`, cancelando las inserciones realizadas anteriormente.
   - Si hay stock suficiente, descontamos la cantidad vendida de la tabla `POSEE` y ejecutamos `COMMIT TRANSACTION` para confirmar todos los cambios.

## 3. Control de atomicidad

Uno de los principios fundamentales de las transacciones es la **atomicidad**, que establece que una operación debe realizarse completamente o no realizarse.

En nuestro ejemplo podemos encontrar dos escenarios:

### Escenario incorrecto: stock insuficiente

Cuando la cantidad solicitada supera el stock disponible, se ejecuta un `ROLLBACK`.

Esto provoca que:
- Se cancele el registro de la compra.
- Se elimine el registro del ticket generado.
- Se cancele el registro del detalle histórico.
- El stock permanezca sin modificaciones.

De esta manera evitamos que queden registros parciales de una venta que no pudo concretarse.

### Escenario correcto: stock suficiente

Cuando la cantidad solicitada se encuentra dentro del stock disponible, se ejecuta el `UPDATE` sobre la tabla `POSEE` para descontar las unidades vendidas.

Finalmente, mediante `COMMIT TRANSACTION`, confirmamos todas las operaciones realizadas.

De esta manera:
- Se registra la compra.
- Se genera el ticket correspondiente.
- Se almacena el detalle histórico.
- Se actualiza la cantidad disponible del producto.

## 4. Script y pruebas

### Script de una prueba para cada escenario

Para comprobar el funcionamiento de las transacciones modificamos el valor de la variable `@cantidad`.

**Prueba 1: Venta correcta**

<img width="757" height="171" alt="image" src="https://github.com/user-attachments/assets/703ad280-b2be-4196-b706-419b9e8f9a58" />

Establecemos una cantidad que sea menor o igual al stock disponible.


Resultado esperado:
- Se ejecutan correctamente las inserciones.
- Se descuenta la cantidad correspondiente del stock.
- Se ejecuta `COMMIT TRANSACTION`.
- Se muestra el mensaje de éxito.


**Prueba 2: Venta incorrecta**

<img width="903" height="139" alt="image" src="https://github.com/user-attachments/assets/a8ae3472-ce05-4b82-a387-4d8a13cbbf66" />

Establecemos una cantidad superior al stock disponible, por ejemplo, `1000`.


Resultado esperado:
- Se realizan inicialmente las inserciones.
- La validación detecta que no hay stock suficiente.
- Se ejecuta `ROLLBACK TRANSACTION`.
- No queda ningún registro parcial de la venta.
- El stock conserva su cantidad original.

## 5. Verificación de resultados

Al finalizar las pruebas realizamos consultas sobre las tablas `COMPRA`, `DETALLE_HISTORICO` y `POSEE`.

Estas consultas nos permiten comprobar tres aspectos importantes:

1. **Total de compras:** verificamos si se incrementó la cantidad de compras registradas.
2. **Total de detalles:** comprobamos si se generaron los detalles históricos correspondientes.
3. **Stock disponible:** verificamos si la cantidad de productos fue descontada correctamente.

Si la transacción finaliza mediante `COMMIT`, los registros deben permanecer guardados y el stock debe reflejar la venta.

En cambio, si finaliza mediante `ROLLBACK`, los registros generados durante esa transacción deben desaparecer y el stock debe permanecer igual.

## Conclusion

Gracias al manejo de transacciones podemos garantizar que las operaciones relacionadas con una venta se ejecuten de manera conjunta, evitando inconsistencias en nuestra base de datos.
Lo más importante es que, mediante la atomicidad, evitamos que una venta quede registrada parcialmente cuando no se cumplen las condiciones necesarias para concretarla. De esta manera mantenemos la integridad de los datos y aseguramos una mayor confiabilidad en el sistema de ventas.
