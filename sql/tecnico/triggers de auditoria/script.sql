USE Proyecto_Integrador_Farmacia;
GO

CREATE TABLE Productos_auditorias(
--Ponemos el ID de la auditoria de la tabla referenciada, el ID de la tabla referenciada
auditoria_ID INT IDENTITY(1,1) PRIMARY KEY,
producto_ID INT NOT NULL,
-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Ahora lo esencial, lo que da vida al triggers
accionRealizada VARCHAR(15) NOT NULL, --si es "DELETE" o "UPDATE" para nuestras preferencias
precioAnterior DECIMAL(10,2) NULL,
precioNuevo DECIMAL(10,2) NULL,
usuario VARCHAR(100) DEFAULT SUSER_SNAME(), --Nombre del usuario conectado en la base de datos
fecha DATETIME DEFAULT GETDATE()
);

-------------------------------------------------
GO --para separar lotes.
CREATE TRIGGER trg_Auditoria_Productos ON PRODUCTO
AFTER INSERT, UPDATE, DELETE
AS
BEGIN 
	IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted) --SELEC 1 solo para dar a entender que nos
	BEGIN															--importa unicamente si existe y no los valores.
		INSERT INTO Productos_auditorias (producto_ID, accionRealizada, precioAnterior, precioNuevo)
		SELECT
			i.ID_Producto, 'UPDATE', d.Precio, i.Precio
		FROM inserted AS i INNER JOIN deleted AS d ON i.ID_Producto = d.ID_Producto;
		--de la tabla de la insercion, aquellos IDs de productos los cuales sean iguales en el momento de la insercion y eliminacion
	END

	IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
	BEGIN
		INSERT INTO Productos_auditorias (producto_ID, accionRealizada, precioAnterior, precioNuevo)
		SELECT
			i.ID_Producto,
			'INSERT',
			NULL,
			i.Precio
		FROM inserted AS i;
		--unicamente de la tabla de insercion
	END

	IF NOT EXISTS(SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
	BEGIN
		INSERT INTO Productos_auditorias (producto_ID, accionRealizada, precioAnterior, precioNuevo)
		SELECT
			d.ID_Producto,
			'DELETE',
			d.Precio,
			NULL
		FROM deleted AS d;
	END
END;

--=============================================
--evidencias
--==============================================

-- 1. INSERT (SQL Server genera el ID automáticamente)
INSERT INTO PRODUCTO (Tipo_de_producto, Descripccion, Precio, Nombre) 
VALUES ('Medicamento', 'Ibupirac 600mg comprimidos', 1500.00, 'Ibuprofeno');

-- Guardamos el ID recién generado en una variable para usarlo en las siguientes pruebas
DECLARE @NuevoID INT = SCOPE_IDENTITY();

-- 2. UPDATE sobre el producto recién creado
UPDATE PRODUCTO 
SET Precio = 1800.50 
WHERE ID_Producto = @NuevoID;

-- 3. DELETE sobre el producto recién creado
DELETE FROM PRODUCTO 
WHERE ID_Producto = @NuevoID;

GO


------------------
--revisinon
SELECT 
    auditoria_ID,
    producto_ID,
    accionRealizada,
    precioAnterior,
    precioNuevo,
    usuario,
    fecha
FROM Productos_auditorias
ORDER BY auditoria_ID ASC;
