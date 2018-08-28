/*
3)Crear una función llamada get_pop_variation_rate(pais_id) que retorne el coeficiente con el que varía anualmente la población en dicho país, tomado en base a los 2 últimos censos.
Es decir esta función debe retornar un número real. por ejemplo si la población crece a un 12% anual, debería retornar 1.12
*/

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
    resul = (ultimo_censo.anio/anteultimo_censo.anio);
    anios_entre_censos = (ultimo_censo - anteultimo_censo);
    coeficiente= power(resul,(1/anios_entre_censos))-10

end;
$$language plpgsql;

/*
4) Crear una vista que devuelva cada país con su población según el último censo
disponible, y la población estimada actual.
*/



/*
5) En el modelo de datos creado, como modelaste el atributo “cantidad de población" y que representa (actual o último censo). En tabla o tablas está ?. Está en más de una tabla ?
*/




/*
6) Crear una función get_pop_by_continent() que devuelva la cantidad de población actual estimada de un continente.
*/

create or replace function get_pop_by_continent(cont_id) returns integer as $$
declare
	poblaciones record;
	poblacion_estimada integer;
begin
	 select sum(p.poblacion) as suma_poblacion into poblaciones from pais p, continente c where p.continente_id = c.continente_id group by p.continente_id;
	return poblaciones.suma_poblacion;
end;
$$language plpgsql;


/*
9) Hacer un query que obtenga la lista de pares de paises que tienen limites entre si ordenado por extension de la frontera.
*/



/*
10) Hacer un query que retorne todos los grupos de 3 paises que limitan entre sí. Hacer este query de 2 formas: una con un producto cartesiano de 3 veces la tabla paises y luego verificar que los pares limiten entre sí mediante subqueries correlacionados con la tabla de fronteras. La otra forma es haciendo un join triple de la tabla fronteras.
*/

