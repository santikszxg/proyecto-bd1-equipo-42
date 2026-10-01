-----------------
--CREATE DATABASE Proyecto_Integrador_Farmacia;

USE Proyecto_Integrador_Farmacia;
GO

--empezamos con la creacion del tipo de empleado
--esto debido a que no depende de nadie si no que actua como un
--molde para la definicion de las tablas empleados, siendo una table padre de ellas

CREATE TABLE TIPO_DE_EMPLEADO (
  ID_Empleado INT IDENTITY(1,1),
  Nombre VARCHAR(25) NOT NULL,
  Apellido VARCHAR(25) NOT NULL,
  DNI INT NOT NULL,
  Hora_fin VARCHAR(25) NOT NULL,
  Hora_inicio VARCHAR(25) NOT NULL,
  CONSTRAINT PK_ID_Empleado PRIMARY KEY (ID_Empleado),
  CONSTRAINT UQ_dni UNIQUE (DNI)
);

--seguimos con cliente ya que no depende de nadie
CREATE TABLE CLIENTE(
  ID_Cliente INT IDENTITY(1,1) NOT NULL,
  Obra_social VARCHAR(30) NULL,
  Receta VARCHAR(80) NULL,
  CONSTRAINT PK_ID_Cliente PRIMARY KEY (ID_Cliente)
);

--Tabla compra que depende de cliente
CREATE TABLE COMPRA (
  ID_Compra INT IDENTITY(1,1) NOT NULL,
  Monto FLOAT NOT NULL,
  Metodo_de_pago VARCHAR(20) NOT NULL,
  ID_Cliente INT NOT NULL,
  CONSTRAINT PK_ID_Compra PRIMARY KEY (ID_Compra),
  CONSTRAINT FK_ID_Cliente FOREIGN KEY (ID_Cliente) REFERENCES CLIENTE(ID_Cliente)
);

--Tabla producto independiente de otras tablas
CREATE TABLE PRODUCTO (
  ID_Producto INT IDENTITY(1,1) NOT NULL,
  Tipo_de_producto VARCHAR(30) NOT NULL,
  Descripccion VARCHAR(80) NOT NULL,
  Precio FLOAT NOT NULL,
  Nombre VARCHAR(25) NOT NULL,
  CONSTRAINT PK_ID_Producto PRIMARY KEY (ID_Producto)
);

--Tabla Stock es independinte
CREATE TABLE STOCK (
  ID_Stock INT IDENTITY(1,1) NOT NULL,
  CONSTRAINT PK_ID_Stock PRIMARY KEY (ID_Stock)
);

-- Tabla independiente
CREATE TABLE HORARIO_ATENCION(
  Cod_Horario INT IDENTITY(1,1) NOT NULL,
  Horario VARCHAR(30) NOT NULL,
  CONSTRAINT PK_Cod_Horario PRIMARY KEY (Cod_Horario)
);

--Tabla "independiente"
CREATE TABLE DIRECT_TECNICO (
  ID_Direct_Tecnico INT IDENTITY(1,1) NOT NULL,
  Fecha_de_inicio VARCHAR(25) NOT NULL,
  Fecha_de_finalizacion VARCHAR(25) NOT NULL,
  CONSTRAINT PK_ID_Direc_tecnico PRIMARY KEY (ID_Direct_Tecnico)
);

--Tabla ubicacion independiente
CREATE TABLE UBICACION (
  Cod_Localizacion INT IDENTITY(1,1) NOT NULL,
  Localidad VARCHAR NOT NULL,
  direccion VARCHAR NOT NULL,
  CONSTRAINT PK_Cod_Localizacion PRIMARY KEY (Cod_Localizacion)
);

--Tabla que anexada por varias tablas
CREATE TABLE SUCURSAL (
  ID_Sucursal INT IDENTITY(1,1) NOT NULL,
  Cantidad_de_empleados INT NOT NULL,
  Num_Telefono VARCHAR(25) NOT NULL,
  ID_Stock INT NOT NULL,
  Cod_Horario INT NOT NULL,
  ID_Empleado INT NOT NULL,
  ID_Direct_Tecnico INT NOT NULL,
  Cod_Localizacion INT NOT NULL,
  CONSTRAINT PK_ID_Sucursal PRIMARY KEY (ID_Sucursal),
  CONSTRAINT FK_ID_Stock FOREIGN KEY (ID_Stock) REFERENCES STOCK(ID_Stock),
  CONSTRAINT FK_Cod_Horario FOREIGN KEY (Cod_Horario) REFERENCES HORARIO_ATENCION(Cod_Horario),
  CONSTRAINT FK_ID_Empleado FOREIGN KEY (ID_Empleado) REFERENCES TIPO_DE_EMPLEADO(ID_Empleado),
  CONSTRAINT FK_ID_Direct_Tecnico FOREIGN KEY (ID_Direct_Tecnico) REFERENCES DIRECT_TECNICO(ID_Direct_Tecnico),
  CONSTRAINT FK_Cod_Localizacion FOREIGN KEY (Cod_Localizacion) REFERENCES UBICACION(Cod_Localizacion)
);

--Proveniente de la clase padre TIPO_DE_EMPLEADO
CREATE TABLE FARMACEUTICO (
  ID_Empleado INT NOT NULL,
  Matricula_profesional VARCHAR(100) NOT NULL,
  ID_Direct_Tecnico INT NULL,
  CONSTRAINT PK_ID_Farmaceutico PRIMARY KEY (ID_Empleado),
  CONSTRAINT FK_ID_Farmaceutico FOREIGN KEY (ID_Empleado) REFERENCES TIPO_DE_EMPLEADO(ID_Empleado),
  CONSTRAINT FK_ID_Direct_Tecnico_Farmaceutico FOREIGN KEY (ID_Direct_Tecnico) REFERENCES DIRECT_TECNICO(ID_Direct_Tecnico),
  CONSTRAINT UQ_Matricula_Profesional UNIQUE (Matricula_profesional)
);

--Tabla hija de la tabla tipo de empleado
CREATE TABLE CAJERO (
  ID_Empleado INT NOT NULL,
  ID_Compra INT NOT NULL,
  CONSTRAINT PK_ID_Cajero PRIMARY KEY (ID_Empleado),
  CONSTRAINT FK_ID_Cajero FOREIGN KEY (ID_Empleado) REFERENCES TIPO_DE_EMPLEADO(ID_Empleado),
  CONSTRAINT FK_ID_Compra FOREIGN KEY (ID_Compra) REFERENCES COMPRA(ID_Compra)
);

--Tabla hija de tipo de empleado
CREATE TABLE SEGURIDAD (
  ID_Empleado INT NOT NULL,
  CONSTRAINT PK_ID_Seguridad PRIMARY KEY (ID_Empleado),
  CONSTRAINT FK_ID_Seguridad FOREIGN KEY (ID_Empleado) REFERENCES TIPO_DE_EMPLEADO(ID_Empleado)
);

--Detalle con respecto a un producto unitario en una compra
CREATE TABLE DETALLE_DE_COMPRA( --X
  Cod_Detalle INT IDENTITY(1,1) NOT NULL,
  Historial_de_precio_uni FLOAT NOT NULL,
  Cantidad_del_producto INT DEFAULT 1,
  Fecha VARCHAR(20) NOT NULL,
  ID_Compra INT NOT NULL,
  ID_Producto INT NOT NULL,
  CONSTRAINT PK_Cod_Detalle PRIMARY KEY (Cod_Detalle),
  CONSTRAINT FK_ID_Compra_Detalle FOREIGN KEY (ID_Compra) REFERENCES COMPRA(ID_Compra),
  CONSTRAINT FK_ID_Producto FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto)
);

--
CREATE TABLE PROVEEDOR (
  ID_Proveedor INT IDENTITY(1,1) NOT NULL,
  Numero_de_telefono VARCHAR(30) NOT NULL,
  Razon_social VARCHAR(40) NOT NULL,
  Cod_Localizacion INT NOT NULL,
  CONSTRAINT PK_ID_Proveedor PRIMARY KEY (ID_Proveedor),
  CONSTRAINT FK_Cod_Localizacion_Proveedor FOREIGN KEY (Cod_Localizacion) REFERENCES Ubicacion(Cod_Localizacion)
);

--tabla intermedia para una mejor remplecentaicon sobre los datos
--Al querer almacenar muchos tipos de productos dentro de un STOCK
CREATE TABLE POSEE(
  ID_Stock INT NOT NULL,
  ID_Producto INT NOT NULL,
  Cantidad_Productos INT NOT NULL,
  CONSTRAINT PK_ID_Stock_ID_Producto PRIMARY KEY (ID_Stock, ID_Producto),
  CONSTRAINT FK_ID_Stock_Posee FOREIGN KEY (ID_Stock) REFERENCES STOCK(ID_Stock),
  CONSTRAINT FK_ID_Producto_Posee FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto)
);

--Tabla para la representacion de N : M
CREATE TABLE CONTIENE ( --X
  ID_Producto INT NOT NULL,
  ID_Compra INT NOT NULL,
  CONSTRAINT PK_ID_Producto_ID_Compra PRIMARY KEY (ID_Producto, ID_Compra),
  FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto),
  FOREIGN KEY (ID_Compra) REFERENCES COMPRA(ID_Compra)
);

--tabla para la representacion de N:M
CREATE TABLE SUMINISTRA (
  ID_Proveedor INT NOT NULL,
  ID_Producto INT NOT NULL,
  CONSTRAINT PK_ID_Proveedor_ID_Producto PRIMARY KEY (ID_Proveedor, ID_Producto),
  CONSTRAINT FK_ID_Proveedor FOREIGN KEY (ID_Proveedor) REFERENCES PROVEEDOR(ID_Proveedor),
  CONSTRAINT FK_ID_Producto_Suministra FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto)
);

--CAMBIOS REALIZADOS

DROP TABLE CONTIENE;

DROP TABLE DETALLE_DE_COMPRA;

--Creacion de 2 tablas nuevas

CREATE TABLE TICKET (
Cod_Ticket INT IDENTITY(1,1) NOT NULL,
Fecha DATE NOT NULL DEFAULT GETDATE(),
ID_compra INT NOT NULL,
CONSTRAINT PK_Cod_ticket PRIMARY KEY (Cod_ticket),
CONSTRAINT FK_ID_Compra_Ticket FOREIGN KEY (ID_compra) REFERENCES COMPRA(ID_Compra)
);

CREATE TABLE DETALLE_HISTORICO (
ID_Producto INT NOT NULL,
Cod_Ticket INT NOT NULL,
Precio_unitario_Historico DECIMAL(5,2) NOT NULL,
CONSTRAINT PK_ID_Producto_Cod_Ticket PRIMARY KEY (ID_Producto, Cod_Ticket),
CONSTRAINT FK_ID_Producto FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID_Producto),
CONSTRAINT FK_Cod_Ticket FOREIGN KEY (Cod_Ticket) REFERENCES TICKET(Cod_Ticket)
);

--cambiar la cantidad del var char de la tabla ubicacion
ALTER TABLE UBICACION ALTER COLUMN Localidad VARCHAR(40) NOT NULL;
ALTER TABLE UBICACION ALTER COLUMN direccion VARCHAR(40) NOT NULL;

--cambios con check y default sobre la tabla "POSEE"
ALTER TABLE POSEE ADD CONSTRAINT DF_Cantidad_Productos DEFAULT 1 FOR Cantidad_Productos,
CONSTRAINT CK_Cantida_Productos CHECK (Cantidad_Productos > 0);

--Detalle historico agrandar la parte entera del decimal
ALTER TABLE DETALLE_HISTORICO ALTER COLUMN Precio_unitario_Historico DECIMAL(10, 2) NOT NULL;

--carga de campos nuevos en tablas SEGURIDAD y STOCK
-- Agregar atributo "lote" a la tabla STOCK y su restricción DEFAULT
ALTER TABLE STOCK ADD lote DATE NOT NULL;

ALTER TABLE STOCK ADD CONSTRAINT DF_STOCK_lote DEFAULT GETDATE() FOR lote;

-- Agregar atributo opcional "credencial" a la tabla SEGURIDAD
ALTER TABLE SEGURIDAD ADD credencial VARCHAR(60) NULL; 

--Modificaciones en los tipos de datos de la tabla tipo de empleado
ALTER TABLE TIPO_DE_EMPLEADO ALTER COLUMN Hora_fin TIME(0) NOT NULL;  
ALTER TABLE TIPO_DE_EMPLEADO ALTER COLUMN Hora_inicio TIME(0) NOT NULL; 

--modificaciones en los tipos de datos de la tabla horario de atencion
ALTER TABLE HORARIO_ATENCION ALTER COLUMN Horario TIME(0) NOT NULL; 

--modificaciones en los tipos de datos de la tabla director tecnico
ALTER TABLE DIRECT_TECNICO ALTER COLUMN Fecha_de_inicio DATE NOT NULL;
ALTER TABLE DIRECT_TECNICO ALTER COLUMN Fecha_de_finalizacion DATE NOT NULL;
