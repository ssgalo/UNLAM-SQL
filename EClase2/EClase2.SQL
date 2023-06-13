/*
1- 
Redactar las sentencias que permitan agregar las restricciones de integridad referencial permitiendo 
la actualizacion automatica para el caso de actualizar o eliminar un banco, moneda o persona.
Demostrar el correcto funcionamiento de las restricciones creadas
Redactar las sentencias que permitan eliminar las restricciones creadas en el paso anterior.
*/
alter table cuenta add constraint fk_banco_idBanco foreign key (idBanco) references Banco(id) on delete cascade on update cascade;
alter table cuenta add constraint fk_banco_idMoneda foreign key (idMoneda) references Moneda(id) on delete cascade on update cascade;
alter table cuenta add constraint fk_banco_idPersona foreign key (idPersona) references Persona(pasaporte) on delete cascade on update cascade;

alter table opera add constraint fk_opera_idBanco foreign key (idBanco) references Banco(id) on delete cascade on update cascade;
alter table opera add constraint fk_opera_idMoneda foreign key (idMoneda) references Moneda(id) on delete cascade on update cascade;


/*
4-
Crear una funcion que devuelva el valor oro de una moneda. La misma debe recibir como parametro el 
codigo de la moneda y devolver el valor -1 para el caso en que la moneda no exista.
Escribir la sentencia que prueba el correcto funcionamiento.
*/
create function f_valor_oro_moneda (@moneda char(2)) returns decimal(18,3)
BEGIN
declare @aux decimal(18,3);
set @aux=(select count(*) from moneda m where m.id=@moneda);
--select @aux=count(*) from moneda m where m.id=@moneda; 
 IF(@aux=0) set @aux=-1;
 else select @aux=m.valorOro from moneda m where m.id=@moneda; 
return @aux;
END

select dbo.f_valor_oro_moneda('MM') as valorOro
select dbo.f_valor_oro_moneda('UY') as valorOro


/*
5- 
Crear una funcion que retorne el pasaporte y el nombre de las personas que tienen cuenta en todos los bancos.
Escribir la sentencia que prueba el correcto funcionamiento.
*/

create function f_cuenta_todos_bancos() returns table as
return(
	select p.pasaporte,p.nombre
			from Persona p
			where not exists
					(select 1
					 from banco b
					 where not exists
								( select 1
									from cuenta c
									where p.pasaporte=c.idPersona and b.id=c.idBanco))
)

select *
from f_cuenta_todos_bancos()

/*
6-
Crear un SP que muestre por pantalla a las personas que tienen mas de 3 cuentas en dolares en bancos extranjeros. 
Escribir la sentencia que prueba el correcto funcionamiento.
*/
create procedure p_3_cuentas_dolares as
BEGIN
select p.* 
from persona p inner join
				(select p.pasaporte, count(*) cantidadCuentas
				from persona p inner join cuenta c on p.pasaporte=c.idPersona inner join banco b on c.idBanco=b.id
				where c.idMoneda='US' and b.pais not in ('Argentina')
				group by p.pasaporte
				having count(*) > 2) as tres 
on p.pasaporte=tres.pasaporte
END

exec p_3_cuentas_dolares

/*
7- 
Crear un SP que reciba por parametro un pasaporte y muestre las cuentas asociadas a la misma. Si el pasaporte no existe, mostrar un mensaje de error.
Escribir la sentencia que prueba el correcto funcionamiento.
*/
create procedure p_cuentas_pasaporte (@pasaporte_parametro char(15)) as
begin
declare @aux integer;
select @aux=count(*) from persona where pasaporte=@pasaporte_parametro;
if (@aux>0) select c.* from cuenta c where c.idPersona=@pasaporte_parametro;
else raiserror ('No existe el pasaporte recibido por parámetro',11,1);
end

exec p_cuentas_pasaporte 16
exec p_cuentas_pasaporte 3

/*
8-
Crear un Trigger que realice el respaldo de los datos de un Banco cuando el mismo es eliminado. El trigger no debe 
permitir que se eliminen bancos que operan con la moneda "PESO ARGENTINO"
Se debe crear una tabla "banco_respaldo"
Escribir las sentencias que prueban el correcto funcionamiento.
*/
create trigger t_baja_banco_moneda_ext on banco instead of delete
as
BEGIN
declare @aux int;
set @aux=0;
select @aux=count(*) from deleted d inner join opera o on d.id=o.idBanco 
where o.idMoneda = 'AR'
IF (@aux=0) 
	begin
		insert into banco_respaldo select * from banco where id in (select id from deleted);
		delete from banco where id in (select id from deleted);
    end
else RAISERROR ('El banco opera con Pesos Argentinos. No puede eliminarse', 11, 50000);
END

/*
9-
Crear un Trigger que actualice el id de moneda en las tablas opera y cuenta para cuando un codigo de moneda 
sea actualizado en la tabla moneda.
Escribir la sentencia que prueba el correcto funcionamiento.
*/
create trigger t_update_moneda on moneda for update
as
begin
declare @idMonedaViejo varchar(2);
declare @idMonedaNuevo varchar(2);

select @idMonedaViejo=d.id from deleted d;
select @idMonedaNuevo=i.id from inserted i;

update opera set idMoneda=@idMonedaNuevo where idMoneda=@idMonedaViejo;
update cuenta set idMoneda=@idMonedaNuevo where idMoneda=@idMonedaViejo;

end