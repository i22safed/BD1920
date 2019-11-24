

-- Práctica 3

-- 1-Obtener el nombre de todos los votantes cuyo 
-- DNI acaba igual que el identificador de su localidad 
-- más 1. Es decir, el votante con DNI 30948214 debe 
-- mostrarse si pertenece a la localidad número 3. 

SELECT V.NOMBRECOMPLETO FROM VOTANTES V
WHERE V.DNI LIKE CONCAT('%', V.LOCALIDAD+1);

-- 2 Obtener el nombre de todos los votantes así como 
-- el nombre de la localidad en la que viven teniendo 
-- en cuenta que todos los que sean de la provincia de 
-- Córdoba (identificador de localidad 1, 2 y 3) se han 
-- mudado a Madrid.

SELECT V.NOMBRECOMPLETO, L.NOMBRE 
FROM VOTANTES V, LOCALIDADES L
WHERE L.IDLOCALIDAD = 
DECODE(V.LOCALIDAD,1,9,2,9,3,9,V.LOCALIDAD);

-- 3. Mostrar las siglas de aquellos partidos que han 
-- participado un mayor número de veces en eventos

