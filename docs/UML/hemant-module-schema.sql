-- SmartDairy: Hemant module tables/reference schema
CREATE TABLE IF NOT EXISTS distributors (
 id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(120) NOT NULL,
 mobile VARCHAR(20),
 shop_name VARCHAR(150),
 address VARCHAR(255),
 area VARCHAR(100),
 status VARCHAR(30) DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS deliveries (
 id INT PRIMARY KEY AUTO_INCREMENT,
 order_id INT NOT NULL,
 delivery_person VARCHAR(120) NOT NULL,
 mobile VARCHAR(20),
 vehicle_number VARCHAR(50),
 delivery_date DATE NOT NULL,
 route VARCHAR(150),
 status VARCHAR(30) DEFAULT 'PENDING',
 remarks VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS expenses (
 id INT PRIMARY KEY AUTO_INCREMENT,
 expense_date DATE NOT NULL,
 category VARCHAR(100) NOT NULL,
 amount DECIMAL(12,2) NOT NULL,
 description VARCHAR(500),
 payment_method VARCHAR(40)
);

CREATE INDEX idx_deliveries_date ON deliveries(delivery_date);
CREATE INDEX idx_deliveries_status ON deliveries(status);
CREATE INDEX idx_expenses_date ON expenses(expense_date);
CREATE INDEX idx_expenses_category ON expenses(category);
