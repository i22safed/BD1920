
-- Practica 4 PLSQL

-- 1. Muestre por pantalla el clasico "Hola mundo!", pero ademas muestre la 
-- fecha actual

    SET SERVEROUTPUT ON; 
    DECLARE
        CAD VARCHAR2(64) := 'Hola mundo !'; /*CADENAS SIEMPRE CON '' */
        FECHA DATE;
    BEGIN 
        DBMS_OUTPUT.PUT_LINE(CAD);
        SELECT TO_CHAR(Sysdate, 'dd/mm/yyyy') 
            INTO FECHA 
            FROM DUAL; 
        DBMS_OUTPUT.PUT_LINE('La fecha de hoy es: ' || FECHA);
    END; 

-- 2. Muestre el primer APELLID y el DNI del votante mas antiguo, su 
-- respuesta debe cumplir el formato:"APELLIDO, con dni DNI es el/la 
-- votante con mas años." La  seleccion  del  primer apellido debe 
-- ser exclusivamente empleando PL/SQL

    SET SERVEROUTPUT ON; 
    DECLARE
        NOMBRE VOTANTES.NOMBRECOMPLETO%TYPE; 
        NO_DNI VOTANTES.DNI%TYPE;
        FECHA DATE; 
        APELLIDO VARCHAR2(64); 
        POSI NUMBER := 0; 
        POSF NUMBER := 0; 
    BEGIN 
        -- SELECCIONAMOS LA FECHA DE NACIMIENTO MAS ANTIGUA DE LA RELACIÓN 
        SELECT MIN(FECHANACIMIENTO)
        INTO FECHA 
        FROM VOTANTES;
        
        -- SELECCIONAMOS LAS POSICIONES DE INICIO Y FIN DEL PRIMER APELLIDO
        SELECT INSTR(NOMBRECOMPLETO,' ',1,1), INSTR(NOMBRECOMPLETO,' ',INSTR(NOMBRECOMPLETO,' ',1,1),1)
        INTO POSI, POSF 
        FROM VOTANTES
        WHERE FECHANACIMIENTO = FECHA; 
        
        -- SELECCIONAMOS EL DNI Y EL APELLIDO, REEMPLAZANDO LOS CARACTERES RAROS
        -- (NO ES OBLIGATORIO)
        SELECT REPLACE(SUBSTR(NOMBRECOMPLETO, POSI, POSF),'Ã±','ñ'), DNI 
        INTO APELLIDO, NO_DNI
        FROM VOTANTES 
        WHERE FECHANACIMIENTO = FECHA ; 
        
        -- MOSTRAMOS LOS VALORES OBTENIDOS
        DBMS_OUTPUT.PUT_LINE(APELLIDO || ', con dni ' || NO_DNI || ' es el/la votante con más años'); 
        
    END; 


-- 3. Mostrar  el  nombre  completo  y  el  correo  electronico  del  
-- votante  con  DNI  30983712, mostrando la informacion como sigue. 
-- <<Jose Perez Perez con correo: jpp@gmail.com>>

    SET SERVEROUTPUT ON; 
    DECLARE
        NOMBRE VOTANTES.NOMBRECOMPLETO%TYPE; 
        CORREO VOTANTES.EMAIL%TYPE; 
    BEGIN
        SELECT NOMBRECOMPLETO, EMAIL
        INTO NOMBRE, CORREO 
        FROM VOTANTES 
        WHERE DNI = 30983712;
    
        DBMS_OUTPUT.PUT_LINE(NOMBRE || ' CON CORREO: ' || CORREO);
    END; 


-- 4. El votante con DNI 30983712 desea que lo llamen Pepe en lugar 
-- de Jose. Sin embargo, este cambio no puede realizarse oficialmente 
-- en la base de datos puesto que no es su nombre real. Muestre el nombre 
-- completo de dicho votante pero apareciendo Pepe en lugar de Jose.

    SET SERVEROUTPUT ON; 
    DECLARE
        /* OJOCUIDAO ES % NO & */
        NOMBRE VOTANTES.NOMBRECOMPLETO%TYPE;  
    BEGIN 
        SELECT REPLACE(V.NOMBRECOMPLETO,'Jose','Pepe')
        INTO NOMBRE 
        FROM VOTANTES V
        WHERE V.DNI = 30983712;
        DBMS_OUTPUT.PUT_LINE(NOMBRE);
    END; 

    DROP TABLE AUDIT_TABLE ; 

-- 5. Teniendo en cuenta a los votantes, diga cuantos años hay entre la
-- persona de mayor edad con respecto a la de menos. Muestre ademas las
-- fechas de nacimiento del par de las personas. 

    SET SERVEROUTPUT ON; 
    DECLARE
        MAYOR VOTANTES.FECHANACIMIENTO%TYPE; 
        MENOR VOTANTES.FECHANACIMIENTO%TYPE; 
        DIFERENCIA NUMBER := 0; 
    BEGIN 
        SELECT FLOOR(MONTHS_BETWEEN(MAX(V.FECHANACIMIENTO), MIN(V.FECHANACIMIENTO))/12)
        INTO DIFERENCIA 
        FROM VOTANTES V;
        DBMS_OUTPUT.PUT_LINE(DIFERENCIA);
    END; 
    
-- 6. Muestre el nombre del partido y la incertidumbre correspondiente 
-- que durante la consulta de datos obtuvieron un "Si" de respuesta y 
-- ademas tengan un valor de certidumbre superior a la media de certidumbres. 
-- En este ejercicio solo podria realizar una unica consulta sobre la tabla 
-- CONSULTAS DATOS. Ademas muestre la media redondeada a 3 cifras significativas
-- a modo de informacion. Muestre los datos como sigue ordenados seguian el 
-- valor de certidumbre. 
    
    /*
        SOLAMENTE SE HACE UNA CONSULTA (EN EL CURSOR) A LA TABLA CONSULTAS_DATOS
        EL RESTO LA MEDIA Y EL MUESTREO DE LOS ELEMENTO SE REALIZA RECORRIENDO EL 
        CURSOR DOS VECES: 
            - PARA HALLAR LA MEDIA 
            - PARA MOSTRAR EL PARTIDO Y SU CERTIDUMBRE (EN CASO DE QUE LA CERTIDUMBRE
            SEA MAYOR QUE LA MEDIA DE TODAS LAS CERTIDUMBRES) 
    */
    
    DECLARE
        CURSOR C IS 
            SELECT P.NOMBRECOMPLETO, CD.RESPUESTA ,CD.CERTIDUMBRE 
            FROM CONSULTAS_DATOS CD, PARTIDOS P
            WHERE P.IDPARTIDO = CD.PARTIDO
                AND CD.RESPUESTA = 'Si'
                ORDER BY CD.CERTIDUMBRE DESC; 
        MEDIA NUMBER := 0; 
        PARTIDO PARTIDOS.NOMBRECOMPLETO%TYPE; 
        CERTIDUMBRE NUMBER := 0; 
        RESPUESTA CONSULTAS_DATOS.RESPUESTA%TYPE; 
        CONTADOR NUMBER := 0; 
    BEGIN
        
        /* CALCULADMOS LA MEDIA */
        OPEN C; 
            LOOP
                FETCH C INTO PARTIDO, RESPUESTA, CERTIDUMBRE; 
                EXIT WHEN C%NOTFOUND; 
                    MEDIA := MEDIA + CERTIDUMBRE;
                    CONTADOR := CONTADOR + 1; 
            END LOOP; 
            MEDIA := ROUND((MEDIA / CONTADOR),3); 
        CLOSE C;        
        
        DBMS_OUTPUT.PUT_LINE('La media de la certidumbre es: ' || MEDIA);
    
        /*
            AHORA MOSTRAMOS TODOS LOS PARTIDOS CUYA CERTIDUMBRE ES MAYOR QUE LA 
            MEDIA 
        */
        
        CONTADOR := 0 ; 
        
        OPEN C; 
            LOOP
                FETCH C INTO PARTIDO, RESPUESTA, CERTIDUMBRE;
                EXIT WHEN C%NOTFOUND;
                IF CERTIDUMBRE > MEDIA THEN
                    DBMS_OUTPUT.PUT_LINE(PARTIDO || ' ' || CERTIDUMBRE);
                    CONTADOR := CONTADOR + 1;  
                END IF; 
            END LOOP; 
        CLOSE C;
        DBMS_OUTPUT.PUT_LINE(CONTADOR);
    END; 
    
    








--