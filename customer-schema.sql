-- SmartDairy Customer Management schema
CREATE TABLE IF NOT EXISTS customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(120) NOT NULL,
    mobile VARCHAR(10) NOT NULL,
    address VARCHAR(255),
    customer_type VARCHAR(30) NOT NULL DEFAULT 'RETAIL',
    status VARCHAR(15) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_customer_name (name),
    INDEX idx_customer_mobile (mobile),
    INDEX idx_customer_status (status)
);
