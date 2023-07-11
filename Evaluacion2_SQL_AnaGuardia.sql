-- EJERCICIO 1
-- Selecciona todos los campos de los productos, que pertenezcan a los proveedores con códigos: 1, 3, 7, 8 y 9, que tengan stock en el almacén,
-- y al mismo tiempo que sus precios unitarios estén entre 50 y 100. Por último, ordena los resultados por código de proveedor de forma ascendente.

USE Northwind;

SELECT products.supplier_id, products.unit_price, products.units_in_stock
FROM products
JOIN suppliers ON suppliers.supplier_id = products.supplier_id
WHERE products.supplier_id IN (1, 3, 7, 8, 9) AND products.units_in_stock > 0
AND products.unit_price BETWEEN 50 AND 100
ORDER BY products.supplier_id ASC;


-- EJERCICIO 2
-- Devuelve el nombre y apellidos y el id de los empleados con códigos entre el 3 y el 6, además que hayan vendido a clientes que tengan códigos que comiencen con las letras de la A hasta la G. 
-- Por último, en esta búsqueda queremos filtrar solo por aquellos envíos que la fecha de pedido este comprendida entre el 22 y el 31 de Diciembre de cualquier año.

-- tablas orders, employees, customers

SELECT employees.employee_id, employees.first_name, employees.last_name, orders.order_date, customers.customer_id
FROM employees
JOIN orders ON employees.employee_id = orders.employee_id
JOIN customers ON orders.customer_id = customers.customer_id
WHERE employees.employee_id BETWEEN 3 AND 6
AND customers.customer_id BETWEEN "A" AND "G"
AND MONTH(orders.order_date) = 12 
AND DAY(orders.order_date) BETWEEN 22 AND 31;


-- EJERCICIO 3
-- Calcula el precio de venta de cada pedido una vez aplicado el descuento. 
-- Muestra el id del la orden, el id del producto, el nombre del producto, 
-- el precio unitario, la cantidad, el descuento y el precio de venta después de haber aplicado el descuento.

SELECT order_details.order_id, products.product_id, products.product_name, products.unit_price, products.units_in_stock, order_details.discount,
(products.unit_price * products.units_in_stock * (1 - (order_details.discount / 100))) AS precio_venta
FROM products
JOIN order_details ON products.product_id = order_details.product_id;

-- EJERCICIO 4
-- Usando una subconsulta, muestra los productos cuyos precios estén por encima del precio medio total de los productos de la BBDD.

SELECT product_id, product_name, unit_price
FROM products
WHERE unit_price > (SELECT AVG(unit_price) FROM products);


-- EJERCICIO 5
-- ¿Qué productos ha vendido cada empleado y cuál es la cantidad vendida de cada uno de ellos?

SELECT employees.employee_id, employees.first_name, employees.last_name, products.product_id, products.product_name, SUM(order_details.quantity) AS cantidad_vendida
FROM employees
JOIN orders ON employees.employee_id = orders.employee_id
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
GROUP BY employees.employee_id, employees.first_name, employees.last_name, products.product_id, products.product_name;
