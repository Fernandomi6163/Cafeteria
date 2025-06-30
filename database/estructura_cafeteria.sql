
-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS cafeteria_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cafeteria_db;

-- Tabla de categorías de productos
CREATE TABLE IF NOT EXISTS categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de productos
CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    categoria_id INT NOT NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE RESTRICT
);

-- Tabla de usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    usuario VARCHAR(50) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    rol ENUM('caja', 'cocina', 'barista', 'admin') NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de pedidos
CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('cocina', 'cafe') NOT NULL,
    estado ENUM('pendiente', 'en_preparacion', 'listo', 'cancelado') NOT NULL DEFAULT 'pendiente',
    total DECIMAL(10,2) NOT NULL CHECK (total >= 0),
    descuento DECIMAL(10,2) DEFAULT 0 CHECK (descuento >= 0),
    mesa VARCHAR(10),
    cliente VARCHAR(100),
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_id INT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL,
    INDEX idx_tipo (tipo),
    INDEX idx_estado (estado),
    INDEX idx_fecha (fecha)
);

-- Tabla detalle de pedidos
CREATE TABLE IF NOT EXISTS pedido_detalles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
    total DECIMAL(10,2) NOT NULL CHECK (total >= 0),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE RESTRICT
);

-- Historial de estados por pedido
CREATE TABLE IF NOT EXISTS pedido_estado_historial (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    estado ENUM('pendiente', 'en_preparacion', 'listo', 'cancelado') NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_id INT,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
);

-- Insertar categorías
INSERT INTO categorias (nombre) VALUES
('Café Caliente'),
('Café Frío'),
('Tés'),
('Bebidas Especiales'),
('Repostería');

-- Insertar productos
INSERT INTO productos (nombre, descripcion, precio, categoria_id) VALUES
('Latte', 'Café con leche vaporizada', 18.50, 1),
('Cappuccino', 'Espuma de leche con café', 20.00, 1),
('Cold Brew', 'Café frío infusionado por 12 horas', 22.00, 2),
('Matcha Latte', 'Té verde japonés con leche', 24.00, 4),
('Té Negro', 'Té caliente clásico', 10.00, 3),
('Té de Frutas Rojas', 'Infusión natural de frutos rojos', 12.00, 3),
('Muffin de Chocolate', 'Muffin artesanal con chispas', 8.00, 5),
('Croissant', 'Hojaldre clásico francés', 9.00, 5),
('Frapuccino Vainilla', 'Café frío batido con hielo y vainilla', 25.00, 2),
('Affogato', 'Helado de vainilla con espresso caliente', 26.00, 4);

-- Insertar usuarios
INSERT INTO usuarios (nombre, usuario, contrasena, rol) VALUES
('Carlos Ramírez', 'admin1', 'admin123', 'admin'),
('Lucía Pérez', 'lucia_caja', 'caja123', 'caja'),
('Marco Gómez', 'marco_cocina', 'cocina123', 'cocina'),
('Sofía Torres', 'sofia_barista', 'barista123', 'barista');

-- Insertar pedidos
INSERT INTO pedidos (tipo, estado, total, descuento, mesa, cliente, usuario_id) VALUES
('cafe', 'pendiente', 35.00, 0.00, 'M1', 'Juan Pérez', 2),
('cocina', 'en_preparacion', 17.00, 0.00, 'M3', 'Ana Soto', 2),
('cafe', 'listo', 50.00, 5.00, 'M5', 'Diego L.', 2),
('cafe', 'pendiente', 18.50, 0.00, NULL, 'Cliente para llevar', 2);

-- Insertar detalle de pedidos
INSERT INTO pedido_detalles (pedido_id, producto_id, cantidad, precio_unitario, total) VALUES
(1, 1, 1, 18.50, 18.50),
(1, 5, 1, 10.00, 10.00),
(1, 7, 1, 8.00, 8.00),
(2, 8, 1, 9.00, 9.00),
(2, 6, 1, 12.00, 12.00),
(3, 9, 2, 25.00, 50.00),
(4, 1, 1, 18.50, 18.50);

-- Insertar historial de estados
INSERT INTO pedido_estado_historial (pedido_id, estado, usuario_id) VALUES
(1, 'pendiente', 2),
(2, 'pendiente', 2),
(2, 'en_preparacion', 3),
(3, 'pendiente', 2),
(3, 'listo', 4),
(4, 'pendiente', 2);
