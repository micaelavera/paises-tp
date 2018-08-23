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
	nombre varchar(64)
);


-- PRIMARY KEYS
alter table pais	 add constraint pais_pk primary key (pais_id);
alter table continente 	 add constraint continente_pk primary key(continente_id);
alter table censo 	 add constraint censo_pk primary key(poblacion);

alter table frontera	 add constraint frontera_pk primary key(pais_id1, pais_id2);



--FOREIGN KEYS
alter table pais add constraint pais_fk foreign key (continente_id)  references continente (continente_id);


--LEEMOS LOS CSV
copy continente from '/home/liz/Moreno-Vera-tp0/Datos_paises - Mica_Liz - Continente.csv' using delimiters ',' csv header;

copy pais from '/home/liz/Moreno-Vera-tp0/Datos_paises - Mica_Liz - Pais.csv' using delimiters ',' csv header;

copy frontera from '/home/liz/Moreno-Vera-tp0/Datos_paises - Mica_Liz - Frontera.csv' using delimiters ',' csv header;

copy censo from '/home/liz/Moreno-Vera-tp0/Datos_paises - Mica_Liz - Censo.csv' using delimiters ',' csv header;



--modificar el path , y que solo tome la carpeta y no "home/lilo etc etc
