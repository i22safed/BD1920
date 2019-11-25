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
    
    