# Diagrama de entidad-relación
## Entidades:  
- Sucursal: Representa las ubicaciones físicas del negocio. Sus atributos son Dirección, Num. Teléfono(único), Localidad, Cantidad de empleados y Horario de atención (multivaluado)  
- Direct. Técnica: Es una entidad débil vinculada a la sucursal. Sus atributos son ID. Dirección Técnica (único), Fecha de inicio y Fecha de finalización.  
- Stock: Entidad utilizada para el manejo del inventario de la sucursal. Sus atributos son ID. Stock (único) y Cantidad de productos.
- Pertenece: tabla intermedia creada. Contiene dos claves foráneas: id_stock e id_producto.
- tipo de empleado: Es una entidad supertipo que agrupa al personal. Sus atributos son DNI (único), Nombre, Apellido y Hora de inicio. Esta entidad se especializa en tres subtipos:  
- Farmacéutico: Tiene el atributo específico Matricula profesional.  
- Cajero: No posee atributos propios, pero se vincula a las ventas mediante la relación "Atiende".  
- Seguridad: No posee atributos propios. 
- producto: Es una entidad débil, representa los artículos disponibles en el sistema. Sus atributos son ID. Producto (único), Nombre, Precio, Descripción y Tipo de producto.  
- Proveedor: Entidad que suministra la mercadería. Sus atributos son ID. Proveedor (único), Razón social, Dirección, Localidad y Numero de teléfono.  
- Compra: Representa la transacción una venta. Sus atributos son ID. Compra (único), Fecha, Monto y Método de pago.  
- Detalle de compra: Es una entidad débil vinculada a la entidad "Compra" que sirve para desglosar los detalles específicos llevados en esa transacción. Sus atributos son Cod. Detalle (único), Cantidad del producto e Historial de precios unitarios.   
- Cliente: Entidad que registra a los clientes. Sus atributos son ID. Cliente (único), Obra social (Opcional) y Receta (Opcional).

## Relaciones y cardinalidades

Acá van las relaciones que armamos en el DER, qué entidades conectan y su cardinalidad. Usamos notación pata de gallo.

También separamos a los empleados en Farmacéutico, Cajero y Seguridad, y cada empleado tiene un solo rol.

**Posee** (Sucursal – Stock) → 1:1
- Cada sucursal tiene un stock.

**Pertenecen** (Sucursal – Empleado) → 1:N
- Una sucursal tiene varios empleados, y cada empleado trabaja en una sola sucursal.

**Cuenta** (Sucursal – Direct. Técnica) → 1:1
- Cada sucursal tiene una Dirección Técnica.

**Ejerce** (Farmacéutico – Direct. Técnica) → 1:0..1
- Un farmacéutico puede estar a cargo de una Dirección Técnica, o de ninguna.

**Pertenece** (Stock – Producto) → N:M
- Un stock tiene varios productos, y un producto puede estar en el stock de varias sucursales.

**Suministra** (Proveedor – Producto) → N:M
- Un proveedor trae varios productos, y un producto puede venir de varios proveedores.

**Contiene** (Producto – Compra) → N:M
- Una compra tiene varios productos, y un producto puede estar en muchas compras.

**Atiende** (Cajero – Compra) → 1:N
- Un cajero atiende varias compras, y cada compra la atiende un cajero.

**Realiza una compra** (Cliente – Compra) → 1:N
- Un cliente puede hacer varias compras, y cada compra es de un cliente.

**Genero** (Compra – Detalle de compra) → 1:N
- Cada compra tiene uno o varios detalles.

**Posee** (Producto – Detalle de compra) → 1:1
- Cada detalle corresponde a un producto.

---

# Modelo relacional
## 1. Resolución de Jerarquías (Superclase / Subclase)

#### Para modelar a los empleados, se optó por la estrategia de mantener la tabla de la superclase y crear tablas para las subclases, vinculándolas mediante claves foráneas.

+ Tipo_de_empleado (Superclase): Se definió id_empleado como Clave Primaria (PK). Se conservaron los atributos del DER y se tomó la decisión de agregar el atributo `hora_fin`.

+ Subclases (Farmaceutico, Seguridad, Cajero): Se crearon como tablas independientes, donde cada una incorpora `id_empleado` como Clave Foránea (FK) y primaria, heredando así los atributos de la superclase.

+ En Farmaceutico, se agregó además la FK `id_direccion_tecnica` para reflejar la relación "ejerce".

+ En Cajero, se agregó la FK `id_compra` para resolver la relación "atiende".

## 2. Resolución de Relaciones Muchos a Muchos (N:M)

#### Se aplicó la regla de creación de tablas intermedias para absorber las cardinalidades de N:M, migrando las claves primarias de las entidades involucradas como claves foráneas:

+ **Contiene**: Creada para resolver la relación N:M entre *COMPRA* y *PRODUCTO*.

+ **Suministra**: Creada para resolver la relación N:M entre *PROVEEDOR* y *PRODUCTO*, conteniendo `id_proveedor` e `id_producto` como FKs.

+ **Pertenece**: Se decidió crear esta tabla para gestionar la relación N:M entre *STOCK* y *PRODUCTO* (conteniendo `id_stock` e `id_producto`), descartando la opción de una FK directa.

## 3. Transformación de Entidades Asociativas y Tablas de Detalle

+ **Director_tecnico**: Pasó de ser una entidad asociativa en el DER a consolidarse como una tabla independiente en el modelo relacional, conservando intactos sus atributos originales.

+ **Detalle_de_compra**: Se consolidó como tabla para preservar el histórico de los detalles de las compras, sin requerir modificaciones respecto a su versión en el DER.

## 4. Creación de claves foráneas

+ **Sucursal**: Se le asignó una PK artificial (`id_sucursal`). Las relaciones que poseía en el DER se transformaron en las FKs: `id_stock`, id_empleado e `id_direccion_tecnica`.

+ **Compra**: Mantuvo sus atributos originales y recibió la FK `id_cliente` para materializar la relación con el cliente que la realiza.

## 5. Consolidación de Entidades Base

+ **Cliente**: Se definió `id_cliente` como PK. Se tomó la decisión de mantener `obra_social` y receta como atributos opcionales (admiten valores nulos) dentro de la misma tabla.

+ **Producto** y **Proveedor**: No sufrieron alteraciones respecto al DER, manteniendo todos sus atributos originales de forma directa.

---

## **Modificaciones del diseño**

+ Se modifico la ubicación del atributo `Cantidad_de_productos` el cual estaba ubicada en la tabla *"Stock"* y se la Re-implemento moviéndola a la tabla intermedia *"Pertenece"*. Esto con el propósito de poder tener una exactitud de la cantidad de productos de un tipo que posee un Stock y no saber la cantidad de productos en general que tiene un Stock.

+ Por otra parte, tras una análisis se pudo observar que la tabla *"Sucursal"* y *"Proveedor"* tenían características en comun (localidad y dirección), las cuales ademas no dependian directamente de sus claves primarias, por ende para resolver una cuestion de diseño y empezar a resolver problemas de la normalizacion se diseño una nueva tabla *"Ubicacion"* la cual poseía un `cod_localizacion` como clave primaria (PK) y dos campos como datos (localidad y direccion). De esta forma mantenemos a las tablas de formas mas puras.

+ **Horario_Atencion**: Se agrego esta tabla, ya que al ser un valor multivaluado representado en el diagrama DER, se necesitaba registrar distintos tipos de horarios según la sucursal, por efecto de esto, en la tabla *"Horario_atencion"* se agregaron los datos `Cod_horario` siendo una clave Primaria (PK), y el horario el cual atiende esa sucursal.

+ Se asigno la clave Primaria a la tabla *"Farmacéutico"* la cual no tenía hasta el momento. Se estableció a `matricula_profesional` como representante de esa clave primaria (PK).
