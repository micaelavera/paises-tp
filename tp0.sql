drop database if exists paises;
create database paises;

\c paises

create table pais(
	pais_id integer,
	nombre	 varchar(64),
	independencia char(10), --e.g. 09-07-1816
	continente_id integer,
	forma_gobierno	varchar(64),
	poblacion integer
);

create table frontera(
	pais_id1 integer,
	pais_id2 integer,
	extension_km float
);


create table censo(
	pais_id integer,
	anio integer,
	poblacion integer
);


create table continente(
	continente_id integer,
	nombre integer
);


-- PRIMARY KEYS
alter table pais add constraint pais_pk primary key (pais_id);
alter table continente add constraint continente_pk primary key(continente_id);

<<<<<<< HEAD
alter table pais  add constraint pais_pk    primary key (pais_id);
=======
>>>>>>> 895447a14863ea1d45fce257f0b4091a70dbbf4c

--FOREIGN KEYS
alter table pais add constraint pais_fk0 foreign key (continente_id)  references continente (continente_id);


