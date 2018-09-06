
--3)Crear una función llamada get_pop_variation_rate(pais_id) que retorne el coeficiente con el que varía anualmente la población en dicho país, tomado en base a los 2 últimos censos.
--Es decir esta función debe retornar un número real. por ejemplo si la población crece a un 12% anual, debería retornar 1.12

create or replace function get_pop_variation_rate(pais_id_param integer) returns float as $$
declare 
    resul float;
    ultimo_censo record;
    anteultimo_censo record;
    coeficiente float;
    anios_entre_censos integer;
begin
    select * into ultimo_censo from censo c1 where c1.pais_id= pais_id_param order by anio desc limit 1;
    select * into anteultimo_censo from censo c2 where c2.pais_id= pais_id_param order by anio desc limit 1 offset 1;
    resul = ultimo_censo.poblacion::float/anteultimo_censo.poblacion::float;
    anios_entre_censos = ultimo_censo.anio - anteultimo_censo.anio;
    coeficiente = power(resul,(1/anios_entre_censos::float)); --ver si restamos -1 o no
    return round (coeficiente::numeric,4);
end;
$$language plpgsql;


--4) Crear una vista que devuelva cada país con su población según el último censo disponible, y la población estimada actual.

--Función para obtener la población actual utilizando "get_pop_variation_rate"
create or replace function get_poblacion_actual(pais_idparam integer) returns bigint as $$
declare
   poblacion_censada record;
   poblacion_total bigint;
begin
   select round(c.poblacion*(power(get_pop_variation_rate(c.pais_id),date_part('year',now())-c.anio))) as suma 
	into poblacion_censada 
		from censo c where c.pais_id=pais_idparam
			order by anio desc limit 1;
   poblacion_total = poblacion_censada.suma;
   return poblacion_total;
end;
$$language plpgsql;


create or replace view vista_poblaciones as(
	select distinct p.nombre, ultimo_censo.anio_censo, censo_poblacion.poblacion, date_part('year',now()) as anio_actual, 
		get_poblacion_actual(p.pais_id) as poblacion_total  
			from (select c.pais_id, max(anio) as anio_censo from censo c group by c.pais_id) as ultimo_censo
			 inner join (select c1.pais_id,c1.anio,c1.poblacion from censo c1) as censo_poblacion on 					(ultimo_censo.pais_id = censo_poblacion.pais_id 
					and ultimo_censo.anio_censo = censo_poblacion.anio) 
						inner join pais p on (p.pais_id = ultimo_censo.pais_id)
);


--5) En el modelo de datos creado, como modelaste el atributo “cantidad de población" y que representa (actual o último censo). En tabla o tablas está ?. Está en más de una tabla ?

--La cantidad de población se encuentra modelada en dos tablas: Pais y Censo.
--En la tabla Pais representamos la población de tipo bigint como la cantidad de población del último censo disponible.
--Mientras que en la tabla Censo representamos la población de tipo de datos bigint como un estimativo de los habitantes en cada censo realizado.



--6) Crear una función get_pop_by_continent() que devuelva la cantidad de población actual estimada de un continente.

create or replace function get_pop_by_continent(cont_id integer) returns bigint as $$
declare
	poblaciones record;
begin
	 select sum (get_poblacion_actual(p.pais_id)) as poblacion_total into poblaciones 
		from pais p, continente cont
			 where cont.continente_id = cont_id 
				and p.continente_id = cont.continente_id ;	
	return poblaciones.poblacion_total;
end;
$$language plpgsql;


--9) Hacer un query que obtenga la lista de pares de paises que tienen limites entre si ordenado por extension de la frontera.

/*
select p1.nombre as pais_1,p2.nombre as pais_2, f.extension_km as extension 
	from pais p1, pais p2, frontera f 
		where f.pais_id1 = p1.pais_id 
			and f.pais_id2 = p2.pais_id 
				order by f.extension_km;
*/

--10) a) Hacer un query que retorne todos los grupos de 3 paises que limitan entre sí. Hacer este query de 2 formas: una con un producto cartesiano de 3 veces la tabla paises y luego verificar que los pares limiten entre sí mediante subqueries correlacionados con la tabla de fronteras. */

/*
---Version 1
select p1.nombre as pais_1, p2.nombre as pais_2,p3.nombre as pais_3 
from  pais p1, pais p2, pais p3
where p1.pais_id in ( --p1 con p2
			select f1.pais_id1 from frontera f1
		        where p1.pais_id = f1.pais_id1 and p2.pais_id = f1.pais_id2)
and  p2.pais_id in (--p2 con p3
			 select f2.pais_id1 from frontera f2
			 where p2.pais_id = f2.pais_id1 and p3.pais_id = f2.pais_id2)
and p1.pais_id in (--p1 con p3
			 select  f3.pais_id1 from frontera f3 
			 where p1.pais_id = f3.pais_id1 and p3.pais_id = f3.pais_id2);

---- version 2
select distinct p1.nombre as pais1, p2.nombre as pais2, p3.nombre as pais3 
	from pais p1, pais p2, pais p3 where exists(
	select 1 from frontera f1
		 where p1.pais_id=f1.pais_id1 and  exists (
			select 1 from frontera f2 
				where p2.pais_id = f2.pais_id1 and exists (
					select 1 from frontera f3
						 where p3.pais_id = f3.pais_id2
							 and f1.pais_id1 = f3.pais_id1 
						 	and f2.pais_id1 = f1.pais_id2
						 	and f3.pais_id2 = f2.pais_id2
					  )
			)
	);


*/

--b)La otra forma es haciendo un join triple de la tabla fronteras


select p1.nombre as pais_1, p2.nombre as pais_2,p3.nombre as pais_3 
	from pais p1, pais p2, pais p3, frontera f1, frontera f2, frontera f3
 		where (f1.pais_id1 = f3.pais_id1 or f3.pais_id1 = f1.pais_id1)
 		and (f2.pais_id1 = f1.pais_id2   or f1.pais_id2 = f2.pais_id1)
 		and (f3.pais_id2 = f2.pais_id2   or f2.pais_id2 = f3.pais_id2)
 		and p1.pais_id =f1.pais_id1  
 		and p2.pais_id= f2.pais_id1 
 		and p3.pais_id=f3.pais_id2;



--11) crear un algún indice que acelere la búsqueda de 10
 create index frontera_indice on frontera(pais_id1,pais_id2);
