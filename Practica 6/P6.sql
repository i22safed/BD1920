
-- Practica 6. 

-- Cree una tabla para almacenar el registro de ejecuciones de los triggers 
-- durante la pr�ctica. Deber� tener dos columnas, �datos� y �tabla�, en el 
-- campo datos almacenar� detalles del cambio y el campo tabla almacenar� el 
-- nombre de la tabla donde ocurri� el cambio. 


    CREATE TABLE "AUDIT_TABLE" ( 
        "DATOS" VARCHAR2(100 BYTE), 
        "TABLA" VARCHAR2(100 BYTE)   
    ) 
 
 /*ESTRUCTURA TRIGGERS***************************************
     CREATE [OR REPLACE] TRIGGER trigger_name 
        {BEFORE | AFTER } triggering_event ON table_name 
        [FOR EACH ROW] [FOLLOWS | PRECEDES another_trigger] 
        [ENABLE / DISABLE ] [WHEN condition] 
        DECLARE 
            DECLARACI�N DE VARIABLES ... 
        BEGIN 
            IF INSERTING THEN 
                [...]
            ELSE
            END IF;
        EXCEPTION 
            EXCEPCIONES 
        END;
************************************************************/
/*
    INSERCIONES 
        INSERT INTO TABLE nombretabla
        values (col1, col2, col3 )
    MODIFICACIONES 
        UPDATE nombretabla 
        SET col1 = valor, col2 = valor ... 
        WHERE TAL
    ELIMINACIONES 
        DELETE FROM TABLE;  -> PARA BORRAR TODO 
        DELETE FROM TABLE 
            WHERE TAL       -> PARA BORRAR UNA DETERMINADA TUPLA 
*/

-- 1. Cree un trigger que guarde los cambios que se produzcan en la columna 
-- �nombre� de la tabla �eventos�. Deber� almacenar: �NombreAnterior NuevoNombre�. 


        CREATE OR REPLACE TRIGGER GUARDAR_CAMBIOS
        AFTER UPDATE 
            OF NOMBRE 
            ON EVENTOS
            FOR EACH ROW -- -> SI NO SE PONE ESTO NO FUNCA EL :OLD/:NEW
        BEGIN 
            IF UPDATING THEN 
                INSERT INTO AUDIT_TABLE VALUES (:new.NOMBRE || ' - ' || :old.NOMBRE, 'eventos');
                DBMS_OUTPUT.PUT_LINE('Ejecutado el Trigger de actualizaci�n de evento');
            ELSE
                DBMS_OUTPUT.PUT_LINE('Error en la operaci�n del TRIGGER');
            END IF; 
        END; 
   
   
   /*   PRUEBA 
   
        UPDATE EVENTOS 
        SET NOMBRE = 'Estatut'
        WHERE NOMBRE = 'Estatuto';
      
        SELECT * FROM AUDIT_TABLE;
    */


-- 2. Implemente un trigger que valide el n�mero de habitantes de las 
-- localidades. Si se intenta modificar dicho valor, el n�mero de habitantes 
-- nunca podr� ser mayor que 4000000 y no podr� ser menor que 1. En caso de 
-- ocurrir lo anterior deber� modificar el valor que se intent� insertar, y 
-- en su lugar deber� mantener el valor de la columna. 

        CREATE OR REPLACE TRIGGER CHECK_NO_HABITANTES
        AFTER UPDATE 
            OF NUMEROHABITANTES 
            ON LOCALIDADES 
        FOR EACH ROW
        BEGIN 
            IF UPDATING THEN 
                IF :NEW.NUMEROHABITANTES > 4000000 OR :NEW.NUMEROHABITANTES < 1 THEN 
                    UPDATE LOCALIDADES
                    SET NUMEROHABITANTES = :OLD.NUMEROHABITANTES
                    WHERE :NEW.IDLOCALIDAD = :OLD.IDLOCALIDAD;
                END IF; 
            END IF; 
        END;
        
        /*PRUEBA 
            // ERROR
            UPDATE LOCALIDADES  
            SET IDLOCALIDAD = 16, NUMEROHABITANTES = 0
            WHERE IDLOCALIDAD = 16; 
            // CORRECTO
            UPDATE LOCALIDADES 
            SET IDLOCALIDAD = 16, NUMEROHABITANTES = 786188
            WHERE IDLOCALIDAD = 16; 
        */


-- 3. Implemente una funcionalidad que cuando se realicen nuevas consultas 
-- (o se modifiquen) a los votantes, valide que las nuevas consultas tengan 
-- una fecha v�lida (menor o igual que la fecha actual). Adem�s, registre 
-- dicho cambio en la tabla de auditor�a. 

        CREATE OR REPLACE TRIGGER CHECK_FECHA
        BEFORE INSERT OR UPDATE 
            OF FECHA 
            ON CONSULTAS 
            FOR EACH ROW
        BEGIN 
            IF INSERTING THEN 
                DBMS_OUTPUT.PUT_LINE('INSERCI�N');
                --[CUERPO EN CASO DE INSERCI�N]
            END IF; 
            IF UPDATING THEN 
                DBMS_OUTPUT.PUT_LINE('ACTUALIZACI�N');
                --[CUERPO EN CASO DE ACTUALIZACI�N]
            END IF; 
        END; 
    


