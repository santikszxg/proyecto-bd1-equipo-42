# Triggers De Auditoria

## 1. Creacion de la tabla `Producto_Auditoria`

Para tener un registro sobre las inserciones, eliminaciones y actualizaciones necesitamos primero un lugar donde podamos guardar esos registros
1. campo `auditoria_ID` auto incremental con identity y `PK` de nuestra tabla
2. `producto_ID` es el id de nuestro producto afectado.

Ahora lo más escencial y lo que caracteriza a los triggers

3. campo `accionRealizada` la cual registra si fue un `INSERT`, `DELETE` o un `UPDATE`, siendo un varchar de 15 caracteres
4. `precioAnterior` registra el precio despues de una actualizacion o eliminacion
5. `precioNuevo` registra el nuevo precio despues de una insercion o actualizacion
6. `usuario` registra el usuario el cual está operando en ese instante, se utiliza la funcion `SUSER_NAME` la cual se encarga de obtener el nombre del usuario el cual este operando o conectado en la base de datos
7. `fecha` registra el tiempo en el que ocurre las operaciones, por default devuelve la actual

## 2. Creacion de los TRIGGERS

Se sigue la siguiente secuencia de pasos para la creacion correcta de los triggers
1. creamos el triger con la palabra reservada `CREATE` y a continuacion `TRIGGER`
2. Luego colocamos sobre que tabla va a interactuar mediante el uso del `ON`, en nuestro caso productos.
3. con la palabra reservada `AFTER`, le indicamos despues de que operaciones queremos que el trigger se ejecute, para nuestro caso usamos `INSERT`, `DELETE` y `UPDATE`
4. luego armamos el cuerpo del TRIGGER y controlamos la insercion de los datos a la tabla `Productos_auditoria` mediante una secuencia de ifs
5. en cada caso (update, insert, delete), utilizamos una condicion distinta, en el caso del `UPDATE` preguntamos si existe al menos 1 elemento del procedimiento `inserted` y de `deleted`, si ambos coinciden entonces es un `UPDATE`.
para el `INSERT` preguntamos si unicamente existe el `inserted` y no existe `deleted`, caso contrario a esto pertenece a la operacion `DELETE`.

## Script y pruebas

### Script de una prueba para cada caso
<img width="882" height="359" alt="image" src="https://github.com/user-attachments/assets/1f52aee0-fb1d-4e13-9dec-e2db67e52118" />

## Resultados

<img width="682" height="432" alt="image" src="https://github.com/user-attachments/assets/efe25f92-e7e9-48ec-b41e-3156f672bd24" />


## Conclusion:
Gracias a los triggers podemos tener un registro histórico más visible sobre los manejos de los datos de los productos los cuales estamos controlando, no a un nivel STOCK o tipos de productos registrados, si no a un nivel donde se pueda simplemente visualizar la interacción que un usuario de la base de datos aplica sobre ciertos productos.
