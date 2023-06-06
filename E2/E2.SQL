/*
Dada la siguiente base de datos:
Proveedor (NroProv, NomProv, Categoria, CiudadProv)
Artículo (NroArt, Descripción, CiudadArt, Precio)
Cliente (NroCli, NomCli, CiudadCli)
Pedido (NroPed, NroArt, NroCli, NroProv, FechaPedido, Cantidad, PrecioTotal)
Stock (NroArt, fecha, cantidad)
*/

--  1. Hallar el código (nroProv) de los proveedores que proveen el artículo 146.
SELECT DISTINCT NroProv FROM Pedido
WHERE NroArt = 146

-- 2. Hallar los clientes (nomCli) que solicitan artículos provistos por 15.
SELECT * FROM Pedido
WHERE NroProv = 15

-- 3. Hallar los clientes que solicitan algún item provisto por proveedores con categoría mayor que 4.
SELECT DISTINCT C.NroCli, C.NomCli, C.CiudadCli
FROM Cliente C
INNER JOIN Pedido P ON P.NroCli = C.NroCli
INNER JOIN Proveedor PR ON PR.NroProv = P.NroProv
WHERE PR.Categoria = 4

-- 4. Hallar los pedidos en los que un cliente de Rosario solicita artículos producidos en la ciudad de Mendoza
SELECT P.NroPed, P.NroArt, P.NroCli, P.NroProv, C.CiudadCli, A.CiudadArt
FROM Pedido P
INNER JOIN Cliente C ON C.NroCli = P.NroCli
INNER JOIN Articulo A ON A.NroArt = P.NroArt
WHERE C.CiudadCli = 'Rosario' and A.CiudadArt  = 'Mendoza'

-- 5. Hallar los pedidos en los que el cliente 1 solicita artículos solicitados por el cliente 2
SELECT * FROM Pedido
WHERE NroCli = 1 
and NroArt in (SELECT NroArt FROM Pedido WHERE NroCli = 2)

-- 6. Hallar los proveedores que suministran todos los artículos cuyo precio es igual o dsuperior 
-- al precio promedio de los artículos que se producen en La Plata.
-- (COCIENTE: PRINCIPAL RESTRICCIÓN CONEXIÓN)
SELECT Pr.NroProv, Pr.NomProv, Pr.Categoria
FROM Proveedor Pr
WHERE NOT EXISTS  (SELECT * FROM Articulo A
					WHERE A.Precio >= (SELECT AVG(Precio) FROM Articulo
										WHERE CiudadArt = 'La Plata')
					and NOT EXISTS (SELECT 1 FROM Pedido P
								    WHERE P.NroArt = A.NroArt and P.NroProv = Pr.NroProv))

-- 7. Hallar la cantidad de artículos diferentes provistos por cada proveedor que provee  
--  a todos los clientes de Junín.
SELECT COUNT (*)
FROM Articulo A
WHERE NOT EXISTS (SELECT 1 FROM Proveedor Pr
				  WHERE Pr.CiudadProv = 'Junín'
				  AND NOT EXISTS (SELECT 1 FROM Pedido P
								  WHERE P.NroProv = PR.CiudadProv
										and P.NroArt = A.NroArt))


