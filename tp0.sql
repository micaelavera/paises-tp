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



--FOREIGN KEYS
--alter table pais add constraint pais_fk0 foreign key (continente_id)  references continente (continente_id);


--LEEMOS LOS CSV
--EJEMPLO
copy pais from '/home/lilo/Moreno-Vera-tp0/Copia de Datos_paises - Pais.csv' using delimiters ',' csv header;

--modificar el path , y que solo tome la carpeta y no "home/lilo etc etc


