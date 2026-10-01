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
