/* 
Nota: El ambiente podrá ser Desarrollo, Testing o Producción. La función date() devuelve la fecha actual.
Si se resta un valor entero a la función, restará días. El ejercicio consiste en indicar qué enunciado dio
origen a cada una de las consultas:
*/

-- 1
Select P.IP, count(distinct fecha), count(distinct IDMetodo), max(fecha)
From Page P Inner join Request R on P.IP=R.IP
Group by P.IP

-- 2
Select *
From Ambiente A
Where id not in
(Select idambiente
From Page P
Where not exists (
Select 1 From Request R
Where R.IP=P.IP and fecha>= date()-7))

-- 3
Select Fecha, count(*)
From Request R
Where hora between ‘00:00’ and ‘04:00’
and not exists(
select 1 from Page P
inner join Ambiente A on P.IDAmbiente = A.ID
where R.IP=P.IP AND A.Descripcion=’Desarrollo’ )
Group by fecha
Having count(*) >= 10

-- 4
Select W.WebPage, A.Descripcion, max(R.fecha), ‘S’
From Request R
Inner join WebPage W on R.IP=W.IP
Inner join Ambiente A on A.id=W.IDAmbiente
Where R.Fecha>=date()-7 and W.Webpage like ‘www%’
Group by W.WebPage, A.Descripcion
Having count(distinct fecha)>=7

-- www.google.com produccion lunes
-- www.google.com produccion lunes
-- www.google.com produccion martes
-- www.google.com produccion miercoles
-- count (distinct fecha) = 3


-- Listar las páginas del tipo www que fueron consultadas los últimos 7 días en un mismo ambiente
-- 

-- Insertar en la tabla Pages
-- las solicitudes de los últimos 30 días
-- con un método de acceso válido que no tengan una página asociada
    