
-- Practica 6. 

-- Cree una tabla para almacenar el registro de ejecuciones de los triggers 
-- durante la practica. Deberïa tener dos columnas, "datos" y "tabla", en el 
-- campo datos almacenara detalles del cambio y el campo tabla almacenara el 
-- nombre de la tabla donde ocurrio el cambio. 

    CREATE TABLE AUDIT_TABLE 
        (DATOS VARCHAR2(64), 
        TABLA VARCHAR2(64));


 /*ESTRUCTURA TRIGGERS***************************************
     CREATE [OR REPLACE] TRIGGER trigger_name 
        {BEFORE | AFTER } triggering_event ON table_name 
        [FOR EACH ROW] [FOLLOWS | PRECEDES another_trigger] 
        [ENABLE / DISABLE ] [WHEN condition] 
        DECLARE 
            DECLARACION DE VARIABLES ... 
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

    ** INFO SOBRE :new Y :old  **

    http://www.tutorialesprogramacionya.com/oracleya/temarios/descripcion.php?cod=270

*/

-- 1. Cree un trigger que guarde los cambios que se produzcan en la columna 
-- "nombre" de la tabla "eventos". Deberá almacenar: "NombreAnterior NuevoNombre". 
   
        CREATE OR REPLACE TRIGGER GUARDAR_CAMBIOS
        AFTER UPDATE 
            OF NOMBRE 
            ON EVENTOS
            FOR EACH ROW
        BEGIN 
            IF UPDATING THEN
                INSERT INTO AUDIT_TABLE VALUES (:old.NOMBRE || ' -> ' || :new.NOMBRE, 'eventos');
            END IF; 
        END; 
        
        /*
            PRUEBA 
        
            [PARA ACTUALIZAR]
                UPDATE EVENTOS 
                SET NOMBRE = 'Madrid 2020'
                WHERE IDEVENTO = 10; 
            
            [PARA VOLVER AL ESTADO ANTERIOR]
                UPDATE EVENTOS 
                SET NOMBRE = 'Madrid'
                WHERE IDEVENTO = 10; 
            
            [TABLAS AFECTADAS]
                SELECT * FROM AUDIT_TABLE; 
                SELECT * FROM EVENTOS; 
        
        */
        
    

-- 2. Implemente un trigger que valide el numero de habitantes de las 
-- localidades. Si se intenta modificar dicho valor, el numero de habitantes 
-- nunca podra ser mayor que 4000000 y no podra ser menor que 1. En caso de 
-- ocurrir lo anterior debera modificar el valor que se intenta insertar, y 
-- en su lugar debera mantener el valor de la columna. 

        CREATE OR REPLACE TRIGGER CHECK_HABITANTES 
        BEFORE UPDATE
            OF NUMEROHABITANTES
            ON LOCALIDADES
            FOR EACH ROW
        BEGIN
            IF UPDATING THEN 
                IF :new.NUMEROHABITANTES < 1 OR :new.NUMEROHABITANTES > 4000000 THEN
                    /*
                        MODIFICA EL VALOR QUE SE VA A ACTUALIZAR ANTES DE 
                        REALIZAR LA INSERCION [NO HAY QUE REALIZAR EL UPDATE AQUI]
                    */
                    :new.NUMEROHABITANTES := :old.NUMEROHABITANTES; 
                END IF; 
            END IF; 
        END; 
        
        /*
            PRUEBA 
            
            SELECT * FROM LOCALIDADES; 
            
            [UPDATE MAL, DEBERÍA DE CONSERVAR EL VALOR ANTERIOR]
            UPDATE LOCALIDADES 
            SET NUMEROHABITANTES = 654545664
            WHERE IDLOCALIDAD = 16 
            
            [UPDATE MAL, DEBERÍA DE MODIFICAR EL VALOR]
            UPDATE LOCALIDADES 
            SET NUMEROHABITANTES = 60000
            WHERE IDLOCALIDAD = 16 
            
            [ORIGINAL]
            UPDATE LOCALIDADES 
            SET NUMEROHABITANTES = 786189 
            WHERE IDLOCALIDAD = 16 
    
        */

-- 3. Implemente una funcionalidad que cuando se realicen nuevas consultas 
-- (o se modifiquen) a los votantes, valide que las nuevas consultas tengan 
-- una fecha valida (menor o igual que la fecha actual). Ademas, registre 
-- dicho cambio en la tabla de auditoria. 

    SELECT * FROM CONSULTAS; 
    
    CREATE OR REPLACE TRIGGER CHECK_CONSULTAS 
    BEFORE INSERT OR UPDATE
        OF FECHA 
        ON CONSULTAS  
    FOR EACH ROW
    DECLARE 
        FECHA DATE; 
    BEGIN
    
        /* ANTES DE NADA DECLARAMOS LA FECHA ACTUAL */
        SELECT TO_CHAR(Sysdate,'DD/MM/YY')
        INTO FECHA 
        FROM dual; 
    
        /* PARA EL CASO DE INSERCIÓN */    
        IF INSERTING THEN 
            IF :new.FECHA > FECHA THEN 
                :new.FECHA := FECHA; 
                INSERT INTO AUDIT_TABLE 
                    VALUES ('INSERTADO EVENTO CON FECHA (FECHA ACTUAL)' || FECHA, 'CONSULTAS');
            ELSE 
                INSERT INTO AUDIT_TABLE 
                    VALUES ('INSERTADO EVENTO CON FECHA' || FECHA, 'CONSULTAS');
            END IF; 
        END IF; 
        
        /* PARA EL CASO DE LA ACTUALIZACION */
        IF UPDATING THEN 
            IF :new.FECHA > FECHA THEN 
                :new.FECHA := :old.FECHA;
                INSERT INTO AUDIT_TABLE 
                    VALUES ('CAMBIO DE FECHA DE (FECHA ANTIGUA), ' || :new.FECHA || ' a ' || :old.FECHA, 'CONSULTAS');
            ELSE
                INSERT INTO AUDIT_TABLE 
                    VALUES ('CAMBIO DE FECHA DE, ' || :old.FECHA || ' a ' || :new.FECHA, 'CONSULTAS');
            END IF; 
        END IF; 
    END; 

    /*
        PRUEBA 
        
        [INSERT CON FECHA CORRECTA] 
        INSERT INTO CONSULTAS 
            VALUES (55,2,31087814,'220118')
        
        [INSERT CON FECHA INCORRECTA] 
        INSERT INTO CONSULTAS 
            VALUES (56,2,30559075,'220130')
        
        [UPDATE CON FECHA CORRECTA]
        UPDATE CONSULTAS 
        SET FECHA = '230118'
        WHERE IDCONSULTA = 55
        
        [UPDATE CON FECHA INCORRECTA] 
        UPDATE CONSULTAS 
        SET FECHA = '230130'
        WHERE IDCONSULTA = 56
        
        [PARA DEJARLO EN ESTADO ORIGINAL]
        DELETE FROM CONSULTAS
        WHERE IDCONSULTA = 56 OR IDCONSULTA = 55; 
        
        SELECT * FROM CONSULTAS; 
        SELECT * FROM AUDIT_TABLE; 
    
    */

    
-- 4. Elabore un procedimiento que no permita que se inserten numeros de 
-- telefono invalidos de los votantes. El rango permitido es de [600000000, 799999999]. 
    
    /* ESTRUCTURA CONSTRAINT
        ALTER TABLE table_name 
        ADD CONSTRAINT nombre 
            CHECK (sentencia-SQL)        
    */
    
    ALTER TABLE VOTANTES 
    ADD CONSTRAINT RANGO_TELEFONO 
        CHECK (TELEFONO > 600000000 AND TELEFONO < 799999999);
        
    /*
        PRUEBA 
        
        SELECT TELEFONO FROM VOTANTES;
        
        [INSERT CON TELEFONO INCORRECTO]      
        INSERT INTO VOTANTES 
            VALUES (30983892, 'Juan Padilla Padillo', 'Basicos', 'Parado','jpp@gmail.com',5,'23/02/1982',862234293)
        
        [INSERT CON TELEFONO CORRECTO]      
        INSERT INTO VOTANTES 
            VALUES (30888712, 'Antonio Moreno Padillo', 'Superiores', 'Parado','jpp@gmail.com',5,'23/02/1982',662235293)
            
        [PARA DEJARLO EN EL ESTADO ORIGINAL]
        DELETE FROM VOTANTES 
        WHERE DNI = 30888712
    */
    
    
        
-- 5. Restrinja que el tipo de los eventos deban comenzar con letra inicial 
-- mayuscula y debe terminar en "s", ademas puede contener numeros. De no 
-- cumplirse deberia impedir que se inserte en la tabla. Deshabilite la 
-- restriccion CK_NOMBRE durante este ejercicio. 

    SELECT * FROM EVENTOS; 

    ALTER TABLE EVENTOS 
        DISABLE CONSTRAINT CK_NOMBRE; 
    
    ALTER TABLE EVENTOS 
    ADD CONSTRAINT CHECK_EVENTOS 
    CHECK (
        /*[LOS EVENTOS DEBEN COMENZAR CON MAYUSCULAS Y ACABAR EN "s"]*/
        
        /* SI EL UPPER DE LA PRIMERA POSICION Y LA PRIMERA POSICION, SON LA 
        MISMA ENTONCES ES QUE EL NOMBRE EMPIEZA CON MAYUSCULA */
        
        /* EL NOMBRE ACABA EN s */
       UPPER(SUBSTR(TIPO,1,1)) LIKE SUBSTR(TIPO,1,1) AND TIPO LIKE '%s'
       
       /* CON RESPECTO A QUE EL NOMBRE PUEDE CONTENER NUMEROS, NO HAY QUE 
       CONTEMPLARLO COMO RESTRICCIÓN */
    );
    ALTER TABLE EVENTOS 
        ENABLE CONSTRAINT CK_NOMBRE;
    
    /*
        PRUEBA
        
        [INSERT INCORRECTO]
        INSERT INTO EVENTOS
        VALUES (12, 'Europa2018', '23/04/2018', 'iuropeas','Elecciones al parlamentazo europeo');
        
        [INSERT CORRECTO CON NUMEROS]
        INSERT INTO EVENTOS
        VALUES (13, 'Europa2018', '23/04/2018', 'Euro45peas','Elecciones al parlamentazo europeo');
    
        [PARA VOLVER AL ESTADO ORIGINAL]
        DELETE FROM EVENTOS 
        WHERE IDEVENTO = 13
        
        SELECT * FROM EVENTOS;
    
    */
        
-- 6. Haga una funcionalidad que permita controlar la situacion laboral 
-- y/o la fecha de nacimiento de los votantes. Si existe un votante que 
-- tenga mas de 59 años y aun no esta jubilado, debera quedar registrado 
-- su DNI en la tabla de control de ejecuciones, asi como de cual tabla 
-- proviene la informacion.

    /*
        SUPONEMOS QUE DEBEMOS DE CONTROLAR DICHA SITUACION EN LA INSERCIÓN
        Y LA ACTUALIZACION 
    */

    CREATE OR REPLACE TRIGGER CHECK_EDAD_JUBILADO
    BEFORE INSERT OR UPDATE 
    ON VOTANTES 
    FOR EACH ROW
    DECLARE 
        EDAD NUMBER; 
        FECHA_ACTUAL DATE; 
    BEGIN
        /* HALLAMOS LA FECHA ACTUAL PARA DETERMINAR LA EDAD DEL VOTANTE */
        FECHA_ACTUAL := TO_CHAR(Sysdate,'DD/MM/YYYY'); 
        EDAD := FLOOR(MONTHS_BETWEEN(FECHA_ACTUAL,:new.FECHANACIMIENTO)/12);
        
        /* PLANTEAMOS CADA UNA DE LAS DIFERENTES OPCIONES PARA EL TRIGGER, TANTO 
        SI INSERTAMOS COMO SI ACTUALIZAMOS ¡SOLAMENTE! DEBEMOS DE INSERTAR EN 
        LA TABLA AUDIT_TABLE, ES DECIR, REGISTRAR QUE HA SIDO INSERTADO UN VOTANTE
        CON DICHOS PARÁMETROS*/
        IF INSERTING THEN 
            IF EDAD > 59 AND :new.SITUACIONLABORAL NOT LIKE 'Jubilado' THEN 
                INSERT INTO AUDIT_TABLE 
                    VALUES ('VOTANTE CON DNI ' || :new.DNI || ' TIENE MAS DE 59 AÑOS Y NO ESTÁ JUBILADO','VOTANTES');
            END IF; 
        END IF; 
        IF UPDATING THEN 
            IF EDAD > 59 AND :new.SITUACIONLABORAL NOT LIKE 'Jubilado' THEN 
                INSERT INTO AUDIT_TABLE 
                    VALUES ('VOTANTE CON DNI ' || :new.DNI || ' TIENE MAS DE 59 AÑOS Y NO ESTÁ JUBILADO','VOTANTES');
            END IF; 
        END IF;
    END;

    /*
        PRUEBA 
      
        [INSERT DE UN ACTIVO CON MAS DE 59 AÑOS]
        INSERT INTO VOTANTES 
            VALUES (30559099, 'Lucia Poyos Martin', 'Basicos', 'Activo','hoyosmalu@hotmail.com',9,'31/03/1902',721988562);
    
        SELECT * FROM AUDIT_TABLE
        SELECT * FROM VOTANTES
    
        [DEVOLVER LA TABLA AL ESTADO ORIGINAL]
        DELETE FROM VOTANTES 
            WHERE DNI = 30559099;
    */




