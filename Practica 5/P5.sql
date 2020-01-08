
-- Practica 5. PLSQL

-- 1. Muestre el nombre de los presidentes de partidos que cumpla con la 
-- condición de que tanto su nombre como sus dos apellidos terminan en “o”. 
-- En este ejercicio no podrá hacer uso del comando WHERE. 

    
        SET SERVEROUTPUT ON; 
        DECLARE
            PRES PARTIDOS.PRESIDENTE%TYPE;
            I NUMBER:=0; 
            CURSOR C IS 
                SELECT PRESIDENTE 
                FROM PARTIDOS; 
        BEGIN 
            OPEN C; 
                LOOP
                    FETCH C INTO PRES; 
                    EXIT WHEN C%NOTFOUND;
                    IF PRES LIKE '_%o%o' THEN 
                        DBMS_OUTPUT.PUT_LINE(PRES);                
                    END IF;
                END LOOP; 
            CLOSE C; 
        END;
        

-- 2. Encuentre la suma total de los resultados de cada partido político en 
-- todos los resultados de eventos. Deberá hacer uso solo de sentencias PL/SQL 
-- y solo una vez los comandos SELECT, FROM, WHERE, JOIN. Se necesita 
-- flexibilidad en su solución, es decir que deberá aceptar nuevos partidos. 
-- Muestre la información con el siguiente formato. 


-- 3. Obtener el nombre de todos los votantes cuyo DNI acaba igual que el 
-- identificador de su localidad más 1. Es decir, el votante con DNI 30948214 
-- debe mostrarse si pertenece a la localidad número 3. 

        SET SERVEROUTPUT ON; 
        DECLARE 
            CURSOR C IS 
                SELECT *
                FROM VOTANTES;
            VOTANTE VOTANTES%ROWTYPE;
            CONTADOR NUMBER:=0;

        BEGIN
            -- ABRIMOS CURSOR 
            OPEN C; 
            LOOP 
                FETCH C INTO VOTANTE;
                EXIT WHEN C%NOTFOUND;
                    IF VOTANTE.LOCALIDAD+1  = MOD(VOTANTE.DNI,10) THEN 
                        DBMS_OUTPUT.PUT_LINE(VOTANTE.NOMBRECOMPLETO); 
                        CONTADOR := CONTADOR + 1; 
                    END IF; 
            END LOOP; 
            DBMS_OUTPUT.PUT_LINE('Hay un total de: ' || CONTADOR);
            
            CLOSE C;
        END; 


-- 4. Mostrar los DNIs de los votantes en orden, indicando va antes que otro. 
-- El último DNI (el más pequeño) se indicará que es el más pequeño. 

        SET SERVEROUTPUT ON;
        DECLARE 
            CURSOR C IS 
                SELECT DNI 
                FROM VOTANTES 
                ORDER BY VOTANTES.DNI DESC;
            DNI1 VOTANTES.DNI%TYPE; 
            DNI2 VOTANTES.DNI%TYPE;
            NUM NUMBER := 0;
            I NUMBER:=1; 
        BEGIN 
            -- SACAMOS EL NUMERO DE FILAS AFECTADAS     
             SELECT COUNT(DNI)
             INTO NUM 
             FROM VOTANTES; 
    
            -- AHORA REALIZAMOS UN BUCLE PARA IMPRIMIR              
             OPEN C; 
             LOOP
                -- IF PARA EL PRIMER CASO 
                IF I = 1 THEN 
                    FETCH C INTO DNI1;  
                    FETCH C INTO DNI2;
                    DBMS_OUTPUT.PUT_LINE(DNI1 || ' ANTES ' || DNI2);
                    I := I + 1;
                END IF;
                IF I > 1 AND I < NUM THEN 
                    DNI1 := DNI2;
                    FETCH C INTO DNI2;
                    DBMS_OUTPUT.PUT_LINE(DNI1 || ' ANTES ' || DNI2);
                    I := I + 1;
                END IF;
                IF I = NUM THEN 
                    FETCH C INTO DNI2;
                    DBMS_OUTPUT.PUT_LINE('EL MENOR ES ' || DNI2);
                    EXIT;
                END IF;
            END LOOP; 
            CLOSE C; 
        END;



---

 