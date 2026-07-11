CREATE DATABASE IF NOT EXISTS retail_data_quality
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE retail_data_quality;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS sales_targets;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS sales_representatives;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_email VARCHAR(255),
    region VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    unit_cost DECIMAL(10,2) NOT NULL CHECK (unit_cost >= 0)
) ENGINE=InnoDB;

CREATE TABLE sales_representatives (
    representative_id INTEGER PRIMARY KEY,
    representative_name VARCHAR(120) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE sales (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(10) NOT NULL,
    representative_id INTEGER NOT NULL,
    sales_channel VARCHAR(50) NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    discount_rate DECIMAL(5,4) NOT NULL CHECK (discount_rate BETWEEN 0 AND 0.5),
    payment_method VARCHAR(50) NOT NULL,
    order_status VARCHAR(20) NOT NULL CHECK (order_status IN ('Completed','Returned','Cancelled')),
    CONSTRAINT fk_sales_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_sales_product FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT fk_sales_representative FOREIGN KEY (representative_id) REFERENCES sales_representatives(representative_id)
) ENGINE=InnoDB;

CREATE TABLE sales_targets (
    target_month CHAR(7) NOT NULL,
    region VARCHAR(50) NOT NULL,
    revenue_target DECIMAL(12,2) NOT NULL CHECK (revenue_target >= 0),
    profit_target DECIMAL(12,2) NOT NULL CHECK (profit_target >= 0),
    PRIMARY KEY (target_month, region)
) ENGINE=InnoDB;

-- Helpful indexes for common filters and joins.
CREATE INDEX idx_sales_order_date ON sales(order_date);
CREATE INDEX idx_sales_customer_id ON sales(customer_id);
CREATE INDEX idx_sales_product_id ON sales(product_id);
CREATE INDEX idx_sales_status ON sales(order_status);

START TRANSACTION;

-- Customers
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1001', 'client79@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1002', 'client180@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1003', 'client136@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1005', 'client74@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1006', 'client1@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1007', 'client62@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1008', 'client171@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1009', 'client39@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1010', 'client22@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1011', 'client175@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1012', 'client138@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1013', 'client113@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1014', 'client25@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1015', 'client37@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1016', 'client33@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1017', 'client11@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1018', 'client77@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1019', 'client5@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1020', 'client156@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1021', 'client113@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1022', 'client152@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1023', 'client93@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1024', 'client70@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1025', 'client159@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1027', 'client113@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1028', 'client149@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1029', 'client158@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1030', 'client55@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1031', 'client147@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1032', 'client118@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1033', 'client169@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1034', 'client172@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1035', 'client1@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1036', 'client38@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1037', 'client21@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1038', 'client30@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1039', 'client42@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1040', 'client146@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1041', 'client179@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1042', 'client27@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1043', 'client173@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1044', 'client125@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1046', 'client13@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1047', 'client142@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1048', 'client133@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1049', 'client146@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1050', 'client21@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1051', 'client167@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1052', 'client137@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1053', 'client120@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1055', 'client179@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1056', 'client28@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1057', 'client81@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1058', 'client69@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1059', 'client145@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1060', 'client175@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1061', 'client65@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1062', 'client55@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1063', 'client161@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1065', 'client155@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1066', 'client103@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1067', 'client143@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1068', 'client35@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1069', 'client140@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1071', 'client97@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1072', 'client143@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1073', 'client173@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1074', 'client134@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1076', 'client177@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1077', 'client84@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1078', 'client158@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1080', 'client40@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1082', 'client60@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1083', 'client28@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1085', 'client9@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1086', 'client25@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1087', 'client116@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1088', 'client21@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1089', 'client31@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1090', 'client70@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1091', 'client13@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1092', 'client123@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1093', 'client169@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1094', 'client58@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1095', 'client178@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1096', 'client156@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1097', 'client17@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1098', 'client168@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1099', 'client5@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1100', 'client98@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1101', 'client127@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1102', 'client177@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1103', 'client151@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1104', 'client29@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1105', 'client84@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1106', 'client117@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1107', 'client178@example.com', 'West');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1108', 'client138@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1109', 'client58@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1110', 'client93@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1112', 'client14@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1113', 'client79@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1114', 'client51@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1115', 'client139@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1116', 'client130@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1117', 'client45@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1118', 'client22@example.com', 'Bucharest');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1119', 'client86@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1120', 'client145@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1121', 'client64@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1122', 'client102@example.com', 'South');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1123', 'client119@example.com', 'North');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1124', 'client31@example.com', 'East');
INSERT INTO customers (customer_id, customer_email, region) VALUES ('C1125', 'client114@example.com', 'West');

-- Products
INSERT INTO products (product_id, product_name, category, unit_price, unit_cost) VALUES ('P1001', 'Laptop Stand', 'Accessories', 95.0, 52.0);
INSERT INTO products (product_id, product_name, category, unit_price, unit_cost) VALUES ('P1002', 'Wireless Mouse', 'Accessories', 85.0, 44.0);
INSERT INTO products (product_id, product_name, category, unit_price, unit_cost) VALUES ('P1003', 'Mechanical Keyboard', 'Accessories', 265.0, 155.0);
INSERT INTO products (product_id, product_name, category, unit_price, unit_cost) VALUES ('P1004', 'USB-C Hub', 'Accessories', 175.0, 98.0);
INSERT INTO products (product_id, product_name, category, unit_price, unit_cost) VALUES ('P1005', '24-inch Monitor', 'Electronics', 720.0, 510.0);
INSERT INTO products (product_id, product_name, category, unit_price, unit_cost) VALUES ('P1006', '27-inch Monitor', 'Electronics', 1090.0, 790.0);
INSERT INTO products (product_id, product_name, category, unit_price, unit_cost) VALUES ('P1007', 'Office Chair', 'Furniture', 840.0, 590.0);
INSERT INTO products (product_id, product_name, category, unit_price, unit_cost) VALUES ('P1008', 'Standing Desk', 'Furniture', 1450.0, 1030.0);
INSERT INTO products (product_id, product_name, category, unit_price, unit_cost) VALUES ('P1009', 'Webcam', 'Electronics', 230.0, 132.0);
INSERT INTO products (product_id, product_name, category, unit_price, unit_cost) VALUES ('P1010', 'Headset', 'Electronics', 195.0, 105.0);

-- Sales representatives
INSERT INTO sales_representatives (representative_id, representative_name) VALUES (1, 'Andrei Pop');
INSERT INTO sales_representatives (representative_id, representative_name) VALUES (2, 'Elena Stan');
INSERT INTO sales_representatives (representative_id, representative_name) VALUES (3, 'Ioana Pavel');
INSERT INTO sales_representatives (representative_id, representative_name) VALUES (4, 'Maria Ionescu');
INSERT INTO sales_representatives (representative_id, representative_name) VALUES (5, 'Mihai Radu');

-- Sales transactions
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10001', '2025-01-13', 'C1029', 'P1002', 3, 'Marketplace', 12, 0.05, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10002', '2025-08-05', 'C1028', 'P1010', 1, 'Marketplace', 1, 0, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10003', '2025-08-03', 'C1036', 'P1009', 5, 'Marketplace', 4, 0.1, 'Cash', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10004', '2025-03-21', 'C1012', 'P1005', 2, 'Store', 4, 0.05, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10005', '2025-08-24', 'C1011', 'P1001', 3, 'Marketplace', 9, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10006', '2025-04-09', 'C1085', 'P1010', 4, 'Online', 12, 0, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10007', '2025-05-23', 'C1021', 'P1007', 2, 'Online', 8, 0.2, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10008', '2025-11-22', 'C1032', 'P1010', 2, 'Store', 3, 0.15, 'Bank Transfer', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10009', '2025-01-29', 'C1052', 'P1006', 3, 'Online', 4, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10011', '2025-08-08', 'C1029', 'P1010', 1, 'Store', 10, 0.1, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10012', '2025-03-20', 'C1055', 'P1002', 5, 'Store', 11, 0, 'Online Wallet', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10013', '2025-05-09', 'C1093', 'P1009', 2, 'Store', 9, 0, 'Card', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10014', '2025-08-11', 'C1123', 'P1005', 3, 'Online', 3, 0.1, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10015', '2025-11-24', 'C1020', 'P1005', 3, 'Marketplace', 9, 0.15, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10016', '2025-06-15', 'C1119', 'P1010', 1, 'Online', 8, 0, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10017', '2025-02-10', 'C1105', 'P1010', 4, 'Online', 2, 0.2, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10018', '2025-03-26', 'C1055', 'P1009', 4, 'Marketplace', 5, 0.15, 'Cash', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10019', '2025-12-10', 'C1116', 'P1007', 4, 'Online', 11, 0.05, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10020', '2025-06-23', 'C1030', 'P1002', 1, 'Online', 1, 0.15, 'Card', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10021', '2025-02-04', 'C1066', 'P1004', 5, 'Marketplace', 1, 0.05, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10022', '2025-03-09', 'C1061', 'P1009', 4, 'Store', 12, 0.15, 'Card', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10023', '2025-12-04', 'C1053', 'P1002', 1, 'Marketplace', 7, 0.05, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10024', '2025-06-23', 'C1025', 'P1007', 5, 'Online', 2, 0, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10026', '2025-05-02', 'C1062', 'P1002', 4, 'Online', 3, 0.1, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10027', '2025-07-19', 'C1055', 'P1001', 5, 'Marketplace', 5, 0.1, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10028', '2025-06-01', 'C1095', 'P1004', 2, 'Marketplace', 4, 0, 'Card', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10029', '2025-10-27', 'C1021', 'P1001', 4, 'Online', 8, 0.15, 'Card', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10030', '2025-02-04', 'C1016', 'P1010', 3, 'Marketplace', 11, 0, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10031', '2025-02-11', 'C1073', 'P1010', 4, 'Store', 7, 0.2, 'Cash', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10032', '2025-05-16', 'C1083', 'P1004', 1, 'Store', 7, 0, 'Card', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10033', '2025-11-15', 'C1069', 'P1008', 4, 'Store', 10, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10034', '2025-05-06', 'C1057', 'P1002', 3, 'Marketplace', 6, 0.05, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10035', '2025-06-03', 'C1034', 'P1009', 3, 'Marketplace', 11, 0, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10036', '2025-05-25', 'C1044', 'P1005', 5, 'Marketplace', 10, 0, 'Cash', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10037', '2025-02-17', 'C1006', 'P1001', 2, 'Online', 11, 0.1, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10038', '2025-10-10', 'C1002', 'P1008', 4, 'Marketplace', 12, 0.1, 'Card', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10039', '2025-10-26', 'C1017', 'P1006', 1, 'Store', 9, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10040', '2025-12-16', 'C1046', 'P1004', 4, 'Marketplace', 4, 0.2, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10041', '2025-04-01', 'C1095', 'P1003', 4, 'Marketplace', 7, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10042', '2025-12-26', 'C1110', 'P1003', 5, 'Online', 2, 0.1, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10043', '2025-04-27', 'C1025', 'P1005', 1, 'Store', 4, 0, 'Cash', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10044', '2025-11-25', 'C1108', 'P1006', 1, 'Online', 9, 0.1, 'Cash', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10045', '2025-10-25', 'C1077', 'P1003', 2, 'Marketplace', 5, 0, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10046', '2025-09-19', 'C1025', 'P1010', 5, 'Marketplace', 2, 0.1, 'Card', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10047', '2025-10-03', 'C1095', 'P1009', 5, 'Store', 11, 0.2, 'Card', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10048', '2025-11-16', 'C1093', 'P1006', 5, 'Store', 6, 0.2, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10050', '2025-10-08', 'C1027', 'P1007', 2, 'Marketplace', 1, 0.05, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10051', '2025-08-15', 'C1061', 'P1008', 3, 'Store', 11, 0, 'Cash', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10052', '2025-05-01', 'C1104', 'P1002', 1, 'Online', 11, 0.05, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10053', '2025-11-09', 'C1114', 'P1008', 5, 'Online', 2, 0.1, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10054', '2025-05-05', 'C1001', 'P1007', 4, 'Online', 3, 0.2, 'Online Wallet', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10055', '2025-10-13', 'C1018', 'P1001', 3, 'Marketplace', 4, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10056', '2025-11-10', 'C1107', 'P1008', 5, 'Online', 12, 0.15, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10057', '2025-05-07', 'C1063', 'P1005', 5, 'Store', 11, 0.05, 'Card', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10058', '2025-05-01', 'C1115', 'P1005', 4, 'Online', 5, 0.05, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10059', '2025-12-22', 'C1009', 'P1007', 3, 'Store', 3, 0.2, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10060', '2025-02-01', 'C1116', 'P1007', 5, 'Marketplace', 4, 0.1, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10061', '2025-06-30', 'C1069', 'P1001', 5, 'Online', 5, 0.1, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10062', '2025-08-12', 'C1044', 'P1005', 4, 'Marketplace', 8, 0, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10063', '2025-11-15', 'C1076', 'P1003', 5, 'Online', 9, 0, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10064', '2025-04-04', 'C1042', 'P1008', 2, 'Store', 1, 0.05, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10065', '2025-08-04', 'C1003', 'P1005', 4, 'Store', 5, 0, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10066', '2025-01-16', 'C1080', 'P1001', 5, 'Online', 4, 0, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10067', '2025-04-22', 'C1099', 'P1010', 3, 'Marketplace', 8, 0.2, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10068', '2025-06-09', 'C1119', 'P1003', 5, 'Marketplace', 2, 0.15, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10069', '2025-02-08', 'C1032', 'P1004', 3, 'Marketplace', 10, 0.2, 'Card', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10070', '2025-01-22', 'C1085', 'P1010', 2, 'Marketplace', 6, 0.15, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10071', '2025-09-08', 'C1082', 'P1007', 4, 'Store', 2, 0.1, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10072', '2025-10-03', 'C1106', 'P1010', 4, 'Store', 8, 0.1, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10074', '2025-04-04', 'C1103', 'P1006', 3, 'Store', 8, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10075', '2025-01-06', 'C1031', 'P1009', 4, 'Marketplace', 9, 0, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10076', '2025-08-18', 'C1029', 'P1008', 3, 'Store', 1, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10077', '2025-10-11', 'C1096', 'P1008', 5, 'Store', 9, 0.05, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10078', '2025-05-09', 'C1025', 'P1005', 3, 'Marketplace', 4, 0, 'Bank Transfer', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10079', '2025-04-21', 'C1093', 'P1004', 2, 'Marketplace', 12, 0.1, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10080', '2025-06-01', 'C1039', 'P1004', 2, 'Online', 4, 0.05, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10081', '2025-10-11', 'C1082', 'P1001', 3, 'Online', 5, 0.2, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10082', '2025-09-03', 'C1124', 'P1008', 1, 'Store', 8, 0.05, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10083', '2025-09-09', 'C1088', 'P1007', 3, 'Online', 2, 0.15, 'Cash', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10084', '2025-05-08', 'C1078', 'P1002', 3, 'Online', 2, 0.15, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10085', '2025-08-15', 'C1040', 'P1008', 3, 'Online', 5, 0.15, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10086', '2025-11-17', 'C1011', 'P1004', 3, 'Online', 4, 0.05, 'Card', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10087', '2025-01-02', 'C1077', 'P1003', 4, 'Online', 7, 0.1, 'Cash', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10088', '2025-12-26', 'C1030', 'P1005', 4, 'Marketplace', 8, 0, 'Online Wallet', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10089', '2025-10-06', 'C1117', 'P1002', 1, 'Online', 4, 0.2, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10090', '2025-11-01', 'C1057', 'P1005', 2, 'Marketplace', 12, 0.15, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10091', '2025-09-14', 'C1011', 'P1005', 2, 'Store', 9, 0.1, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10092', '2025-02-16', 'C1076', 'P1001', 1, 'Marketplace', 4, 0.2, 'Bank Transfer', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10093', '2025-09-23', 'C1024', 'P1008', 5, 'Marketplace', 11, 0.1, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10094', '2025-06-28', 'C1086', 'P1008', 5, 'Store', 7, 0.05, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10095', '2025-12-06', 'C1059', 'P1005', 2, 'Store', 7, 0.15, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10097', '2025-09-13', 'C1027', 'P1010', 2, 'Online', 11, 0.1, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10098', '2025-03-04', 'C1103', 'P1008', 3, 'Store', 1, 0.2, 'Card', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10099', '2025-07-28', 'C1060', 'P1009', 2, 'Store', 2, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10100', '2025-09-05', 'C1071', 'P1007', 3, 'Online', 8, 0, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10101', '2025-05-22', 'C1035', 'P1002', 2, 'Marketplace', 7, 0.05, 'Online Wallet', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10102', '2025-08-17', 'C1043', 'P1003', 5, 'Store', 9, 0.1, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10103', '2025-12-24', 'C1030', 'P1004', 5, 'Store', 4, 0.15, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10104', '2025-12-06', 'C1124', 'P1007', 3, 'Marketplace', 11, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10105', '2025-08-14', 'C1002', 'P1002', 4, 'Marketplace', 2, 0.15, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10106', '2025-05-16', 'C1051', 'P1008', 3, 'Store', 6, 0.15, 'Online Wallet', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10107', '2025-11-17', 'C1005', 'P1006', 2, 'Online', 12, 0.1, 'Bank Transfer', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10108', '2025-08-11', 'C1112', 'P1002', 2, 'Online', 2, 0.2, 'Card', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10109', '2025-06-16', 'C1048', 'P1001', 3, 'Online', 1, 0.05, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10110', '2025-12-16', 'C1011', 'P1010', 4, 'Marketplace', 3, 0, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10111', '2025-03-15', 'C1033', 'P1010', 1, 'Marketplace', 4, 0.1, 'Online Wallet', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10112', '2025-12-13', 'C1057', 'P1005', 5, 'Store', 9, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10113', '2025-06-04', 'C1014', 'P1008', 2, 'Marketplace', 4, 0.1, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10114', '2025-01-12', 'C1002', 'P1005', 5, 'Marketplace', 11, 0.1, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10115', '2025-11-07', 'C1025', 'P1004', 4, 'Marketplace', 6, 0, 'Card', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10116', '2025-06-08', 'C1047', 'P1001', 2, 'Store', 8, 0, 'Online Wallet', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10117', '2025-04-13', 'C1068', 'P1003', 2, 'Online', 3, 0.15, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10118', '2025-06-23', 'C1019', 'P1005', 2, 'Marketplace', 2, 0.1, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10119', '2025-01-08', 'C1059', 'P1007', 5, 'Marketplace', 5, 0.15, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10121', '2025-12-25', 'C1015', 'P1008', 2, 'Online', 5, 0.2, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10122', '2025-02-19', 'C1050', 'P1002', 3, 'Marketplace', 4, 0.15, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10123', '2025-03-21', 'C1107', 'P1010', 2, 'Store', 7, 0.2, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10124', '2025-04-22', 'C1110', 'P1006', 2, 'Marketplace', 8, 0.1, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10125', '2025-07-23', 'C1122', 'P1001', 4, 'Marketplace', 5, 0, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10126', '2025-06-20', 'C1027', 'P1001', 3, 'Online', 4, 0, 'Bank Transfer', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10127', '2025-06-18', 'C1036', 'P1004', 2, 'Marketplace', 3, 0.15, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10128', '2025-12-05', 'C1046', 'P1002', 1, 'Store', 1, 0, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10129', '2025-01-27', 'C1068', 'P1005', 5, 'Store', 3, 0.2, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10130', '2025-10-31', 'C1029', 'P1009', 3, 'Marketplace', 2, 0.1, 'Cash', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10131', '2025-11-26', 'C1109', 'P1008', 1, 'Marketplace', 1, 0, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10132', '2025-02-07', 'C1019', 'P1008', 3, 'Store', 2, 0.05, 'Cash', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10133', '2025-11-02', 'C1065', 'P1007', 1, 'Online', 9, 0.05, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10134', '2025-08-20', 'C1106', 'P1007', 1, 'Store', 4, 0.1, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10135', '2025-06-10', 'C1123', 'P1007', 1, 'Online', 11, 0.05, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10136', '2025-08-10', 'C1048', 'P1002', 3, 'Online', 2, 0.2, 'Cash', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10137', '2025-07-30', 'C1112', 'P1002', 2, 'Marketplace', 6, 0.2, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10138', '2025-10-23', 'C1085', 'P1002', 2, 'Online', 9, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10139', '2025-05-23', 'C1109', 'P1002', 3, 'Marketplace', 10, 0, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10140', '2025-12-03', 'C1024', 'P1010', 2, 'Store', 12, 0.05, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10141', '2025-03-15', 'C1009', 'P1003', 3, 'Online', 10, 0.2, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10142', '2025-08-03', 'C1048', 'P1007', 3, 'Marketplace', 8, 0.05, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10143', '2025-03-21', 'C1087', 'P1001', 5, 'Store', 3, 0.15, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10145', '2025-12-14', 'C1068', 'P1005', 4, 'Online', 11, 0.15, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10146', '2025-01-29', 'C1122', 'P1010', 2, 'Store', 1, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10147', '2025-01-04', 'C1023', 'P1002', 4, 'Marketplace', 8, 0.2, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10148', '2025-07-23', 'C1003', 'P1002', 3, 'Store', 12, 0, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10149', '2025-07-27', 'C1038', 'P1010', 2, 'Online', 12, 0.2, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10150', '2025-08-24', 'C1056', 'P1010', 3, 'Store', 12, 0.05, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10151', '2025-02-10', 'C1044', 'P1009', 1, 'Online', 7, 0.05, 'Card', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10152', '2025-09-19', 'C1094', 'P1009', 1, 'Online', 4, 0.05, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10153', '2025-04-12', 'C1098', 'P1005', 5, 'Online', 3, 0.15, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10154', '2025-10-24', 'C1083', 'P1010', 2, 'Store', 8, 0.2, 'Bank Transfer', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10155', '2025-02-04', 'C1039', 'P1008', 2, 'Online', 8, 0.1, 'Card', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10156', '2025-08-25', 'C1048', 'P1005', 1, 'Marketplace', 8, 0, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10157', '2025-10-25', 'C1058', 'P1008', 3, 'Store', 9, 0.2, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10158', '2025-03-19', 'C1104', 'P1009', 4, 'Marketplace', 1, 0.1, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10159', '2025-12-29', 'C1067', 'P1004', 2, 'Store', 8, 0.1, 'Cash', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10160', '2025-07-29', 'C1007', 'P1007', 2, 'Online', 6, 0.2, 'Card', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10161', '2025-12-14', 'C1093', 'P1009', 2, 'Online', 7, 0.05, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10162', '2025-12-06', 'C1124', 'P1010', 3, 'Online', 3, 0.05, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10163', '2025-10-14', 'C1105', 'P1005', 5, 'Online', 7, 0.2, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10164', '2025-07-05', 'C1044', 'P1001', 4, 'Online', 5, 0, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10165', '2025-06-01', 'C1107', 'P1002', 2, 'Marketplace', 2, 0.15, 'Bank Transfer', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10166', '2025-07-12', 'C1107', 'P1010', 5, 'Online', 3, 0, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10167', '2025-07-06', 'C1125', 'P1007', 5, 'Store', 11, 0.2, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10169', '2025-09-15', 'C1105', 'P1007', 2, 'Online', 9, 0.1, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10170', '2025-07-10', 'C1109', 'P1008', 1, 'Store', 9, 0, 'Bank Transfer', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10171', '2025-08-19', 'C1012', 'P1005', 1, 'Store', 9, 0, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10172', '2025-07-22', 'C1050', 'P1001', 1, 'Online', 9, 0.05, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10173', '2025-11-29', 'C1005', 'P1002', 4, 'Marketplace', 6, 0, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10174', '2025-11-12', 'C1033', 'P1008', 3, 'Marketplace', 1, 0, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10175', '2025-05-28', 'C1007', 'P1002', 3, 'Marketplace', 4, 0.05, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10176', '2025-02-26', 'C1003', 'P1002', 4, 'Marketplace', 8, 0.15, 'Bank Transfer', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10177', '2025-08-08', 'C1031', 'P1005', 1, 'Online', 1, 0.15, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10178', '2025-09-27', 'C1071', 'P1002', 1, 'Store', 9, 0.15, 'Online Wallet', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10179', '2025-05-10', 'C1101', 'P1006', 1, 'Online', 12, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10180', '2025-01-23', 'C1105', 'P1003', 5, 'Marketplace', 6, 0.15, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10181', '2025-03-11', 'C1005', 'P1003', 4, 'Online', 2, 0.2, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10182', '2025-06-08', 'C1061', 'P1006', 4, 'Marketplace', 9, 0.1, 'Cash', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10183', '2025-01-25', 'C1016', 'P1006', 5, 'Store', 11, 0.05, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10184', '2025-04-06', 'C1048', 'P1006', 5, 'Online', 8, 0.2, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10185', '2025-11-05', 'C1042', 'P1007', 2, 'Store', 3, 0.15, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10186', '2025-11-05', 'C1089', 'P1008', 1, 'Store', 12, 0.1, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10187', '2025-08-11', 'C1010', 'P1010', 3, 'Store', 5, 0.2, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10188', '2025-03-15', 'C1005', 'P1001', 2, 'Online', 10, 0.2, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10189', '2025-10-18', 'C1087', 'P1007', 5, 'Store', 1, 0.15, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10190', '2025-03-12', 'C1041', 'P1010', 1, 'Online', 9, 0.05, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10191', '2025-09-13', 'C1016', 'P1003', 5, 'Marketplace', 9, 0.1, 'Bank Transfer', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10192', '2025-05-27', 'C1016', 'P1010', 4, 'Store', 12, 0.1, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10193', '2025-12-16', 'C1091', 'P1002', 2, 'Marketplace', 6, 0.2, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10194', '2025-12-31', 'C1023', 'P1003', 1, 'Online', 12, 0.2, 'Bank Transfer', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10195', '2025-05-02', 'C1071', 'P1003', 3, 'Store', 8, 0, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10196', '2025-02-14', 'C1092', 'P1010', 5, 'Store', 2, 0.05, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10197', '2025-06-12', 'C1060', 'P1003', 4, 'Store', 11, 0, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10198', '2025-08-10', 'C1067', 'P1003', 4, 'Online', 9, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10199', '2025-06-27', 'C1033', 'P1004', 4, 'Store', 9, 0.05, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10200', '2025-10-01', 'C1022', 'P1010', 4, 'Online', 2, 0.15, 'Cash', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10201', '2025-01-22', 'C1122', 'P1010', 4, 'Store', 1, 0, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10203', '2025-08-21', 'C1021', 'P1005', 5, 'Store', 2, 0.2, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10204', '2025-11-07', 'C1041', 'P1006', 2, 'Online', 3, 0.05, 'Card', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10205', '2025-05-04', 'C1058', 'P1006', 1, 'Online', 8, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10206', '2025-11-12', 'C1105', 'P1007', 2, 'Marketplace', 7, 0, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10207', '2025-09-13', 'C1113', 'P1003', 1, 'Online', 9, 0.1, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10208', '2025-08-23', 'C1046', 'P1009', 5, 'Store', 4, 0, 'Online Wallet', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10209', '2025-10-02', 'C1018', 'P1005', 2, 'Store', 1, 0, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10210', '2025-01-27', 'C1047', 'P1007', 5, 'Online', 10, 0.15, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10211', '2025-05-24', 'C1016', 'P1009', 2, 'Store', 10, 0.2, 'Cash', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10212', '2025-07-07', 'C1066', 'P1009', 1, 'Online', 3, 0, 'Card', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10213', '2025-06-20', 'C1020', 'P1003', 2, 'Online', 8, 0.15, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10214', '2025-07-21', 'C1076', 'P1003', 3, 'Marketplace', 10, 0.2, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10215', '2025-06-03', 'C1043', 'P1010', 3, 'Store', 8, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10216', '2025-11-02', 'C1101', 'P1001', 1, 'Online', 8, 0.05, 'Online Wallet', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10217', '2025-09-26', 'C1100', 'P1003', 4, 'Marketplace', 11, 0.2, 'Card', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10218', '2025-12-25', 'C1057', 'P1010', 5, 'Online', 2, 0, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10219', '2025-09-14', 'C1094', 'P1007', 4, 'Marketplace', 10, 0.1, 'Cash', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10220', '2025-09-27', 'C1059', 'P1008', 2, 'Marketplace', 7, 0.05, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10221', '2025-09-05', 'C1072', 'P1010', 2, 'Store', 4, 0, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10222', '2025-06-12', 'C1120', 'P1008', 3, 'Online', 8, 0.05, 'Online Wallet', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10223', '2025-06-26', 'C1037', 'P1007', 2, 'Store', 3, 0.05, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10224', '2025-04-14', 'C1090', 'P1004', 3, 'Online', 9, 0.05, 'Bank Transfer', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10225', '2025-01-26', 'C1082', 'P1004', 5, 'Online', 11, 0.15, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10227', '2025-05-28', 'C1008', 'P1004', 3, 'Online', 6, 0.05, 'Card', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10228', '2025-08-02', 'C1101', 'P1003', 2, 'Marketplace', 3, 0, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10229', '2025-06-02', 'C1119', 'P1001', 3, 'Store', 10, 0.15, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10230', '2025-09-16', 'C1104', 'P1003', 5, 'Online', 8, 0.05, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10231', '2025-01-08', 'C1073', 'P1003', 3, 'Online', 12, 0.05, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10232', '2025-09-21', 'C1086', 'P1007', 5, 'Online', 6, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10233', '2025-01-04', 'C1058', 'P1004', 3, 'Store', 5, 0.1, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10234', '2025-12-01', 'C1008', 'P1005', 2, 'Store', 6, 0.2, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10235', '2025-12-18', 'C1089', 'P1007', 3, 'Store', 9, 0.2, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10236', '2025-03-10', 'C1096', 'P1004', 3, 'Store', 8, 0, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10237', '2025-12-07', 'C1097', 'P1009', 5, 'Marketplace', 4, 0, 'Cash', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10238', '2025-10-16', 'C1116', 'P1002', 3, 'Marketplace', 2, 0, 'Bank Transfer', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10239', '2025-06-17', 'C1088', 'P1003', 1, 'Store', 9, 0.1, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10240', '2025-08-21', 'C1059', 'P1001', 5, 'Marketplace', 3, 0.15, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10241', '2025-07-22', 'C1028', 'P1001', 5, 'Online', 5, 0, 'Cash', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10242', '2025-10-05', 'C1005', 'P1002', 4, 'Online', 1, 0, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10243', '2025-07-15', 'C1011', 'P1006', 2, 'Online', 8, 0.1, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10244', '2025-10-03', 'C1094', 'P1003', 2, 'Online', 7, 0.15, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10245', '2025-08-06', 'C1032', 'P1009', 2, 'Online', 9, 0.1, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10246', '2025-01-17', 'C1099', 'P1002', 1, 'Online', 11, 0.1, 'Card', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10247', '2025-01-18', 'C1091', 'P1010', 1, 'Marketplace', 8, 0.15, 'Online Wallet', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10248', '2025-04-30', 'C1018', 'P1008', 3, 'Online', 9, 0, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10249', '2025-11-03', 'C1039', 'P1010', 5, 'Online', 11, 0.05, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10250', '2025-02-01', 'C1117', 'P1005', 5, 'Marketplace', 9, 0.15, 'Card', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10251', '2025-11-26', 'C1041', 'P1006', 4, 'Store', 11, 0.1, 'Cash', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10252', '2025-04-05', 'C1109', 'P1007', 4, 'Marketplace', 9, 0.1, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10253', '2025-10-15', 'C1068', 'P1001', 2, 'Online', 7, 0.1, 'Bank Transfer', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10254', '2025-11-28', 'C1012', 'P1006', 2, 'Online', 2, 0.1, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10255', '2025-11-05', 'C1103', 'P1010', 5, 'Online', 1, 0, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10256', '2025-06-05', 'C1124', 'P1006', 3, 'Online', 1, 0, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10257', '2025-05-03', 'C1049', 'P1007', 2, 'Marketplace', 9, 0.05, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10258', '2025-07-04', 'C1013', 'P1005', 2, 'Online', 9, 0.1, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10259', '2025-01-24', 'C1019', 'P1007', 3, 'Marketplace', 10, 0, 'Online Wallet', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10260', '2025-03-20', 'C1049', 'P1005', 3, 'Store', 4, 0.05, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10262', '2025-10-07', 'C1083', 'P1003', 1, 'Online', 8, 0, 'Card', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10263', '2025-07-31', 'C1009', 'P1001', 3, 'Online', 3, 0.2, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10264', '2025-01-31', 'C1120', 'P1006', 5, 'Marketplace', 10, 0.2, 'Card', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10265', '2025-09-30', 'C1003', 'P1001', 2, 'Marketplace', 9, 0.1, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10266', '2025-12-24', 'C1014', 'P1009', 4, 'Online', 11, 0.1, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10267', '2025-09-27', 'C1102', 'P1010', 5, 'Store', 5, 0.05, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10268', '2025-05-05', 'C1088', 'P1010', 5, 'Online', 12, 0, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10269', '2025-10-10', 'C1002', 'P1007', 5, 'Online', 8, 0, 'Online Wallet', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10270', '2025-10-17', 'C1030', 'P1006', 2, 'Store', 2, 0.15, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10271', '2025-12-17', 'C1085', 'P1002', 1, 'Store', 5, 0.15, 'Bank Transfer', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10272', '2025-03-15', 'C1039', 'P1010', 3, 'Online', 12, 0.1, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10273', '2025-06-19', 'C1102', 'P1009', 2, 'Marketplace', 7, 0.2, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10274', '2025-08-12', 'C1078', 'P1002', 2, 'Store', 4, 0, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10275', '2025-08-19', 'C1071', 'P1005', 3, 'Online', 8, 0, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10276', '2025-11-13', 'C1010', 'P1002', 5, 'Online', 5, 0, 'Bank Transfer', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10277', '2025-06-12', 'C1001', 'P1007', 2, 'Store', 6, 0, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10278', '2025-02-14', 'C1072', 'P1003', 1, 'Store', 3, 0.1, 'Card', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10279', '2025-07-01', 'C1077', 'P1002', 2, 'Online', 9, 0, 'Online Wallet', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10280', '2025-02-13', 'C1074', 'P1007', 5, 'Marketplace', 12, 0.15, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10282', '2025-09-05', 'C1121', 'P1005', 3, 'Marketplace', 2, 0.05, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10283', '2025-02-24', 'C1122', 'P1008', 5, 'Marketplace', 3, 0.05, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10284', '2025-06-21', 'C1018', 'P1008', 4, 'Marketplace', 7, 0.2, 'Online Wallet', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10285', '2025-04-01', 'C1095', 'P1006', 4, 'Marketplace', 7, 0.05, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10286', '2025-05-24', 'C1120', 'P1007', 3, 'Marketplace', 7, 0.05, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10287', '2025-01-14', 'C1027', 'P1009', 1, 'Marketplace', 12, 0.1, 'Online Wallet', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10288', '2025-03-13', 'C1033', 'P1008', 5, 'Marketplace', 11, 0.05, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10289', '2025-08-18', 'C1052', 'P1002', 5, 'Marketplace', 10, 0.1, 'Card', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10290', '2025-12-26', 'C1118', 'P1006', 2, 'Online', 9, 0.15, 'Bank Transfer', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10291', '2025-01-23', 'C1083', 'P1010', 1, 'Store', 10, 0.2, 'Card', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10292', '2025-05-13', 'C1067', 'P1002', 3, 'Marketplace', 4, 0.15, 'Bank Transfer', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10293', '2025-07-11', 'C1076', 'P1008', 2, 'Online', 7, 0.1, 'Card', 'Cancelled');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10294', '2025-02-23', 'C1015', 'P1008', 2, 'Store', 5, 0.1, 'Online Wallet', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10295', '2025-09-24', 'C1013', 'P1004', 1, 'Store', 8, 0.05, 'Cash', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10296', '2025-12-30', 'C1083', 'P1001', 4, 'Marketplace', 2, 0, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10297', '2025-03-23', 'C1123', 'P1009', 4, 'Store', 6, 0.15, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10298', '2025-07-22', 'C1114', 'P1007', 5, 'Marketplace', 1, 0.2, 'Online Wallet', 'Returned');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10299', '2025-12-27', 'C1097', 'P1001', 3, 'Online', 4, 0, 'Bank Transfer', 'Completed');
INSERT INTO sales (order_id, order_date, customer_id, product_id, representative_id, sales_channel, quantity, discount_rate, payment_method, order_status) VALUES ('ORD-10300', '2025-06-16', 'C1034', 'P1006', 2, 'Marketplace', 4, 0.1, 'Online Wallet', 'Completed');

-- Monthly regional targets
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-01', 'Bucharest', 8950.00, 1969.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-01', 'North', 9600.00, 2160.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-01', 'South', 10250.00, 2357.50);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-01', 'East', 10900.00, 2561.50);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-01', 'West', 11550.00, 2772.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-02', 'Bucharest', 9400.00, 2068.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-02', 'North', 10050.00, 2261.25);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-02', 'South', 10700.00, 2461.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-02', 'East', 11350.00, 2667.25);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-02', 'West', 12000.00, 2880.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-03', 'Bucharest', 9850.00, 2167.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-03', 'North', 10500.00, 2362.50);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-03', 'South', 11150.00, 2564.50);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-03', 'East', 11800.00, 2773.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-03', 'West', 12450.00, 2988.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-04', 'Bucharest', 10300.00, 2266.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-04', 'North', 10950.00, 2463.75);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-04', 'South', 11600.00, 2668.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-04', 'East', 12250.00, 2878.75);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-04', 'West', 12900.00, 3096.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-05', 'Bucharest', 10750.00, 2365.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-05', 'North', 11400.00, 2565.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-05', 'South', 12050.00, 2771.50);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-05', 'East', 12700.00, 2984.50);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-05', 'West', 13350.00, 3204.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-06', 'Bucharest', 11200.00, 2464.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-06', 'North', 11850.00, 2666.25);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-06', 'South', 12500.00, 2875.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-06', 'East', 13150.00, 3090.25);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-06', 'West', 13800.00, 3312.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-07', 'Bucharest', 11650.00, 2563.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-07', 'North', 12300.00, 2767.50);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-07', 'South', 12950.00, 2978.50);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-07', 'East', 13600.00, 3196.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-07', 'West', 14250.00, 3420.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-08', 'Bucharest', 12100.00, 2662.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-08', 'North', 12750.00, 2868.75);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-08', 'South', 13400.00, 3082.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-08', 'East', 14050.00, 3301.75);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-08', 'West', 14700.00, 3528.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-09', 'Bucharest', 12550.00, 2761.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-09', 'North', 13200.00, 2970.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-09', 'South', 13850.00, 3185.50);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-09', 'East', 14500.00, 3407.50);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-09', 'West', 15150.00, 3636.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-10', 'Bucharest', 13000.00, 2860.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-10', 'North', 13650.00, 3071.25);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-10', 'South', 14300.00, 3289.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-10', 'East', 14950.00, 3513.25);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-10', 'West', 15600.00, 3744.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-11', 'Bucharest', 13450.00, 2959.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-11', 'North', 14100.00, 3172.50);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-11', 'South', 14750.00, 3392.50);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-11', 'East', 15400.00, 3619.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-11', 'West', 16050.00, 3852.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-12', 'Bucharest', 13900.00, 3058.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-12', 'North', 14550.00, 3273.75);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-12', 'South', 15200.00, 3496.00);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-12', 'East', 15850.00, 3724.75);
INSERT INTO sales_targets (target_month, region, revenue_target, profit_target) VALUES ('2025-12', 'West', 16500.00, 3960.00);

COMMIT;

-- Quick verification
SELECT 'customers' AS table_name, COUNT(*) AS rows_loaded FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'sales_representatives', COUNT(*) FROM sales_representatives
UNION ALL SELECT 'sales', COUNT(*) FROM sales
UNION ALL SELECT 'sales_targets', COUNT(*) FROM sales_targets;