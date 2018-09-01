drop database if exists paises;
create database paises;

\c paises

drop table if exists pais cascade;
create table pais(
	pais_id integer,
	nombre	 varchar(64),
	independencia char(10), --e.g. 09-07-1816
	continente_id integer,
	forma_gobierno	varchar(64),
	poblacion integer
);

drop table if exists frontera cascade;
create table frontera(
	pais_id1 integer,
	pais_id2 integer,
	extension_km float
);

drop table if exists censo cascade;
create table censo(
	pais_id integer,
	anio integer,
	poblacion integer
);

drop table if exists continente cascade;
create table continente(
	continente_id integer,
	nombre varchar(64)
);

--LEEMOS LOS CSV
copy continente from '/home/demo/Moreno-Vera-tp0/Datos_paises - Continente.csv' using delimiters ',' csv header;

copy pais from '/home/demo/Moreno-Vera-tp0/Datos_paises - Pais.csv' using delimiters ',' csv header;

copy frontera from '/home/demo/Moreno-Vera-tp0/Datos_paises - Frontera.csv' using delimiters ',' csv header;

copy censo from '/home/demo/Moreno-Vera-tp0/Datos_paises - Censo.csv' using delimiters ',' csv header;

-- PRIMARY KEYS
alter table pais	 add constraint pais_pk             primary key (pais_id);
alter table continente 	 add constraint continente_pk   primary key(continente_id);
alter table censo 	 add constraint censo_pk            primary key(pais_id,anio);
alter table frontera add constraint frontera_pk primary key (pais_id1, pais_id2);

--FOREIGN KEYS
alter table pais        add constraint pais_fk      foreign key (continente_id)  references continente (continente_id);
alter table frontera    add constraint frontera_fk0 foreign key (pais_id1) references pais (pais_id);
alter table frontera    add constraint frontera_fk1 foreign key (pais_id2) references pais (pais_id);
alter table censo add constraint censo_fk foreign key (pais_id) references pais (pais_id);
