create table Proveedor
(CodProv int not null primary key,
RazonSocial varchar(20),
FechaInicio date)

create table Producto 
(CodProd int not null primary key,
Descripcion varchar(20),
CodProv int,
StockActual int,
constraint FKCodProv foreign key (CodProv) references Proveedor(CodProv))

create table Stock
(Nro int not null,
Fecha date not null,
CodProd int not null,
Cantidad int,
constraint PKStock primary key (Nro, Fecha, CodProd),
constraint FKCodProd foreign key (CodProd) references Producto(CodProd)
)


-- 1. p_EliminaSinstock(): Realizar un procedimiento que elimine los productos que no poseen stock.
GO
CREATE OR ALTER PROCEDURE p_EliminarSinStock
AS
BEGIN 
	DELETE FROM Producto
	WHERE StockActual = 0
END

-- 2. p_ActualizaStock(): Para los casos que se presenten inconvenientes en los
-- datos, se necesita realizar un procedimiento que permita actualizar todos los
-- Stock_Actual de los productos, tomando los datos de la entidad Stock. Para ello,
-- se utilizará como stock válido la última fecha en la cual se haya cargado el stock.
GO
CREATE OR ALTER PROCEDURE p_ActualizarStock
AS
BEGIN
	DECLARE @cantRows int
	DECLARE @ultStock int
	SET @cantRows = (SELECT MAX(CodProd) FROM Stock)

	WHILE @cantRows > 0
	BEGIN
		SET @ultStock = (SELECT TOP 1 Cantidad From Stock WHERE CodProd = @cantRows ORDER BY Fecha DESC)

		-- Habría que validar si la consulta trajo algo, si el stock es diferente, pero a fines prácticos lo hago rápido para entender bien procedures.
		UPDATE Producto
		SET StockActual = @ultStock 
		WHERE CodProd = @cantRows

		SET @cantRows = @cantRows - 1
	END
END;

-- Otra mejor forma:

CREATE OR ALTER PROCEDURE p_ActualizaStock2
AS
BEGIN
    -- Actualizar StockActual en la tabla Producto
    UPDATE Producto
    SET StockActual = S.Cantidad
    FROM Producto P
    INNER JOIN (
        SELECT CodProd, Cantidad
        FROM Stock S
        WHERE Fecha = (
            SELECT MAX(Fecha)
            FROM Stock
            WHERE CodProd = S.CodProd
        )
    ) AS S ON P.CodProd = S.CodProd;
END;

