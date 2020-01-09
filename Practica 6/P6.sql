
-- Practica 6. 

-- Cree una tabla para almacenar el registro de ejecuciones de los triggers 
-- durante la práctica. Deberá tener dos columnas, “datos” y “tabla”, en el 
-- campo datos almacenará detalles del cambio y el campo tabla almacenará el 
-- nombre de la tabla donde ocurrió el cambio. 


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
            DECLARACIÓN DE VARIABLES ... 
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
-- “nombre” de la tabla “eventos”. Deberá almacenar: “NombreAnterior NuevoNombre”. 


        CREATE OR REPLACE TRIGGER GUARDAR_CAMBIOS
        AFTER UPDATE 
            OF NOMBRE 
            ON EVENTOS
            FOR EACH ROW -- -> SI NO SE PONE ESTO NO FUNCA EL :OLD/:NEW
        BEGIN 
            IF UPDATING THEN 
                INSERT INTO AUDIT_TABLE VALUES (:new.NOMBRE || ' - ' || :old.NOMBRE, 'eventos');
                DBMS_OUTPUT.PUT_LINE('Ejecutado el Trigger de actualización de evento');
            ELSE
                DBMS_OUTPUT.PUT_LINE('Error en la operación del TRIGGER');
            END IF; 
        END; 
   
   
   /*   PRUEBA 
   
        UPDATE EVENTOS 
        SET NOMBRE = 'Estatut'
        WHERE NOMBRE = 'Estatuto';
      
        SELECT * FROM AUDIT_TABLE;
    */


-- 2. Implemente un trigger que valide el número de habitantes de las 
-- localidades. Si se intenta modificar dicho valor, el número de habitantes 
-- nunca podrá ser mayor que 4000000 y no podrá ser menor que 1. En caso de 
-- ocurrir lo anterior deberá modificar el valor que se intentó insertar, y 
-- en su lugar deberá mantener el valor de la columna. 

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
-- una fecha válida (menor o igual que la fecha actual). Además, registre 
-- dicho cambio en la tabla de auditoría. 

-- .new Y .old SON SOLAMENTE REGISTROS DE  ||LECTURA|| 

    CREATE OR REPLACE TRIGGER CHECK_FECHA_CONSULTAS  
    AFTER UPDATE 
        OF FECHA 
        ON CONSULTAS 
    FOR EACH ROW 
    DECLARE 
        FECH DATE; 
    BEGIN 
        SELECT TO_CHAR(SysDate,'DD/MM/YY')
        INTO FECH 
        FROM dual;
        
        IF INSERTING THEN
            IF :NEW.FECHA > FECH THEN 
                UPDATE CONSULTAS 
                SET FECHA = FECH 
                WHERE :NEW.IDCONSULTA = :OLD.IDCONSULTA; 
            END IF;
        END IF;     
    END;
    
    
    INSERT INTO CONSULTAS
    VALUES (56,2,30559075,'01/01/21');   
    INSERT INTO CONSULTAS
    VALUES (57,2,30559075,'01/01/19'); 
    INSERT INTO CONSULTAS
    VALUES (58,2,30559075,'21/01/21'); 
    SELECT * FROM CONSULTAS; 

    DELETE FROM CONSULTAS 
    WHERE IDCONSULTA = 55 OR IDCONSULTA = 56 OR IDCONSULTA = 57 OR IDCONSULTA = 58 ;
    DROP TRIGGER CHECK_FECHA;
    

-- 4. Elabore un procedimiento que no permita que se inserten números de 
-- teléfono inválidos de los votantes. El rango permitido es de [600000000, 799999999]. 
    
    /*ESTRUCTURA ASSERTIONS
        CREATE ASSERTIONS limit_localidades AS CHECK (CONSULTA-SQL)
    */
    
        ALTER TABLE VOTANTES 
        ADD CONSTRAINT CHECK_MOVIL_VOTANTES CHECK (
            TELEFONO > 600000000 AND TELEFONO < 799999999
        )

        SELECT * FROM VOTANTES;
        
-- 5. Restrinja que el tipo de los eventos deban comenzar con letra inicial 
-- mayúscula y debe terminar en “s”, además puede contener números. De no 
-- cumplirse deberá impedir que se inserte en la tabla. Deshabilite la 
-- restricción CK_NOMBRE durante este ejercicio. 

        ALTER TABLE EVENTOS
        DISABLE CONSTRAINT CK_NOMBRE;
        -- ESTO NO TIENE NI PIES NI CABEZA 
        -- HABRÍA QUE PASAR EL PRIMER CARACTER A ENTERO Y 
        -- COMPROBAR QUE SE ENCUENTRA EN EL RANGO DE LAS MAYUSCULAS  
        ALTER TABLE EVENTOS
        ADD CONSTRAINT REQUISITOS_EVENTOS CHECK (
           UPPER(SUBSTR(NOMBRE,1,1)) LIKE SUBSTR(NOMBRE,1,1) AND (NOMBRE LIKE '%s')
        );
        -- (NO FUNKA)
        ALTER TABLE EVENTOS
        DROP CONSTRAINT REQUISITOS_EVENTOS;
        
-- 6. Haga una funcionalidad que permita controlar la situación laboral 
-- y/o la fecha de nacimiento de los votantes. Si existe un votante que 
-- tenga más de 59 años y aún no está jubilado, deberá quedar registrado 
-- su DNI en la tabla de control de ejecuciones, así como de cuál tabla 
-- proviene la información.

    CREATE OR REPLACE TRIGGER ultimotrigger 
    BEFORE  INSERT OR UPDATE ON votantes 
    FOR EACH ROW 
    BEGIN 
        IF :new.FECHANACIMIENTO > '09/01/61' THEN     
            INSERT INTO audit_table(DATOS,TABLA) 
            VALUES('votante con dni '||:new.DNI || 'tiene mas de 59 y no esta jubilado' ,'VOTANTES'); 
        END IF; 
    END; --UPDATE 
    
    DECLARE
    BEGIN 
        INSERT INTO VOTANTES (DNI,NOMBRECOMPLETO,ESTUDIOSSUPERIORES,
                SITUACIONLABORAL,EMAIL,LOCALIDAD,FECHANACIMIENTO,TELEFONO) 
        VALUES (30983719,'Antonio Vazquez Padilla','Basicos','Parado','ggg@r'
        ,6,'22/11/18',600000002 ); 
    END;

SELECT * FROM AUDIT_TABLE; 

