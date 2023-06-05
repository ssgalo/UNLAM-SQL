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