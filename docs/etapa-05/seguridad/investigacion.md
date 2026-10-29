# Seguridad: permisos a nivel de usuarios y roles

## 1. Definición y objetivo

La seguridad en una base de datos permite controlar quién puede acceder a la información y qué puede hacer con ella. En SQL Server los permisos se pueden dar a cada usuario por separado o se pueden agrupar en roles.

Para ello se trabaja en dos niveles:

- Inicio de sesión (login): permite conectarse al servidor.
- Usuario: se crea dentro de la base de datos a partir de un login, y es al que se le asignan los permisos.

El objetivo es que cada usuario tenga solamente los permisos que necesita para hacer su trabajo (principio de mínimo privilegio).

## 2. Ventajas y aplicaciones

- Protege la información de la base de datos.
- Evita modificaciones accidentales o no autorizadas.
- Permite asignar permisos según el puesto de cada empleado.
- Los roles simplifican la administración, ya que los permisos se asignan una sola vez al rol y todos sus miembros los heredan.

En el caso de la farmacia, por ejemplo, un cajero no debería poder modificar los precios de los productos, ni el personal de seguridad consultar las ventas realizadas.

## 3. Implementación en SQL Server Express

Los pasos realizados fueron los siguientes:

1. Crear el inicio de sesión con `CREATE LOGIN`.
2. Crear el usuario en la base con `CREATE USER ... FOR LOGIN`.
3. Asignar permisos con `GRANT`, o crear un rol con `CREATE ROLE`, darle permisos al rol y agregar usuarios con `ALTER ROLE ... ADD MEMBER`.

Para probar los permisos se utilizó `EXECUTE AS USER`, que permite ejecutar las consultas en nombre de otro usuario, y `REVERT`, que vuelve al usuario original. De esta forma no fue necesario iniciar sesión con cada login por separado.

## 4. Caso aplicado a la farmacia

El ejemplo de la guía se adaptó al modelo de la farmacia con los siguientes usuarios:

| Usuario | Puesto | Permisos |
|---|---|---|
| usuario_admin | Administrador | Pertenece al rol db_owner |
| usuario_cajero | Cajero | SELECT sobre COMPRA y EXECUTE sobre sp_RegistrarVentaCompleta |
| usuario_farmaceutico | Farmacéutico | Pertenece a rol_farmaceutico (SELECT sobre PRODUCTO) |
| usuario_seguridad | Seguridad | Ninguno |

### Permisos a nivel de usuarios

Al cajero se le otorgó permiso para consultar la tabla COMPRA, pero no para insertar registros en ella. Sin embargo, puede registrar ventas mediante el procedimiento sp_RegistrarVentaCompleta, desarrollado en el tema de procedimientos y funciones almacenadas.

De esta manera, el cajero no puede registrar una compra directamente en la tabla, sino que debe hacerlo a través del procedimiento, el cual valida el stock, aplica el descuento correspondiente y genera el ticket.

### Permisos a nivel de roles

Se creó el rol rol_farmaceutico con permiso de lectura sobre la tabla PRODUCTO y se incorporó al usuario del farmacéutico como miembro. El usuario de seguridad no pertenece al rol, por lo que no puede consultar los productos.

## 5. Script y pruebas

El script se encuentra en [scripts.sql](scripts.sql). Las pruebas se realizaron en SQL Server Express.

| Prueba | Usuario | Resultado esperado | Resultado obtenido |
|---|---|---|---|
| INSERT en COMPRA | usuario_admin | Correcto | Correcto |
| INSERT en COMPRA | usuario_cajero | Error | Error de permiso |
| EXEC sp_RegistrarVentaCompleta | usuario_cajero | Correcto | Correcto |
| SELECT en PRODUCTO | usuario_farmaceutico | Correcto | Correcto |
| SELECT en PRODUCTO | usuario_seguridad | Error | Error de permiso |

### Prueba 1: el administrador inserta en COMPRA

Al pertenecer al rol db_owner, la inserción se realiza correctamente.

![Captura: INSERT exitoso con usuario_admin](evidencias/captura_01_admin_insert.png)

### Prueba 2: el cajero inserta en COMPRA

El cajero solo tiene permiso de consulta sobre COMPRA, por lo que SQL Server rechaza la inserción y muestra el error "Se denegó el permiso INSERT en el objeto 'COMPRA'".

![Captura: error de permiso INSERT con usuario_cajero](evidencias/captura_02_cajero_insert_denegado.png)

### Prueba 3: el cajero registra una venta con el procedimiento

El mismo cajero que no pudo insertar en COMPRA sí puede registrar una venta mediante el procedimiento. Se registró la venta de 5 unidades del producto 1 y el stock disminuyó de 50 a 45 unidades.

![Captura: stock antes y después de la venta](evidencias/captura_03_cajero_procedimiento.png)

### Prueba 4: el farmacéutico consulta los productos

El usuario no tiene permisos asignados directamente, pero los hereda del rol, por lo que puede consultar los productos.

![Captura: consulta de productos con usuario_farmaceutico](evidencias/captura_04_farmaceutico_select.png)

### Prueba 5: el usuario de seguridad consulta los productos

Al no pertenecer al rol, SQL Server muestra el error "Se denegó el permiso SELECT en el objeto 'PRODUCTO'".

![Captura: error de permiso SELECT con usuario_seguridad](evidencias/captura_05_seguridad_select_denegado.png)

## Conclusión

Las pruebas realizadas permitieron comprobar que los permisos funcionan según lo esperado. El cajero no puede modificar la tabla COMPRA directamente, pero sí puede registrar ventas mediante el procedimiento almacenado, lo que garantiza que cada venta pase por las validaciones del sistema. Por otro lado, el uso de roles permitió asignar los permisos al farmacéutico de una sola vez, mientras que el usuario que no pertenece al rol no tiene acceso a la información.

