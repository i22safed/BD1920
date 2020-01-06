
-- Práctica 3

-- 1-Obtener el nombre de todos los votantes cuyo 
-- DNI acaba igual que el identificador de su localidad 
-- más 1. Es decir, el votante con DNI 30948214 debe 
-- mostrarse si pertenece a la localidad número 3. 

        SELECT V.NOMBRECOMPLETO FROM VOTANTES V
        WHERE V.DNI LIKE CONCAT('%', V.LOCALIDAD+1);

-- 2 Obtener el nombre de todos los votantes así como 
-- el nombre de la localidad en la que viven teniendo 
-- en cuenta que todos los que sean de la provincia de 
-- Córdoba (identificador de localidad 1, 2 y 3) se han 
-- mudado a Madrid.

        SELECT V.NOMBRECOMPLETO, L.NOMBRE 
        FROM VOTANTES V, LOCALIDADES L
        WHERE L.IDLOCALIDAD = 
        DECODE(V.LOCALIDAD,1,9,2,9,3,9,V.LOCALIDAD);

-- 3. Mostrar las siglas de aquellos partidos que han 
-- participado un mayor número de veces en eventos

        SELECT P.SIGLAS  
        FROM(   
            SELECT  PARTIDO, COUNT(EVR.PARTIDO) AS NO_EVENTOS   
            FROM EVENTOS_RESULTADOS EVR   
            GROUP BY EVR.PARTIDO) P_NEVE , PARTIDOS P 
            WHERE P_NEVE.PARTIDO = P.IDPARTIDO 
            AND NO_EVENTOS >= (   
                SELECT MAX(NO_EVENTOS) AS MAXIMO    
                FROM (
                    SELECT  PARTIDO, COUNT(EVR.PARTIDO) AS NO_EVENTOS    
                    FROM EVENTOS_RESULTADOS EVR   GROUP BY EVR.PARTIDO
                )   
            );
        
--4. Obtener el DNI del segundo votante de más edad de entre todos los 
-- votantes existentes en la base de datos.
        
        SELECT DNI 
        FROM VOTANTES 
        WHERE FECHANACIMIENTO = (
            SELECT MIN(SUB2.FECHANACIMIENTO) 
            FROM (        
                SELECT VOT.DNI, VOT.FECHANACIMIENTO        
                FROM VOTANTES VOT   
                WHERE VOT.FECHANACIMIENTO != (              
                    SELECT MIN(FECHANACIMIENTO)                      
                    FROM VOTANTES     
                )   
            ) SUB2 
        ); 
    
    
-- 5- Obtener el DNI del votante y el numero de veces que dicho 
-- votante ha participado en una consulta, mostrando el resultado de 
-- manera descendente en cuanto a número de participaciones. 


        SELECT C.VOTANTE, COUNT(C.VOTANTE)
        FROM CONSULTAS C, (
            SELECT DISTINCT(VOTANTE) 
            FROM CONSULTAS
        ) VOTS 
        WHERE VOTS.VOTANTE = C.VOTANTE
        GROUP BY C.VOTANTE
        ORDER BY C.VOTANTE DESC;

-- 6. Obtener el DNI del votante y el numero de veces que dicho votante 
-- ha participado en una consulta, mostrando el resultado de manera 
-- descendente en cuanto a número de participaciones. Sólo se mostrarán 
-- aquellos votantes cuya participación ha sido mayor que la media de 
-- participaciones de todos los votantes.  

        SELECT C.VOTANTE, COUNT(C.VOTANTE)
        FROM CONSULTAS C   
            HAVING COUNT(C.VOTANTE) > (                 
                SELECT AVG(PART) FROM (                        
                    SELECT COUNT(CON.VOTANTE) AS PART          
                    FROM CONSULTAS CON        
                    GROUP BY VOTANTE   ) 
            ) 
        GROUP BY C.VOTANTE 
        ORDER BY COUNT(C.VOTANTE) DESC; 
        
        
-- 7. Obtener el nombre de los votantes cuya participación ha sido mayor 
-- que la media de participaciones de todos los votantes. 

        SELECT V.NOMBRECOMPLETO AS NOMBRE, SUB.VOTS AS VECES
        FROM VOTANTES V, (
            SELECT  * 
            FROM (
                SELECT C.VOTANTE, COUNT(C.VOTANTE) AS VOTS
                FROM CONSULTAS C
                GROUP BY C.VOTANTE
            ) CONS
            WHERE CONS.VOTS > (
                SELECT AVG(COUNT(C.VOTANTE)) AS VOTS
                FROM CONSULTAS C
                GROUP BY C.VOTANTE
            )
        ) SUB
        WHERE V.DNI = SUB.VOTANTE
        ORDER BY SUB.VOTS DESC;
    
        
-- 8. Obtener el DNI del votante y el numero de veces que dicho votante 
-- ha participado en una consulta, mostrando el resultado de manera 
-- descendente en cuanto a número de participaciones y no mostrando los 
-- resultados del segundo votante de más edad. 

        
        SELECT VOTANTE, COUNT(VOTANTE) AS CONTEO
        FROM CONSULTAS C, (          
             SELECT * FROM VOTANTES V1
             WHERE FECHANACIMIENTO != (
                 SELECT MIN(V.FECHANACIMIENTO) 
                 FROM VOTANTES V 
                 WHERE V.FECHANACIMIENTO != (             
                     SELECT MIN(FECHANACIMIENTO) 
                     FROM VOTANTES 
                 )
            )  
        ) SPLIT
        WHERE C.VOTANTE = SPLIT.DNI
        GROUP BY C.VOTANTE
        ORDER BY CONTEO DESC; 


-- Práctica 3. Ampliación 

-- 1. Mostrar el nombre de pila (sin apellidos), nombre de 
-- localidad y nombre de comunidad de los votantes pertenecientes 
-- a las localidades 1, 3 ó 9. Personaliza el título de dichas 
-- columnas.

        SELECT V.NOMBRECOMPLETO AS NOMBRE, L.NOMBRE AS LOCALIDAD, P.COMUNIDAD AS COMUNIDAD
        FROM VOTANTES V,  LOCALIDADES L, PROVINCIAS P
        WHERE V.LOCALIDAD = L.IDLOCALIDAD 
            AND L.PROVINCIA = P.IDPROVINCIA
            AND (
                L.IDLOCALIDAD = 1 OR L.IDLOCALIDAD = 3 OR L.IDLOCALIDAD = 9
            );

-- 2. Ordenar las localidades en base a su identificador de localidad, 
-- de manera que el resultado quede así: 

        SELECT L1.NOMBRE || ' va antes que ' || L2.NOMBRE AS ORDENACIÓN
        FROM LOCALIDADES L1, LOCALIDADES L2 
        WHERE L1.IDLOCALIDAD + 1 = L2.IDLOCALIDAD; 

-- 3. Obtener el nombre de las localidades que tienen un número de habitantes 
-- mayor que la localidad del votante que es el segundo votante de más edad de 
-- entre todos los votantes existentes en la base de datos

        SELECT NOMBRE 
        FROM LOCALIDADES 
        WHERE NUMEROHABITANTES > (
            
            SELECT L.NUMEROHABITANTES 
            FROM LOCALIDADES L
            WHERE L.IDLOCALIDAD = (
               
                SELECT LOCALIDAD 
                FROM VOTANTES 
                WHERE FECHANACIMIENTO = (
                    
                    SELECT MIN(SUB2.FECHANACIMIENTO) 
                    FROM (        
                        SELECT VOT.DNI, VOT.FECHANACIMIENTO        
                        FROM VOTANTES VOT   
                        WHERE VOT.FECHANACIMIENTO != (              
                            SELECT MIN(FECHANACIMIENTO)                      
                            FROM VOTANTES     
                        )   
                    ) SUB2 
                )
            )
        ); 
        
        
-- 4. Mostrar el nombre completo de los votantes, número de localidad a la 
-- que pertenecen y “mayoria edad” (mostrará: 'mayor edad' y 'menor edad' 
-- en lugar de su fecha de nacimiento en función de si son mayores de edad 
-- o no). Los resultados de esta consulta sólo recogerán a los votantes 
-- de las localidades 2, 4 y 8 y quedarán ordenados por la nueva columna 
-- de “mayoria edad”.

        -- 1. Seleccionamos primeramente los que son mayores de edad 
        SELECT V1.NOMBRECOMPLETO, V1.LOCALIDAD, 
                DECODE(V1.FECHANACIMIENTO,V1.FECHANACIMIENTO,' MAYOR') AS MAYORIA
        FROM VOTANTES V1
        WHERE V1.FECHANACIMIENTO < '01012000' 
            AND (V1.LOCALIDAD = 2 OR V1.LOCALIDAD = 4 OR V1.LOCALIDAD = 8)
        
        UNION   -- Realizamos la UNION de cada una de las consultas 
        
        -- 2. Seleccionamos después los que son menores de edad 
        SELECT V2.NOMBRECOMPLETO, V2.LOCALIDAD,
                DECODE(V2.FECHANACIMIENTO,V2.FECHANACIMIENTO,' MENOR') AS MAYORIA
        FROM VOTANTES V2
        WHERE V2.FECHANACIMIENTO > '01012000'
            AND (V2.LOCALIDAD = 2 OR V2.LOCALIDAD = 4 OR V2.LOCALIDAD = 8)

-- 5. Muestra el nombre de las localidades, su número de habitantes y el nombre 
-- de la comunidad a la que pertenecen. Se recogerán sólo aquellas localidades 
-- cuyo número de provincia sea el 1, 2, o 3 y que tengan mayor número de 
-- habitantes que alguna de las localidades de la provincia número 4. 


    SELECT L.NOMBRE, L.NUMEROHABITANTES, P.COMUNIDAD 
    FROM LOCALIDADES L, PROVINCIAS P
    WHERE L.PROVINCIA = P.IDPROVINCIA
        AND (P.IDPROVINCIA = 1 OR P.IDPROVINCIA = 2 OR P.IDPROVINCIA = 3)
        AND L.NUMEROHABITANTES > 
            (   
                SELECT NUMEROHABITANTES 
                FROM LOCALIDADES
                WHERE IDLOCALIDAD = 4
                                    
            ); 
    
    
    
-- 6. Obtener el nombre de los votantes cuya participación ha sido menor que 
-- la media de participaciones de todos los votantes a pesar de encontrarse 
-- en situación laboral de 'Activo'. 

    SELECT * FROM CONSULTAS; 

    SELECT V.NOMBRECOMPLETO AS NOMBRE, CTEO.CONTEO 
    FROM VOTANTES V,(
            SELECT C.VOTANTE, COUNT(C.VOTANTE) AS CONTEO 
            FROM CONSULTAS C 
            GROUP BY C.VOTANTE
    ) CTEO   
    WHERE V.DNI = CTEO.VOTANTE
        AND CTEO.CONTEO < (
            SELECT AVG(COUNT(C.VOTANTE))    -- SUBCONSULTA PARA HALLAR EL
            FROM CONSULTAS C                -- PROMEDIO DE LAS VITACIONES 
            GROUP BY C.VOTANTE
        );
    

-- 7. Mostrar el nombre de las localidades ordenadas de mayor a menor nivel de 
-- estudiosSuperiores medio de sus votantes. 

        SELECT L.NOMBRE AS LOCALIDAD, CONTEO 
        FROM LOCALIDADES L,  (
            SELECT LOCALIDAD, COUNT(ESTUDIOSSUPERIORES) AS CONTEO
            FROM ( 
                SELECT V.ESTUDIOSSUPERIORES, V.LOCALIDAD
                FROM VOTANTES V
            )
            GROUP BY LOCALIDAD
            ORDER BY CONTEO DESC
        ) 
        WHERE L.IDLOCALIDAD = LOCALIDAD; 
        

-- 8. Mostrar aquellas localidades cuyos votantes tienen un nivel de 
-- estudiosSuperiores medio mayor que todas las medias de estudiosSuperiores 
-- de las provincias.
 
        SELECT * 
        FROM (
            SELECT L.NOMBRE AS LOCALIDAD, CONTEO 
            FROM LOCALIDADES L,  (
                SELECT LOCALIDAD, COUNT(ESTUDIOSSUPERIORES) AS CONTEO
                FROM ( 
                    SELECT V.ESTUDIOSSUPERIORES, V.LOCALIDAD
                    FROM VOTANTES V
                )
                GROUP BY LOCALIDAD
                ORDER BY CONTEO DESC
            ) 
            WHERE L.IDLOCALIDAD = LOCALIDAD
        ) WHERE CONTEO > (        
            SELECT AVG(COUNT(ESTUDIOSSUPERIORES))
            FROM ( 
                SELECT V.ESTUDIOSSUPERIORES, V.LOCALIDAD
                FROM VOTANTES V
            )
            GROUP BY LOCALIDAD
        )
        
        
        
        
 