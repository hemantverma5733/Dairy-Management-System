-- SmartDairy: Product + Inventory module verification schema
-- Use only if these tables do not already exist in the base database.

CREATE TABLE IF NOT EXISTS products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(100),
    unit VARCHAR(30),
    purchase_price DECIMAL(12,2) NOT NULL DEFAULT 0,
    selling_price DECIMAL(12,2) NOT NULL DEFAULT 0,
    stock DECIMAL(12,2) NOT NULL DEFAULT 0,
    minimum_stock DECIMAL(12,2) NOT NULL DEFAULT 0,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS inventory (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    transaction_type VARCHAR(30) NOT NULL,
    quantity DECIMAL(12,2) NOT NULL,
    reference_type VARCHAR(50),
    reference_id INT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    remarks VARCHAR(500),
    CONSTRAINT fk_inventory_product FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE INDEX idx_products_name ON products(product_name);
CREATE INDEX idx_products_status ON products(status);
CREATE INDEX idx_inventory_product ON inventory(product_id);
CREATE INDEX idx_inventory_date ON inventory(transaction_date);
