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

