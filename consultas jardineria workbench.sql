-- informacion
use jardineria;
select  codigo_oficina, ciudad, ciudad, pais, telefono
from oficina;

-- empleados por oficina 
select codigo_oficina, nombre, apellido1, apellido2, puesto
from empleado
order by codigo_oficina;

-- promedio salario
select region, avg(limite_credito) as promedio_limite_credito
from cliente
group by region;

-- clientes y representante en ventas 
select cliente.nombre as cliente, concat (empleado.nombre,' ' , empleado.apellido) AS representante
from cliente
inner join empleado on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado;

-- productos en stock
select codigo, nombre, cantidad,_en_stock
from producto
where cantidad_en_stock>0;

-- productos bajo precio  del promedio
select codigo, nombre, precio_venta
from producto
where precio_venta < (select AVG(precio_venta) from producto); 

-- pedidos pendientes por clientes 
select pedido.codigo_pedido, pedido.estado, cliente.nombre_cliente 
from pedido
join cliente on pedido.codigo_cliente = cliente.codigo_cliente
where pedido.estado != 'entregado' ;

-- total productos por categoria, gama
select gama, count(codigo_producto) as total_producto
from producto
group by gama;

-- ingresos totales generados por clientes
select cliente.nombre_cliente, SUM(pago.total) as ingresos_totales 
from cliente 
join pago on cliente.codigo_cliente = pago.codigo_cliente
group by cliente.codigo_cliente;

-- pedidos realizados (fecha)
SELECT codigo_pedido, fecha_pedido
from pedido
where fecha_pedido BETWEEN '2008-01-01' AND '2008-01-31';

-- detalle pedido en especifico
SELECT pedido.codigo_pedido, producto.nombre, detalle_pedido.cantidad, 
       detalle_pedido.cantidad * detalle_pedido.precio_unidad AS precio_total
FROM pedido
JOIN detalle_pedido ON pedido.codigo_pedido = detalle_pedido.codigo_pedido
JOIN producto ON detalle_pedido.codigo_producto = producto.codigo_producto
WHERE pedido.codigo_pedido = 120;

-- productos mas vendidos
SELECT producto.codigo_producto, producto.nombre, SUM(detalle_pedido.cantidad) AS cantidad_total_vendida
FROM producto
JOIN detalle_pedido ON producto.codigo_producto = detalle_pedido.codigo_producto
GROUP BY producto.codigo_producto
ORDER BY cantidad_total_vendida DESC;

-- pedidos con un valor total o superior 
SELECT detalle_pedido.codigo_pedido, 
       SUM(detalle_pedido.cantidad * detalle_pedido.precio_unidad) AS valor_total
FROM detalle_pedido
GROUP BY detalle_pedido.codigo_pedido
HAVING valor_total > (SELECT AVG(detalle_pedido.cantidad * detalle_pedido.precio_unidad) 
                      FROM detalle_pedido);
                      
-- clientes sin representante de venta asignado
SELECT nombre_cliente
FROM cliente
WHERE codigo_empleado_rep_ventas IS NULL;

-- numero total de empleados por oficina 
SELECT codigo_oficina, COUNT(codigo_empleado) AS total_empleados
FROM empleado
GROUP BY codigo_oficina;

-- pagos realizados con cheque
SELECT cliente.nombre_cliente, pago.forma_pago, pago.total
FROM pago
JOIN cliente ON pago.codigo_cliente = cliente.codigo_cliente
WHERE pago.forma_pago = 'cheque';

-- ingresos mensuales 
SELECT MONTH(fecha_pago) AS mes, YEAR(fecha_pago) AS año, SUM(total) AS ingresos_totales
FROM pago
GROUP BY YEAR(fecha_pago), MONTH(fecha_pago);

-- clientes multiple pedidos 
SELECT cliente.nombre_cliente, COUNT(pedido.codigo_pedido) AS total_pedidos
FROM cliente
JOIN pedido ON cliente.codigo_cliente = pedido.codigo_cliente
GROUP BY cliente.codigo_cliente
HAVING total_pedidos > 1;

-- pedidos con productos agotados 
SELECT pedido.codigo_pedido, producto.nombre
FROM detalle_pedido
JOIN producto ON detalle_pedido.codigo_producto = producto.codigo_producto
JOIN pedido ON detalle_pedido.codigo_pedido = pedido.codigo_pedido
WHERE producto.cantidad_en_stock = 0;

-- Promedio, máximo y mínimo del límite de crédito de los clientes por país:
SELECT pais, 
       AVG(limite_credito) AS promedio_limite_credito,
       MAX(limite_credito) AS maximo_limite_credito,
       MIN(limite_credito) AS minimo_limite_credito
FROM cliente
GROUP BY pais;

-- historial de transacciones del cliente  
SELECT pago.fecha_pago, pago.total, pago.forma_pago
FROM pago
WHERE codigo_cliente = 5;

-- Empleados sin jefe directo asignado
SELECT nombre, apellido1, apellido2
FROM empleado
WHERE codigo_jefe IS NULL;

-- Productos con precio supera el promedio de su categoría (gama)
SELECT producto.codigo_producto, producto.nombre, producto.precio_venta
FROM producto
JOIN gama_producto ON producto.gama = gama_producto.gama
WHERE producto.precio_venta > (SELECT AVG(precio_venta) 
                               FROM producto 
                               WHERE gama = producto.gama);

--  promedio de dias de entrega por estado
SELECT estado, AVG(DATEDIFF(fecha_entrega, fecha_pedido)) AS promedio_dias_entrega
FROM pedido
WHERE fecha_entrega IS NOT NULL
GROUP BY estado;

-- Clientes por país con más de un pedido
SELECT cliente.pais, COUNT(cliente.codigo_cliente) AS clientes_con_multiples_pedidos
FROM cliente
JOIN pedido ON cliente.codigo_cliente = pedido.codigo_cliente
GROUP BY cliente.pais
HAVING COUNT(DISTINCT pedido.codigo_cliente) > 1;
