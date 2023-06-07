-- 1. Indique la cantidad de productos que tiene la empresa.
SELECT COUNT(*)
FROM Producto

-- 2. Indique la cantidad de productos en estado 'en stock' que tiene la empresa
SELECT COUNT(*)
FROM Producto
WHERE estado = 'en stock'

-- 3. Indique los productos que nunca fueron vendidos.
SELECT * FROM Producto
WHERE idProducto NOT IN (SELECT idProducto FROM Detalle_venta)

-- 4. Indique la cantidad de unidades que fueron vendidas de cada producto.
SELECT idProducto, SUM(Cantidad) As CantidadPorProducto
FROM Detalle_venta
GROUP BY idProducto

-- 5. Indique cual es la cantidad promedio de unidades vendidas de cada producto.
SELECT AVG(CantidadPorProducto)
FROM 
(SELECT idProducto, SUM(Cantidad) As CantidadPorProducto
FROM Detalle_venta
GROUP BY idProducto) As Tabla1

-- 6. Indique quien es el vendedor con mas ventas realizadas
SELECT * FROM Vendedor 
WHERE idEmpleado in (
SELECT idVendedor 
FROM (	SELECT idVendedor, COUNT(*) As CantidadDeVentas
		FROM Venta
		GROUP BY idVendedor) As Tabla
WHERE CantidadDeVentas = (SELECT MAX (CantidadDeVentas)
FROM (	SELECT idVendedor, COUNT(*) As CantidadDeVentas
		FROM Venta
		GROUP BY idVendedor) As Tabla))

-- 7. Indique todos los productos de lo que se hayan vendido más de 15.000 unidades.
SELECT * FROM Producto
WHERE idProducto in
	(SELECT idProducto
	FROM (
		SELECT idProducto, Sum(Cantidad) as CantidadVendida
		FROM Detalle_venta
		GROUP BY idProducto ) As Tabla1
	WHERE CantidadVendida > 15000)

-- 8. Indique quien es el vendedor con mayor volumen de ventas.
SELECT * FROM Vendedor
WHERE idEmpleado IN (
SELECT idVendedor 
FROM 
(	SELECT V.idVendedor, SUM(DV.cantidad) As VolumenVendido
	FROM Venta V
	INNER JOIN Detalle_venta DV ON DV.nroFactura = V.nroFactura
	GROUP BY V.idVendedor) As Tabla1
WHERE VolumenVendido = (SELECT MAX(VolumenVendido) As VolumenMaximo
	FROM(
		SELECT V.idVendedor, SUM(DV.cantidad) As VolumenVendido
		FROM Venta V
		INNER JOIN Detalle_venta DV ON DV.nroFactura = V.nroFactura
		GROUP BY V.idVendedor
	) As Tabla))