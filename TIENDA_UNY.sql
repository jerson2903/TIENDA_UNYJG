-- Base de datos TIENDA_UNY
CREATE DATABASE TIENDA_UNY;
USE TIENDA_UNY;

CREATE TABLE Clientes (
  ID_cliente INT,
  nombre VARCHAR(50),
  telefono VARCHAR(50),
  direccion VARCHAR(100),
  PRIMARY KEY (ID_Cliente)
);

-- DROP TABLE IF EXISTS Productos;
CREATE TABLE Productos (
  ID INT AUTO_INCREMENT,
  nombre VARCHAR(255),
  precio DECIMAL(10, 2),
  stock INT,
  PRIMARY KEY (ID)
);

CREATE TABLE Pedidos (
  ID INT AUTO_INCREMENT,
  ID_cliente INT,
  fecha_pedido DATE,
  ID_producto INT,
  cantidad INT,
  precio DECIMAL(10, 2),
  PRIMARY KEY (ID),
  FOREIGN KEY (ID_producto) REFERENCES Productos(ID),
  FOREIGN KEY (ID_cliente) REFERENCES clientes(ID_cliente)
);

INSERT INTO Clientes (ID_cLiente, nombre, telefono, direccion) VALUES
  (1, "Jerson Gomez", "04145716176", "la antena"),
  (2, "Yoleida Vergara", "04146663322", "la vega"),
  (3, "Carlos Rojas", "04245776633", "Tamaca");

INSERT INTO Productos (nombre, precio, stock) VALUES
  ('Lapicero', 10.99, 5),
  ('Sacapuntas', 5.99, 3),
  ('Libros', 7.99, 2),
  ('Hojas', 8.55, 5);
  
 
 -- Procedimiento para realizar compra
DELIMITER //
CREATE PROCEDURE realizar_compra(
  IN ID_cliente INT,
  IN ID_producto1 INT,
  IN cantidad1 INT,
  IN ID_producto2 INT,
  IN cantidad2 INT
)
BEGIN
  DECLARE stock1 INT;
  DECLARE stock2 INT;

  -- Verificar stock
  SELECT stock INTO stock1 FROM Productos WHERE ID = ID_producto1;
  SELECT stock INTO stock2 FROM Productos WHERE ID = ID_producto2;

  IF stock1 >= cantidad1 AND stock2 >= cantidad2 THEN
  
    START TRANSACTION;

    -- Agregar pedidos
    INSERT INTO Pedidos (ID_cliente, fecha_pedido, ID_producto, cantidad, precio)
      VALUES
        (ID_cliente, CURDATE(), ID_producto1, cantidad1, (SELECT precio FROM Productos WHERE ID = ID_producto1)),
        (ID_cliente, CURDATE(), ID_producto2, cantidad2, (SELECT precio FROM Productos WHERE ID = ID_producto2));

    -- Actualizar stock
    UPDATE Productos SET stock = stock - cantidad1 WHERE ID = ID_producto1;
    UPDATE Productos SET stock = stock - cantidad2 WHERE ID = ID_producto2;

    -- Confirmar transacción
    COMMIT;
  ELSE
    -- Abortar transacción
    ROLLBACK;
  END IF;
END //
DELIMITER ;

-- Agregando productos al inventario
DELIMITER //
CREATE PROCEDURE agregar_producto(
  IN nombre_prod VARCHAR(50),
  IN precio_prod DECIMAL(10, 2),
  IN cantidad_prod INT
)
BEGIN
  START TRANSACTION;

  INSERT INTO Productos (ID, nombre, precio, stock)
    VALUES (nombre_prod, precio_prod, cantidad_prod);

  -- Confirmar transacción
  COMMIT;
END //
DELIMITER ;
  
  DELIMITER //
CREATE PROCEDURE agregar_stock(
  IN ID_prod INT,
  IN cantidad_prod INT
)
BEGIN
  START TRANSACTION;

  UPDATE Productos
    SET stock = stock + cantidad_prod
    WHERE ID = ID_prod;

  -- Confirmar transacción
  COMMIT;
END //
DELIMITER ;

-- se comentarizo lo de abajo para los ejemplos
-- DROP DATABASE IF EXISTS TIENDA_UNY;
-- 5 3 2 5

-- SELECT * FROM Productos

-- ID_cliente, ID_producto1, cantidad1, ID_producto2, cantidad2

-- CALL realizar_compra(1, 1, 2, 2, 1);

-- SELECT * FROM Productos

-- CALL realizar_compra(2, 3, 1, 4, 7);

-- SELECT * FROM Productos

-- CALL agregar_stock(2, 10);
-- SELECT * FROM Productos

-- SELECT * FROM Pedidos

  
  