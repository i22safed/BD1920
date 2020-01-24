
-- Practica 2. 

-- 1. Obtener el nombre de todos los votantes cuyo segundo apellido acaba en “n”.  
 
    SELECT V.NOMBRECOMPLETO 
    FROM VOTANTES V
    WHERE V.NOMBRECOMPLETO LIKE '%n';
 
-- 2. Obtener el DNI de todos los votantes que tengan al menos tres 5s en su DNI. 
 
    SELECT V.DNI 
    FROM VOTANTES V 
    WHERE DNI LIKE '%5%5%5%';
 
-- 3. Obtener el nombre de aquellos votantes cuya fecha de nacimiento sea 
-- posterior al 1 de Enero de 1990. 

    SELECT V.NOMBRECOMPLETO 
    FROM VOTANTES V 
    WHERE V.FECHANACIMIENTO < '01011990';
 
-- 4. Obtener el nombre del votante y el nombre de la localidad de aquellos 
-- votantes que han ejercido el voto en una localidad que tiene más de 300000 
-- habitantes. 

    SELECT V.NOMBRECOMPLETO, L.NOMBRE 
    FROM VOTANTES V, LOCALIDADES L
    WHERE V.LOCALIDAD = L.IDLOCALIDAD
        AND L.NUMEROHABITANTES > 300000;
 
-- 5. Obtener el nombre del votante y el nombre de la comunidad de aquellos 
-- votantes que han ejercido el voto en una localidad que tiene más de 300000 
-- habitantes. 

    SELECT V.NOMBRECOMPLETO, P.COMUNIDAD 
    FROM VOTANTES V, LOCALIDADES L, PROVINCIAS P
    WHERE L.NUMEROHABITANTES > 300000
        AND V.LOCALIDAD = L.IDLOCALIDAD 
        AND L.PROVINCIA = P.IDPROVINCIA;
    
-- 6. Obtener el identificador del partido y el número de datos o consultas que
-- se tiene para dicho partido de entre todos los partidos sobre los que se han
-- realizado alguna consulta. 
    
    SELECT P.IDPARTIDO, COUNT(CD.PARTIDO) AS "#CONSULTAS"
    FROM PARTIDOS P, CONSULTAS_DATOS CD
    WHERE P.IDPARTIDO = CD.PARTIDO
    GROUP BY P.IDPARTIDO;
    
-- 7. Mostrar el identificador de partido y el número de consultas realizadas 
-- para cada partido. 

    SELECT P.IDPARTIDO, COUNT(CD.PARTIDO) AS "#CONSULTAS"
    FROM PARTIDOS P, CONSULTAS_DATOS CD
    WHERE P.IDPARTIDO = CD.PARTIDO
    GROUP BY P.IDPARTIDO;
    
-- 8. Mostrar el nombre del partido político sobre el que se han realizado más 
-- de 10 consultas. 
  
    SELECT P.IDPARTIDO, COUNT(CD.PARTIDO) AS NO_CONSULTAS
    FROM PARTIDOS P, CONSULTAS_DATOS CD
    HAVING P.IDPARTIDO = CD.PARTIDO
        AND COUNT(CD.PARTIDO) > 10 
    GROUP BY P.IDPARTIDO;
    
    -- CON LAS FUNCIONES MAX, MIN, COUNT, AVG ... NO SE PUEDE UTILIZAR WHERE 
    -- EN ESTE CASO DSE UTLIZA LA FUNCION HAVING 
    
-- 9. Mostrar el nombre del partido y el número de consultas realizadas para 
-- aquellos partidos que aparecen en más de 10 consultas. 
  
    SELECT * FROM PARTIDOS; 
    SELECT * FROM CONSULTAS_DATOS; 
  
    SELECT P.NOMBRECOMPLETO, COUNT(CD.PARTIDO) AS NO_CONSULTAS
    FROM PARTIDOS P, CONSULTAS_DATOS CD 
    WHERE P.IDPARTIDO = CD.PARTIDO
    GROUP BY P.NOMBRECOMPLETO
    HAVING COUNT(CD.PARTIDO) > 10; 
    
    -- SE PUEDE UTILIZAR WHERE Y EL HAVING EN LA MISMA CONSULTA
        
-- 10. Mostrar el nombre de los partidos y el número de consultas realizadas 
-- para cada partido considerando sólo aquellas consultas en las que el 
-- encuestado ha contestado afirmativamente a votar a dicho partido y con 
-- una certidumbre por encima del 80%, es decir, 0.8. 

    SELECT * FROM CONSULTAS_DATOS; 
    DESCRIBE CONSULTAS_DATOS; 

    SELECT P.NOMBRECOMPLETO, COUNT(CD.PARTIDO) AS "#CONSULTAS"
    FROM PARTIDOS P, CONSULTAS_DATOS CD
    WHERE P.IDPARTIDO = CD.PARTIDO
        AND CD.RESPUESTA = 'Si'
        AND CD.CERTIDUMBRE > 0.8
    GROUP BY P.NOMBRECOMPLETO;

-- Ampliación Práctica 2 

-- 1. Obtener el DNI de todos los votantes que tengan dos 6s en su telefono 
-- pero contemplar que no tienen mas de tres
    
    SELECT V.DNI, V.TELEFONO 
    FROM VOTANTES V  
    WHERE V.TELEFONO LIKE '%6%6%'
        AND NOT V.TELEFONO LIKE '%6%6%6%'

-- 2. Obtener el DNI de todos los votantes que tengan tres 6s en su telefono
-- pero contemplar que no tienen mas de tres, dos de ellos deben estar juntos

    SELECT V.DNI, V.TELEFONO 
    FROM VOTANTES V  
    WHERE V.TELEFONO LIKE '%6%6%'
        AND NOT V.TELEFONO LIKE '%6%6%6%'
        AND V.TELEFONO LIKE '%66%'

-- 3. Mostrar aquella localidad cuyo numero de habitantes acaba igual que su 
-- numero de provincia, mostrando tambien el nombre de la provincia a la que 
-- pertenece
    
    SELECT L.NOMBRE AS LOCALIDAD , P.NOMBRE AS PROVINCIA
    FROM LOCALIDADES L, PROVINCIAS P
    WHERE MOD(L.NUMEROHABITANTES,10) = L.PROVINCIA
        AND L.PROVINCIA = P.IDPROVINCIA;

-- 4. Mostrar el nombre completo de los votantes cuyo telefono acaba igual que 
-- su dni
    
    SELECT V.NOMBRECOMPLETO
    FROM VOTANTES V 
    WHERE MOD(V.DNI,10) = MOD(V.TELEFONO,10);
        
-- 5. Mostrar el nombre completo de aquellos votantes que contienen al menos 
-- una 'S' y cuya fecha de nacimiento es anterior al 12 de Febrero de 1990.

    SELECT NOMBRECOMPLETO 
    FROM VOTANTES 
    WHERE NOMBRECOMPLETO LIKE '%s%'
        AND FECHANACIMIENTO < '12021990';


-- 6. Usar el operador DISTINCT (http://www.w3schools.com/sql/sql_distinct.asp). 
-- Obtener todos los votantes que han participado en alguna consulta. Dichos 
-- votantes deben aparecer en orden decreciente de dni
    
    SELECT DISTINCT(C.VOTANTE)
    FROM CONSULTAS C
    ORDER BY C.VOTANTE DESC; 
    
-- 7. Mostrar el dni de aquellos votantes que han participado en mas de tres 
-- consultas 

    SELECT C.VOTANTE, COUNT(C.VOTANTE) AS CONTEO
    FROM CONSULTAS C
    HAVING COUNT(C.VOTANTE) > 3
    GROUP BY C.VOTANTE;

-- 8. Mostrar el nombre completo de los votantes que han participado en mas 
-- de tres consultas y especificar en cu?ntas consultas participaron  
-- (en orden creciente)

    SELECT V.NOMBRECOMPLETO, COUNT(C.VOTANTE) AS CONTEO
    FROM CONSULTAS C, VOTANTES V
    WHERE V.DNI = C.VOTANTE
    GROUP BY V.NOMBRECOMPLETO
    ORDER BY CONTEO ASC;

-- 9. Obtener el nombre de los votantes y el nombre de su localidad para 
-- aquellos votantes que han sido consultados en una localidad que tiene mas 
-- de 300000 habitantes
    
    SELECT V.NOMBRECOMPLETO, L.NOMBRE
    FROM VOTANTES V, LOCALIDADES L
    WHERE L.NUMEROHABITANTES > 300000
        AND V.LOCALIDAD = L.IDLOCALIDAD;

-- 10. Mostrar el nombre de cada partido politico y la maxima certidumbre que 
-- tiene para sus consultas

    SELECT P.NOMBRECOMPLETO, MAX(CD.CERTIDUMBRE)
    FROM PARTIDOS P, CONSULTAS_DATOS CD  
    WHERE CD.PARTIDO = P.IDPARTIDO
    GROUP BY P.NOMBRECOMPLETO;

-- 11. Mostrar el nombre del votante y su certidumbre media en todas las 
-- consultas en las que ha respondido de manera afirmativa

    SELECT V.NOMBRECOMPLETO, AVG(CD.CERTIDUMBRE) 
    FROM VOTANTES V, CONSULTAS C ,CONSULTAS_DATOS CD 
    WHERE CD.RESPUESTA = 'Si'
        AND V.DNI = C.VOTANTE
        AND CD.CONSULTA = C.EVENTO
    GROUP BY V.NOMBRECOMPLETO;
        
-- 12. Mostrar el nombre del votante y su certidumbre media en todas las 
-- consultas en las que ha respondido de manera afirmativa UNICAMENTE para 
-- aquellos votantes cuyo certidumbre media este entre 0'5 y 0'8.

    SELECT V.NOMBRECOMPLETO, AVG(CD.CERTIDUMBRE) 
    FROM VOTANTES V, CONSULTAS C ,CONSULTAS_DATOS CD 
    WHERE CD.RESPUESTA = 'Si'
        AND V.DNI = C.VOTANTE
        AND CD.CONSULTA = C.EVENTO
        HAVING AVG(CD.CERTIDUMBRE) BETWEEN 0.5 AND 0.8
    GROUP BY V.NOMBRECOMPLETO;


-- 13. Mostrar el nombre de los partidos y la certidumbre media obtenida para 
-- cada partido considerando s?lo aquellas consultas en las que el encuestado 
-- ha contestado negativamente a votar a dicho partido y con una certidumbre 
-- significativa (por encima del 60%)

    SELECT P.NOMBRECOMPLETO, AVG(CERTIDUMBRE) AS CERTIDUMBRE_MEDIA
    FROM CONSULTAS_DATOS CD, PARTIDOS P
    WHERE CD.RESPUESTA = 'No'
        AND CD.CERTIDUMBRE > 0.6
        AND P.IDPARTIDO = CD.PARTIDO
    GROUP BY P.NOMBRECOMPLETO;




