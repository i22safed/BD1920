


-- Practica 4 PLSQL

-- 1. Muestre por pantalla el clásico “Hola mundo”, pero además muestre la 
-- fecha actual

    SET SERVEROUTPUT ON;  -- INCLUIMOS EL SERVIDOR DE SALIDA 
    DECLARE
        FECHA varchar(50);
    BEGIN 
        SELECT TO_CHAR(SysDate,'YYYY/MM/DD') todays_date  -- PARA COGER LA FECHA DEL 
        INTO FECHA                                        -- SISTEMA  
        FROM DUAL;                                        -- TABLA DONDE SE ALMACENA
                                                          -- LA FECHA 
        DBMS_OUTPUT.PUT_LINE('Hola mundo! ' || FECHA);    -- IMPRIMIR LINEA DE FECHA
    END; 

-- 2. Muestre el primer APELLIDO y el DNI del votante más antiguo, su 
-- respuesta debe cumplir el formato:“APELLIDO, con dni DNI es el/la 
-- votante con más años.” La  selección  del  primer apellido debe 
-- ser exclusivamente empleando PL/SQL

    SET SERVEROUTPUT ON;  
    DECLARE 
        FECHA_ANTIGUA DATE;
        NOMBRE_COMPLETO VOTANTES.NOMBRECOMPLETO%TYPE; 
        APELLIDO_SPLIT VARCHAR2(64);
        DNI VOTANTES.DNI%TYPE;
        POSI_APELLIDO NUMBER:=0;
        POSF_APELLIDO NUMBER:=0;        
    BEGIN   
  -- SELECCIONAMOS LA FECHA MAS ANTIGUA DE TODOS LOS 
  -- VOTANTES 
        SELECT MIN(VOTANTES.FECHANACIMIENTO) 
        INTO FECHA_ANTIGUA
        FROM VOTANTES;  
  
  -- DBMS_OUTPUT.PUT_LINE('Fecha de nacimiento: '||FECHA_ANTIGUA);
  
        SELECT VOTANTES.NOMBRECOMPLETO 
        INTO NOMBRE_COMPLETO 
        FROM VOTANTES 
        WHERE VOTANTES.FECHANACIMIENTO = FECHA_ANTIGUA;
  
  -- DBMS_OUTPUT.PUT_LINE('Nombre completo: '||NOMBRE_COMPLETO);
  
  -- SELECCIONAMOS LA PRIMERA Y LA SEGUNDA OCURRENCIA DE LOS ESPACIOS 
  -- EN EL NOMBRECOMPLETO, LOS CUALES DELIMITAN EL PRIMER APELLIDO
        
        SELECT INSTR(VOTANTES.NOMBRECOMPLETO,' ',1), INSTR(VOTANTES.NOMBRECOMPLETO,' ',1,2)
        INTO POSI_APELLIDO, POSF_APELLIDO
        FROM VOTANTES 
        WHERE VOTANTES.FECHANACIMIENTO = FECHA_ANTIGUA;
  
  -- DBMS_OUTPUT.PUT_LINE('Posicion INICIO: '||POSI_APELLIDO);  
  -- DBMS_OUTPUT.PUT_LINE('Posicion FIN: '||POSF_APELLIDO);
  
  -- SELECCIONAMOS LOS CARACTERES ENTRE INICIO Y FIN Y SUMAMOS 1 (PRINCIPIO) Y 
  -- RESTAMOS 1 (FINAL) PARA NO CONTEMPLAR LOS ESPACIOS
        SELECT SUBSTR(NOMBRECOMPLETO,POSI_APELLIDO+1,POSF_APELLIDO-POSI_APELLIDO-1)
        INTO APELLIDO_SPLIT 
        FROM VOTANTES   
        WHERE FECHANACIMIENTO = FECHA_ANTIGUA;
      
        DBMS_OUTPUT.PUT_LINE(APELLIDO_SPLIT || ', con dni ' || DNI || 'es el/la votante con más años');
  
    END;

-- 3. Mostrar  el  nombre  completo  y  el  correo  electrónico  del  
-- votante  con  DNI  30983712, mostrando la información como sigue.

    SET SERVEROUTPUT ON; 
    DECLARE
        NOMBRE_VOTANTE VOTANTES.NOMBRECOMPLETO%TYPE;
        EMAIL_VOTANTE VOTANTES.EMAIL%TYPE;
    BEGIN 
        SELECT V.NOMBRECOMPLETO, V.EMAIL 
        INTO NOMBRE_VOTANTE,EMAIL_VOTANTE
        FROM VOTANTES V
        WHERE V.DNI = 30983712;
        DBMS_OUTPUT.PUT_LINE(NOMBRE_VOTANTE || ' con correo: ' || EMAIL_VOTANTE);
    END;

-- 4. El votante con DNI 30983712 desea que lo llamen Pepe en lugar 
-- de Jose. Sin embargo, este cambio no puede realizarse oficialmente 
-- en la base de datos puesto que no es su nombre real. Muestre el nombre 
-- completo de dicho votante pero apareciendo Pepe en lugar de Jose.

    SET SERVEROUTPUT ON;
    DECLARE 
        NOMBRE_VOTANTE VOTANTES.NOMBRECOMPLETO%TYPE;
    BEGIN 
        SELECT REPLACE(V.NOMBRECOMPLETO,'Jose','Pepe') 
        INTO NOMBRE_VOTANTE 
        FROM VOTANTES V 
        WHERE V.DNI = 30983712;
        DBMS_OUTPUT.PUT_LINE(NOMBRE_VOTANTE);  
    END;

-- 5. Teniendo en cuenta a los votantes, diga cuantos años hay entre la
-- persona de mayor edad con respecto a la de menos. Muestre ademas las
-- fechas de nacimiento del par de las personas. 

    DESCRIBE VOTANTES; 

    SET SERVEROUTPUT ON;
    DECLARE 
        FECHA_JOVEN  DATE;
        FECHA_VIEJO DATE; 
        DIFERENCIA NUMBER := 0; 
    BEGIN 
        
        -- ALMACENAMOS LA FECHA DE NACIMIENTO MAS CHICA EN LA VARIABLE FECHA_JOVEN
        SELECT MIN(V.FECHANACIMIENTO) 
        INTO FECHA_JOVEN 
        FROM VOTANTES V;
        
        -- ALMACENAMOS LA FECHA DE NACIMIENTO MAS CHICA EN LA VARIABLE FECHA_JOVEN
        SELECT MAX(V.FECHANACIMIENTO) 
        INTO FECHA_VIEJO 
        FROM VOTANTES V;

        DIFERENCIA := FLOOR(MONTHS_BETWEEN(FECHA_VIEJO,FECHA_JOVEN)/12);

        -- CALCULAMOS LA DIFERENCIA ENTRE AMBAS EDADES
        DBMS_OUTPUT.PUT_LINE(FECHA_VIEJO);
        DBMS_OUTPUT.PUT_LINE(FECHA_JOVEN);
        DBMS_OUTPUT.PUT_LINE(DIFERENCIA);

    END; 

-- 6. Muestre el nombre del partido y la incertidumbre correspondiente 
-- que durante la consulta de datos obtuvieron un "Si" de respuesta y 
-- además tengan un valor de certidumbre superior a la media de certidumbres. 
-- En este ejercicio solo podrá realizar una única consulta sobre la tabla 
-- CONSULTAS DATOS. Además muestre la media redondeada a 3 cifras significativas
-- a modo de información. Muestre los datos como sigue ordenados según el 
-- valor de certidumbre. 



