USE Proyecto_Integrador_Farmacia;
GO

------------------------------------------------------------------------------
-- ETAPA V - TEMA: SEGURIDAD (permisos a nivel de usuarios y roles)
-- Sistema de Gestión de Farmacias - Equipo 42
--
-- Antes de correr este script hay que tener creado el procedimiento
-- dbo.sp_RegistrarVentaCompleta (sql/tecnico/procedimientos/scripts.sql)
--
-- Para probar cada usuario se usa EXECUTE AS USER (ejecuta "como" ese usuario)
-- y REVERT (vuelve a nuestro usuario).
------------------------------------------------------------------------------


------------------------------------------------------------------------------
-- PARTE 1 - PERMISOS A NIVEL DE USUARIOS
------------------------------------------------------------------------------

-- Creación de inicios de sesión
CREATE LOGIN usuario_admin
WITH PASSWORD = 'Admin123*';

CREATE LOGIN usuario_cajero
WITH PASSWORD = 'Cajero123*';
GO

-- Creación de usuarios en la base
CREATE USER usuario_admin FOR LOGIN usuario_admin;
CREATE USER usuario_cajero FOR LOGIN usuario_cajero;
GO

-- Usuario administrador: se agrega al rol db_owner
ALTER ROLE db_owner
ADD MEMBER usuario_admin;
GO

-- Usuario cajero: solo permiso de lectura sobre COMPRA
GRANT SELECT ON dbo.COMPRA TO usuario_cajero;
GO

-- Permiso de ejecución sobre el procedimiento que registra ventas
GRANT EXECUTE
ON dbo.sp_RegistrarVentaCompleta
TO usuario_cajero;
GO


-- PRUEBA 1: INSERT directo sobre COMPRA con usuario_admin
-- Resultado esperado: operación exitosa
EXECUTE AS USER = 'usuario_admin';

INSERT INTO COMPRA (Monto, Metodo_de_pago, ID_Cliente)
VALUES (15000, 'Efectivo', 1);

REVERT;
GO

-- PRUEBA 2: INSERT directo sobre COMPRA con usuario_cajero
-- Resultado esperado: SQL Server rechaza la operación por falta de permisos
EXECUTE AS USER = 'usuario_cajero';

INSERT INTO COMPRA (Monto, Metodo_de_pago, ID_Cliente)
VALUES (15000, 'Efectivo', 1);

REVERT;
GO

-- PRUEBA 3: registrar venta mediante el procedimiento con usuario_cajero
-- Resultado esperado: la venta se registra porque tiene permiso EXECUTE
-- (ajustar los IDs según los datos de prueba)
EXECUTE AS USER = 'usuario_cajero';

EXEC dbo.sp_RegistrarVentaCompleta
    @ID_Cliente = 1,
    @ID_Producto = 1,
    @ID_Stock = 1,
    @Cantidad = 1,
    @Metodo_de_pago = 'Efectivo';

REVERT;
GO


------------------------------------------------------------------------------
-- PARTE 2 - PERMISOS A NIVEL DE ROLES
------------------------------------------------------------------------------

-- Creación de inicios de sesión
CREATE LOGIN usuario_farmaceutico
WITH PASSWORD = 'Farma123*';

CREATE LOGIN usuario_seguridad
WITH PASSWORD = 'Segur123*';
GO

-- Creación de usuarios en la base
CREATE USER usuario_farmaceutico
FOR LOGIN usuario_farmaceutico;

CREATE USER usuario_seguridad
FOR LOGIN usuario_seguridad;
GO

-- Creación de un rol personalizado para consultar productos
CREATE ROLE rol_farmaceutico;
GO

-- Asignación de permisos al rol
GRANT SELECT
ON dbo.PRODUCTO
TO rol_farmaceutico;
GO

-- Incorporación del farmacéutico al rol (el de seguridad queda afuera)
ALTER ROLE rol_farmaceutico
ADD MEMBER usuario_farmaceutico;
GO


-- PRUEBA 4: SELECT sobre PRODUCTO con usuario que tiene el rol
-- Resultado esperado: consulta exitosa
EXECUTE AS USER = 'usuario_farmaceutico';

SELECT *
FROM PRODUCTO;

REVERT;
GO

-- PRUEBA 5: SELECT sobre PRODUCTO con usuario sin el rol
-- Resultado esperado: SQL Server deniega el acceso por falta de permisos
EXECUTE AS USER = 'usuario_seguridad';

SELECT *
FROM PRODUCTO;

REVERT;
GO
