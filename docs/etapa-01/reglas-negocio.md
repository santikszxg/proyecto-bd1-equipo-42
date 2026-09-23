# Reglas de negocio  
- RN.01 — Farmacia y sucursales  
Una farmacia debe tener una o más sucursales, y cada sucursal debe pertenecer a una única farmacia.  
- RN.02 — Sucursal y dirección  
Cada sucursal debe tener una única dirección, y una dirección corresponde a una única sucursal.  
- RN.03 — Sucursal y horarios de atención  
Una sucursal puede tener uno o más horarios de atención, y cada horario de atención corresponde a una única sucursal.  
- RN.04 — Sucursal y empleados  
Una sucursal debe tener uno o más empleados, y cada empleado debe pertenecer a una única sucursal.  
- RN.05 — Empleados y roles  
Cada empleado debe desempeñar un rol determinado, mientras que un mismo tipo de rol puede corresponder a varios empleados.  
- RN.06 — Dirección Técnica y sucursal  
Cada sucursal debe contar con una única Dirección Técnica vigente, y cada Dirección Técnica corresponde a una única sucursal.  
- RN.07 — Dirección Técnica y farmacéutico  
Cada Dirección Técnica debe ser ejercida por un único farmacéutico, mientras que un farmacéutico puede ejercer la Dirección Técnica de una o más sucursales en distintos períodos, sujeto a las restricciones que establezca la normativa.  
- RN.08 — Sucursal y stock  
Cada sucursal debe contar con un único stock, y cada stock debe corresponder a una única sucursal.  
- RN.9 — Stock y productos  
Un stock puede contener uno o más productos, y un producto puede formar parte del stock de una o más sucursales.  
- RN.10 — Cliente y compras  
Un cliente puede realizar una o más compras, mientras que cada compra debe corresponder a un único cliente.  
- RN.11 — Empleado y compras  
Un empleado puede atender cero o más compras, mientras que cada compra debe ser atendida o realizada por un único empleado.  
- RN.12 — Compra y detalle de compra  
Cada compra debe contener uno o más detalles de compra, y cada detalle de compra debe pertenecer a una única compra.  
- RN.13 — Producto y detalle de compra  
Un producto puede aparecer en cero o más detalles de compra, mientras que cada detalle de compra corresponde a un único producto.  
- RN.14 — Compra y método de pago  
Cada compra debe utilizar un único método de pago, mientras que un mismo método de pago puede utilizarse en una o más compras.  
- RN.15 — Producto y proveedores  
Un proveedor puede suministrar uno o más productos, y un producto puede ser suministrado por uno o más proveedores.  
