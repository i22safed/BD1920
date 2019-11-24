
-- Practica 1. 

-- 1.Descargar el script Votacion.sql disponible en Moodle y analizar las 
-- tablas   definidas   así como los atributos definidos para cada una 
-- de las tablas

  -- BUSCAR EL RELACIONAL DEL AÑO PASADO 

-- 2.Comprobar que todas las tablas han sido creadas correctamente. Para ello,
-- listaremos el nombre de todas las tablas que tenemos actualmente creadas 
-- mediante el comando: SELECT table_name FROM user_tables

    SELECT table_name FROM user_tables; 

-- 3.Obtener descripciones de las diferentes tablas creadas mediante el script. 
-- Para describir la tabla eventos, usaremos el comando: DESCRIBE eventos; 
-- Realizar el ejercicio sobre todas y cada una de las diferentes tablas y 
-- comprobar el tipo de datos de cada uno de los atributos.

    DESCRIBE PARTIDOS; 
    DESCRIBE PROVINCIAS; 
    DESCRIBE LOCALIDADES; 
    DESCRIBE VOTANTES; 
    DESCRIBE EVENTOS; 
    DESCRIBE EVENTOS_RESULTADOS; 
    DESCRIBE CONSULTAS; 
    DESCRIBE CONSULTAS_RESULTADOS; 

-- 4.Realizar el borrado de la tabla votantes mediante el comando: DROP TABLE 
-- votantes; Analizar por qué el comando da un error y hacer lo posible para 
-- conseguir borrar la tabla socio. Una vez conseguido, borrar el resto de 
-- tablas de la base de datos hasta comprobar que no existe ninguna tabla en 
-- la base de datos.

-- 5. Cargar de nuevo el script Votacion.sql y realizar la siguiente inserción en 
-- la tabla votantes:
--    dni:  30653845
--    nombreCompleto:  Maria Gonzalez Ramirez
--    estudiosSuperiores:  Doctorado
--    situacionLaboral:  Activo
--    email: goram@telefonica.es
--    localidad: 1
--    fechaNacimiento:  21 de Agosto de 1989
--    telefono:  677544822

-- 6.Comprobar que todos los campos han sido insertados correctamente, 
-- utilizando el comando: SELECT * FROM votantes;

-- 7.Realizar el borrado de la inserción que acabamos de hacer sobre la tabla 
-- votantes. Comprobar que dicho votante ha sido efectivamente borrado de la 
-- base de datos, comparando los resultados de la instrucción del ejercicio 
-- anterior y los actuales.

-- 8.Realizar diferentes inserciones sobre cada una de las diferentes tablas 
-- existentes y comprobar que dichas inserciones fueron realizadas correctamente.
