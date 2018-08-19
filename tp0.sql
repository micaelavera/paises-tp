drop database if exists paises;
create database paises;

\c paises

create table pais(
	pais_id integer,
	nombre	 varchar(64),
	independencia varchar(64),
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



alter table pais  add constraint pais_pk    primary key (pais_id);


alter table pais add constraint pais_fk0 foreign key (continente)  references continente (continente_id);


