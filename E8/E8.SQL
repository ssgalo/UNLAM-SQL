create table Bar
(id int not null primary key,
descripcion varchar(20))

create table Cerveza
(id int not null primary key,
descripcion varchar(20))

create table Persona
(dni int not null primary key,
nombre varchar(20))


create table Frecuenta
(idPersona int not null,
idBar int not null,
constraint PKFrecuenta primary key (idPersona, idBar),
constraint FK1Frecuenta foreign key (idPersona) references Persona(dni),
constraint FK2Freucenta foreign key (idBar) references Bar(id))

create table Sirve
(idBar int not null,
idCerveza int not null,
constraint PKSirve primary key (idBar, idCerveza),
constraint FK1Sirve foreign key (idBar) references Bar(id),
constraint FK2Sirve foreign key (idCerveza) references Cerveza(id))

create table Gusta
(idPersona int not null,
idCerveza int not null,
constraint PKGusta primary key (idPersona, idCerveza),
constraint FK1Gusta foreign key (idPersona) references Persona (dni),
constraint FK2Gusta foreign key (idCerveza) references Cerveza(id))


-- 1. Frecuentan solamente bares que sirven alguna cerveza que les guste

-- Con esta consulta obtengo el idPersona de la cual asiste a un bar que NO sirve ninguna cerveza que le guste
SELECT F.idPersona FROM Frecuenta F
WHERE NOT EXISTS(
	SELECT 1 FROM Sirve S
	INNER JOIN Gusta G ON S.idCerveza = G.idCerveza
	WHERE S.idBar = F.idBar and G.idPersona = f.idPersona
	)

-- Entonces quedaría:
SELECT P.dni, P.nombre
FROM Persona P
WHERE NOT EXISTS (
	SELECT 1 FROM Frecuenta F
	WHERE F.idPersona = P.dni
	AND NOT EXISTS (
		SELECT S.idBar, G.idCerveza, G.idPersona FROM Sirve S
		INNER JOIN Gusta G ON S.idCerveza = G.idCerveza
		WHERE S.idBar = F.idBar and G.idPersona = F.idPersona
		)
	)

--  2. No frecuentan ningún bar que sirva alguna cerveza que les guste.
SELECT P.dni, P.nombre 
FROM Persona P
WHERE P.dni NOT IN (
	SELECT F.idPersona FROM Frecuenta F
	WHERE EXISTS (
		SELECT S.idBar, S.idCerveza, G.idPersona FROM Sirve S
		INNER JOIN Gusta G ON S.idCerveza = G.idCerveza
		WHERE G.idPersona = F.idPersona and F.idBar = S.idBar
	))

-- En la consulta de arriba lo que hago es ver si existe alguna persona que frecuente un bar
-- que de alguna cerveza que le guste. Con encontrar al menos uno, ya se que a ese no cumple la condición,
-- ya que en el enunciado dice que no frecuente NINGÚN BAR.

-- 3. Frecuentan solamente los bares que sirven todas las cervezas que les gustan
SELECT * FROM Persona
WHERE dni IN (
SELECT DISTINCT F.idPersona
FROM Frecuenta F
WHERE NOT EXISTS (
	SELECT 1 FROM Gusta G
	WHERE F.idPersona = G.idPersona
	and NOT EXISTS ( 
		SELECT 1 FROM Sirve S
		WHERE S.idBar = F.idBar and S.idCerveza = G.idCerveza
		)
	))

-- 4. Frecuentan solamente los bares que no sirven ninguna de las cervezas que no les gusta.
SELECT * FROM Persona
WHERE NOT EXISTS (
	SELECT 1
	FROM Frecuenta
	WHERE Persona.dni = Frecuenta.idPersona
	AND EXISTS (
		SELECT 1
		FROM Sirve
		WHERE Sirve.idBar = Frecuenta.idBar
		AND NOT EXISTS (
			SELECT 1
			FROM Gusta
			WHERE Gusta.idPersona = Frecuenta.idPersona
			AND Gusta.idCerveza = Sirve.idCerveza
		)
	)
)



