
-- Practica 5. PLSQL

-- 1. Muestre el nombre de los presidentes de partidos que cumpla con la 
-- condicion de que tanto su nombre como sus dos apellidos terminan en "o". 
-- En este ejercicio no podria hacer uso del comando WHERE. 

    SET SERVEROUTPUT ON; 
    DECLARE
        NOMBRE PARTIDOS.PRESIDENTE%TYPE; 
        CURSOR C IS 
            SELECT P.PRESIDENTE 
            FROM PARTIDOS P; 
    BEGIN 
        OPEN C; 
            LOOP 
                FETCH C INTO NOMBRE;
                EXIT WHEN C%NOTFOUND; 
                IF NOMBRE LIKE '%o %o' THEN 
                    DBMS_OUTPUT.PUT_LINE(NOMBRE);
                END IF; 
            END LOOP; 
        CLOSE C; 
    END; 
    
-- 2. Encuentre la suma total de los resultados de cada partido politico en 
-- todos los resultados de eventos. Debera hacer uso solo de sentencias PL/SQL 
-- y solo una vez los comandos SELECT, FROM, WHERE, JOIN. Se necesita 
-- flexibilidad en su solucion, es decir que deberia aceptar nuevos partidos. 
-- Muestre la informacion con el siguiente formato. 
    
    SET SERVEROUTPUT ON; 
    DECLARE 
        /*
            - TIPO nombre IS TABLE OF tipoDeDato INDEX BY tipoDelIndice
            - LA TABLA "HASH_MAP" ES UNA TABLA DE FLOATs CON UN INDICE 
            DE VARCHAR2(100)
            - ¡¡CON ESTO DECLARAMOS EL TIPO!!
        */
        TYPE HASH_MAP IS TABLE OF NUMBER INDEX BY VARCHAR2(64);     
        
        /*
            INSTANCIAMOS UNA TABLA DEL TIPO DECLARADO ANTERIORMENTE
            NOMBRE_VARIABLE + TIPO_VARIABLE; 
        */
        TABLA HASH_MAP; 
        
        /*
            CLAVE DEL MAPA 
        */
        KEY PARTIDOS.NOMBRECOMPLETO%TYPE; 
        
        /*
            DECLARAMOS UN CURSOR PARA VOLCAR TODOS LOS DATOS 
        */
        CURSOR C IS 
            SELECT P.NOMBRECOMPLETO , ER.RESULTADO
            FROM PARTIDOS P, EVENTOS_RESULTADOS ER 
            WHERE P.IDPARTIDO = ER.PARTIDO; 
    BEGIN 
        
        FOR FILA IN C LOOP
            
            /* 
                SI EN LA TABLA EXISTE EL VALOR DE CLAVE: 
                    - SUMA EL VALOR AL VALOR ANTERIOR 
                        <<TABLA[KEY] = TABLA[KEY] + VALOR>>
                SI NO: 
                    - CREA UN NUEVO CAMPO CON EL VALOR CORRESPONDIENTE 
                        <<TABLA[KEY] = VALOR>>
            */
            IF TABLA.EXISTS(FILA.NOMBRECOMPLETO) THEN 
                TABLA(FILA.NOMBRECOMPLETO) := TABLA(FILA.NOMBRECOMPLETO) + FILA.RESULTADO;
            ELSE 
                TABLA(FILA.NOMBRECOMPLETO) := FILA.RESULTADO;
            END IF;
        END LOOP; 
        
        /* SE POSICIONA LA KEY AL PRINCIPIO ... */
        KEY := TABLA.FIRST(); 
        
        /* ... Y MIENTRAS QUE LA CLAVE NO SEA NULA:     
                - IMPRIMA EL VALOR DE LA CLAVE Y EL VALOR QUE ALMACENA
                EL MAPA PARA DICHO VALOR DE CLAVE 
        */
        WHILE KEY IS NOT NULL LOOP 
            DBMS_OUTPUT.PUT_LINE(KEY || ' ' || TABLA(KEY));
            KEY := TABLA.NEXT(KEY);
        END LOOP; 
    END; 

-- 3. Obtener el nombre de todos los votantes cuyo DNI acaba igual que el 
-- identificador de su localidad mas 1. Es decir, el votante con DNI 30948214 
-- debe mostrarse si pertenece a la localidad nu½mero 3. 

    SET SERVEROUTPUT ON; 
    DECLARE
        CURSOR C IS
            SELECT V.NOMBRECOMPLETO, V.DNI, V.LOCALIDAD
            FROM VOTANTES V;
        NOMBRE VOTANTES.NOMBRECOMPLETO%TYPE; 
        DNI VOTANTES.DNI%TYPE; 
        LOCALIDAD VOTANTES.LOCALIDAD%TYPE; 
        CONTADOR NUMBER := 0; 
    BEGIN
        OPEN C; 
            LOOP 
                FETCH C INTO NOMBRE, DNI, LOCALIDAD; 
                EXIT WHEN C%NOTFOUND; 
                
                IF (MOD(DNI,10) = LOCALIDAD + 1) THEN 
                    DBMS_OUTPUT.PUT_LINE(NOMBRE);
                    CONTADOR := CONTADOR + 1;
                END IF; 
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('Hay un total de: ' || CONTADOR || ' personas');
        CLOSE C; 
    END; 
    
-- 4. Mostrar los DNIs de los votantes en orden, indicando va antes que otro. 
-- El ultimo DNI (el mas pequeño) se indicara que es el mas pequeño. 

    SET SERVEROUTPUT ON; 
    DECLARE
        DNI1 VOTANTES.DNI%TYPE; 
        DNI2 VOTANTES.DNI%TYPE; 
        CURSOR C IS 
            SELECT V.DNI 
            FROM VOTANTES V
            ORDER BY V.DNI DESC;
        NFILS NUMBER := 0; 
        CONTADOR NUMBER := 0; 
    BEGIN
      
        /*  SACAMOS EL NUMERO DE FILAS  */
        SELECT COUNT(V.DNI) 
        INTO NFILS 
        FROM VOTANTES V; 
        
        OPEN C; 
            WHILE CONTADOR < NFILS LOOP 
            
                IF CONTADOR = 0 THEN
                    FETCH C INTO DNI1; 
                    FETCH C INTO DNI2;
                    DBMS_OUTPUT.PUT_LINE(DNI1 || ' ANTES ' || DNI2);
                    CONTADOR := CONTADOR + 1; 
                END IF; 
             
                IF CONTADOR > 0 AND CONTADOR < NFILS THEN
                    DNI1 := DNI2; 
                    FETCH C INTO DNI2; 
                    DBMS_OUTPUT.PUT_LINE(DNI1 || ' ANTES ' || DNI2);
                    CONTADOR := CONTADOR + 1;
                END IF; 
               
                IF CONTADOR = NFILS - 1 THEN
                    DBMS_OUTPUT.PUT_LINE('EL ULTIMO ' || DNI2);
                    CONTADOR := CONTADOR + 1;
                END IF;
            END LOOP; 
        CLOSE C;
    END; 

---

 