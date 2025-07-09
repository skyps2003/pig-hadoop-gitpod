ventas = LOAD '/datos/ventas.csv' USING PigStorage(',') 
  AS (id:int, nombre:chararray, monto:int, ciudad:chararray, categoria:chararray);

altas = FILTER ventas BY monto > 500;

por_ciudad = GROUP ventas BY ciudad;
total_ciudad = FOREACH por_ciudad GENERATE 
  group AS ciudad, 
  SUM(ventas.monto) AS total;

por_categoria = GROUP ventas BY categoria;
estadisticas = FOREACH por_categoria GENERATE 
  group AS categoria, 
  COUNT(ventas) AS cantidad,
  AVG(ventas.monto) AS promedio;  -- 💡 aquí estaba el error

ordenadas = ORDER altas BY monto DESC;

STORE total_ciudad INTO '/salida/por_ciudad' USING PigStorage(',');
STORE estadisticas INTO '/salida/por_categoria' USING PigStorage(',');
STORE ordenadas INTO '/salida/ventas_altas' USING PigStorage(',');
