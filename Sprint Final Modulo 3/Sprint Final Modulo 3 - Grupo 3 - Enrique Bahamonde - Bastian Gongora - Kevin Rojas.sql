-- Creacion de usuario

CREATE USER 'profe'@'localhost' IDENTIFIED BY '123456';

-- Privilegios a user

GRANT ALL PRIVILEGES ON * . * TO 'profe'@'localhost';

FLUSH PRIVILEGES;

-- Creación de Base de Datos 

CREATE DATABASE telovendo;

-- Selección de base de Dato 'telovendo'

USE telovendo;

-- Creación de tablas

CREATE TABLE proveedor(
	rut_proveedor VARCHAR(10) PRIMARY KEY,
	nombre_rep VARCHAR(80) NOT NULL,
    nombre_corporativo VARCHAR(255) NOT NULL,
	categoria_producto VARCHAR(45) DEFAULT 'Tecnología',   
	email VARCHAR(45) NOT NULL
);


CREATE TABLE contacto_proveedor(
	id_contacto INT AUTO_INCREMENT PRIMARY KEY,
	rut_proveedor VARCHAR(10) NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    telefono INT NOT NULL,
    FOREIGN KEY (rut_proveedor) references proveedor(rut_proveedor)
);

CREATE TABLE cliente(
	rut_cliente VARCHAR(10) PRIMARY KEY,
    nombre_cliente VARCHAR(25) NOT NULL,
    apellido_cliente VARCHAR(25) NOT NULL,
    direccion_cliente VARCHAR(45) NOT NULL
);

CREATE TABLE producto(
	id_producto VARCHAR(10) PRIMARY KEY,
	nombre_producto VARCHAR(100),
    precio INT NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    rut_proveedor VARCHAR(10) NOT NULL,
    color VARCHAR(25) NOT NULL,
    stock INT NOT NULL,
    FOREIGN KEY (rut_proveedor) references proveedor(rut_proveedor)
);

-- INSERT 5 PROVEEDORES A LA BASE DE DATOS
INSERT INTO proveedor() VALUES 
('78191530-0','Julio Cesar','IMPORTADORA CELCOM SA','Celulares','contacto@celcom.cl'),
('78530520-2','Juan Perez','TELOTRAIGO DE CHINA LTDA','Notebook','contacto@telotraigo.cl'),
('77890525-K','Enrique Bahamonde','EDUCOM LIMITADA','Librería y artículos de tecnología','contacto@educom.cl'),
('79555444-0','Bastian Góngora','ANDROID LTDA','Celulares','contacto@androidltda.cl'),
('74123456-9','Kevin Rojas','TECNOGLOBAL','Articulos de computación','contacto@tecnoglobal.cl')
;

-- INSERT 2 CONTACTOS POR PROVEEDOR
-- 2 Contacto para empresa id 78191530-0
INSERT INTO contacto_proveedor(rut_proveedor,nombre,telefono) VALUES 
('78191530-0','Luz Maria',966362686),
('78191530-0','José Rodriguez',966362687),
-- 2 Contacto para empresa id 78530520-2
('78530520-2','Alejandro Altamirano',988568745),
('78530520-2','Federico Portela',988568746),
-- 2 Contacto para empresa id 77890525-K
('77890525-K','Norma Somarriva',977565421),
('77890525-K','Tomas Delgado',977565422),
-- 2 Contacto para empresa id 79555444-0
('79555444-0','Sofía Rojas',963258741),
('79555444-0','Eduardo Puentes',963258742),
-- 2 Contacto para empresa id 74123456-9
('74123456-9','Elizabeth Zepeda',974114477),
('74123456-9','Rafael Poblete',974114478)
;

-- INSERT 5 CLIENTES A LA BASE DE DATOS
INSERT INTO cliente () VALUES 
  ('11111111-1', 'Juan', 'Pérez', 'Calle 123'),
  ('22222222-2', 'María', 'González', 'Avenida 456'),
  ('33333333-3', 'Pedro', 'Sánchez', 'Plaza 789'),
  ('44444444-4', 'Ana', 'López', 'Carrera 321'),
  ('55555555-5', 'Luis', 'Rodríguez', 'Camino 654')
;



-- INSERT 10 PRODUCTOS A LA BASE DE DATOS
INSERT INTO producto () VALUES
  ('P1', 'iPhone 12 Pro Max', 500000 , 'Teléfonos', '78191530-0', 'Gris Espacial', 50),
  ('P2', 'Samsung QLED 4K TV', 300000 , 'Televisores', '78530520-2', 'Negro', 20),
  ('P3', 'MacBook Pro 13"', 1500000, 'Laptops', '78530520-2', 'Plata', 30),
  ('P4', 'Canon EOS R6',200000, 'Cámaras',   '77890525-K', 'Negro', 15),
  ('P5', 'JBL Flip 5', 65000, 'Altavoces', '79555444-0', 'Azul', 10),
  ('P6', 'JBL Flip 5', 68000, 'Altavoces', '74123456-9', 'Azul', 4),
  ('P7', 'Apple Watch Series 7', 150000, 'Smartwatches', '74123456-9', 'Plateado', 8),
  ('P8', 'iPad Air', 400000, 'Tabletas', '77890525-K', 'Gris Espacial', 12),
  ('P9', 'HP OfficeJet Pro 9015', 90000 , 'Impresoras', '78191530-0', 'Blanco', 7),
  ('P10', 'iPhone 12 Pro Max', 550000 , 'Teléfonos', '74123456-9', 'Gris Espacial', 5)  
  ;
  
-- CONSULTAS SQL
-- Cuál es la categoría de productos que más se repite
  
SELECT categoria, COUNT(*) as cantidad
FROM producto
GROUP BY categoria
ORDER BY cantidad DESC
LIMIT 1;

-- Cuáles son los productos con mayor stock
-- Se busca el producto que tenga más stock
SELECT * FROM producto WHERE stock = (SELECT MAX(stock) FROM producto) ORDER BY stock DESC;
-- Muestra los 5 productos con más stock
SELECT id_producto, nombre_producto, stock FROM producto ORDER BY stock DESC LIMIT 5;

-- Qué color de producto es más común en nuestra tienda.
SELECT color AS 'Color que más se repite'
FROM producto
GROUP BY color
ORDER BY COUNT(*) DESC
LIMIT 1;


-- Cual o cuales son los proveedores con menor stock de productos.
-- Solucion con JOIN
SELECT p.rut_proveedor, p.nombre_rep, p.nombre_corporativo, MIN(pr.stock) AS menor_stock
FROM proveedor p JOIN producto pr ON p.rut_proveedor = pr.rut_proveedor 
GROUP BY p.rut_proveedor, p.nombre_rep HAVING MIN(pr.stock) = (SELECT MIN(stock) FROM producto);

-- Solucion con INNER JOIN
SELECT a.rut_proveedor, b.nombre_corporativo
FROM producto a INNER JOIN proveedor b ON a.rut_proveedor = b.rut_proveedor WHERE a.stock = (SELECT MIN(stock) FROM producto) ORDER BY a.stock DESC;




-- Cambien la categoría de productos más popular por ‘Electrónica y computación’.

UPDATE producto
SET categoria = 'Electrónica y computación'
WHERE categoria = (
    SELECT categoria
    FROM (
        SELECT categoria, COUNT(*) AS cantidad
        FROM producto
        GROUP BY categoria
        ORDER BY cantidad DESC
        LIMIT 1
    ) as ejecutar
);

-- Cuál es la categoría de productos que más se repite para verificar el cambio del punto anterior
  
SELECT categoria, COUNT(*) as cantidad
FROM producto
GROUP BY categoria
ORDER BY cantidad DESC
LIMIT 1;