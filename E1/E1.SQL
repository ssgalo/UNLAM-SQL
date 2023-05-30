------Dada la siguiente base de datos------ 
--(Lamentablemente no puedo subrayar las claves primarias y foráneas)

/*
Almacén (Nro, Responsable)
Artículo (CodArt, descripción, Precio)
Material (CodMat, Descripción)
Proveedor (CodProv, Nombre, Domicilio, Ciudad)
Tiene (Nro, CodArt)
Compuesto_por (CodArt, CodMat)
Provisto_por (CodMat, CodProv)
*/

-----CREACION DE TABLAS-----

create table Almacen(Nro int not null primary key, Responsable varchar(20))
create table Articulo(CodArt int not null primary key, Descripcion varchar(20), Precio int)
create table Material(CodMat int not null primary key, Descripcion varchar(20))
create table Proveedor(CodProv int not null primary key, Nombre varchar(20), Domicilio varchar(20), Ciudad varchar(20))
create table Tiene (NroAlmacen int not null, CodArt int not null, constraint PKTiene primary key(NroAlmacen,CodArt), constraint FK1Tiene foreign key(NroAlmacen) references Almacen (Nro), constraint FK2Tiene foreign key (CodArt) references Articulo(CodArt))
create table Compuesto_por(CodArt int not null, CodMat int not null, constraint PKCompuesto primary key(CodArt, CodMat), constraint FKCompuesto foreign key(CodArt) references Articulo(CodArt), constraint FK2Compuesto foreign key (CodMat) references Material(CodMat))
create table Provisto_por(CodMat int not null, CodProv int not null, constraint PKProvisto primary key (CodMat, CodProv), constraint FKProvisto foreign key (CodMat) references Material(CodMat), constraint FK2Provisto foreign key (CodProv) references Proveedor(CodProv))

-----AÑADIMOS DATOS A LAS TABLAS-----

--Insertar Almacenes--

insert into Almacen values
(1, 'Santiago'),
(2, 'Lucas'),
(3, 'Claudia'),
(4, 'Azul'),
(5, 'Javier'),
(6, 'Marcos')

--Insertar Artículos--
insert into Articulo values
(1, 'Mesa', 500),
(2, 'Silla', 200),
(3, 'Escritorio', 1500),
(4, 'Lata', 30),
(5, 'Jarra', 390),
(6, 'Plato', 200)

--Insertar Materiales--
insert into Material values
(1, 'Madera'),
(2, 'Metal'),
(3, 'Ceramica')

--Insertar Proveedores--
insert into Proveedor values
(1, 'Maderera Jose', 'Chavez 630','La Plata'),
(2, 'Maderera Raul', 'Varela 300','San Justo'),
(3, 'Ceramicas Juan', 'Cavia 450','Belgrano'),
(4, 'Metales SA', 'Salguero 100','Palermo'),
(5, 'Ceramicas SA', 'Rivadavia 4000','Caballito'),
(6, 'MetalTuyo', 'La Coyunda 809','Ituzaingo'),
(7, 'CeramicaNS', 'San Martin 200', 'La Plata')

--Insertar la relacion Tiene (entre Almacen y Articulo)--
insert into Tiene values
(1, 1),
(1,2),
(1,3),
(2,4),
(3,5),
(3,6),
(4,1),
(4,2),
(4,3),
(4,4),
(4,5),
(4,6),
(5,1),
(5,6),
(6,4),
(6,5)

--Insertar la relacion Compuesto_Por (entre Articulo y Material)
insert into Compuesto_por values
(1,1),
(2,1),
(2,2),
(3,1),
(4,2),
(5,3),
(6,3)

--Insertar la relacion Provisto_por (entre Material y Proveedor)
insert into Provisto_por values
(1,1),
(1,2),
(2,4),
(2,6),
(3,3),
(3,5),
(3,7)

--EJERCICIOS--

-- 1.  Listar los nombres de los proveedores de la ciudad de La Plata. --
select * from Proveedor 
where Ciudad = 'La Plata'

-- 2. Listar los números de artículos cuyo precio sea inferior a $10.
select * from Articulo
where Precio < 10

-- 3. Listar los responsables de los almacenes.
select distinct Responsable from Almacen

-- 4. Listar los códigos de los materiales que provea el proveedor 1 y no los provea el proveedor 2
select distinct CodMat
from Provisto_por 
where CodProv = 1
and CodMat not in (
		select distinct CodMat from Provisto_por 
		where CodProv = 2
	)

-- 5. Listar los números de almacenes que almacenan el artículo Mesa.
select t.NroAlmacen 
from Tiene t 
inner join Articulo a
on a.Descripcion = 'Mesa' and a.CodArt = t.CodArt

--  6. Listar los proveedores de Pergamino que se llamen Pérez.
select * from Proveedor
where Ciudad = 'Pergamino' and Nombre = 'Perez'

-- 7. Listar los almacenes que contienen los artículos Mesa (cod 1) y los artículos Silla (cod 2) (ambos).
select * from Tiene
select * from Articulo
select * from Almacen

-- Si supiera los códigos de antemano, podría hacer asi:
select NroAlmacen from Tiene
where CodArt = 1
and NroAlmacen in (select NroAlmacen from Tiene
				where CodArt = 2)

-- 8. Listar los artículos que cuesten más de $100 o que estén compuestos por el material de código 1.
select * from Articulo
where Precio > 100 or CodArt in (select CodArt from Compuesto_por where CodMat = 1)

-- 9. Listar los materiales, código y descripción, provistos por proveedores de la ciudad de Rosario.
SELECT * FROM MATERIAL 
where CodMat in (SELECT CodMat from Provisto_por 
					where CodProv in (SELECT CodProv FROM Proveedor where Ciudad = 'Rosario')
				)
-- Otra opción
SELECT M.CodMat, M.Descripcion
FROM Material M
INNER JOIN Provisto_por PP ON M.CodMat = PP.CodMat
INNER JOIN Proveedor P ON PP.CodProv = P.CodProv
WHERE P.Ciudad = 'Rosario';

--  10. Listar el código, descripción y precio de los artículos que se almacenan en A1.
SELECT A.CodArt, A.Descripcion, A.Precio 
FROM Articulo A
INNER JOIN Tiene T ON A.CodArt = T.CodArt
INNER JOIN Almacen Al ON Al.Nro  = T.NroAlmacen
WHERE Al.Nro = 1

-- 11. Listar la descripción de los materiales que componen el artículo 2.
SELECT M.Descripcion, CP.CodArt FROM Material M
INNER JOIN Compuesto_por CP ON M.CodMat = CP.CodMat
WHERE CP.CodArt = 2

-- 12. Listar los nombres de los proveedores que proveen los materiales al almacén que Santiago tiene a su cargo.
SELECT distinct P.Nombre, A.Responsable FROM Proveedor P
INNER JOIN Provisto_por PP ON P.CodProv = PP.CodProv
INNER JOIN Compuesto_por CP ON CP.CodMat = PP.CodMat
INNER JOIN Tiene T ON T.CodArt =  CP.CodArt	
INNER JOIN Almacen A ON A.Nro = T.NroAlmacen
WHERE A.Responsable =  'Santiago'

-- 14. Hallar los códigos y nombres de los proveedores que proveen al menos un material que se usa en algún artículo cuyo precio es mayor a $100
SELECT DISTINCT P.CodProv, P.Nombre
FROM Proveedor P
INNER JOIN Provisto_por PP ON P.CodProv = PP.CodProv
INNER JOIN Compuesto_por CP ON CP.CodMat = PP.CodMat
INNER JOIN Articulo A ON A.CodArt = CP.CodArt
WHERE A.Precio > 100



