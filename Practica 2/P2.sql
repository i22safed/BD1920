-- Practica 2. 

-- 1.Obtener el nombre de todos los votantes cuyo segundo apellido acaba en “n”

    -- Se utiliza el operador LIKE en la clausula WHERE para especificar un 
    -- patrón en una columna. Se puede añadir dos argumentos para detectar la 
    -- expresión regular: 
      --  · % indica cero o varios caracteres. 
      --  · _ indica solo un carácter. 
      --    * [...] LIKE 'a%' -> empiece por 'a' 
      --    * [...] LIKE '%a' -> termine en 'a' 
      --    * [...] LIKE '%a%' -> contenga una 'a'
      --    * [...] LIKE '_a%' -> la segunda letra sea una 'a'

    SELECT V.NOMBRECOMPLETO FROM VOTANTES V
    WHERE V.NOMBRECOMPLETO LIKE '%n';
    
-- 2.Obtener el DNI de todos los votantes que tengan al menos tres 5s en su DNI

    SELECT V.DNI FROM VOTANTES V
    WHERE V.DNI LIKE '%5%5%5%';
    
    -- Cumple el patrón de que tiene que haber 3 cincos dando igual la secuencia 

-- 3.Obtener el nombre de aquellos votantes cuya fecha de nacimiento sea 
-- posterior al 1 de Enero de 1990

    SELECT V.NOMBRECOMPLETO FROM VOTANTES V
    WHERE V.FECHANACIMIENTO > '01011990';

-- 4.Obtener el nombre del votante y el nombre de la localidad de aquellos 
-- votantes que han ejercido el voto en una localidad que tiene más de 300000 
-- habitantes

    SELECT V.NOMBRECOMPLETO
    FROM VOTANTES V, LOCALIDADES L      -- AÑADIDAS LAS DOS TABLAS NECESARIAS 
    WHERE V.LOCALIDAD = L.IDLOCALIDAD   -- LOS IDs DEBEN DE COINCIDIR 
    AND L.NUMEROHABITANTES > 300000;    -- Y EL NUMERO DE HABITANTES DEBE DE SER
                                        -- MAYOR QUE 300000

-- 5.Obtener el nombre del votante y el nombre de la comunidad de aquellos 
-- votantes que han ejercido el voto en una localidad que tiene más de 300000 
-- habitantes.
    
    SELECT VOTANTES.NOMBRECOMPLETO, PROVINCIAS.COMUNIDAD 
    FROM  VOTANTES, PROVINCIAS, LOCALIDADES 
    WHERE VOTANTES.LOCALIDAD = LOCALIDADES.IDLOCALIDAD  
    AND LOCALIDADES.PROVINCIA = PROVINCIAS.IDPROVINCIA 
    AND LOCALIDADES.NUMEROHABITANTES > 300000;
                -- [EXPLICAR]

-- 6.Obtener el identificador del partido y el número de datos o consultas 
-- que se tiene para dicho partido de entre todos los partidos sobre los 
-- que se han realizado alguna consulta

    SELECT CD.PARTIDO, COUNT(CD.PARTIDO) 
    FROM CONSULTAS_DATOS CD
    GROUP BY PARTIDO;
    -- REALIZAMOS UN CONTEO DE FRECUENCIAS CON SOLO UNA TABLA, ES DECIR, CUANTAS
    -- VECES APARECE CADA UNO DE LOS IDENTIFICADORES DE LOS PARTIDOS A LO LARGO 
    -- DE LA TABLA DE CONSULTAS_DATOS
    
-- 7.Mostrar el identificador de partido y el número de consultas realizadas 
-- para cada partido.

    SELECT P.IDPARTIDO AS PARTIDO, COUNT(CD.PARTIDO) AS CONTEO
    FROM PARTIDOS P, CONSULTAS_DATOS CD
    WHERE P.IDPARTIDO = CD.PARTIDO
    GROUP BY P.IDPARTIDO;

-- 8.Mostrar el nombre del partido político sobre el que se han realizado más 
-- de 10 consultas.

    SELECT P.NOMBRECOMPLETO
    FROM PARTIDOS P, CONSULTAS_DATOS CD 
    WHERE P.IDPARTIDO = CD.PARTIDO
    GROUP BY P.NOMBRECOMPLETO
    HAVING COUNT(CD.PARTIDO) > 10; 
    
-- 9.Mostrar el nombre del partido y el número de consultas realizadas para 
-- aquellos partidos que aparecen en más de 10 consultas. 
    
    SELECT P.NOMBRECOMPLETO, COUNT(CD.PARTIDO)
    FROM PARTIDOS P, CONSULTAS_DATOS CD 
    WHERE P.IDPARTIDO = CD.PARTIDO
    GROUP BY P.NOMBRECOMPLETO
    HAVING COUNT(CD.PARTIDO) > 10;    
    
-- 10. Mostrar el nombre de los partidos y el número de consultas realizadas
-- para cada partido considerando sólo aquellas consultas en las que el 
-- encuestado ha contestado afirmativamente a votar a dicho partido y con una 
-- certidumbre por encima del 80%, es decir, 0.8. 
    
    SELECT P.NOMBRECOMPLETO, COUNT(P.NOMBRECOMPLETO) AS CONTEO
    FROM PARTIDOS P, CONSULTAS_DATOS CD 
    WHERE P.IDPARTIDO = CD.PARTIDO
    AND CD.RESPUESTA = 'Si' 
    AND CD.CERTIDUMBRE > 0.8
    GROUP BY P.NOMBRECOMPLETO;
    
-- PRACTICA 2 - AMPLIACIÓN 

-- 1.Obtener el DNI de todos los votantes que tengan dos 6s en su teléfono 
-- pero contemplar que no tienen más de tres
    
    SELECT DNI 
    FROM VOTANTES 
    WHERE TELEFONO LIKE '%6%6%' -- CASO PARA QUE TENGA MAS DE 2 SEISES
        AND NOT TELEFONO LIKE '%6%6%6%';    -- PERO QUE NO TENGA MAS DE 3 SEISES

-- 2.Obtener el DNI de todos los votantes que tengan tres 6s en su teléfono 
-- pero contemplar que no tienen más de tres, dos de ellos deben estar juntos

    SELECT TELEFONO 
    FROM VOTANTES 
    WHERE TELEFONO LIKE '%6%6%6%' 
        AND NOT TELEFONO LIKE '%6%6%6%6%'
        AND TELEFONO LIKE '%66%';

-- 3.Mostrar aquella localidad cuyo número de habitantes acaba igual que su 
-- número de provincia, mostrando también el nombre de la provincia a la que 
-- pertenece

    SELECT L.NOMBRE
    FROM LOCALIDADES L
    WHERE L.IDLOCALIDAD = L.PROVINCIA;


-- 4.Mostrar el nombre completo de los votantes cuyo teléfono acaba igual que 
-- su dni

    SELECT NOMBRECOMPLETO FROM VOTANTES
    WHERE MOD(TELEFONO,10) = MOD(DNI,10);

-- 5.Mostrar el nombre completo de aquellos votantes que contienen al menos 
-- una 'S' y cuya fecha de nacimiento es anterior al 12 de Febrero de 1990.
    
        SELECT NOMBRECOMPLETO FROM VOTANTES
        WHERE NOMBRECOMPLETO LIKE '%S%'
            OR NOMBRECOMPLETO LIKE '%s%'
            AND FECHANACIMIENTO < '12021990';

-- 6.Usar el operador DISTINCT (http://www.w3schools.com/sql/sql_distinct.asp). 
-- Obtener todos los votantes que han participado en alguna consulta. Dichos 
-- votantes deben aparecer en orden decreciente de dni

        SELECT V.NOMBRECOMPLETO, V.DNI  
        FROM VOTANTES V
        WHERE EXISTS( 
                SELECT DISTINCT(C.VOTANTE) 
                FROM CONSULTAS C
                WHERE V.DNI = C.VOTANTE
        )
        ORDER BY V.DNI DESC; 
            
        -- Seleccionamos el nombre completo y el DNI de aquellos votantes 
        -- que existen en la consulta de los votantes que han participado 
        -- en alguna consulta. Y ordenados de manera decreciente. 

-- 7.Mostrar el dni de aquellos votantes que han participado en más de tres 
-- consultas 
    
        SELECT C.VOTANTE, COUNT(C.VOTANTE)
        FROM CONSULTAS C
        -- WHERE COUNT(C.VOTANTE) > 3  -> EL WHERE NO PUEDE IR CON EL COUNT 
        HAVING COUNT(C.VOTANTE) > 3 
        GROUP BY C.VOTANTE; 
    
-- 8.Mostrar el nombre completo de los votantes que han participado en más de 
-- tres consultas y especificar en cuantas consultas participaron  
-- (en orden creciente)

    SELECT V.NOMBRECOMPLETO, CONT 
    FROM VOTANTES V , (
        SELECT C.VOTANTE AS VOT, COUNT(C.VOTANTE) AS CONT 
        FROM CONSULTAS C
        HAVING COUNT(C.VOTANTE) > 3 
        GROUP BY C.VOTANTE
    )
    WHERE V.DNI = VOT
    ORDER BY CONT ASC;

-- 9. Obtener el nombre de los votantes y el nombre de su localidad para 
-- aquellos votantes que han sido consultados en una localidad que tiene más 
-- de 300000 habitantes

    -- [Hacer cuando sobre tiempo]
        
-- 10.Mostrar el nombre de cada partido político y la máxima certidumbre que 
-- tiene para sus consultas

-- 11.Mostrar el nombre del votante y su certidumbre media en todas las 
-- consultas en las que ha respondido de manera afirmativa

-- 12.Mostrar el nombre del votante y su certidumbre media en todas las 
-- consultas en las que ha respondido de manera afirmativa ÚNICAMENTE para 
-- aquellos votantes cuyo certidumbre media est? entre 0'5 y 0'8.

-- 13.Mostrar el nombre de los partidos y la certidumbre media obtenida para 
-- cada partido considerando sólo aquellas consultas en las que el encuestado 
-- ha contestado negativamente a votar a dicho partido y con una certidumbre 
-- significativa (por encima del 60%)


    