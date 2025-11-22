-- ========================================
-- Shipping Management System Database
-- Complete Creation Script
-- Database Name: shipping_management_system
-- ========================================

-- Create Database
DROP DATABASE IF EXISTS shipping_management_system;
# SET GLOBAL log_bin_trust_function_creators = 1;
CREATE DATABASE shipping_management_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE shipping_management_system;

-- ========================================
-- Table Creation
-- ========================================

-- 1. Shipping Companies Table
CREATE TABLE shipping_companies (
                                    company_id INT PRIMARY KEY AUTO_INCREMENT,
                                    company_name VARCHAR(100) NOT NULL UNIQUE,
                                    registration_country VARCHAR(50) NOT NULL,
                                    contact_phone VARCHAR(20),
                                    contact_email VARCHAR(100),
                                    address TEXT,
                                    established_year YEAR,
                                    fleet_size INT DEFAULT 0,
                                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Ships Table
CREATE TABLE ships (
                       ship_id INT PRIMARY KEY AUTO_INCREMENT,
                       ship_name VARCHAR(100) NOT NULL UNIQUE,
                       ship_type ENUM('cargo_ship', 'passenger_ship', 'container_ship', 'tanker', 'bulk_carrier') NOT NULL,
                       deadweight_tonnage DECIMAL(10,2) NOT NULL,
                       length DECIMAL(8,2) NOT NULL,
                       width DECIMAL(8,2) NOT NULL,
                       build_year YEAR NOT NULL,
                       company_id INT NOT NULL,
                       current_status ENUM('in_port', 'sailing', 'under_maintenance', 'out_of_service') DEFAULT 'in_port',
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                       FOREIGN KEY (company_id) REFERENCES shipping_companies(company_id)
);

-- 3. Ports Table
CREATE TABLE ports (
                       port_id INT PRIMARY KEY AUTO_INCREMENT,
                       port_name VARCHAR(100) NOT NULL,
                       city VARCHAR(50) NOT NULL,
                       country VARCHAR(50) NOT NULL,
                       port_type ENUM('cargo_port', 'passenger_port', 'multi_purpose', 'specialized_port') NOT NULL,
                       berth_count INT NOT NULL DEFAULT 0,
                       max_draft DECIMAL(5,2) NOT NULL,
                       latitude DECIMAL(10,7),
                       longitude DECIMAL(10,7),
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 4. Customers Table
CREATE TABLE customers (
                           customer_id INT PRIMARY KEY AUTO_INCREMENT,
                           company_name VARCHAR(100) NOT NULL,
                           contact_person VARCHAR(50) NOT NULL,
                           phone VARCHAR(20),
                           email VARCHAR(100),
                           address TEXT,
                           customer_type ENUM('shipper', 'consignee', 'freight_forwarder', 'comprehensive') NOT NULL,
                           credit_rating ENUM('AAA', 'AA', 'A', 'BBB', 'BB', 'B', 'C') DEFAULT 'BBB',
                           registration_date DATE NOT NULL,
                           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 5. Cargo Types Table
CREATE TABLE cargo_types (
                             type_id INT PRIMARY KEY AUTO_INCREMENT,
                             type_name VARCHAR(50) NOT NULL UNIQUE,
                             description TEXT,
                             base_rate DECIMAL(8,2) NOT NULL,
                             risk_factor DECIMAL(3,2) DEFAULT 1.00,
                             special_requirements TEXT,
                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Cargos Table
CREATE TABLE cargos (
                        cargo_id INT PRIMARY KEY AUTO_INCREMENT,
                        cargo_name VARCHAR(100) NOT NULL,
                        type_id INT NOT NULL,
                        weight DECIMAL(10,2) NOT NULL,
                        volume DECIMAL(10,2) NOT NULL,
                        value DECIMAL(12,2),
                        danger_level ENUM('no_danger', 'slight_danger', 'moderate_danger', 'high_danger') DEFAULT 'no_danger',
                        packaging_type VARCHAR(50),
                        description TEXT,
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        FOREIGN KEY (type_id) REFERENCES cargo_types(type_id)
);

-- 7. Transport Orders Table
CREATE TABLE transport_orders (
                                  order_id INT PRIMARY KEY AUTO_INCREMENT,
                                  order_number VARCHAR(20) NOT NULL UNIQUE,
                                  shipper_id INT NOT NULL,
                                  consignee_id INT NOT NULL,
                                  origin_port_id INT NOT NULL,
                                  destination_port_id INT NOT NULL,
                                  order_status ENUM('pending', 'confirmed', 'ship_assigned', 'in_transit', 'arrived', 'completed', 'cancelled') DEFAULT 'pending',
                                  total_weight DECIMAL(10,2) NOT NULL,
                                  total_volume DECIMAL(10,2) NOT NULL,
                                  total_value DECIMAL(12,2),
                                  freight_amount DECIMAL(10,2),
                                  order_date DATE NOT NULL,
                                  required_delivery_date DATE,
                                  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                  FOREIGN KEY (shipper_id) REFERENCES customers(customer_id),
                                  FOREIGN KEY (consignee_id) REFERENCES customers(customer_id),
                                  FOREIGN KEY (origin_port_id) REFERENCES ports(port_id),
                                  FOREIGN KEY (destination_port_id) REFERENCES ports(port_id)
);

-- 8. Order Cargo Details Table
CREATE TABLE order_cargo_details (
                                     detail_id INT PRIMARY KEY AUTO_INCREMENT,
                                     order_id INT NOT NULL,
                                     cargo_id INT NOT NULL,
                                     quantity INT NOT NULL,
                                     unit_price DECIMAL(8,2),
                                     total_amount DECIMAL(10,2),
                                     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     FOREIGN KEY (order_id) REFERENCES transport_orders(order_id) ON DELETE CASCADE,
                                     FOREIGN KEY (cargo_id) REFERENCES cargos(cargo_id)
);

-- 9. Voyages Table
CREATE TABLE voyages (
                         voyage_id INT PRIMARY KEY AUTO_INCREMENT,
                         voyage_number VARCHAR(20) NOT NULL UNIQUE,
                         ship_id INT NOT NULL,
                         origin_port_id INT NOT NULL,
                         destination_port_id INT NOT NULL,
                         departure_time DATETIME,
                         arrival_time DATETIME,
                         voyage_status ENUM('planned', 'in_progress', 'completed', 'cancelled') DEFAULT 'planned',
                         distance_nautical_miles DECIMAL(8,2),
                         fuel_consumption DECIMAL(8,2),
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                         FOREIGN KEY (ship_id) REFERENCES ships(ship_id),
                         FOREIGN KEY (origin_port_id) REFERENCES ports(port_id),
                         FOREIGN KEY (destination_port_id) REFERENCES ports(port_id)
);

-- 10. Order Voyage Assignments Table
CREATE TABLE order_voyage_assignments (
                                          assignment_id INT PRIMARY KEY AUTO_INCREMENT,
                                          order_id INT NOT NULL,
                                          voyage_id INT NOT NULL,
                                          assignment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
                                          loading_port_id INT,
                                          unloading_port_id INT,
                                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                          FOREIGN KEY (order_id) REFERENCES transport_orders(order_id),
                                          FOREIGN KEY (voyage_id) REFERENCES voyages(voyage_id),
                                          FOREIGN KEY (loading_port_id) REFERENCES ports(port_id),
                                          FOREIGN KEY (unloading_port_id) REFERENCES ports(port_id),
                                          UNIQUE KEY unique_order_voyage (order_id, voyage_id)
);

-- 11. Berths Table
CREATE TABLE berths (
                        berth_id INT PRIMARY KEY AUTO_INCREMENT,
                        port_id INT NOT NULL,
                        berth_name VARCHAR(50) NOT NULL,
                        berth_type ENUM('container_berth', 'bulk_berth', 'oil_berth', 'general_berth') NOT NULL,
                        length DECIMAL(8,2) NOT NULL,
                        max_draft DECIMAL(5,2) NOT NULL,
                        status ENUM('available', 'occupied', 'under_maintenance') DEFAULT 'available',
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                        FOREIGN KEY (port_id) REFERENCES ports(port_id),
                        UNIQUE KEY unique_port_berth (port_id, berth_name)
);

-- 12. Berth Occupancy Table
CREATE TABLE berth_occupancy (
                                 occupancy_id INT PRIMARY KEY AUTO_INCREMENT,
                                 berth_id INT NOT NULL,
                                 ship_id INT NOT NULL,
                                 voyage_id INT,
                                 start_time DATETIME NOT NULL,
                                 end_time DATETIME,
                                 occupancy_type ENUM('loading', 'unloading', 'transit', 'waiting') NOT NULL,
                                 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                 FOREIGN KEY (berth_id) REFERENCES berths(berth_id),
                                 FOREIGN KEY (ship_id) REFERENCES ships(ship_id),
                                 FOREIGN KEY (voyage_id) REFERENCES voyages(voyage_id)
);

-- 13. Fee Details Table
CREATE TABLE fee_details (
                             fee_id INT PRIMARY KEY AUTO_INCREMENT,
                             order_id INT NOT NULL,
                             fee_type ENUM('freight', 'port_fee', 'fuel_surcharge', 'insurance', 'other') NOT NULL,
                             amount DECIMAL(10,2) NOT NULL,
                             currency VARCHAR(3) DEFAULT 'USD',
                             description TEXT,
                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             FOREIGN KEY (order_id) REFERENCES transport_orders(order_id) ON DELETE CASCADE
);

-- 14. Transport Tracking Table
CREATE TABLE transport_tracking (
                                    tracking_id INT PRIMARY KEY AUTO_INCREMENT,
                                    order_id INT NOT NULL,
                                    voyage_id INT,
                                    location_port_id INT,
                                    tracking_status ENUM('order_received', 'cargo_loaded', 'departed', 'in_transit', 'arrived_destination', 'cargo_unloaded', 'delivered') NOT NULL,
                                    tracking_time DATETIME NOT NULL,
                                    latitude DECIMAL(10,7),
                                    longitude DECIMAL(10,7),
                                    remarks TEXT,
                                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                    FOREIGN KEY (order_id) REFERENCES transport_orders(order_id),
                                    FOREIGN KEY (voyage_id) REFERENCES voyages(voyage_id),
                                    FOREIGN KEY (location_port_id) REFERENCES ports(port_id)
);

-- 15. Customer Credit Records Table
CREATE TABLE customer_credit_records (
                                         record_id INT PRIMARY KEY AUTO_INCREMENT,
                                         customer_id INT NOT NULL,
                                         order_id INT,
                                         credit_change ENUM('upgrade', 'downgrade', 'violation_record', 'excellent_record') NOT NULL,
                                         old_rating ENUM('AAA', 'AA', 'A', 'BBB', 'BB', 'B', 'C'),
                                         new_rating ENUM('AAA', 'AA', 'A', 'BBB', 'BB', 'B', 'C'),
                                         change_reason TEXT,
                                         record_date DATE NOT NULL,
                                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                         FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
                                         FOREIGN KEY (order_id) REFERENCES transport_orders(order_id)
);

-- 16. System Logs Table
CREATE TABLE system_logs (
                             log_id INT PRIMARY KEY AUTO_INCREMENT,
                             table_name VARCHAR(50) NOT NULL,
                             operation_type ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
                             record_id INT NOT NULL,
                             old_values JSON,
                             new_values JSON,
                             operator VARCHAR(50),
                             operation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================================
-- Index Creation for Performance
-- ========================================

-- Primary business indexes
CREATE INDEX idx_orders_status ON transport_orders(order_status);
CREATE INDEX idx_orders_date ON transport_orders(order_date);
CREATE INDEX idx_voyages_status ON voyages(voyage_status);
CREATE INDEX idx_tracking_order ON transport_tracking(order_id, tracking_time);
CREATE INDEX idx_customer_type ON customers(customer_type);
CREATE INDEX idx_cargo_type ON cargos(type_id);
CREATE INDEX idx_berth_status ON berths(status);
CREATE INDEX idx_fee_order ON fee_details(order_id);
CREATE INDEX idx_ships_status ON ships(current_status);

-- Composite indexes
CREATE INDEX idx_voyage_ship_time ON voyages(ship_id, departure_time);
CREATE INDEX idx_order_customer_port ON transport_orders(shipper_id, origin_port_id);
CREATE INDEX idx_berth_occupancy_time ON berth_occupancy(berth_id, start_time);
CREATE INDEX idx_tracking_status_time ON transport_tracking(tracking_status, tracking_time);

-- ========================================
-- Views Creation
-- ========================================

-- 1. Order Details View
CREATE VIEW order_details_view AS
SELECT
    o.order_id,
    o.order_number,
    s.company_name AS shipper_name,
    c.company_name AS consignee_name,
    op.port_name AS origin_port,
    dp.port_name AS destination_port,
    o.order_status,
    o.total_weight,
    o.total_volume,
    o.freight_amount,
    o.order_date,
    o.required_delivery_date
FROM transport_orders o
         JOIN customers s ON o.shipper_id = s.customer_id
         JOIN customers c ON o.consignee_id = c.customer_id
         JOIN ports op ON o.origin_port_id = op.port_id
         JOIN ports dp ON o.destination_port_id = dp.port_id;

-- 2. Ship Operation Statistics View
CREATE VIEW ship_operation_stats AS
SELECT
    s.ship_id,
    s.ship_name,
    sc.company_name,
    s.ship_type,
    COUNT(v.voyage_id) as total_voyages,
    COALESCE(SUM(v.distance_nautical_miles), 0) as total_distance,
    COALESCE(AVG(v.fuel_consumption), 0) as avg_fuel_consumption,
    s.current_status
FROM ships s
         JOIN shipping_companies sc ON s.company_id = sc.company_id
         LEFT JOIN voyages v ON s.ship_id = v.ship_id AND v.voyage_status = 'completed'
GROUP BY s.ship_id, s.ship_name, sc.company_name, s.ship_type, s.current_status;

-- 3. Port Business Volume View
CREATE VIEW port_business_volume AS
SELECT
    p.port_id,
    p.port_name,
    p.city,
    p.country,
    COUNT(DISTINCT o1.order_id) as outbound_orders,
    COUNT(DISTINCT o2.order_id) as inbound_orders,
    COUNT(DISTINCT v1.voyage_id) as departure_voyages,
    COUNT(DISTINCT v2.voyage_id) as arrival_voyages,
    p.berth_count
FROM ports p
         LEFT JOIN transport_orders o1 ON p.port_id = o1.origin_port_id
         LEFT JOIN transport_orders o2 ON p.port_id = o2.destination_port_id
         LEFT JOIN voyages v1 ON p.port_id = v1.origin_port_id
         LEFT JOIN voyages v2 ON p.port_id = v2.destination_port_id
GROUP BY p.port_id, p.port_name, p.city, p.country, p.berth_count;

-- 4. Customer Business Statistics View
CREATE VIEW customer_business_stats AS
SELECT
    c.customer_id,
    c.company_name,
    c.customer_type,
    c.credit_rating,
    COUNT(DISTINCT CASE WHEN o.shipper_id = c.customer_id THEN o.order_id END) as sent_orders,
    COUNT(DISTINCT CASE WHEN o.consignee_id = c.customer_id THEN o.order_id END) as received_orders,
    COALESCE(SUM(CASE WHEN o.shipper_id = c.customer_id THEN o.freight_amount ELSE 0 END), 0) as total_freight_paid,
    COALESCE(AVG(CASE WHEN o.shipper_id = c.customer_id THEN o.freight_amount END), 0) as avg_freight_per_order
FROM customers c
         LEFT JOIN transport_orders o ON c.customer_id IN (o.shipper_id, o.consignee_id)
GROUP BY c.customer_id, c.company_name, c.customer_type, c.credit_rating;

-- ========================================
-- Functions Creation
-- ========================================

-- 1. Calculate Distance Function (Simplified)
DELIMITER //
CREATE FUNCTION CalculateDistance(
    p_origin_port_id INT,
    p_destination_port_id INT
) RETURNS DECIMAL(8,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_distance DECIMAL(8,2);
    DECLARE v_lat1, v_lon1, v_lat2, v_lon2 DECIMAL(10,7);

    -- Get port coordinates
SELECT latitude, longitude INTO v_lat1, v_lon1
FROM ports WHERE port_id = p_origin_port_id;

SELECT latitude, longitude INTO v_lat2, v_lon2
FROM ports WHERE port_id = p_destination_port_id;

-- Simplified distance calculation (should use Haversine formula in production)
IF v_lat1 IS NOT NULL AND v_lon1 IS NOT NULL AND v_lat2 IS NOT NULL AND v_lon2 IS NOT NULL THEN
        SET v_distance = SQRT(POW(v_lat2 - v_lat1, 2) + POW(v_lon2 - v_lon1, 2)) * 60;
ELSE
        SET v_distance = 1000; -- Default distance if coordinates not available
END IF;

RETURN COALESCE(v_distance, 1000);
END//
DELIMITER ;

-- 2. Get Customer Credit Score Function
DELIMITER //
CREATE FUNCTION GetCustomerCreditScore(
    p_customer_id INT
) RETURNS INT
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_score INT DEFAULT 0;
    DECLARE v_rating VARCHAR(3);
    DECLARE v_completed_orders INT DEFAULT 0;
    DECLARE v_cancelled_orders INT DEFAULT 0;

SELECT credit_rating INTO v_rating FROM customers WHERE customer_id = p_customer_id;

-- Count order completion status
SELECT
    COUNT(CASE WHEN order_status = 'completed' THEN 1 END),
    COUNT(CASE WHEN order_status = 'cancelled' THEN 1 END)
INTO v_completed_orders, v_cancelled_orders
FROM transport_orders
WHERE shipper_id = p_customer_id;

-- Set base score according to credit rating
CASE v_rating
        WHEN 'AAA' THEN SET v_score = 950;
WHEN 'AA' THEN SET v_score = 900;
WHEN 'A' THEN SET v_score = 850;
WHEN 'BBB' THEN SET v_score = 800;
WHEN 'BB' THEN SET v_score = 750;
WHEN 'B' THEN SET v_score = 700;
WHEN 'C' THEN SET v_score = 600;
ELSE SET v_score = 500;
END CASE;

    -- Adjust score based on performance
    SET v_score = v_score + (v_completed_orders * 5) - (v_cancelled_orders * 20);

RETURN GREATEST(300, LEAST(1000, v_score));
END//
DELIMITER ;

-- ========================================
-- Stored Procedures Creation
-- ========================================

-- 1. Create Transport Order Procedure
DELIMITER //
CREATE PROCEDURE CreateTransportOrder(
    IN p_shipper_id INT,
    IN p_consignee_id INT,
    IN p_origin_port_id INT,
    IN p_destination_port_id INT,
    IN p_total_weight DECIMAL(10,2),
    IN p_total_volume DECIMAL(10,2),
    IN p_total_value DECIMAL(12,2),
    IN p_required_delivery_date DATE,
    OUT p_order_id INT,
    OUT p_order_number VARCHAR(20)
)
BEGIN
    DECLARE v_base_rate DECIMAL(8,2) DEFAULT 100.00;
    DECLARE v_distance_factor DECIMAL(3,2) DEFAULT 1.0;
    DECLARE v_freight_amount DECIMAL(10,2);
    DECLARE v_port_fee DECIMAL(10,2);
    DECLARE v_fuel_surcharge DECIMAL(10,2);
    DECLARE v_sequence_num INT;
    DECLARE v_max_attempts INT DEFAULT 10;
    DECLARE v_attempt_count INT DEFAULT 0;
    DECLARE v_order_exists INT DEFAULT 0;

    -- 生成订单号的循环，确保唯一性
    order_generation_loop: LOOP
        SET v_attempt_count = v_attempt_count + 1;

        -- 获取当天的订单序列号
SELECT COALESCE(MAX(CAST(RIGHT(order_number, 4) AS UNSIGNED)), 0) + 1
INTO v_sequence_num
FROM transport_orders
WHERE DATE(order_date) = CURDATE()
  AND order_number LIKE CONCAT('ORD', DATE_FORMAT(NOW(), '%Y%m%d'), '%');

-- 生成新的订单号
SET p_order_number = CONCAT('ORD', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(v_sequence_num, 4, '0'));

        -- 检查订单号是否已存在
SELECT COUNT(*) INTO v_order_exists
FROM transport_orders
WHERE order_number = p_order_number;

-- 如果订单号不存在，跳出循环
IF v_order_exists = 0 THEN
            LEAVE order_generation_loop;
END IF;

        -- 如果尝试次数过多，抛出错误
        IF v_attempt_count >= v_max_attempts THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Unable to generate unique order number after maximum attempts';
END IF;

END LOOP;

    -- 计算运费（简化计算）
    SET v_freight_amount = p_total_weight * v_base_rate * v_distance_factor;
    SET v_port_fee = p_total_weight * 5;
    SET v_fuel_surcharge = v_freight_amount * 0.1;

    -- 插入订单
INSERT INTO transport_orders (
    order_number, shipper_id, consignee_id, origin_port_id,
    destination_port_id, total_weight, total_volume, total_value,
    freight_amount, order_date, required_delivery_date
) VALUES (
             p_order_number, p_shipper_id, p_consignee_id, p_origin_port_id,
             p_destination_port_id, p_total_weight, p_total_volume, p_total_value,
             v_freight_amount + v_port_fee + v_fuel_surcharge, CURDATE(), p_required_delivery_date
         );

SET p_order_id = LAST_INSERT_ID();

    -- 插入费用明细
INSERT INTO fee_details (order_id, fee_type, amount, description) VALUES
                                                                      (p_order_id, 'freight', v_freight_amount, 'Basic freight charge'),
                                                                      (p_order_id, 'port_fee', v_port_fee, 'Port handling fee'),
                                                                      (p_order_id, 'fuel_surcharge', v_fuel_surcharge, 'Fuel price adjustment');

-- 插入初始跟踪记录
INSERT INTO transport_tracking (order_id, tracking_status, tracking_time, remarks)
VALUES (p_order_id, 'order_received', NOW(), 'Order created and received');
END//
DELIMITER ;

-- 2. Assign Ship to Order Procedure
DELIMITER //
CREATE PROCEDURE AssignShipToOrder(
    IN p_order_id INT,
    IN p_ship_id INT,
    OUT p_success BOOLEAN,
    OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_ship_status VARCHAR(20);
    DECLARE v_order_status VARCHAR(20);
    DECLARE v_voyage_id INT;
    DECLARE v_voyage_number VARCHAR(20);
    DECLARE v_origin_port INT;
    DECLARE v_destination_port INT;

    -- Check ship and order status
SELECT current_status INTO v_ship_status FROM ships WHERE ship_id = p_ship_id;
SELECT order_status, origin_port_id, destination_port_id
INTO v_order_status, v_origin_port, v_destination_port
FROM transport_orders WHERE order_id = p_order_id;

IF v_ship_status = 'in_port' AND v_order_status = 'confirmed' THEN
        -- Generate voyage number
        SET v_voyage_number = CONCAT('VOY', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(p_ship_id, 3, '0'));

        -- Create voyage
INSERT INTO voyages (voyage_number, ship_id, origin_port_id, destination_port_id, voyage_status)
VALUES (v_voyage_number, p_ship_id, v_origin_port, v_destination_port, 'planned');

SET v_voyage_id = LAST_INSERT_ID();

        -- Assign order to voyage
INSERT INTO order_voyage_assignments (order_id, voyage_id, loading_port_id, unloading_port_id)
VALUES (p_order_id, v_voyage_id, v_origin_port, v_destination_port);

-- Update order status
UPDATE transport_orders SET order_status = 'ship_assigned' WHERE order_id = p_order_id;

-- Update ship status
UPDATE ships SET current_status = 'sailing' WHERE ship_id = p_ship_id;

SET p_success = TRUE;
        SET p_message = CONCAT('Ship successfully assigned. Voyage: ', v_voyage_number);
ELSE
        SET p_success = FALSE;
        SET p_message = CONCAT('Cannot assign ship. Ship status: ', v_ship_status, ', Order status: ', v_order_status);
END IF;
END//
DELIMITER ;

-- 3. Port Utilization Statistics Procedure
DELIMITER //
CREATE PROCEDURE GetPortUtilizationStats(
    IN p_port_id INT,
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
SELECT
    p.port_name,
    p.city,
    p.country,
    COUNT(bo.occupancy_id) as total_occupancies,
    COALESCE(AVG(TIMESTAMPDIFF(HOUR, bo.start_time, bo.end_time)), 0) as avg_occupancy_hours,
    COUNT(DISTINCT bo.ship_id) as unique_ships,
    SUM(CASE WHEN bo.occupancy_type = 'loading' THEN 1 ELSE 0 END) as loading_operations,
    SUM(CASE WHEN bo.occupancy_type = 'unloading' THEN 1 ELSE 0 END) as unloading_operations,
    p.berth_count,
    ROUND((COUNT(bo.occupancy_id) / NULLIF(p.berth_count, 0)), 2) as operations_per_berth
FROM ports p
         JOIN berths b ON p.port_id = b.port_id
         LEFT JOIN berth_occupancy bo ON b.berth_id = bo.berth_id
    AND DATE(bo.start_time) BETWEEN p_start_date AND p_end_date
WHERE p.port_id = p_port_id
GROUP BY p.port_id, p.port_name, p.city, p.country, p.berth_count;
END//
DELIMITER ;

-- ========================================
-- Triggers Creation
-- ========================================

-- 1. Order Status Update Trigger
DELIMITER //
CREATE TRIGGER tr_order_status_update
    AFTER UPDATE ON transport_orders
    FOR EACH ROW
BEGIN
    IF OLD.order_status != NEW.order_status THEN
        INSERT INTO transport_tracking (
            order_id, tracking_status, tracking_time, remarks
        ) VALUES (
            NEW.order_id,
            CASE NEW.order_status
                WHEN 'confirmed' THEN 'order_received'
                WHEN 'ship_assigned' THEN 'order_received'
                WHEN 'in_transit' THEN 'in_transit'
                WHEN 'arrived' THEN 'arrived_destination'
                WHEN 'completed' THEN 'delivered'
                ELSE 'order_received'
END,
NOW(),
CONCAT('Order status updated from ', OLD.order_status, ' to ', NEW.order_status)
);
END IF;
END//
DELIMITER ;

-- 2. Fleet Size Update Triggers
DELIMITER //
CREATE TRIGGER tr_update_fleet_size_insert
    AFTER INSERT ON ships
    FOR EACH ROW
BEGIN
    UPDATE shipping_companies
    SET fleet_size = fleet_size + 1
    WHERE company_id = NEW.company_id;
END//

CREATE TRIGGER tr_update_fleet_size_delete
    AFTER DELETE ON ships
    FOR EACH ROW
BEGIN
    UPDATE shipping_companies
    SET fleet_size = fleet_size - 1
    WHERE company_id = OLD.company_id;
END//
DELIMITER ;

-- 3. Berth Status Update Triggers
DELIMITER //
CREATE TRIGGER tr_berth_occupancy_start
    AFTER INSERT ON berth_occupancy
    FOR EACH ROW
BEGIN
    UPDATE berths
    SET status = 'occupied'
    WHERE berth_id = NEW.berth_id;
END//

CREATE TRIGGER tr_berth_occupancy_end
    AFTER UPDATE ON berth_occupancy
    FOR EACH ROW
BEGIN
    IF NEW.end_time IS NOT NULL AND OLD.end_time IS NULL THEN
    UPDATE berths
    SET status = 'available'
    WHERE berth_id = NEW.berth_id;
END IF;
END//
DELIMITER ;

-- 4. System Log Trigger
DELIMITER //
CREATE TRIGGER tr_log_transport_orders
    AFTER UPDATE ON transport_orders
    FOR EACH ROW
BEGIN
    INSERT INTO system_logs (
        table_name, operation_type, record_id, old_values, new_values, operation_time
    ) VALUES (
                 'transport_orders', 'UPDATE', NEW.order_id,
                 JSON_OBJECT('status', OLD.order_status, 'freight_amount', OLD.freight_amount),
                 JSON_OBJECT('status', NEW.order_status, 'freight_amount', NEW.freight_amount),
                 NOW()
             );
END//
DELIMITER ;

-- ========================================
-- Data Integrity Constraints
-- ========================================

-- Business rule constraints
ALTER TABLE transport_orders
    ADD CONSTRAINT chk_order_weight CHECK (total_weight > 0);

ALTER TABLE transport_orders
    ADD CONSTRAINT chk_order_volume CHECK (total_volume > 0);

ALTER TABLE ships
    ADD CONSTRAINT chk_ship_tonnage CHECK (deadweight_tonnage > 0);

ALTER TABLE berth_occupancy
    ADD CONSTRAINT chk_occupancy_time CHECK (start_time <= end_time OR end_time IS NULL);

ALTER TABLE cargo_types
    ADD CONSTRAINT chk_base_rate CHECK (base_rate > 0);

ALTER TABLE fee_details
    ADD CONSTRAINT chk_fee_amount CHECK (amount >= 0);

-- ========================================
-- Sample Data Insertion
-- ========================================

-- Insert sample shipping companies
INSERT INTO shipping_companies (company_name, registration_country, contact_phone, contact_email, established_year) VALUES
                                                                                                                        ('Global Maritime Corp', 'USA', '+1-555-0101', 'info@globalmaritime.com', 1995),
                                                                                                                        ('Pacific Shipping Ltd', 'Japan', '+81-3-1234-5678', 'contact@pacificship.jp', 1988),
                                                                                                                        ('European Sea Lines', 'Germany', '+49-40-123456', 'info@euroseelines.de', 1992),
                                                                                                                        ('Asian Cargo Express', 'Singapore', '+65-6123-4567', 'service@asiancargoexpress.sg', 2001),
                                                                                                                        ('Atlantic Fleet Inc', 'UK', '+44-20-7123-4567', 'operations@atlanticfleet.co.uk', 1987);

-- Insert sample ports
INSERT INTO ports (port_name, city, country, port_type, berth_count, max_draft, latitude, longitude) VALUES
                                                                                                         ('Port of Shanghai', 'Shanghai', 'China', 'cargo_port', 25, 15.5, 31.2304, 121.4737),
                                                                                                         ('Port of Singapore', 'Singapore', 'Singapore', 'multi_purpose', 20, 16.0, 1.2966, 103.8006),
                                                                                                         ('Port of Rotterdam', 'Rotterdam', 'Netherlands', 'cargo_port', 22, 14.5, 51.9244, 4.4777),
                                                                                                         ('Port of Los Angeles', 'Los Angeles', 'USA', 'cargo_port', 18, 13.7, 33.7373, -118.2647),  -- 修正：container_port -> cargo_port
                                                                                                         ('Port of Hamburg', 'Hamburg', 'Germany', 'multi_purpose', 15, 13.8, 53.5511, 9.9937),
                                                                                                         ('Port of Busan', 'Busan', 'South Korea', 'cargo_port', 12, 14.2, 35.1028, 129.0403),      -- 修正：container_port -> cargo_port
                                                                                                         ('Port of Dubai', 'Dubai', 'UAE', 'cargo_port', 16, 15.0, 25.2769, 55.3072);

-- Insert sample ships
INSERT INTO ships (ship_name, ship_type, deadweight_tonnage, length, width, build_year, company_id) VALUES
                                                                                                        ('Ocean Pioneer', 'container_ship', 95000.00, 350.0, 45.0, 2018, 1),
                                                                                                        ('Pacific Star', 'bulk_carrier', 180000.00, 280.0, 50.0, 2016, 2),
                                                                                                        ('European Express', 'cargo_ship', 75000.00, 220.0, 32.0, 2019, 3),
                                                                                                        ('Asia Dream', 'container_ship', 120000.00, 380.0, 52.0, 2020, 4),
                                                                                                        ('Atlantic Voyager', 'tanker', 150000.00, 250.0, 44.0, 2017, 5),
                                                                                                        ('Global Trader', 'cargo_ship', 85000.00, 200.0, 30.0, 2021, 1),
                                                                                                        ('Pacific Guardian', 'container_ship', 110000.00, 320.0, 48.0, 2019, 2);

-- Insert sample customers
INSERT INTO customers (company_name, contact_person, phone, email, customer_type, credit_rating, registration_date) VALUES
                                                                                                                        ('International Trade Co', 'John Smith', '+1-555-1001', 'j.smith@intltrade.com', 'shipper', 'AA', '2020-01-15'),
                                                                                                                        ('Global Imports Ltd', 'Maria Garcia', '+44-20-7001-2001', 'm.garcia@globalimports.co.uk', 'consignee', 'A', '2019-03-22'),
                                                                                                                        ('Asian Logistics Inc', 'Chen Wei', '+86-21-6001-3001', 'c.wei@asianlogistics.cn', 'freight_forwarder', 'AAA', '2018-07-10'),
                                                                                                                        ('European Distribution', 'Hans Mueller', '+49-40-401-5001', 'h.mueller@eurodist.de', 'comprehensive', 'BBB', '2021-02-28'),
                                                                                                                        ('Pacific Commerce', 'Yuki Tanaka', '+81-3-7001-8001', 'y.tanaka@pacificcommerce.jp', 'shipper', 'A', '2020-09-14'),
                                                                                                                        ('Middle East Trading', 'Ahmed Al-Rashid', '+971-4-301-9001', 'a.alrashid@metrading.ae', 'consignee', 'BB', '2021-05-03');

-- Insert sample cargo types
INSERT INTO cargo_types (type_name, description, base_rate, risk_factor, special_requirements) VALUES
                                                                                                   ('Electronics', 'Electronic goods and components', 150.00, 1.2, 'Temperature controlled, anti-static packaging'),
                                                                                                   ('Textiles', 'Clothing and fabric materials', 80.00, 1.0, 'Moisture protection required'),
                                                                                                   ('Machinery', 'Industrial equipment and machinery', 200.00, 1.5, 'Heavy lift equipment required'),
                                                                                                   ('Food Products', 'Perishable and non-perishable food items', 120.00, 1.3, 'Refrigeration may be required'),
                                                                                                   ('Chemicals', 'Industrial chemicals and compounds', 300.00, 2.5, 'Hazardous material handling, special permits'),
                                                                                                   ('Raw Materials', 'Basic materials like steel, aluminum', 60.00, 1.0, 'Weather protection recommended'),
                                                                                                   ('Automotive Parts', 'Vehicle components and accessories', 180.00, 1.1, 'Secure packaging to prevent damage');

-- Insert sample berths
INSERT INTO berths (port_id, berth_name, berth_type, length, max_draft) VALUES
                                                                            (1, 'Terminal A-1', 'container_berth', 400.0, 15.5),
                                                                            (1, 'Terminal A-2', 'container_berth', 350.0, 14.8),
                                                                            (1, 'Terminal B-1', 'bulk_berth', 280.0, 13.5),
                                                                            (2, 'Tanjong Pagar T1', 'container_berth', 380.0, 16.0),
                                                                            (2, 'Tanjong Pagar T2', 'container_berth', 380.0, 16.0),
                                                                            (3, 'Maasvlakte M1', 'container_berth', 420.0, 14.5),
                                                                            (3, 'Maasvlakte M2', 'general_berth', 300.0, 12.0),
                                                                            (4, 'Terminal Island T1', 'container_berth', 360.0, 13.7),
                                                                            (5, 'Container Terminal CT1', 'container_berth', 340.0, 13.8),
                                                                            (6, 'New Port Terminal', 'container_berth', 320.0, 14.2);

-- ========================================
-- Sample Business Data
-- ========================================

-- Create sample cargos
INSERT INTO cargos (cargo_name, type_id, weight, volume, value, danger_level, packaging_type) VALUES
                                                                                                  ('Laptop Computers', 1, 500.00, 15.5, 250000.00, 'no_danger', 'Anti-static boxes'),
                                                                                                  ('Cotton Fabric Rolls', 2, 2000.00, 45.2, 35000.00, 'no_danger', 'Plastic wrapped'),
                                                                                                  ('Industrial Pumps', 3, 5000.00, 85.0, 180000.00, 'no_danger', 'Wooden crates'),
                                                                                                  ('Frozen Seafood', 4, 1500.00, 25.8, 45000.00, 'no_danger', 'Refrigerated containers'),
                                                                                                  ('Industrial Solvents', 5, 800.00, 12.5, 25000.00, 'moderate_danger', 'Chemical drums'),
                                                                                                  ('Steel Coils', 6, 8000.00, 120.5, 65000.00, 'no_danger', 'Weather protection'),
                                                                                                  ('Car Engine Parts', 7, 1200.00, 28.3, 95000.00, 'no_danger', 'Protective packaging');

-- Create sample transport orders
CALL CreateTransportOrder(1, 2, 1, 3, 2500.00, 45.5, 285000.00, '2024-03-15', @order_id1, @order_num1);
CALL CreateTransportOrder(3, 4, 2, 4, 5800.00, 95.2, 380000.00, '2024-03-20', @order_id2, @order_num2);
CALL CreateTransportOrder(5, 6, 1, 7, 1800.00, 32.1, 125000.00, '2024-03-25', @order_id3, @order_num3);

-- Update some orders to confirmed status
UPDATE transport_orders SET order_status = 'confirmed' WHERE order_id IN (@order_id1, @order_id2);

-- Assign ships to orders
CALL AssignShipToOrder(@order_id1, 1, @success1, @message1);
CALL AssignShipToOrder(@order_id2, 2, @success2, @message2);

-- ========================================
-- Verification Queries
-- ========================================

-- Display database summary
SELECT 'Database Creation Complete' as Status;

SELECT
    'Tables Created' as Category,
    COUNT(*) as Count
FROM information_schema.tables
WHERE table_schema = 'shipping_management_system';

SELECT
    'Views Created' as Category,
    COUNT(*) as Count
FROM information_schema.views
WHERE table_schema = 'shipping_management_system';

SELECT
    'Stored Procedures Created' as Category,
    COUNT(*) as Count
FROM information_schema.routines
WHERE routine_schema = 'shipping_management_system'
  AND routine_type = 'PROCEDURE';

SELECT
    'Functions Created' as Category,
    COUNT(*) as Count
FROM information_schema.routines
WHERE routine_schema = 'shipping_management_system'
  AND routine_type = 'FUNCTION';

SELECT
    'Triggers Created' as Category,
    COUNT(*) as Count
FROM information_schema.triggers
WHERE trigger_schema = 'shipping_management_system';

-- Show sample data
SELECT 'Sample Orders Created:' as Info;
SELECT order_number, shipper_id, consignee_id, order_status, freight_amount FROM transport_orders LIMIT 5;

SELECT 'Sample Ships:' as Info;
SELECT ship_name, ship_type, current_status FROM ships LIMIT 5;

SELECT 'Sample Ports:' as Info;
SELECT port_name, city, country, berth_count FROM ports LIMIT 5;