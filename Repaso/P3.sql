
-- Practica 3. 

-- 1. Obtener el nombre de todos los votantes cuyo DNI acaba igual 
-- que el identificador de su localidad mas 1. Es decir, el votante
-- con DNI 30948214 debe mostrarse si pertenece a la localidad nÃºmero 3. 

        SELECT V.NOMBRECOMPLETO, V.DNI, V.LOCALIDAD
        FROM VOTANTES V 
        WHERE V.LOCALIDAD+1 = MOD(V.DNI,10);
  
-- 2. Obtener el nombre de todos los votantes así como el nombre de 
-- la localidad en la que viven teniendo en cuenta que todos los 
-- que sean de la provincia de Cordoba (identificador de localidad 1, 
-- 2 y 3) se han mudado a Madrid. 
    
        SELECT * FROM LOCALIDADES;
        
        SELECT V.NOMBRECOMPLETO, L.NOMBRE 
        FROM VOTANTES V, LOCALIDADES L 
        WHERE L.IDLOCALIDAD = DECODE(V.LOCALIDAD,1,9,2,9,3,9,V.LOCALIDAD)
     
     /*
        DECODE(expr, value1 [, return1, value2, return2....,] default )
        
        Traduce una expresión a un valor de retorno. Si expr es igual a value1, 
        la función devuelve Return1. Si expr es igual a value2, la función 
        devuelve Return2. Y asi sucesivamente. Si expr no es igual a ningun 
        valor la funcion devuelve el valor por defecto.
     */
     
-- 3. Mostrar	las	siglas	de	aquellos	partidos	que	han	
-- participado	un	mayor	numero	de	veces	en	eventos.	 
    
    
    SELECT SIGLAS 
    FROM PARTIDOS P, (
        SELECT SUB.PART, SUB.CONTEO
        FROM (
            SELECT EVR.PARTIDO AS PART, COUNT(EVR.PARTIDO) AS CONTEO
            FROM EVENTOS_RESULTADOS EVR 
            GROUP BY EVR.PARTIDO
        ) SUB 
        WHERE SUB.CONTEO = (    -- EL CONTEO DEBE DE SER IGUAL QUE EL MÁXIMO PARA
                                -- SACAR LAS SIGLAS DEL MÁXIMO
            SELECT MAX(COUNT(EVR.PARTIDO))
            FROM EVENTOS_RESULTADOS EVR 
            GROUP BY EVR.PARTIDO
        )
    ) SUB1 
    WHERE SUB1.PART = P.IDPARTIDO;

-- 4. Obtener el DNI del segundo votante de mas edad de entre todos
-- los votantes existentes en la base de datos. 
    
    SELECT V1.DNI 
    FROM VOTANTES V1 
    WHERE V1.FECHANACIMIENTO = (
        SELECT MIN(FECHANACIMIENTO) 
        FROM (
            SELECT V.DNI, V.FECHANACIMIENTO     -- ELIMINAMOS EL VOTANTE MAS 
            FROM VOTANTES V                     -- VIEJO PARA VOLVER A COGER EL 
            WHERE V.FECHANACIMIENTO != (        -- MINIMO
                SELECT MIN(FECHANACIMIENTO)
                FROM VOTANTES
            )
            ORDER BY V.FECHANACIMIENTO
        ) SUB 
    )         
 
-- 5. Obtener el DNI del votante y el numero de veces que dicho 
-- votante ha participado en una consulta, mostrando el resultado 
-- de manera descendente en cuanto a numero de participaciones. 
    
        SELECT CD.VOTANTE, COUNT(CD.VOTANTE) AS CONTEO
        FROM CONSULTAS CD 
        GROUP BY CD.VOTANTE
        ORDER BY CONTEO DESC; 
 
-- 6. Obtener el DNI del votante y el numero de veces que dicho 
-- votante ha participado en una consulta, mostrando el resultado 
-- de manera descendente en cuanto a nÃºmero de participaciones. 
-- Solo se mostraran aquellos votantes cuya participaciÃ³n ha 
-- sido mayor que la media de participaciones de todos los votantes.  
 
        
        SELECT CD.VOTANTE, COUNT(CD.VOTANTE) AS CONTEO
        FROM CONSULTAS CD 
        HAVING COUNT(CD.VOTANTE) > (        
            SELECT AVG(COUNT(CD.VOTANTE))
            FROM CONSULTAS CD 
            GROUP BY CD.VOTANTE
        )
        GROUP BY CD.VOTANTE
        ORDER BY CONTEO DESC;
 
-- 7. Obtener el nombre de los votantes cuya participacion ha sido 
-- mayor que la media de participaciones de todos los votantes. 

    SELECT V.NOMBRECOMPLETO , SUB.CONTEO
    FROM VOTANTES V, ( 
        SELECT CD.VOTANTE, COUNT(CD.VOTANTE) AS CONTEO
        FROM CONSULTAS CD 
        HAVING COUNT(CD.VOTANTE) > (        
            SELECT AVG(COUNT(CD.VOTANTE))
            FROM CONSULTAS CD 
            GROUP BY CD.VOTANTE
        )
        GROUP BY CD.VOTANTE
    ) SUB 
    WHERE V.DNI = SUB.VOTANTE
    ORDER BY SUB.CONTEO;  
    
-- 8. Obtener el DNI del votante y el numero de veces que dicho 
-- votante ha participado en una consulta, mostrando el resultado de 
-- manera descendente en cuanto a numero de participaciones y no 
-- mostrando los resultados del segundo votante de mas edad. 

    SELECT C.VOTANTE, COUNT(C.VOTANTE) AS CONTEO 
    FROM CONSULTAS C
    WHERE C.VOTANTE != (
        SELECT DNI 
        FROM VOTANTES 
        WHERE FECHANACIMIENTO = (
            SELECT MIN(V1.FECHANACIMIENTO)
            FROM VOTANTES V1 
            WHERE V1.FECHANACIMIENTO != (
                SELECT MIN(V.FECHANACIMIENTO) 
                FROM VOTANTES V
            ) 
        )
    )
    GROUP BY C.VOTANTE
    ORDER BY CONTEO DESC;

-- Practica 3 - Ampliacion. 

-- 1. Mostrar el nombre de pila (sin apellidos), nombre de localidad
-- y nombre de comunidad de los votantes pertenecientes a las localidades
-- 1, 3 o 9. Personaliza el titulo de dichas columnas.

    SELECT SUBSTR(V.NOMBRECOMPLETO,1,INSTR(V.NOMBRECOMPLETO,' ',1,1)) AS NOMBRE, 
        L.NOMBRE, 
        P.COMUNIDAD
    FROM VOTANTES V, LOCALIDADES L, PROVINCIAS P
    WHERE V.LOCALIDAD = L.IDLOCALIDAD -- PARA EL NOMBRE DE LA LOCALIDAD
        AND L.PROVINCIA = P.IDPROVINCIA -- PARA EL NOMBRE DE LA COMUNIDAD
        AND (V.LOCALIDAD = 1 OR V.LOCALIDAD = 3 OR V.LOCALIDAD = 9); -- FILTRAR IDLOCALIDAD
        
    /*
        INSTR(cadena, subcadena, posicion, ocurrencia)
            * cadena -> cadena donde se quiere realizar la busqueda 
            * subcadena -> subcadena que se quiere encontrar 
            * posicion -> posición donde comienza la búsqueda 
            * ocurrencia -> numero de la ocurrencia que se quiere devolver la pos
    */
    
-- 2. Ordenar las localidades en base a su identificador de localidad,
-- de manera que el resultado quede asi: 

    SELECT L1.NOMBRE || ' va antes que ' || L2.NOMBRE
    FROM LOCALIDADES L1, LOCALIDADES L2
    WHERE L1.IDLOCALIDAD + 1 = L2.IDLOCALIDAD;

-- 3. Obtener el nombre de las localidades que tienen un numero de 
-- habitantes mayor que la localidad del votante que es el segundo 
-- votante de mas edad de entre todos los votantes existentes en la 
-- base de datos 

    SELECT L1.NOMBRE, L1.NUMEROHABITANTES
    FROM LOCALIDADES L1, (
        SELECT V2.LOCALIDAD, L.NOMBRE, L.NUMEROHABITANTES 
        FROM VOTANTES V2 , LOCALIDADES L 
        WHERE V2.FECHANACIMIENTO = (
            SELECT MIN(V1.FECHANACIMIENTO)
            FROM VOTANTES V1 
            WHERE V1.FECHANACIMIENTO != (
                SELECT MIN(V.FECHANACIMIENTO) 
                FROM VOTANTES V  
            ) 
        )
            AND V2.LOCALIDAD = L.IDLOCALIDAD
    ) SUB 
    WHERE L1.NUMEROHABITANTES > SUB.NUMEROHABITANTES;
    
    
-- 4. Mostrar el nombre completo de los votantes, numero de localidad 
-- a la que pertenecen y "mayoria edad"? (mostrara: 'mayor edad' y 'menor
-- edad' en lugar de su fecha de nacimiento en funcion de si son mayores 
-- de edad o no). Los resultados de esta consulta solo recogeran a los 
-- votantes de las localidades 2, 4 y 8 y quedaran ordenados por la 
-- nueva columna de mayoria edad?.

    SELECT V.NOMBRECOMPLETO AS NOMBRE , V.LOCALIDAD AS LOCALIDAD, 
        CASE WHEN V.FECHANACIMIENTO > '01011993' THEN 'MAYOR' ELSE 'MENOR' END AS MAYORIA
    FROM VOTANTES V 
    WHERE V.LOCALIDAD = 2 OR  
        V.LOCALIDAD = 4 OR 
        V.LOCALIDAD = 8
    ORDER BY MAYORIA ASC; 
        
-- 5. Muestra el nombre de las localidades, su numero de habitantes y 
-- el nombre de la comunidad a la que pertenecen. Se recogeran solo 
-- aquellas localidades cuyo numero de provincia sea el 1, 2, o 3 
-- y que tengan mayor numero de habitantes que alguna de las localidades
-- de la provincia numero 4. 
    
    SELECT L.NOMBRE, L.NUMEROHABITANTES, P.NOMBRE 
    FROM LOCALIDADES L, PROVINCIAS P 
    WHERE (L.IDLOCALIDAD = 1 
        OR L.IDLOCALIDAD = 2 
        OR L.IDLOCALIDAD = 3)
        AND (
            L.PROVINCIA = P.IDPROVINCIA 
        )
        AND L.NUMEROHABITANTES > ANY (
            SELECT L.NUMEROHABITANTES 
            FROM LOCALIDADES L
            WHERE L.PROVINCIA = 4     
        )


-- 6. Obtener el nombre de los votantes cuya participacion ha sido menor
-- que la media de participaciones de todos los votantes a pesar de (en caso de) 
-- encontrarse en situacion laboral de 'Activo'.

    SELECT V.NOMBRECOMPLETO, V.SITUACIONLABORAL, SUB.CONTEO
    FROM VOTANTES V, ( 
        SELECT C.VOTANTE, COUNT(C.VOTANTE) AS CONTEO
        FROM CONSULTAS C 
        GROUP BY C.VOTANTE
    ) SUB 
    WHERE V.DNI = SUB.VOTANTE
        AND SUB.CONTEO < (
            SELECT AVG(COUNT(C.VOTANTE))
            FROM CONSULTAS C 
            GROUP BY C.VOTANTE    
        )
        AND SITUACIONLABORAL = 'Activo'

-- 7. Mostrar el nombre de las localidades ordenadas de mayor a menor 
-- nivel de estudiosSuperiores medio de sus votantes. 

    SELECT L.NOMBRE, SUB.ALGO, SUB.NINGUNO
    FROM LOCALIDADES L , ( 
        SELECT  V.LOCALIDAD, 
            COUNT(CASE WHEN V.ESTUDIOSSUPERIORES != 'Ninguno' THEN 1 ELSE NULL END) AS ALGO,
            COUNT(CASE WHEN V.ESTUDIOSSUPERIORES = 'Ninguno' THEN 1 ELSE NULL END) AS NINGUNO
        FROM VOTANTES V 
        GROUP BY V.LOCALIDAD
    ) SUB
    WHERE L.IDLOCALIDAD = SUB.LOCALIDAD
    ORDER BY SUB.ALGO DESC
    
-- 8. Mostrar aquellas localidades cuyos votantes tienen un nivel de 
-- estudiosSuperiores medio mayor que todas las medias de estudiosSuperiores 
-- de las provincias.

    /*
        (?)
    */


