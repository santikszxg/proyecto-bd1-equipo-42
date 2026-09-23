Entidades:  
- Sucursal: Representa las ubicaciones físicas del negocio. Sus atributos son Dirección, Num. Teléfono(único), Localidad, Cantidad de empleados y Horario de atención (multivaluado)  
- Direct. Técnica: Es una entidad débil vinculada a la sucursal. Sus atributos son ID. Dirección Técnica (único), Fecha de inicio y Fecha de finalización.  
- Stock: Entidad utilizada para el manejo del inventario de la sucursal. Sus atributos son ID. Stock (único) y Cantidad de productos.  
- tipo de empleado: Es una entidad supertipo que agrupa al personal. Sus atributos son DNI (único), Nombre, Apellido y Hora de inicio. Esta entidad se especializa en tres subtipos:  
- Farmacéutico: Tiene el atributo específico Matricula profesional.  
- Cajero: No posee atributos propios, pero se vincula a las ventas mediante la relación "Atiende".  
- Seguridad: No posee atributos propios. 
- producto: Es una entidad débil, representa los artículos disponibles en el sistema. Sus atributos son ID. Producto (único), Nombre, Precio, Descripción y Tipo de producto.  
- Proveedor: Entidad que suministra la mercadería. Sus atributos son ID. Proveedor (único), Razón social, Dirección, Localidad y Numero de teléfono.  
- Compra: Representa la transacción una venta. Sus atributos son ID. Compra (único), Fecha, Monto y Método de pago.  
- Detalle de compra: Es una entidad débil vinculada a la entidad "Compra" que sirve para desglosar los detalles específicos llevados en esa transacción. Sus atributos son Cod. Detalle (único), Cantidad del producto e Historial de precios unitarios.   
- Cliente: Entidad que registra a los clientes. Sus atributos son ID. Cliente (único), Obra social (Opcional) y Receta (Opcional).

# Relaciones y cardinalidades

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
