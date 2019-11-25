-- Practica 2. 

-- 1.Obtener el nombre de todos los votantes cuyo segundo apellido acaba en �n�

    -- Se utiliza el operador LIKE en la clausula WHERE para especificar un 
    -- patr�n en una columna. Se puede a�adir dos argumentos para detectar la 
    -- expresi�n regular: 
      --  � % indica cero o varios caracteres. 
      --  � _ indica solo un car�cter. 
      --    * [...] LIKE 'a%' -> empiece por 'a' 
      --    * [...] LIKE '%a' -> termine en 'a' 
      --    * [...] LIKE '%a%' -> contenga una 'a'
      --    * [...] LIKE '_a%' -> la segunda letra sea una 'a'

    SELECT V.NOMBRECOMPLETO FROM VOTANTES V
    WHERE V.NOMBRECOMPLETO LIKE '%n';
    
-- 2.Obtener el DNI de todos los votantes que tengan al menos tres 5s en su DNI

-- 3.Obtener el nombre de aquellos votantes cuya fecha de nacimiento sea 
-- posterior al 1 de Enero de 1990

-- 4.Obtener el nombre del votante y el nombre de la localidad de aquellos 
-- votantes que han ejercido el voto en una localidad que tiene m�s de 300000 
-- habitantes

-- 5.Obtener el nombre del votante y el nombre de la comunidad de aquellos 
-- votantes que han ejercido el voto en una localidad que tiene m�s de 300000 
-- habitantes.

-- 6.Obtener el identificador del partido y el n�mero de datos o consultas 
-- que se tiene para dicho partido de entre todos los partidos sobre los 
-- que se han realizado alguna consulta

-- 7.Mostrar el identificador de partido y el n�mero de consultas realizadas 
-- para cada partido.

-- 8.Mostrar el nombre del partido pol�tico sobre el que se han realizado m�s 
-- de 10 consultas.