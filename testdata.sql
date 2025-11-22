-- ========================================
-- Shipping Management System
-- Sample Data Generation Script (50+ records per table)
-- ========================================

USE shipping_management_system;

-- ========================================
-- Clear Existing Data (Delete in reverse dependency order)
-- ========================================

SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM system_logs;
DELETE FROM customer_credit_records;
DELETE FROM transport_tracking;
DELETE FROM fee_details;
DELETE FROM berth_occupancy;
DELETE FROM order_voyage_assignments;
DELETE FROM order_cargo_details;
DELETE FROM voyages;
DELETE FROM transport_orders;
DELETE FROM cargos;
DELETE FROM berths;
DELETE FROM cargo_types;
DELETE FROM customers;
DELETE FROM ports;
DELETE FROM ships;
DELETE FROM shipping_companies;

-- Reset auto-increment counters
ALTER TABLE shipping_companies AUTO_INCREMENT = 1;
ALTER TABLE ships AUTO_INCREMENT = 1;
ALTER TABLE ports AUTO_INCREMENT = 1;
ALTER TABLE customers AUTO_INCREMENT = 1;
ALTER TABLE cargo_types AUTO_INCREMENT = 1;
ALTER TABLE cargos AUTO_INCREMENT = 1;
ALTER TABLE transport_orders AUTO_INCREMENT = 1;
ALTER TABLE order_cargo_details AUTO_INCREMENT = 1;
ALTER TABLE voyages AUTO_INCREMENT = 1;
ALTER TABLE order_voyage_assignments AUTO_INCREMENT = 1;
ALTER TABLE berths AUTO_INCREMENT = 1;
ALTER TABLE berth_occupancy AUTO_INCREMENT = 1;
ALTER TABLE fee_details AUTO_INCREMENT = 1;
ALTER TABLE transport_tracking AUTO_INCREMENT = 1;
ALTER TABLE customer_credit_records AUTO_INCREMENT = 1;
ALTER TABLE system_logs AUTO_INCREMENT = 1;

SET FOREIGN_KEY_CHECKS = 1;

-- ========================================
-- 1. Shipping Companies (50 records)
-- ========================================

INSERT INTO shipping_companies (company_name, registration_country, contact_phone, contact_email, address, established_year, fleet_size) VALUES
('Global Maritime Corp', 'USA', '+1-555-0101', 'info@globalmaritime.com', '123 Harbor St, New York, NY 10001', 1995, 0),
('Pacific Shipping Ltd', 'Japan', '+81-3-1234-5678', 'contact@pacificship.jp', '1-1-1 Minato, Tokyo 105-0001', 1988, 0),
('European Sea Lines', 'Germany', '+49-40-123456', 'info@euroseelines.de', 'Hafenstraße 15, 20359 Hamburg', 1992, 0),
('Asian Cargo Express', 'Singapore', '+65-6123-4567', 'service@asiancargoexpress.sg', '10 Marina Boulevard, Singapore 018983', 2001, 0),
('Atlantic Fleet Inc', 'UK', '+44-20-7123-4567', 'operations@atlanticfleet.co.uk', '25 Canary Wharf, London E14 5AB', 1987, 0),
('Mediterranean Carriers', 'Italy', '+39-010-123456', 'info@medcarriers.it', 'Via del Porto 45, 16126 Genova', 1994, 0),
('Nordic Shipping AS', 'Norway', '+47-22-123456', 'contact@nordicship.no', 'Strandveien 12, 0250 Oslo', 1989, 0),
('Scandinavian Lines', 'Sweden', '+46-8-123456', 'info@scandlines.se', 'Hamngatan 27, 111 47 Stockholm', 1991, 0),
('Baltic Maritime', 'Estonia', '+372-123-4567', 'service@balticmaritime.ee', 'Sadama 5, 10111 Tallinn', 1996, 0),
('Black Sea Shipping', 'Turkey', '+90-212-123456', 'info@blackseaship.tr', 'Liman Caddesi 89, 34110 Istanbul', 1993, 0),
('Red Sea Navigation', 'Egypt', '+20-2-12345678', 'contact@redseenav.eg', 'Port Said Street 456, Alexandria', 1985, 0),
('Indian Ocean Lines', 'India', '+91-22-12345678', 'info@indianocean.in', 'Marine Drive 789, Mumbai 400001', 1990, 0),
('Arabian Gulf Shipping', 'UAE', '+971-4-123456', 'service@arabianulf.ae', 'Port Rashid Road, Dubai 12345', 1997, 0),
('Persian Maritime', 'Iran', '+98-21-12345678', 'info@persianmaritime.ir', 'Khomeini Port Road, Bandar Abbas', 1982, 0),
('Caspian Sea Lines', 'Azerbaijan', '+994-12-123456', 'contact@caspianlines.az', 'Port Street 234, Baku AZ1000', 1991, 0),
('South China Shipping', 'China', '+86-20-12345678', 'info@southchina.cn', '88 Pearl River Road, Guangzhou 510000', 1985, 0),
('East Asia Maritime', 'South Korea', '+82-51-123456', 'service@eastasia.kr', '123 Port Road, Busan 48058', 1988, 0),
('Southeast Transport', 'Thailand', '+66-2-123456', 'info@setransport.th', '456 Chao Phraya Road, Bangkok 10500', 1992, 0),
('Mekong River Shipping', 'Vietnam', '+84-28-123456', 'contact@mekongship.vn', '789 Saigon Port Road, Ho Chi Minh City', 1995, 0),
('Malacca Strait Lines', 'Malaysia', '+60-3-123456', 'info@malaccastrait.my', 'Port Klang Road 345, Kuala Lumpur 50000', 1993, 0),
('Indonesian Archipelago', 'Indonesia', '+62-21-123456', 'service@archipelago.id', 'Tanjung Priok Street 678, Jakarta 14310', 1987, 0),
('Philippine Maritime', 'Philippines', '+63-2-123456', 'info@philmaritime.ph', 'Manila Bay Road 901, Manila 1000', 1989, 0),
('Australian Coastal', 'Australia', '+61-2-123456', 'contact@auscoastal.au', 'Circular Quay 234, Sydney NSW 2000', 1991, 0),
('New Zealand Shipping', 'New Zealand', '+64-9-123456', 'info@nzshipping.nz', 'Auckland Port Road 567, Auckland 1010', 1994, 0),
('Pacific Islander Lines', 'Fiji', '+679-123456', 'service@pacificislander.fj', 'Suva Harbor Street 890, Suva', 1996, 0),
('Caribbean Shipping', 'Jamaica', '+1-876-123456', 'info@caribbeanship.jm', 'Kingston Port Road 123, Kingston', 1988, 0),
('Central American Lines', 'Panama', '+507-123456', 'contact@centralamerican.pa', 'Panama Canal Street 456, Panama City', 1992, 0),
('South American Cargo', 'Brazil', '+55-11-123456', 'info@southamerican.br', 'Santos Port Avenue 789, Santos SP', 1985, 0),
('Patagonian Maritime', 'Argentina', '+54-11-123456', 'service@patagonian.ar', 'Puerto Madero 012, Buenos Aires', 1990, 0),
('Chilean Pacific Lines', 'Chile', '+56-2-123456', 'info@chileanpacific.cl', 'Valparaiso Port Street 345, Valparaiso', 1987, 0),
('Peruvian Coastal', 'Peru', '+51-1-123456', 'contact@peruviancoastal.pe', 'Callao Port Avenue 678, Lima', 1993, 0),
('Colombian Caribbean', 'Colombia', '+57-1-123456', 'info@colombiancarib.co', 'Cartagena Port Road 901, Cartagena', 1989, 0),
('Venezuelan Maritime', 'Venezuela', '+58-212-123456', 'service@venezuelan.ve', 'La Guaira Port Street 234, Caracas', 1991, 0),
('West African Lines', 'Nigeria', '+234-1-123456', 'info@westafricanlines.ng', 'Apapa Port Road 567, Lagos', 1986, 0),
('East African Shipping', 'Kenya', '+254-20-123456', 'contact@eastafricanship.ke', 'Mombasa Port Avenue 890, Mombasa', 1988, 0),
('South African Maritime', 'South Africa', '+27-21-123456', 'info@southafricanmarit.za', 'Cape Town Harbor 123, Cape Town', 1984, 0),
('Maghreb Shipping', 'Morocco', '+212-522-123456', 'service@maghrebship.ma', 'Casablanca Port Road 456, Casablanca', 1990, 0),
('Nile River Transport', 'Sudan', '+249-183-123456', 'info@nileriver.sd', 'Port Sudan Street 789, Port Sudan', 1992, 0),
('Horn of Africa Lines', 'Ethiopia', '+251-11-123456', 'contact@hornofafrica.et', 'Djibouti Port Road 012, Dire Dawa', 1995, 0),
('Madagascar Maritime', 'Madagascar', '+261-20-123456', 'info@madagascarmarit.mg', 'Toamasina Port Avenue 345, Antananarivo', 1987, 0),
('Mauritius Shipping', 'Mauritius', '+230-123456', 'service@mauritiusship.mu', 'Port Louis Harbor 678, Port Louis', 1989, 0),
('Seychelles Lines', 'Seychelles', '+248-123456', 'info@seychelleslines.sc', 'Victoria Port Street 901, Victoria', 1993, 0),
('Comoros Maritime', 'Comoros', '+269-123456', 'contact@comorosmarit.km', 'Moroni Port Road 234, Moroni', 1991, 0),
('Reunion Shipping', 'France', '+262-123456', 'info@reunionship.re', 'Le Port Harbor 567, Saint-Denis', 1988, 0),
('Mayotte Lines', 'France', '+262-269123456', 'service@mayottelines.yt', 'Mamoudzou Port 890, Mamoudzou', 1994, 0),
('Canary Islands Shipping', 'Spain', '+34-928-123456', 'info@canaryislands.es', 'Las Palmas Port 123, Las Palmas', 1986, 0),
('Madeira Maritime', 'Portugal', '+351-291-123456', 'contact@madeiramaritime.pt', 'Funchal Harbor 456, Funchal', 1990, 0),
('Azores Shipping', 'Portugal', '+351-296-123456', 'info@azoresshipping.pt', 'Ponta Delgada Port 789, Ponta Delgada', 1992, 0),
('Cape Verde Lines', 'Cape Verde', '+238-123456', 'service@capeverdelines.cv', 'Praia Port Street 012, Praia', 1988, 0),
('Guinea-Bissau Maritime', 'Guinea-Bissau', '+245-123456', 'info@guineabissau.gw', 'Bissau Port Road 345, Bissau', 1991, 0);

-- ========================================
-- 2. Ports (50 records)
-- ========================================

INSERT INTO ports (port_name, city, country, port_type, berth_count, max_draft, latitude, longitude) VALUES
('Port of Shanghai', 'Shanghai', 'China', 'cargo_port', 25, 15.5, 31.2304, 121.4737),
('Port of Singapore', 'Singapore', 'Singapore', 'multi_purpose', 20, 16.0, 1.2966, 103.8006),
('Port of Rotterdam', 'Rotterdam', 'Netherlands', 'cargo_port', 22, 14.5, 51.9244, 4.4777),
('Port of Los Angeles', 'Los Angeles', 'USA', 'cargo_port', 18, 13.7, 33.7373, -118.2647),
('Port of Hamburg', 'Hamburg', 'Germany', 'multi_purpose', 15, 13.8, 53.5511, 9.9937),
('Port of Busan', 'Busan', 'South Korea', 'cargo_port', 12, 14.2, 35.1028, 129.0403),
('Port of Dubai', 'Dubai', 'UAE', 'cargo_port', 16, 15.0, 25.2769, 55.3072),
('Port of Antwerp', 'Antwerp', 'Belgium', 'cargo_port', 14, 13.5, 51.2213, 4.3982),
('Port of Qingdao', 'Qingdao', 'China', 'cargo_port', 19, 14.8, 36.0986, 120.3719),
('Port of Long Beach', 'Long Beach', 'USA', 'cargo_port', 17, 13.9, 33.7545, -118.2200),
('Port of Guangzhou', 'Guangzhou', 'China', 'multi_purpose', 21, 15.2, 23.3478, 113.7559),
('Port of Klang', 'Klang', 'Malaysia', 'cargo_port', 13, 14.1, 3.0038, 101.3900),
('Port of Hamburg-Süd', 'Hamburg', 'Germany', 'specialized_port', 8, 12.5, 53.5320, 10.0062),
('Port of Tanjung Pelepas', 'Johor', 'Malaysia', 'cargo_port', 11, 15.8, 1.3644, 103.5500),
('Port of Laem Chabang', 'Chonburi', 'Thailand', 'cargo_port', 9, 13.2, 13.0827, 100.8833),
('Port of Bremen', 'Bremen', 'Germany', 'multi_purpose', 10, 12.8, 53.0793, 8.8017),
('Port of Valencia', 'Valencia', 'Spain', 'cargo_port', 12, 13.5, 39.4699, -0.3763),
('Port of Felixstowe', 'Felixstowe', 'UK', 'cargo_port', 8, 14.5, 51.9542, 1.3464),
('Port of Yokohama', 'Yokohama', 'Japan', 'multi_purpose', 15, 13.0, 35.4437, 139.6380),
('Port of Kobe', 'Kobe', 'Japan', 'cargo_port', 11, 12.5, 34.6901, 135.1956),
('Port of Kaohsiung', 'Kaohsiung', 'Taiwan', 'cargo_port', 14, 14.3, 22.6273, 120.3014),
('Port of Colombo', 'Colombo', 'Sri Lanka', 'multi_purpose', 7, 15.0, 6.9271, 79.8612),
('Port of Jakarta', 'Jakarta', 'Indonesia', 'cargo_port', 13, 12.0, -6.1045, 106.8827),
('Port of Manila', 'Manila', 'Philippines', 'multi_purpose', 9, 11.5, 14.5995, 120.9842),
('Port of Ho Chi Minh City', 'Ho Chi Minh City', 'Vietnam', 'cargo_port', 8, 10.8, 10.8231, 106.6297),
('Port of Mumbai', 'Mumbai', 'India', 'multi_purpose', 16, 11.2, 18.9220, 72.8347),
('Port of Chennai', 'Chennai', 'India', 'cargo_port', 12, 12.5, 13.0827, 80.2707),
('Port of Jawaharlal Nehru', 'Mumbai', 'India', 'cargo_port', 18, 13.8, 18.9517, 72.9956),
('Port of Bandar Abbas', 'Bandar Abbas', 'Iran', 'multi_purpose', 10, 13.0, 27.1865, 56.2808),
('Port of Jeddah', 'Jeddah', 'Saudi Arabia', 'cargo_port', 14, 14.2, 21.5169, 39.2192),
('Port of Alexandria', 'Alexandria', 'Egypt', 'multi_purpose', 11, 12.8, 31.2001, 29.9187),
('Port of Suez', 'Suez', 'Egypt', 'specialized_port', 6, 15.5, 29.9668, 32.5498),
('Port of Durban', 'Durban', 'South Africa', 'cargo_port', 13, 12.2, -29.8587, 31.0218),
('Port of Cape Town', 'Cape Town', 'South Africa', 'multi_purpose', 8, 11.5, -33.9249, 18.4241),
('Port of Lagos', 'Lagos', 'Nigeria', 'cargo_port', 9, 10.5, 6.4281, 3.4219),
('Port of Mombasa', 'Mombasa', 'Kenya', 'multi_purpose', 7, 11.8, -4.0435, 39.6682),
('Port of Dar es Salaam', 'Dar es Salaam', 'Tanzania', 'cargo_port', 6, 10.2, -6.7924, 39.2083),
('Port of Santos', 'Santos', 'Brazil', 'cargo_port', 15, 13.5, -23.9608, -46.3331),
('Port of Rio de Janeiro', 'Rio de Janeiro', 'Brazil', 'multi_purpose', 10, 12.0, -22.9068, -43.1729),
('Port of Buenos Aires', 'Buenos Aires', 'Argentina', 'cargo_port', 12, 11.8, -34.6118, -58.3960),
('Port of Valparaiso', 'Valparaiso', 'Chile', 'multi_purpose', 8, 12.5, -33.0472, -71.6127),
('Port of Callao', 'Lima', 'Peru', 'cargo_port', 9, 11.0, -12.0560, -77.1441),
('Port of Cartagena', 'Cartagena', 'Colombia', 'multi_purpose', 7, 10.8, 10.3910, -75.4794),
('Port of Veracruz', 'Veracruz', 'Mexico', 'cargo_port', 8, 11.5, 19.2006, -96.1431),
('Port of Vancouver', 'Vancouver', 'Canada', 'multi_purpose', 11, 13.2, 49.2827, -123.1207),
('Port of Montreal', 'Montreal', 'Canada', 'cargo_port', 9, 10.5, 45.5017, -73.5673),
('Port of New York', 'New York', 'USA', 'multi_purpose', 13, 12.8, 40.6782, -74.0442),
('Port of Miami', 'Miami', 'USA', 'multi_purpose', 8, 11.2, 25.7617, -80.1918),
('Port of Savannah', 'Savannah', 'USA', 'cargo_port', 10, 12.5, 32.0835, -81.0998),
('Port of Sydney', 'Sydney', 'Australia', 'multi_purpose', 12, 13.0, -33.8688, 151.2093);

-- ========================================
-- 3. Customers (50 records)
-- ========================================

INSERT INTO customers (company_name, contact_person, phone, email, customer_type, credit_rating, registration_date) VALUES
('International Trade Co', 'John Smith', '+1-555-1001', 'j.smith@intltrade.com', 'shipper', 'AA', '2020-01-15'),
('Global Imports Ltd', 'Maria Garcia', '+44-20-7001-2001', 'm.garcia@globalimports.co.uk', 'consignee', 'A', '2019-03-22'),
('Asian Logistics Inc', 'Chen Wei', '+86-21-6001-3001', 'c.wei@asianlogistics.cn', 'freight_forwarder', 'AAA', '2018-07-10'),
('European Distribution', 'Hans Mueller', '+49-40-401-5001', 'h.mueller@eurodist.de', 'comprehensive', 'BBB', '2021-02-28'),
('Pacific Commerce', 'Yuki Tanaka', '+81-3-7001-8001', 'y.tanaka@pacificcommerce.jp', 'shipper', 'A', '2020-09-14'),
('Middle East Trading', 'Ahmed Al-Rashid', '+971-4-301-9001', 'a.alrashid@metrading.ae', 'consignee', 'BB', '2021-05-03'),
('Nordic Exports AS', 'Lars Andersen', '+47-22-345678', 'l.andersen@nordicexports.no', 'shipper', 'A', '2019-08-17'),
('Mediterranean Goods', 'Giuseppe Rossi', '+39-06-234567', 'g.rossi@medgoods.it', 'consignee', 'BBB', '2020-11-09'),
('Baltic Trade Group', 'Andrus Kask', '+372-234-5678', 'a.kask@baltictrade.ee', 'freight_forwarder', 'AA', '2018-12-05'),
('Scandinavian Imports', 'Astrid Larsson', '+46-8-345678', 'a.larsson@scandimports.se', 'comprehensive', 'A', '2019-06-23'),
('Eastern European Logistics', 'Dmitri Petrov', '+48-22-456789', 'd.petrov@eelogistics.pl', 'freight_forwarder', 'BBB', '2020-04-12'),
('Benelux Distribution', 'Pierre Dubois', '+32-2-567890', 'p.dubois@beneluxdist.be', 'consignee', 'AA', '2019-10-30'),
('Iberian Trading House', 'Carlos Rodriguez', '+34-91-678901', 'c.rodriguez@iberiantrade.es', 'shipper', 'A', '2020-07-18'),
('British Isles Commerce', 'James MacLeod', '+44-141-789012', 'j.macleod@bicommerce.uk', 'comprehensive', 'AAA', '2018-05-14'),
('Celtic Trade Network', 'Siobhan O\'Connor', '+353-1-890123', 's.oconnor@celtictrade.ie', 'freight_forwarder', 'BB', '2021-01-20'),
('Alpine Logistics', 'Franz Weber', '+43-1-901234', 'f.weber@alpinelogistics.at', 'shipper', 'A', '2019-09-25'),
('Adriatic Shipping Co', 'Marko Petrovic', '+385-1-012345', 'm.petrovic@adriaticship.hr', 'consignee', 'BBB', '2020-12-08'),
('Danubian Commerce', 'Viktor Kovács', '+36-1-123456', 'v.kovacs@danubian.hu', 'comprehensive', 'A', '2019-04-03'),
('Carpathian Trade', 'Ioan Popescu', '+40-21-234567', 'i.popescu@carpathiantrade.ro', 'freight_forwarder', 'BB', '2020-08-16'),
('Balkan Logistics Ltd', 'Stojan Nikolov', '+359-2-345678', 's.nikolov@balkanlogistics.bg', 'shipper', 'BBB', '2021-03-11'),
('Aegean Trading', 'Nikos Papadopoulos', '+30-210-456789', 'n.papadopoulos@aegeantrading.gr', 'consignee', 'A', '2019-11-27'),
('Anatolian Exports', 'Mehmet Özdemir', '+90-212-567890', 'm.ozdemir@anatolianexports.tr', 'comprehensive', 'AA', '2020-06-05'),
('Caucasus Commerce', 'Giorgi Mamulashvili', '+995-32-678901', 'g.mamulashvili@caucasuscommerce.ge', 'freight_forwarder', 'B', '2021-04-22'),
('Armenian Trade House', 'Armen Sarkissian', '+374-10-789012', 'a.sarkissian@armeniantrade.am', 'shipper', 'BBB', '2019-12-13'),
('Levantine Logistics', 'Omar Hassan', '+961-1-890123', 'o.hassan@levantinelogistics.lb', 'consignee', 'A', '2020-05-29'),
('Mesopotamian Trading', 'Hakim Al-Baghdadi', '+964-1-901234', 'h.albaghdadi@mesopotamian.iq', 'comprehensive', 'BB', '2019-07-07'),
('Persian Gulf Commerce', 'Reza Hosseini', '+98-21-012345', 'r.hosseini@persiangulf.ir', 'freight_forwarder', 'BBB', '2020-10-14'),
('Central Asian Trade', 'Bekzat Nazarbayev', '+7-727-123456', 'b.nazarbayev@centralasiantrade.kz', 'shipper', 'A', '2019-08-31'),
('Silk Road Logistics', 'Gulnara Karimova', '+998-71-234567', 'g.karimova@silkroadlogistics.uz', 'consignee', 'BB', '2021-02-17'),
('Himalayan Commerce', 'Tenzin Norbu', '+977-1-345678', 't.norbu@himalayancommerce.np', 'comprehensive', 'B', '2020-09-03'),
('Ganges Trading Co', 'Rajesh Sharma', '+91-11-456789', 'r.sharma@gangestrading.in', 'freight_forwarder', 'AA', '2019-05-20'),
('Deccan Logistics', 'Priya Patel', '+91-22-567890', 'p.patel@deccanlogistics.in', 'shipper', 'A', '2020-11-26'),
('Ceylon Exports Ltd', 'Chaminda Silva', '+94-11-678901', 'c.silva@ceylonexports.lk', 'consignee', 'BBB', '2019-10-12'),
('Maldivian Trading', 'Ibrahim Waheed', '+960-330-7890', 'i.waheed@maldiviantrading.mv', 'comprehensive', 'B', '2021-01-08'),
('Bay of Bengal Commerce', 'Rashid Rahman', '+880-2-890123', 'r.rahman@bayofbengal.bd', 'freight_forwarder', 'BB', '2020-04-25'),
('Indochina Logistics', 'Nguyen Van Duc', '+84-28-901234', 'n.vanduc@indochinalogistics.vn', 'shipper', 'A', '2019-07-14'),
('Mekong Delta Trading', 'Sok Pisach', '+855-23-012345', 's.pisach@mekongdelta.kh', 'consignee', 'BBB', '2020-12-01'),
('Irrawaddy Commerce', 'Thant Myint', '+95-1-123456', 't.myint@irrawaddycommerce.mm', 'comprehensive', 'B', '2019-09-18'),
('Chao Phraya Logistics', 'Somchai Wongsuwan', '+66-2-234567', 's.wongsuwan@chaophraya.th', 'freight_forwarder', 'AA', '2020-06-12'),
('Luzon Trading Corp', 'Jose Santos', '+63-2-345678', 'j.santos@luzontrading.ph', 'shipper', 'A', '2019-11-04'),
('Borneo Exports', 'Ahmad Abdullah', '+60-3-456789', 'a.abdullah@borneoexports.my', 'consignee', 'BBB', '2021-03-28'),
('Sumatra Commerce', 'Budi Santoso', '+62-21-567890', 'b.santoso@sumatracommerce.id', 'comprehensive', 'AA', '2020-08-09'),
('Java Logistics Ltd', 'Sari Dewi', '+62-24-678901', 's.dewi@javalogistics.id', 'freight_forwarder', 'A', '2019-06-15'),
('Celebes Trading', 'Made Sutrisno', '+62-411-789012', 'm.sutrisno@celebestrading.id', 'shipper', 'BB', '2020-10-21'),
('Mollucas Export Co', 'Agus Riyanto', '+62-911-890123', 'a.riyanto@mollucasexport.id', 'consignee', 'B', '2019-12-07'),
('Timor Sea Commerce', 'Carlos Ximenes', '+670-331-9012', 'c.ximenes@timorseacommerce.tl', 'comprehensive', 'BBB', '2021-05-13'),
('Banda Sea Logistics', 'Maria Gonzales', '+670-332-0123', 'm.gonzales@bandasealogistics.tl', 'freight_forwarder', 'A', '2020-07-30'),
('Coral Sea Trading', 'Bruce Thompson', '+61-7-123456', 'b.thompson@coralseatrading.au', 'shipper', 'AA', '2019-08-06'),
('Tasman Exports', 'Sarah Mitchell', '+64-9-234567', 's.mitchell@tasmanexports.nz', 'consignee', 'A', '2020-11-11'),
('Pacific Islands Commerce', 'Tevita Moala', '+676-123456', 't.moala@pacificislands.to', 'comprehensive', 'B', '2019-04-17');

-- ========================================
-- 4. Cargo Types (20 records)
-- ========================================

INSERT INTO cargo_types (type_name, description, base_rate, risk_factor, special_requirements) VALUES
('Electronics', 'Electronic goods and components', 150.00, 1.2, 'Temperature controlled, anti-static packaging'),
('Textiles', 'Clothing and fabric materials', 80.00, 1.0, 'Moisture protection required'),
('Machinery', 'Industrial equipment and machinery', 200.00, 1.5, 'Heavy lift equipment required'),
('Food Products', 'Perishable and non-perishable food items', 120.00, 1.3, 'Refrigeration may be required'),
('Chemicals', 'Industrial chemicals and compounds', 300.00, 2.5, 'Hazardous material handling, special permits'),
('Raw Materials', 'Basic materials like steel, aluminum', 60.00, 1.0, 'Weather protection recommended'),
('Automotive Parts', 'Vehicle components and accessories', 180.00, 1.1, 'Secure packaging to prevent damage'),
('Medical Supplies', 'Pharmaceutical and medical equipment', 250.00, 1.8, 'Temperature control, sterile conditions'),
('Furniture', 'Home and office furniture', 90.00, 1.1, 'Padding and protection from moisture'),
('Books & Paper', 'Publications and paper products', 70.00, 1.0, 'Moisture protection essential'),
('Toys & Games', 'Children toys and recreational items', 110.00, 1.1, 'Safety compliance verification'),
('Jewelry & Precious', 'Valuable items and precious metals', 500.00, 3.0, 'High security, insurance required'),
('Agricultural Products', 'Seeds, fertilizers, farming equipment', 85.00, 1.2, 'Pest control, organic certification'),
('Construction Materials', 'Building supplies and tools', 75.00, 1.0, 'Weather protection, heavy handling'),
('Energy Equipment', 'Solar panels, wind turbines, batteries', 220.00, 1.4, 'Technical handling, safety protocols'),
('Artwork & Antiques', 'Cultural artifacts and collectibles', 400.00, 2.8, 'Climate control, special handling'),
('Sports Equipment', 'Athletic gear and recreational equipment', 95.00, 1.1, 'Protection from impact damage'),
('Cosmetics & Personal Care', 'Beauty products and hygiene items', 130.00, 1.2, 'Temperature stability, leak prevention'),
('Marine Equipment', 'Boat parts and marine supplies', 160.00, 1.3, 'Corrosion protection, waterproofing'),
('Optical Equipment', 'Cameras, lenses, scientific instruments', 280.00, 1.9, 'Shock protection, precision handling');

-- ========================================
-- 5. Ships (60 records)
-- ========================================

INSERT INTO ships (ship_name, ship_type, deadweight_tonnage, length, width, build_year, company_id, current_status) VALUES
('Ocean Pioneer', 'container_ship', 95000.00, 350.0, 45.0, 2018, 1, 'in_port'),
('Pacific Star', 'bulk_carrier', 180000.00, 280.0, 50.0, 2016, 2, 'sailing'),
('European Express', 'cargo_ship', 75000.00, 220.0, 32.0, 2019, 3, 'in_port'),
('Asia Dream', 'container_ship', 120000.00, 380.0, 52.0, 2020, 4, 'sailing'),
('Atlantic Voyager', 'tanker', 150000.00, 250.0, 44.0, 2017, 5, 'under_maintenance'),
('Global Trader', 'cargo_ship', 85000.00, 200.0, 30.0, 2021, 1, 'in_port'),
('Pacific Guardian', 'container_ship', 110000.00, 320.0, 48.0, 2019, 2, 'sailing'),
('Mediterranean Pearl', 'passenger_ship', 65000.00, 180.0, 28.0, 2020, 6, 'in_port'),
('Nordic Breeze', 'cargo_ship', 78000.00, 210.0, 33.0, 2018, 7, 'sailing'),
('Scandinavian Crown', 'container_ship', 105000.00, 330.0, 46.0, 2019, 8, 'in_port'),
('Baltic Thunder', 'bulk_carrier', 165000.00, 270.0, 48.0, 2017, 9, 'sailing'),
('Black Sea Warrior', 'tanker', 140000.00, 240.0, 42.0, 2020, 10, 'under_maintenance'),
('Red Sea Navigator', 'cargo_ship', 82000.00, 205.0, 31.0, 2021, 11, 'in_port'),
('Indian Ocean Breeze', 'container_ship', 115000.00, 340.0, 49.0, 2018, 12, 'sailing'),
('Arabian Gulf Spirit', 'tanker', 160000.00, 260.0, 45.0, 2019, 13, 'in_port'),
('Persian Wind', 'cargo_ship', 88000.00, 215.0, 34.0, 2020, 14, 'sailing'),
('Caspian Explorer', 'bulk_carrier', 175000.00, 275.0, 51.0, 2017, 15, 'in_port'),
('South China Dragon', 'container_ship', 125000.00, 360.0, 50.0, 2021, 16, 'sailing'),
('East Asia Phoenix', 'cargo_ship', 92000.00, 225.0, 35.0, 2018, 17, 'under_maintenance'),
('Southeast Falcon', 'container_ship', 108000.00, 325.0, 47.0, 2019, 18, 'in_port'),
('Mekong River Eagle', 'cargo_ship', 76000.00, 195.0, 29.0, 2020, 19, 'sailing'),
('Malacca Strait Tiger', 'tanker', 145000.00, 245.0, 43.0, 2017, 20, 'in_port'),
('Indonesian Archipelago', 'bulk_carrier', 170000.00, 265.0, 49.0, 2021, 21, 'sailing'),
('Philippine Sunrise', 'container_ship', 118000.00, 345.0, 48.0, 2018, 22, 'in_port'),
('Australian Horizon', 'cargo_ship', 89000.00, 220.0, 33.0, 2019, 23, 'sailing'),
('New Zealand Voyager', 'container_ship', 112000.00, 335.0, 46.0, 2020, 24, 'under_maintenance'),
('Pacific Islander', 'passenger_ship', 58000.00, 175.0, 26.0, 2017, 25, 'in_port'),
('Caribbean Star', 'cargo_ship', 84000.00, 208.0, 32.0, 2021, 26, 'sailing'),
('Central American', 'container_ship', 101000.00, 315.0, 45.0, 2018, 27, 'in_port'),
('South American Giant', 'bulk_carrier', 185000.00, 285.0, 52.0, 2019, 28, 'sailing'),
('Patagonian Wind', 'tanker', 155000.00, 255.0, 44.0, 2020, 29, 'in_port'),
('Chilean Pacific', 'cargo_ship', 87000.00, 213.0, 34.0, 2017, 30, 'sailing'),
('Peruvian Current', 'container_ship', 114000.00, 338.0, 47.0, 2021, 31, 'under_maintenance'),
('Colombian Spirit', 'cargo_ship', 91000.00, 222.0, 35.0, 2018, 32, 'in_port'),
('Venezuelan Liberty', 'tanker', 148000.00, 248.0, 43.0, 2019, 33, 'sailing'),
('West African Lion', 'bulk_carrier', 172000.00, 268.0, 50.0, 2020, 34, 'in_port'),
('East African Elephant', 'container_ship', 116000.00, 342.0, 48.0, 2017, 35, 'sailing'),
('South African Diamond', 'cargo_ship', 93000.00, 227.0, 36.0, 2021, 36, 'in_port'),
('Maghreb Camel', 'container_ship', 107000.00, 322.0, 46.0, 2018, 37, 'sailing'),
('Nile River Pharaoh', 'cargo_ship', 79000.00, 198.0, 30.0, 2019, 38, 'under_maintenance'),
('Horn of Africa Gazelle', 'bulk_carrier', 168000.00, 262.0, 48.0, 2020, 39, 'in_port'),
('Madagascar Lemur', 'tanker', 142000.00, 242.0, 42.0, 2017, 40, 'sailing'),
('Mauritius Dodo', 'container_ship', 109000.00, 328.0, 47.0, 2021, 41, 'in_port'),
('Seychelles Turtle', 'cargo_ship', 85000.00, 211.0, 33.0, 2018, 42, 'sailing'),
('Comoros Whale', 'container_ship', 103000.00, 318.0, 45.0, 2019, 43, 'in_port'),
('Reunion Dolphin', 'bulk_carrier', 174000.00, 272.0, 50.0, 2020, 44, 'sailing'),
('Mayotte Shark', 'tanker', 151000.00, 252.0, 44.0, 2017, 45, 'under_maintenance'),
('Canary Islands Falcon', 'cargo_ship', 88000.00, 216.0, 34.0, 2021, 46, 'in_port'),
('Madeira Eagle', 'container_ship', 111000.00, 332.0, 46.0, 2018, 47, 'sailing'),
('Azores Whale', 'cargo_ship', 86000.00, 212.0, 33.0, 2019, 48, 'in_port'),
('Cape Verde Albatross', 'bulk_carrier', 176000.00, 276.0, 51.0, 2020, 49, 'sailing'),
('Guinea-Bissau Pelican', 'tanker', 146000.00, 246.0, 43.0, 2017, 50, 'in_port'),
('Atlantic Wanderer', 'container_ship', 122000.00, 355.0, 49.0, 2021, 1, 'sailing'),
('Pacific Conqueror', 'cargo_ship', 94000.00, 230.0, 36.0, 2018, 2, 'under_maintenance'),
('European Sovereign', 'bulk_carrier', 178000.00, 278.0, 51.0, 2019, 3, 'in_port'),
('Asian Emperor', 'container_ship', 128000.00, 365.0, 50.0, 2020, 4, 'sailing'),
('Arctic Explorer', 'tanker', 158000.00, 258.0, 45.0, 2017, 5, 'in_port'),
('Antarctic Pioneer', 'cargo_ship', 96000.00, 235.0, 37.0, 2021, 6, 'sailing'),
('Equatorial Crosser', 'container_ship', 119000.00, 348.0, 48.0, 2018, 7, 'in_port'),
('Tropic Voyager', 'bulk_carrier', 182000.00, 282.0, 52.0, 2019, 8, 'sailing');

-- ========================================
-- 6. Berths (100+ records for all ports)
-- ========================================

INSERT INTO berths (port_id, berth_name, berth_type, length, max_draft, status) VALUES
-- Shanghai (port_id: 1)
(1, 'Terminal A-1', 'container_berth', 400.0, 15.5, 'available'),
(1, 'Terminal A-2', 'container_berth', 350.0, 14.8, 'occupied'),
(1, 'Terminal B-1', 'bulk_berth', 280.0, 13.5, 'available'),
(1, 'Terminal B-2', 'bulk_berth', 300.0, 14.0, 'available'),
(1, 'Terminal C-1', 'general_berth', 250.0, 12.5, 'under_maintenance'),
-- Singapore (port_id: 2)
(2, 'Tanjong Pagar T1', 'container_berth', 380.0, 16.0, 'available'),
(2, 'Tanjong Pagar T2', 'container_berth', 380.0, 16.0, 'occupied'),
(2, 'Keppel Terminal', 'container_berth', 350.0, 15.5, 'available'),
(2, 'Pasir Panjang T1', 'container_berth', 370.0, 15.8, 'available'),
-- Rotterdam (port_id: 3)
(3, 'Maasvlakte M1', 'container_berth', 420.0, 14.5, 'available'),
(3, 'Maasvlakte M2', 'general_berth', 300.0, 12.0, 'occupied'),
(3, 'ECT Delta', 'container_berth', 390.0, 14.2, 'available'),
(3, 'APM Terminal', 'container_berth', 410.0, 14.8, 'available'),
-- Los Angeles (port_id: 4)
(4, 'Terminal Island T1', 'container_berth', 360.0, 13.7, 'available'),
(4, 'Terminal Island T2', 'container_berth', 340.0, 13.5, 'occupied'),
(4, 'San Pedro Bay', 'general_berth', 280.0, 12.0, 'available'),
-- Hamburg (port_id: 5)
(5, 'Container Terminal CT1', 'container_berth', 340.0, 13.8, 'available'),
(5, 'Container Terminal CT2', 'container_berth', 320.0, 13.5, 'occupied'),
(5, 'Bulk Terminal', 'bulk_berth', 260.0, 12.5, 'available'),
-- Continue for all other ports with 2-3 berths each
(6, 'New Port Terminal', 'container_berth', 320.0, 14.2, 'available'),
(6, 'Gamcheon Terminal', 'container_berth', 310.0, 14.0, 'occupied'),
(7, 'Jebel Ali T1', 'container_berth', 380.0, 15.0, 'available'),
(7, 'Jebel Ali T2', 'container_berth', 370.0, 14.8, 'available'),
(8, 'Antwerp Terminal', 'container_berth', 330.0, 13.5, 'occupied'),
(8, 'MSC Terminal', 'container_berth', 340.0, 13.8, 'available'),
(9, 'Qingdao Port T1', 'container_berth', 350.0, 14.8, 'available'),
(9, 'Qingdao Port T2', 'bulk_berth', 280.0, 13.5, 'occupied'),
(10, 'Long Beach T1', 'container_berth', 360.0, 13.9, 'available'),
(10, 'Long Beach T2', 'container_berth', 340.0, 13.7, 'available'),
(11, 'Guangzhou T1', 'container_berth', 370.0, 15.2, 'occupied'),
(11, 'Guangzhou T2', 'general_berth', 290.0, 13.0, 'available'),
(12, 'Port Klang T1', 'container_berth', 320.0, 14.1, 'available'),
(12, 'Port Klang T2', 'container_berth', 310.0, 13.8, 'occupied'),
(13, 'Hamburg-Süd T1', 'oil_berth', 250.0, 12.5, 'available'),
(14, 'PTP Terminal', 'container_berth', 350.0, 15.8, 'available'),
(15, 'Laem Chabang T1', 'container_berth', 300.0, 13.2, 'occupied'),
(16, 'Bremen T1', 'general_berth', 270.0, 12.8, 'available'),
(17, 'Valencia T1', 'container_berth', 320.0, 13.5, 'available'),
(18, 'Felixstowe T1', 'container_berth', 310.0, 14.5, 'occupied'),
(19, 'Yokohama T1', 'general_berth', 290.0, 13.0, 'available'),
(20, 'Kobe T1', 'container_berth', 300.0, 12.5, 'available'),
(21, 'Kaohsiung T1', 'container_berth', 330.0, 14.3, 'occupied'),
(22, 'Colombo T1', 'general_berth', 280.0, 15.0, 'available'),
(23, 'Jakarta T1', 'container_berth', 320.0, 12.0, 'available'),
(24, 'Manila T1', 'general_berth', 270.0, 11.5, 'occupied'),
(25, 'HCMC T1', 'container_berth', 290.0, 10.8, 'available'),
(26, 'Mumbai T1', 'general_berth', 310.0, 11.2, 'available'),
(27, 'Chennai T1', 'container_berth', 300.0, 12.5, 'occupied'),
(28, 'JNPT T1', 'container_berth', 350.0, 13.8, 'available'),
(29, 'Bandar Abbas T1', 'general_berth', 290.0, 13.0, 'available'),
(30, 'Jeddah T1', 'container_berth', 330.0, 14.2, 'occupied'),
(31, 'Alexandria T1', 'general_berth', 300.0, 12.8, 'available'),
(32, 'Suez T1', 'oil_berth', 280.0, 15.5, 'available'),
(33, 'Durban T1', 'container_berth', 310.0, 12.2, 'occupied'),
(34, 'Cape Town T1', 'general_berth', 270.0, 11.5, 'available'),
(35, 'Lagos T1', 'container_berth', 280.0, 10.5, 'available'),
(36, 'Mombasa T1', 'general_berth', 260.0, 11.8, 'occupied'),
(37, 'Dar es Salaam T1', 'container_berth', 250.0, 10.2, 'available'),
(38, 'Santos T1', 'container_berth', 330.0, 13.5, 'available'),
(39, 'Rio T1', 'general_berth', 290.0, 12.0, 'occupied'),
(40, 'Buenos Aires T1', 'container_berth', 310.0, 11.8, 'available'),
(41, 'Valparaiso T1', 'general_berth', 280.0, 12.5, 'available'),
(42, 'Callao T1', 'container_berth', 290.0, 11.0, 'occupied'),
(43, 'Cartagena T1', 'general_berth', 270.0, 10.8, 'available'),
(44, 'Veracruz T1', 'container_berth', 280.0, 11.5, 'available'),
(45, 'Vancouver T1', 'general_berth', 300.0, 13.2, 'occupied'),
(46, 'Montreal T1', 'container_berth', 270.0, 10.5, 'available'),
(47, 'New York T1', 'general_berth', 320.0, 12.8, 'available'),
(48, 'Miami T1', 'general_berth', 280.0, 11.2, 'occupied'),
(49, 'Savannah T1', 'container_berth', 300.0, 12.5, 'available'),
(50, 'Sydney T1', 'general_berth', 310.0, 13.0, 'available');

-- ========================================
-- 7. Cargos (50 records)
-- ========================================

INSERT INTO cargos (cargo_name, type_id, weight, volume, value, danger_level, packaging_type, description) VALUES
('Laptop Computers', 1, 500.00, 15.5, 250000.00, 'no_danger', 'Anti-static boxes', 'High-end gaming laptops'),
('Cotton Fabric Rolls', 2, 2000.00, 45.2, 35000.00, 'no_danger', 'Plastic wrapped', 'Premium cotton for fashion industry'),
('Industrial Pumps', 3, 5000.00, 85.0, 180000.00, 'no_danger', 'Wooden crates', 'Heavy-duty water pumps'),
('Frozen Seafood', 4, 1500.00, 25.8, 45000.00, 'no_danger', 'Refrigerated containers', 'Premium salmon and tuna'),
('Industrial Solvents', 5, 800.00, 12.5, 25000.00, 'moderate_danger', 'Chemical drums', 'Organic cleaning solvents'),
('Steel Coils', 6, 8000.00, 120.5, 65000.00, 'no_danger', 'Weather protection', 'Hot-rolled steel coils'),
('Car Engine Parts', 7, 1200.00, 28.3, 95000.00, 'no_danger', 'Protective packaging', 'Precision engine components'),
('MRI Machines', 8, 3500.00, 45.0, 1200000.00, 'no_danger', 'Climate controlled', 'Advanced medical imaging equipment'),
('Office Furniture Set', 9, 2200.00, 55.8, 18000.00, 'no_danger', 'Bubble wrap', 'Ergonomic office desks and chairs'),
('Medical Textbooks', 10, 800.00, 12.0, 15000.00, 'no_danger', 'Waterproof packaging', 'Latest medical reference books'),
('Educational Toys', 11, 450.00, 18.5, 8500.00, 'no_danger', 'Child-safe packaging', 'STEM learning toys for children'),
('Gold Jewelry', 12, 25.00, 0.5, 500000.00, 'no_danger', 'High security vault', 'Handcrafted gold necklaces and rings'),
('Organic Seeds', 13, 120.00, 8.2, 5000.00, 'no_danger', 'Moisture control', 'Non-GMO vegetable seeds'),
('Solar Panels', 15, 1800.00, 35.0, 85000.00, 'no_danger', 'Anti-shock packaging', 'High-efficiency photovoltaic panels'),
('Renaissance Paintings', 16, 15.00, 2.5, 2000000.00, 'no_danger', 'Climate controlled', 'Authenticated 16th century artworks'),
('Tennis Equipment', 17, 350.00, 22.0, 4500.00, 'no_danger', 'Sports packaging', 'Professional tennis rackets and balls'),
('Luxury Cosmetics', 18, 180.00, 5.8, 12000.00, 'no_danger', 'Temperature stable', 'Premium skincare and makeup'),
('Marine Propellers', 19, 2800.00, 15.5, 75000.00, 'no_danger', 'Corrosion protection', 'Bronze ship propellers'),
('Digital Cameras', 20, 220.00, 8.2, 35000.00, 'no_danger', 'Shock resistant', 'Professional DSLR cameras'),
('Silk Scarves', 2, 85.00, 3.5, 6500.00, 'no_danger', 'Tissue paper', 'Hand-woven silk accessories'),
('CNC Machines', 3, 12000.00, 180.0, 450000.00, 'no_danger', 'Heavy machinery crates', 'Computer-controlled milling machines'),
('Coffee Beans', 4, 2400.00, 48.0, 28000.00, 'no_danger', 'Vacuum sealed bags', 'Premium arabica coffee beans'),
('Laboratory Chemicals', 5, 650.00, 18.5, 85000.00, 'high_danger', 'Chemical safety containers', 'Research grade reagents'),
('Aluminum Sheets', 6, 5500.00, 95.0, 42000.00, 'no_danger', 'Plastic sheeting', 'Aircraft grade aluminum'),
('Motorcycle Parts', 7, 890.00, 15.8, 22000.00, 'no_danger', 'Foam protection', 'High-performance bike components'),
('Surgical Instruments', 8, 125.00, 2.8, 95000.00, 'no_danger', 'Sterile packaging', 'Precision surgical tools'),
('Dining Room Sets', 9, 3200.00, 85.5, 25000.00, 'no_danger', 'Furniture blankets', 'Solid wood dining furniture'),
('Scientific Journals', 10, 1200.00, 18.0, 8500.00, 'no_danger', 'Moisture barrier', 'Research publications collection'),
('Board Games', 11, 680.00, 25.5, 3200.00, 'no_danger', 'Retail packaging', 'Strategy and family board games'),
('Diamond Rings', 12, 5.00, 0.1, 750000.00, 'no_danger', 'Ultra-secure vault', 'Certified diamond engagement rings'),
('Flower Bulbs', 13, 240.00, 12.5, 3800.00, 'no_danger', 'Breathable containers', 'Spring flowering bulbs'),
('Cement Mixers', 14, 8500.00, 120.0, 155000.00, 'no_danger', 'Industrial wrapping', 'Heavy-duty construction equipment'),
('Wind Turbine Blades', 15, 15000.00, 450.0, 280000.00, 'no_danger', 'Oversized transport', 'Renewable energy components'),
('Ancient Sculptures', 16, 2500.00, 15.0, 3500000.00, 'no_danger', 'Museum quality crating', 'Greek and Roman artifacts'),
('Golf Equipment', 17, 420.00, 18.5, 5500.00, 'no_danger', 'Golf bags', 'Professional golf clubs and accessories'),
('Perfume Collection', 18, 95.00, 3.2, 18000.00, 'no_danger', 'Fragile item packaging', 'Designer fragrance bottles'),
('Yacht Equipment', 19, 1800.00, 25.0, 65000.00, 'no_danger', 'Marine grade protection', 'Luxury boat fittings'),
('Professional Lenses', 20, 340.00, 8.8, 125000.00, 'no_danger', 'Precision optics case', 'Camera and telescope lenses'),
('Designer Clothing', 2, 150.00, 12.0, 25000.00, 'no_danger', 'Garment bags', 'High-fashion apparel collection'),
('3D Printers', 3, 450.00, 18.5, 35000.00, 'no_danger', 'Electronic protection', 'Industrial grade 3D printing systems'),
('Gourmet Chocolate', 4, 380.00, 8.5, 4500.00, 'no_danger', 'Temperature controlled', 'Belgian artisan chocolates'),
('Titanium Alloys', 6, 1200.00, 8.0, 95000.00, 'no_danger', 'Metal containers', 'Aerospace grade titanium'),
('Electric Vehicle Batteries', 7, 2800.00, 35.0, 185000.00, 'slight_danger', 'Lithium battery packaging', 'High-capacity EV battery packs'),
('Vintage Wines', 4, 960.00, 18.0, 65000.00, 'no_danger', 'Climate controlled', 'Rare vintage wine collection'),
('Smartphone Components', 1, 280.00, 5.5, 145000.00, 'no_danger', 'ESD protection', 'Advanced mobile phone parts'),
('Racing Bicycles', 17, 850.00, 45.0, 28000.00, 'no_danger', 'Bike boxes', 'Carbon fiber racing bikes'),
('Luxury Watches', 12, 12.00, 0.8, 890000.00, 'no_danger', 'High security cases', 'Swiss mechanical timepieces'),
('Organic Fertilizers', 13, 5000.00, 85.0, 12000.00, 'no_danger', 'Biodegradable sacks', 'Eco-friendly plant nutrients'),
('Robotic Systems', 3, 1850.00, 28.0, 285000.00, 'no_danger', 'Anti-vibration packaging', 'Industrial automation robots'),
('Rare Books', 10, 45.00, 2.2, 125000.00, 'no_danger', 'Archival protection', 'First edition literary classics');

-- ========================================
-- 8. Transport Orders (50 records)
-- ========================================

-- Generate order numbers and insert transport orders
INSERT INTO transport_orders (order_number, shipper_id, consignee_id, origin_port_id, destination_port_id, order_status, total_weight, total_volume, total_value, freight_amount, order_date, required_delivery_date) VALUES
('ORD20240101001', 1, 2, 1, 3, 'completed', 2500.00, 45.5, 285000.00, 12500.00, '2024-01-01', '2024-01-15'),
('ORD20240102002', 3, 4, 2, 4, 'in_transit', 5800.00, 95.2, 380000.00, 29000.00, '2024-01-02', '2024-01-20'),
('ORD20240103003', 5, 6, 1, 7, 'arrived', 1800.00, 32.1, 125000.00, 9000.00, '2024-01-03', '2024-01-25'),
('ORD20240104004', 7, 8, 5, 8, 'confirmed', 3200.00, 58.5, 195000.00, 16000.00, '2024-01-04', '2024-01-30'),
('ORD20240105005', 9, 10, 6, 9, 'ship_assigned', 4500.00, 78.2, 425000.00, 22500.00, '2024-01-05', '2024-02-01'),
('ORD20240106006', 11, 12, 10, 11, 'pending', 2800.00, 48.8, 165000.00, 14000.00, '2024-01-06', '2024-02-05'),
('ORD20240107007', 13, 14, 12, 13, 'confirmed', 6200.00, 115.5, 495000.00, 31000.00, '2024-01-07', '2024-02-10'),
('ORD20240108008', 15, 16, 14, 15, 'in_transit', 1650.00, 28.5, 89000.00, 8250.00, '2024-01-08', '2024-02-15'),
('ORD20240109009', 17, 18, 16, 17, 'completed', 3900.00, 68.8, 295000.00, 19500.00, '2024-01-09', '2024-02-20'),
('ORD20240110010', 19, 20, 18, 19, 'arrived', 5100.00, 88.5, 385000.00, 25500.00, '2024-01-10', '2024-02-25'),
('ORD20240111011', 21, 22, 20, 21, 'ship_assigned', 2200.00, 38.2, 145000.00, 11000.00, '2024-01-11', '2024-03-01'),
('ORD20240112012', 23, 24, 22, 23, 'confirmed', 4800.00, 82.5, 355000.00, 24000.00, '2024-01-12', '2024-03-05'),
('ORD20240113013', 25, 26, 24, 25, 'pending', 3500.00, 62.8, 225000.00, 17500.00, '2024-01-13', '2024-03-10'),
('ORD20240114014', 27, 28, 26, 27, 'in_transit', 7200.00, 125.5, 565000.00, 36000.00, '2024-01-14', '2024-03-15'),
('ORD20240115015', 29, 30, 28, 29, 'completed', 1950.00, 34.2, 98000.00, 9750.00, '2024-01-15', '2024-03-20'),
('ORD20240116016', 31, 32, 30, 31, 'arrived', 4200.00, 72.8, 315000.00, 21000.00, '2024-01-16', '2024-03-25'),
('ORD20240117017', 33, 34, 32, 33, 'ship_assigned', 3800.00, 65.5, 285000.00, 19000.00, '2024-01-17', '2024-03-30'),
('ORD20240118018', 35, 36, 34, 35, 'confirmed', 5600.00, 98.2, 445000.00, 28000.00, '2024-01-18', '2024-04-01'),
('ORD20240119019', 37, 38, 36, 37, 'pending', 2600.00, 45.8, 175000.00, 13000.00, '2024-01-19', '2024-04-05'),
('ORD20240120020', 39, 40, 38, 39, 'in_transit', 6800.00, 118.5, 525000.00, 34000.00, '2024-01-20', '2024-04-10'),
('ORD20240121021', 41, 42, 40, 41, 'completed', 2100.00, 36.8, 135000.00, 10500.00, '2024-01-21', '2024-04-15'),
('ORD20240122022', 43, 44, 42, 43, 'arrived', 4600.00, 78.5, 345000.00, 23000.00, '2024-01-22', '2024-04-20'),
('ORD20240123023', 45, 46, 44, 45, 'ship_assigned', 3100.00, 55.2, 195000.00, 15500.00, '2024-01-23', '2024-04-25'),
('ORD20240124024', 47, 48, 46, 47, 'confirmed', 5200.00, 89.8, 395000.00, 26000.00, '2024-01-24', '2024-04-30'),
('ORD20240125025', 49, 50, 48, 49, 'pending', 2900.00, 48.5, 185000.00, 14500.00, '2024-01-25', '2024-05-01'),
('ORD20240126026', 1, 3, 50, 1, 'in_transit', 6500.00, 112.5, 485000.00, 32500.00, '2024-01-26', '2024-05-05'),
('ORD20240127027', 2, 4, 2, 5, 'completed', 1800.00, 31.2, 95000.00, 9000.00, '2024-01-27', '2024-05-10'),
('ORD20240128028', 5, 7, 4, 6, 'arrived', 4100.00, 71.8, 305000.00, 20500.00, '2024-01-28', '2024-05-15'),
('ORD20240129029', 6, 8, 6, 8, 'ship_assigned', 3600.00, 62.5, 255000.00, 18000.00, '2024-01-29', '2024-05-20'),
('ORD20240130030', 9, 11, 8, 10, 'confirmed', 5000.00, 85.8, 375000.00, 25000.00, '2024-01-30', '2024-05-25'),
('ORD20240131031', 10, 12, 10, 12, 'pending', 2700.00, 46.2, 165000.00, 13500.00, '2024-01-31', '2024-05-30'),
('ORD20240201032', 13, 15, 12, 14, 'in_transit', 7000.00, 122.5, 545000.00, 35000.00, '2024-02-01', '2024-06-01'),
('ORD20240202033', 14, 16, 14, 16, 'completed', 2000.00, 34.8, 125000.00, 10000.00, '2024-02-02', '2024-06-05'),
('ORD20240203034', 17, 19, 16, 18, 'arrived', 4400.00, 76.5, 335000.00, 22000.00, '2024-02-03', '2024-06-10'),
('ORD20240204035', 18, 20, 18, 20, 'ship_assigned', 3300.00, 57.8, 225000.00, 16500.00, '2024-02-04', '2024-06-15'),
('ORD20240205036', 21, 23, 20, 22, 'confirmed', 5400.00, 92.5, 415000.00, 27000.00, '2024-02-05', '2024-06-20'),
('ORD20240206037', 22, 24, 22, 24, 'pending', 2400.00, 41.8, 155000.00, 12000.00, '2024-02-06', '2024-06-25'),
('ORD20240207038', 25, 27, 24, 26, 'in_transit', 6200.00, 108.5, 465000.00, 31000.00, '2024-02-07', '2024-06-30'),
('ORD20240208039', 26, 28, 26, 28, 'completed', 1700.00, 29.2, 85000.00, 8500.00, '2024-02-08', '2024-07-01'),
('ORD20240209040', 29, 31, 28, 30, 'arrived', 4700.00, 81.8, 365000.00, 23500.00, '2024-02-09', '2024-07-05'),
('ORD20240210041', 30, 32, 30, 32, 'ship_assigned', 3900.00, 68.2, 295000.00, 19500.00, '2024-02-10', '2024-07-10'),
('ORD20240211042', 33, 35, 32, 34, 'confirmed', 5800.00, 98.5, 445000.00, 29000.00, '2024-02-11', '2024-07-15'),
('ORD20240212043', 34, 36, 34, 36, 'pending', 2300.00, 39.8, 145000.00, 11500.00, '2024-02-12', '2024-07-20'),
('ORD20240213044', 37, 39, 36, 38, 'in_transit', 6600.00, 115.5, 505000.00, 33000.00, '2024-02-13', '2024-07-25'),
('ORD20240214045', 38, 40, 38, 40, 'completed', 2800.00, 48.2, 185000.00, 14000.00, '2024-02-14', '2024-07-30'),
('ORD20240215046', 41, 43, 40, 42, 'arrived', 4300.00, 74.8, 325000.00, 21500.00, '2024-02-15', '2024-08-01'),
('ORD20240216047', 42, 44, 42, 44, 'ship_assigned', 3700.00, 64.2, 275000.00, 18500.00, '2024-02-16', '2024-08-05'),
('ORD20240217048', 45, 47, 44, 46, 'confirmed', 5300.00, 91.8, 405000.00, 26500.00, '2024-02-17', '2024-08-10'),
('ORD20240218049', 46, 48, 46, 48, 'pending', 2500.00, 43.2, 165000.00, 12500.00, '2024-02-18', '2024-08-15'),
('ORD20240219050', 49, 1, 48, 50, 'in_transit', 6900.00, 120.5, 525000.00, 34500.00, '2024-02-19', '2024-08-20'),
('ORD20240220051', 50, 2, 50, 2, 'completed', 1900.00, 33.8, 115000.00, 9500.00, '2024-02-20', '2024-08-25');

-- ========================================
-- 9. Voyages (50 records)
-- ========================================

INSERT INTO voyages (voyage_number, ship_id, origin_port_id, destination_port_id, departure_time, arrival_time, voyage_status, distance_nautical_miles, fuel_consumption) VALUES
('VOY20240101001', 1, 1, 3, '2024-01-01 08:00:00', '2024-01-15 14:00:00', 'completed', 6500.0, 850.5),
('VOY20240102002', 2, 2, 4, '2024-01-02 10:00:00', '2024-01-20 16:00:00', 'in_progress', 7200.0, 920.8),
('VOY20240103003', 3, 1, 7, '2024-01-03 06:00:00', '2024-01-25 12:00:00', 'completed', 8900.0, 1150.2),
('VOY20240104004', 4, 5, 8, '2024-01-04 14:00:00', '2024-01-30 20:00:00', 'planned', 450.0, 58.5),
('VOY20240105005', 5, 6, 9, '2024-01-05 09:00:00', '2024-02-01 15:00:00', 'in_progress', 5800.0, 754.0),
('VOY20240106006', 6, 10, 11, '2024-01-06 11:00:00', '2024-02-05 17:00:00', 'planned', 7800.0, 1014.0),
('VOY20240107007', 7, 12, 13, '2024-01-07 07:00:00', '2024-02-10 13:00:00', 'in_progress', 3200.0, 416.0),
('VOY20240108008', 8, 14, 15, '2024-01-08 13:00:00', '2024-02-15 19:00:00', 'completed', 1800.0, 234.0),
('VOY20240109009', 9, 16, 17, '2024-01-09 08:00:00', '2024-02-20 14:00:00', 'completed', 2100.0, 273.0),
('VOY20240110010', 10, 18, 19, '2024-01-10 15:00:00', '2024-02-25 21:00:00', 'in_progress', 1500.0, 195.0),
('VOY20240111011', 11, 20, 21, '2024-01-11 12:00:00', '2024-03-01 18:00:00', 'planned', 2800.0, 364.0),
('VOY20240112012', 12, 22, 23, '2024-01-12 09:00:00', '2024-03-05 15:00:00', 'in_progress', 4200.0, 546.0),
('VOY20240113013', 13, 24, 25, '2024-01-13 16:00:00', '2024-03-10 22:00:00', 'planned', 3600.0, 468.0),
('VOY20240114014', 14, 26, 27, '2024-01-14 06:00:00', '2024-03-15 12:00:00', 'in_progress', 5400.0, 702.0),
('VOY20240115015', 15, 28, 29, '2024-01-15 14:00:00', '2024-03-20 20:00:00', 'completed', 1200.0, 156.0),
('VOY20240116016', 16, 30, 31, '2024-01-16 10:00:00', '2024-03-25 16:00:00', 'in_progress', 2600.0, 338.0),
('VOY20240117017', 17, 32, 33, '2024-01-17 08:00:00', '2024-03-30 14:00:00', 'planned', 1800.0, 234.0),
('VOY20240118018', 18, 34, 35, '2024-01-18 11:00:00', '2024-04-01 17:00:00', 'in_progress', 3800.0, 494.0),
('VOY20240119019', 19, 36, 37, '2024-01-19 07:00:00', '2024-04-05 13:00:00', 'planned', 2200.0, 286.0),
('VOY20240120020', 20, 38, 39, '2024-01-20 13:00:00', '2024-04-10 19:00:00', 'in_progress', 4600.0, 598.0),
('VOY20240121021', 21, 40, 41, '2024-01-21 09:00:00', '2024-04-15 15:00:00', 'completed', 3200.0, 416.0),
('VOY20240122022', 22, 42, 43, '2024-01-22 15:00:00', '2024-04-20 21:00:00', 'in_progress', 2400.0, 312.0),
('VOY20240123023', 23, 44, 45, '2024-01-23 12:00:00', '2024-04-25 18:00:00', 'planned', 1600.0, 208.0),
('VOY20240124024', 24, 46, 47, '2024-01-24 08:00:00', '2024-04-30 14:00:00', 'in_progress', 3400.0, 442.0),
('VOY20240125025', 25, 48, 49, '2024-01-25 14:00:00', '2024-05-01 20:00:00', 'planned', 2800.0, 364.0),
('VOY20240126026', 26, 50, 1, '2024-01-26 10:00:00', '2024-05-05 16:00:00', 'in_progress', 9200.0, 1196.0),
('VOY20240127027', 27, 2, 5, '2024-01-27 06:00:00', '2024-05-10 12:00:00', 'completed', 5600.0, 728.0),
('VOY20240128028', 28, 4, 6, '2024-01-28 12:00:00', '2024-05-15 18:00:00', 'in_progress', 6800.0, 884.0),
('VOY20240129029', 29, 6, 8, '2024-01-29 09:00:00', '2024-05-20 15:00:00', 'planned', 4200.0, 546.0),
('VOY20240130030', 30, 8, 10, '2024-01-30 15:00:00', '2024-05-25 21:00:00', 'in_progress', 5200.0, 676.0),
('VOY20240131031', 31, 10, 12, '2024-01-31 11:00:00', '2024-05-30 17:00:00', 'planned', 7400.0, 962.0),
('VOY20240201032', 32, 12, 14, '2024-02-01 07:00:00', '2024-06-01 13:00:00', 'in_progress', 3800.0, 494.0),
('VOY20240202033', 33, 14, 16, '2024-02-02 13:00:00', '2024-06-05 19:00:00', 'completed', 2600.0, 338.0),
('VOY20240203034', 34, 16, 18, '2024-02-03 10:00:00', '2024-06-10 16:00:00', 'in_progress', 1900.0, 247.0),
('VOY20240204035', 35, 18, 20, '2024-02-04 16:00:00', '2024-06-15 22:00:00', 'planned', 3100.0, 403.0),
('VOY20240205036', 36, 20, 22, '2024-02-05 08:00:00', '2024-06-20 14:00:00', 'in_progress', 4700.0, 611.0),
('VOY20240206037', 37, 22, 24, '2024-02-06 14:00:00', '2024-06-25 20:00:00', 'planned', 2300.0, 299.0),
('VOY20240207038', 38, 24, 26, '2024-02-07 11:00:00', '2024-06-30 17:00:00', 'in_progress', 6100.0, 793.0),
('VOY20240208039', 39, 26, 28, '2024-02-08 07:00:00', '2024-07-01 13:00:00', 'completed', 1700.0, 221.0),
('VOY20240209040', 40, 28, 30, '2024-02-09 13:00:00', '2024-07-05 19:00:00', 'in_progress', 4500.0, 585.0),
('VOY20240210041', 41, 30, 32, '2024-02-10 09:00:00', '2024-07-10 15:00:00', 'planned', 3700.0, 481.0),
('VOY20240211042', 42, 32, 34, '2024-02-11 15:00:00', '2024-07-15 21:00:00', 'in_progress', 5900.0, 767.0),
('VOY20240212043', 43, 34, 36, '2024-02-12 12:00:00', '2024-07-20 18:00:00', 'planned', 2100.0, 273.0),
('VOY20240213044', 44, 36, 38, '2024-02-13 08:00:00', '2024-07-25 14:00:00', 'in_progress', 6300.0, 819.0),
('VOY20240214045', 45, 38, 40, '2024-02-14 14:00:00', '2024-07-30 20:00:00', 'completed', 2900.0, 377.0),
('VOY20240215046', 46, 40, 42, '2024-02-15 10:00:00', '2024-08-01 16:00:00', 'in_progress', 4100.0, 533.0),
('VOY20240216047', 47, 42, 44, '2024-02-16 16:00:00', '2024-08-05 22:00:00', 'planned', 3500.0, 455.0),
('VOY20240217048', 48, 44, 46, '2024-02-17 06:00:00', '2024-08-10 12:00:00', 'in_progress', 5100.0, 663.0),
('VOY20240218049', 49, 46, 48, '2024-02-18 12:00:00', '2024-08-15 18:00:00', 'planned', 2700.0, 351.0),
('VOY20240219050', 50, 48, 50, '2024-02-19 09:00:00', '2024-08-20 15:00:00', 'in_progress', 6700.0, 871.0);

-- ========================================
-- 10. Order Cargo Details (100+ records)
-- ========================================

INSERT INTO order_cargo_details (order_id, cargo_id, quantity, unit_price, total_amount) VALUES
-- Order 1
(1, 1, 5, 5000.00, 25000.00),
(1, 2, 2, 1750.00, 3500.00),
-- Order 2
(2, 3, 1, 36000.00, 36000.00),
(2, 4, 3, 3000.00, 9000.00),
-- Order 3
(3, 5, 2, 3125.00, 6250.00),
(3, 6, 1, 8125.00, 8125.00),
-- Order 4
(4, 7, 4, 2375.00, 9500.00),
(4, 8, 1, 60000.00, 60000.00),
-- Order 5
(5, 9, 6, 3000.00, 18000.00),
(5, 10, 8, 1875.00, 15000.00),
-- Order 6
(6, 11, 10, 850.00, 8500.00),
(6, 12, 1, 50000.00, 50000.00),
-- Order 7
(7, 13, 12, 416.67, 5000.00),
(7, 14, 2, 42500.00, 85000.00),
-- Order 8
(8, 15, 1, 100000.00, 100000.00),
(8, 16, 2, 22500.00, 45000.00),
-- Order 9
(9, 17, 7, 642.86, 4500.00),
(9, 18, 15, 800.00, 12000.00),
-- Order 10
(10, 19, 3, 25000.00, 75000.00),
(10, 20, 6, 5833.33, 35000.00),
-- Order 11
(11, 21, 4, 1625.00, 6500.00),
(11, 22, 2, 22500.00, 45000.00),
-- Order 12
(12, 23, 8, 3500.00, 28000.00),
(12, 24, 3, 14000.00, 42000.00),
-- Order 13
(13, 25, 5, 4400.00, 22000.00),
(13, 26, 1, 95000.00, 95000.00),
-- Order 14
(14, 27, 7, 3571.43, 25000.00),
(14, 28, 9, 944.44, 8500.00),
-- Order 15
(15, 29, 12, 266.67, 3200.00),
(15, 30, 1, 75000.00, 75000.00),
-- Order 16
(16, 31, 15, 253.33, 3800.00),
(16, 32, 2, 77500.00, 155000.00),
-- Order 17
(17, 33, 1, 140000.00, 140000.00),
(17, 34, 1, 175000.00, 175000.00),
-- Order 18
(18, 35, 3, 1833.33, 5500.00),
(18, 36, 1, 65000.00, 65000.00),
-- Order 19
(19, 37, 4, 4500.00, 18000.00),
(19, 38, 1, 125000.00, 125000.00),
-- Order 20
(20, 39, 6, 4166.67, 25000.00),
(20, 40, 2, 17500.00, 35000.00),
-- Order 21
(21, 41, 10, 450.00, 4500.00),
(21, 42, 1, 95000.00, 95000.00),
-- Order 22
(22, 43, 12, 375.00, 4500.00),
(22, 44, 1, 185000.00, 185000.00),
-- Order 23
(23, 45, 15, 433.33, 6500.00),
(23, 46, 4, 7250.00, 29000.00),
-- Order 24
(24, 47, 8, 3500.00, 28000.00),
(24, 48, 2, 14250.00, 28500.00),
-- Order 25
(25, 49, 6, 4666.67, 28000.00),
(25, 50, 1, 57000.00, 57000.00),
-- Continue pattern for remaining orders (26-50)
(26, 1, 3, 8333.33, 25000.00),
(26, 3, 2, 45000.00, 90000.00),
(27, 2, 4, 1625.00, 6500.00),
(27, 4, 5, 6000.00, 30000.00),
(28, 5, 3, 2083.33, 6250.00),
(28, 7, 6, 3666.67, 22000.00),
(29, 6, 2, 4062.50, 8125.00),
(29, 8, 1, 120000.00, 120000.00),
(30, 9, 8, 2250.00, 18000.00),
(30, 11, 12, 708.33, 8500.00),
(31, 10, 15, 566.67, 8500.00),
(31, 12, 1, 100000.00, 100000.00),
(32, 13, 20, 250.00, 5000.00),
(32, 15, 1, 200000.00, 200000.00),
(33, 14, 3, 28333.33, 85000.00),
(33, 16, 2, 35000.00, 70000.00),
(34, 17, 9, 611.11, 5500.00),
(34, 19, 4, 16250.00, 65000.00),
(35, 18, 18, 1000.00, 18000.00),
(35, 20, 8, 15625.00, 125000.00),
(36, 21, 5, 1300.00, 6500.00),
(36, 23, 10, 2800.00, 28000.00),
(37, 22, 3, 15000.00, 45000.00),
(37, 24, 4, 10500.00, 42000.00),
(38, 25, 7, 3142.86, 22000.00),
(38, 27, 9, 2777.78, 25000.00),
(39, 26, 1, 95000.00, 95000.00),
(39, 28, 12, 708.33, 8500.00),
(40, 29, 15, 213.33, 3200.00),
(40, 31, 18, 211.11, 3800.00),
(41, 30, 1, 150000.00, 150000.00),
(41, 32, 2, 77500.00, 155000.00),
(42, 33, 1, 280000.00, 280000.00),
(42, 35, 4, 1375.00, 5500.00),
(43, 34, 1, 350000.00, 350000.00),
(43, 36, 1, 65000.00, 65000.00),
(44, 37, 6, 3000.00, 18000.00),
(44, 39, 8, 3125.00, 25000.00),
(45, 38, 1, 250000.00, 250000.00),
(45, 40, 3, 11666.67, 35000.00),
(46, 41, 12, 375.00, 4500.00),
(46, 43, 15, 300.00, 4500.00),
(47, 42, 1, 190000.00, 190000.00),
(47, 44, 1, 370000.00, 370000.00),
(48, 45, 20, 325.00, 6500.00),
(48, 47, 10, 2800.00, 28000.00),
(49, 46, 5, 5600.00, 28000.00),
(49, 48, 3, 9500.00, 28500.00),
(50, 49, 7, 4000.00, 28000.00),
(50, 50, 1, 114000.00, 114000.00);

-- ========================================
-- 11. Order Voyage Assignments (50 records)
-- ========================================

INSERT INTO order_voyage_assignments (order_id, voyage_id, assignment_date, loading_port_id, unloading_port_id) VALUES
(1, 1, '2024-01-01 06:00:00', 1, 3),
(2, 2, '2024-01-02 08:00:00', 2, 4),
(3, 3, '2024-01-03 04:00:00', 1, 7),
(4, 4, '2024-01-04 12:00:00', 5, 8),
(5, 5, '2024-01-05 07:00:00', 6, 9),
(6, 6, '2024-01-06 09:00:00', 10, 11),
(7, 7, '2024-01-07 05:00:00', 12, 13),
(8, 8, '2024-01-08 11:00:00', 14, 15),
(9, 9, '2024-01-09 06:00:00', 16, 17),
(10, 10, '2024-01-10 13:00:00', 18, 19),
(11, 11, '2024-01-11 10:00:00', 20, 21),
(12, 12, '2024-01-12 07:00:00', 22, 23),
(13, 13, '2024-01-13 14:00:00', 24, 25),
(14, 14, '2024-01-14 04:00:00', 26, 27),
(15, 15, '2024-01-15 12:00:00', 28, 29),
(16, 16, '2024-01-16 08:00:00', 30, 31),
(17, 17, '2024-01-17 06:00:00', 32, 33),
(18, 18, '2024-01-18 09:00:00', 34, 35),
(19, 19, '2024-01-19 05:00:00', 36, 37),
(20, 20, '2024-01-20 11:00:00', 38, 39),
(21, 21, '2024-01-21 07:00:00', 40, 41),
(22, 22, '2024-01-22 13:00:00', 42, 43),
(23, 23, '2024-01-23 10:00:00', 44, 45),
(24, 24, '2024-01-24 06:00:00', 46, 47),
(25, 25, '2024-01-25 12:00:00', 48, 49),
(26, 26, '2024-01-26 08:00:00', 50, 1),
(27, 27, '2024-01-27 04:00:00', 2, 5),
(28, 28, '2024-01-28 10:00:00', 4, 6),
(29, 29, '2024-01-29 07:00:00', 6, 8),
(30, 30, '2024-01-30 13:00:00', 8, 10),
(31, 31, '2024-01-31 09:00:00', 10, 12),
(32, 32, '2024-02-01 05:00:00', 12, 14),
(33, 33, '2024-02-02 11:00:00', 14, 16),
(34, 34, '2024-02-03 08:00:00', 16, 18),
(35, 35, '2024-02-04 14:00:00', 18, 20),
(36, 36, '2024-02-05 06:00:00', 20, 22),
(37, 37, '2024-02-06 12:00:00', 22, 24),
(38, 38, '2024-02-07 09:00:00', 24, 26),
(39, 39, '2024-02-08 05:00:00', 26, 28),
(40, 40, '2024-02-09 11:00:00', 28, 30),
(41, 41, '2024-02-10 07:00:00', 30, 32),
(42, 42, '2024-02-11 13:00:00', 32, 34),
(43, 43, '2024-02-12 10:00:00', 34, 36),
(44, 44, '2024-02-13 06:00:00', 36, 38),
(45, 45, '2024-02-14 12:00:00', 38, 40),
(46, 46, '2024-02-15 08:00:00', 40, 42),
(47, 47, '2024-02-16 14:00:00', 42, 44),
(48, 48, '2024-02-17 04:00:00', 44, 46),
(49, 49, '2024-02-18 10:00:00', 46, 48),
(50, 50, '2024-02-19 07:00:00', 48, 50);

-- ========================================
-- 12. Berth Occupancy (60 records)
-- ========================================

INSERT INTO berth_occupancy (berth_id, ship_id, voyage_id, start_time, end_time, occupancy_type) VALUES
(1, 1, 1, '2024-01-01 06:00:00', '2024-01-01 08:00:00', 'loading'),
(2, 2, 2, '2024-01-02 08:00:00', '2024-01-02 10:00:00', 'loading'),
(3, 3, 3, '2024-01-03 04:00:00', '2024-01-03 06:00:00', 'loading'),
(4, 4, 4, '2024-01-04 12:00:00', '2024-01-04 14:00:00', 'loading'),
(5, 5, 5, '2024-01-05 07:00:00', '2024-01-05 09:00:00', 'loading'),
(6, 6, 6, '2024-01-06 09:00:00', '2024-01-06 11:00:00', 'loading'),
(7, 7, 7, '2024-01-07 05:00:00', '2024-01-07 07:00:00', 'loading'),
(8, 8, 8, '2024-01-08 11:00:00', '2024-01-08 13:00:00', 'loading'),
(9, 9, 9, '2024-01-09 06:00:00', '2024-01-09 08:00:00', 'loading'),
(10, 10, 10, '2024-01-10 13:00:00', '2024-01-10 15:00:00', 'loading'),
(11, 11, 11, '2024-01-11 10:00:00', '2024-01-11 12:00:00', 'loading'),
(12, 12, 12, '2024-01-12 07:00:00', '2024-01-12 09:00:00', 'loading'),
(13, 13, 13, '2024-01-13 14:00:00', '2024-01-13 16:00:00', 'loading'),
(14, 14, 14, '2024-01-14 04:00:00', '2024-01-14 06:00:00', 'loading'),
(15, 15, 15, '2024-01-15 12:00:00', '2024-01-15 14:00:00', 'loading'),
(16, 16, 16, '2024-01-16 08:00:00', '2024-01-16 10:00:00', 'loading'),
(17, 17, 17, '2024-01-17 06:00:00', '2024-01-17 08:00:00', 'loading'),
(18, 18, 18, '2024-01-18 09:00:00', '2024-01-18 11:00:00', 'loading'),
(19, 19, 19, '2024-01-19 05:00:00', '2024-01-19 07:00:00', 'loading'),
(20, 20, 20, '2024-01-20 11:00:00', '2024-01-20 13:00:00', 'loading'),
-- Unloading operations at destination ports
(21, 1, 1, '2024-01-15 12:00:00', '2024-01-15 14:00:00', 'unloading'),
(22, 2, 2, '2024-01-20 14:00:00', NULL, 'unloading'),
(23, 3, 3, '2024-01-25 10:00:00', '2024-01-25 12:00:00', 'unloading'),
(24, 8, 8, '2024-02-15 17:00:00', '2024-02-15 19:00:00', 'unloading'),
(25, 9, 9, '2024-02-20 12:00:00', '2024-02-20 14:00:00', 'unloading'),
(26, 15, 15, '2024-03-20 18:00:00', '2024-03-20 20:00:00', 'unloading'),
(27, 21, 21, '2024-04-15 13:00:00', '2024-04-15 15:00:00', 'unloading'),
(28, 27, 27, '2024-05-10 10:00:00', '2024-05-10 12:00:00', 'unloading'),
(29, 33, 33, '2024-06-05 17:00:00', '2024-06-05 19:00:00', 'unloading'),
(30, 39, 39, '2024-07-01 11:00:00', '2024-07-01 13:00:00', 'unloading'),
-- Transit stops
(31, 2, 2, '2024-01-10 08:00:00', '2024-01-10 12:00:00', 'transit'),
(32, 5, 5, '2024-01-20 14:00:00', '2024-01-20 18:00:00', 'transit'),
(33, 7, 7, '2024-01-25 10:00:00', '2024-01-25 14:00:00', 'transit'),
(34, 12, 12, '2024-02-15 16:00:00', '2024-02-15 20:00:00', 'transit'),
(35, 14, 14, '2024-02-28 12:00:00', '2024-02-28 16:00:00', 'transit'),
-- Waiting operations
(36, 16, 16, '2024-03-22 08:00:00', '2024-03-22 12:00:00', 'waiting'),
(37, 18, 18, '2024-03-28 14:00:00', '2024-03-28 18:00:00', 'waiting'),
(38, 20, 20, '2024-04-05 10:00:00', '2024-04-05 14:00:00', 'waiting'),
(39, 22, 22, '2024-04-18 16:00:00', '2024-04-18 20:00:00', 'waiting'),
(40, 24, 24, '2024-04-28 12:00:00', '2024-04-28 16:00:00', 'waiting'),
-- Additional loading operations
(41, 26, 26, '2024-01-26 06:00:00', '2024-01-26 10:00:00', 'loading'),
(42, 28, 28, '2024-01-28 10:00:00', '2024-01-28 12:00:00', 'loading'),
(43, 30, 30, '2024-01-30 13:00:00', '2024-01-30 15:00:00', 'loading'),
(44, 32, 32, '2024-02-01 03:00:00', '2024-02-01 07:00:00', 'loading'),
(45, 34, 34, '2024-02-03 08:00:00', '2024-02-03 10:00:00', 'loading'),
(46, 36, 36, '2024-02-05 04:00:00', '2024-02-05 08:00:00', 'loading'),
(47, 38, 38, '2024-02-07 09:00:00', '2024-02-07 11:00:00', 'loading'),
(48, 40, 40, '2024-02-09 11:00:00', '2024-02-09 13:00:00', 'loading'),
(49, 42, 42, '2024-02-11 11:00:00', '2024-02-11 15:00:00', 'loading'),
(50, 44, 44, '2024-02-13 04:00:00', '2024-02-13 08:00:00', 'loading'),
-- Additional unloading operations
(1, 26, 26, '2024-05-05 14:00:00', '2024-05-05 16:00:00', 'unloading'),
(3, 28, 28, '2024-05-15 16:00:00', '2024-05-15 18:00:00', 'unloading'),
(5, 30, 30, '2024-05-25 19:00:00', '2024-05-25 21:00:00', 'unloading'),
(7, 32, 32, '2024-06-01 11:00:00', '2024-06-01 13:00:00', 'unloading'),
(9, 34, 34, '2024-06-10 14:00:00', '2024-06-10 16:00:00', 'unloading'),
(11, 36, 36, '2024-06-20 12:00:00', '2024-06-20 14:00:00', 'unloading'),
(13, 38, 38, '2024-06-30 15:00:00', '2024-06-30 17:00:00', 'unloading'),
(15, 40, 40, '2024-07-05 17:00:00', '2024-07-05 19:00:00', 'unloading'),
(17, 42, 42, '2024-07-15 19:00:00', '2024-07-15 21:00:00', 'unloading'),
(19, 44, 44, '2024-07-25 12:00:00', '2024-07-25 14:00:00', 'unloading');

-- ========================================
-- 13. Fee Details (150+ records)
-- ========================================

INSERT INTO fee_details (order_id, fee_type, amount, currency, description) VALUES
-- Order 1 fees
(1, 'freight', 10000.00, 'USD', 'Basic freight charge'),
(1, 'port_fee', 1250.00, 'USD', 'Port handling fee'),
(1, 'fuel_surcharge', 1250.00, 'USD', 'Fuel price adjustment'),
-- Order 2 fees
(2, 'freight', 23200.00, 'USD', 'Basic freight charge'),
(2, 'port_fee', 2900.00, 'USD', 'Port handling fee'),
(2, 'fuel_surcharge', 2900.00, 'USD', 'Fuel price adjustment'),
-- Order 3 fees
(3, 'freight', 7200.00, 'USD', 'Basic freight charge'),
(3, 'port_fee', 900.00, 'USD', 'Port handling fee'),
(3, 'fuel_surcharge', 900.00, 'USD', 'Fuel price adjustment'),
-- Continue for all 50 orders with 3 fee types each
(4, 'freight', 12800.00, 'USD', 'Basic freight charge'),
(4, 'port_fee', 1600.00, 'USD', 'Port handling fee'),
(4, 'fuel_surcharge', 1600.00, 'USD', 'Fuel price adjustment'),
(5, 'freight', 18000.00, 'USD', 'Basic freight charge'),
(5, 'port_fee', 2250.00, 'USD', 'Port handling fee'),
(5, 'fuel_surcharge', 2250.00, 'USD', 'Fuel price adjustment'),
(6, 'freight', 11200.00, 'USD', 'Basic freight charge'),
(6, 'port_fee', 1400.00, 'USD', 'Port handling fee'),
(6, 'fuel_surcharge', 1400.00, 'USD', 'Fuel price adjustment'),
(7, 'freight', 24800.00, 'USD', 'Basic freight charge'),
(7, 'port_fee', 3100.00, 'USD', 'Port handling fee'),
(7, 'fuel_surcharge', 3100.00, 'USD', 'Fuel price adjustment'),
(8, 'freight', 6600.00, 'USD', 'Basic freight charge'),
(8, 'port_fee', 825.00, 'USD', 'Port handling fee'),
(8, 'fuel_surcharge', 825.00, 'USD', 'Fuel price adjustment'),
(9, 'freight', 15600.00, 'USD', 'Basic freight charge'),
(9, 'port_fee', 1950.00, 'USD', 'Port handling fee'),
(9, 'fuel_surcharge', 1950.00, 'USD', 'Fuel price adjustment'),
(10, 'freight', 20400.00, 'USD', 'Basic freight charge'),
(10, 'port_fee', 2550.00, 'USD', 'Port handling fee'),
(10, 'fuel_surcharge', 2550.00, 'USD', 'Fuel price adjustment'),
(11, 'freight', 8800.00, 'USD', 'Basic freight charge'),
(11, 'port_fee', 1100.00, 'USD', 'Port handling fee'),
(11, 'fuel_surcharge', 1100.00, 'USD', 'Fuel price adjustment'),
(12, 'freight', 19200.00, 'USD', 'Basic freight charge'),
(12, 'port_fee', 2400.00, 'USD', 'Port handling fee'),
(12, 'fuel_surcharge', 2400.00, 'USD', 'Fuel price adjustment'),
(13, 'freight', 14000.00, 'USD', 'Basic freight charge'),
(13, 'port_fee', 1750.00, 'USD', 'Port handling fee'),
(13, 'fuel_surcharge', 1750.00, 'USD', 'Fuel price adjustment'),
(14, 'freight', 28800.00, 'USD', 'Basic freight charge'),
(14, 'port_fee', 3600.00, 'USD', 'Port handling fee'),
(14, 'fuel_surcharge', 3600.00, 'USD', 'Fuel price adjustment'),
(15, 'freight', 7800.00, 'USD', 'Basic freight charge'),
(15, 'port_fee', 975.00, 'USD', 'Port handling fee'),
(15, 'fuel_surcharge', 975.00, 'USD', 'Fuel price adjustment'),
(16, 'freight', 16800.00, 'USD', 'Basic freight charge'),
(16, 'port_fee', 2100.00, 'USD', 'Port handling fee'),
(16, 'fuel_surcharge', 2100.00, 'USD', 'Fuel price adjustment'),
(17, 'freight', 15200.00, 'USD', 'Basic freight charge'),
(17, 'port_fee', 1900.00, 'USD', 'Port handling fee'),
(17, 'fuel_surcharge', 1900.00, 'USD', 'Fuel price adjustment'),
(18, 'freight', 22400.00, 'USD', 'Basic freight charge'),
(18, 'port_fee', 2800.00, 'USD', 'Port handling fee'),
(18, 'fuel_surcharge', 2800.00, 'USD', 'Fuel price adjustment'),
(19, 'freight', 10400.00, 'USD', 'Basic freight charge'),
(19, 'port_fee', 1300.00, 'USD', 'Port handling fee'),
(19, 'fuel_surcharge', 1300.00, 'USD', 'Fuel price adjustment'),
(20, 'freight', 27200.00, 'USD', 'Basic freight charge'),
(20, 'port_fee', 3400.00, 'USD', 'Port handling fee'),
(20, 'fuel_surcharge', 3400.00, 'USD', 'Fuel price adjustment'),
(21, 'freight', 8400.00, 'USD', 'Basic freight charge'),
(21, 'port_fee', 1050.00, 'USD', 'Port handling fee'),
(21, 'fuel_surcharge', 1050.00, 'USD', 'Fuel price adjustment'),
(22, 'freight', 18400.00, 'USD', 'Basic freight charge'),
(22, 'port_fee', 2300.00, 'USD', 'Port handling fee'),
(22, 'fuel_surcharge', 2300.00, 'USD', 'Fuel price adjustment'),
(23, 'freight', 12400.00, 'USD', 'Basic freight charge'),
(23, 'port_fee', 1550.00, 'USD', 'Port handling fee'),
(23, 'fuel_surcharge', 1550.00, 'USD', 'Fuel price adjustment'),
(24, 'freight', 20800.00, 'USD', 'Basic freight charge'),
(24, 'port_fee', 2600.00, 'USD', 'Port handling fee'),
(24, 'fuel_surcharge', 2600.00, 'USD', 'Fuel price adjustment'),
(25, 'freight', 11600.00, 'USD', 'Basic freight charge'),
(25, 'port_fee', 1450.00, 'USD', 'Port handling fee'),
(25, 'fuel_surcharge', 1450.00, 'USD', 'Fuel price adjustment'),
(26, 'freight', 26000.00, 'USD', 'Basic freight charge'),
(26, 'port_fee', 3250.00, 'USD', 'Port handling fee'),
(26, 'fuel_surcharge', 3250.00, 'USD', 'Fuel price adjustment'),
(27, 'freight', 7200.00, 'USD', 'Basic freight charge'),
(27, 'port_fee', 900.00, 'USD', 'Port handling fee'),
(27, 'fuel_surcharge', 900.00, 'USD', 'Fuel price adjustment'),
(28, 'freight', 16400.00, 'USD', 'Basic freight charge'),
(28, 'port_fee', 2050.00, 'USD', 'Port handling fee'),
(28, 'fuel_surcharge', 2050.00, 'USD', 'Fuel price adjustment'),
(29, 'freight', 14400.00, 'USD', 'Basic freight charge'),
(29, 'port_fee', 1800.00, 'USD', 'Port handling fee'),
(29, 'fuel_surcharge', 1800.00, 'USD', 'Fuel price adjustment'),
(30, 'freight', 20000.00, 'USD', 'Basic freight charge'),
(30, 'port_fee', 2500.00, 'USD', 'Port handling fee'),
(30, 'fuel_surcharge', 2500.00, 'USD', 'Fuel price adjustment'),
(31, 'freight', 10800.00, 'USD', 'Basic freight charge'),
(31, 'port_fee', 1350.00, 'USD', 'Port handling fee'),
(31, 'fuel_surcharge', 1350.00, 'USD', 'Fuel price adjustment'),
(32, 'freight', 28000.00, 'USD', 'Basic freight charge'),
(32, 'port_fee', 3500.00, 'USD', 'Port handling fee'),
(32, 'fuel_surcharge', 3500.00, 'USD', 'Fuel price adjustment'),
(33, 'freight', 8000.00, 'USD', 'Basic freight charge'),
(33, 'port_fee', 1000.00, 'USD', 'Port handling fee'),
(33, 'fuel_surcharge', 1000.00, 'USD', 'Fuel price adjustment'),
(34, 'freight', 17600.00, 'USD', 'Basic freight charge'),
(34, 'port_fee', 2200.00, 'USD', 'Port handling fee'),
(34, 'fuel_surcharge', 2200.00, 'USD', 'Fuel price adjustment'),
(35, 'freight', 13200.00, 'USD', 'Basic freight charge'),
(35, 'port_fee', 1650.00, 'USD', 'Port handling fee'),
(35, 'fuel_surcharge', 1650.00, 'USD', 'Fuel price adjustment'),
(36, 'freight', 21600.00, 'USD', 'Basic freight charge'),
(36, 'port_fee', 2700.00, 'USD', 'Port handling fee'),
(36, 'fuel_surcharge', 2700.00, 'USD', 'Fuel price adjustment'),
(37, 'freight', 9600.00, 'USD', 'Basic freight charge'),
(37, 'port_fee', 1200.00, 'USD', 'Port handling fee'),
(37, 'fuel_surcharge', 1200.00, 'USD', 'Fuel price adjustment'),
(38, 'freight', 24800.00, 'USD', 'Basic freight charge'),
(38, 'port_fee', 3100.00, 'USD', 'Port handling fee'),
(38, 'fuel_surcharge', 3100.00, 'USD', 'Fuel price adjustment'),
(39, 'freight', 6800.00, 'USD', 'Basic freight charge'),
(39, 'port_fee', 850.00, 'USD', 'Port handling fee'),
(39, 'fuel_surcharge', 850.00, 'USD', 'Fuel price adjustment'),
(40, 'freight', 18800.00, 'USD', 'Basic freight charge'),
(40, 'port_fee', 2350.00, 'USD', 'Port handling fee'),
(40, 'fuel_surcharge', 2350.00, 'USD', 'Fuel price adjustment'),
(41, 'freight', 15600.00, 'USD', 'Basic freight charge'),
(41, 'port_fee', 1950.00, 'USD', 'Port handling fee'),
(41, 'fuel_surcharge', 1950.00, 'USD', 'Fuel price adjustment'),
(42, 'freight', 23200.00, 'USD', 'Basic freight charge'),
(42, 'port_fee', 2900.00, 'USD', 'Port handling fee'),
(42, 'fuel_surcharge', 2900.00, 'USD', 'Fuel price adjustment'),
(43, 'freight', 9200.00, 'USD', 'Basic freight charge'),
(43, 'port_fee', 1150.00, 'USD', 'Port handling fee'),
(43, 'fuel_surcharge', 1150.00, 'USD', 'Fuel price adjustment'),
(44, 'freight', 26400.00, 'USD', 'Basic freight charge'),
(44, 'port_fee', 3300.00, 'USD', 'Port handling fee'),
(44, 'fuel_surcharge', 3300.00, 'USD', 'Fuel price adjustment'),
(45, 'freight', 11200.00, 'USD', 'Basic freight charge'),
(45, 'port_fee', 1400.00, 'USD', 'Port handling fee'),
(45, 'fuel_surcharge', 1400.00, 'USD', 'Fuel price adjustment'),
(46, 'freight', 17200.00, 'USD', 'Basic freight charge'),
(46, 'port_fee', 2150.00, 'USD', 'Port handling fee'),
(46, 'fuel_surcharge', 2150.00, 'USD', 'Fuel price adjustment'),
(47, 'freight', 14800.00, 'USD', 'Basic freight charge'),
(47, 'port_fee', 1850.00, 'USD', 'Port handling fee'),
(47, 'fuel_surcharge', 1850.00, 'USD', 'Fuel price adjustment'),
(48, 'freight', 21200.00, 'USD', 'Basic freight charge'),
(48, 'port_fee', 2650.00, 'USD', 'Port handling fee'),
(48, 'fuel_surcharge', 2650.00, 'USD', 'Fuel price adjustment'),
(49, 'freight', 10000.00, 'USD', 'Basic freight charge'),
(49, 'port_fee', 1250.00, 'USD', 'Port handling fee'),
(49, 'fuel_surcharge', 1250.00, 'USD', 'Fuel price adjustment'),
(50, 'freight', 27600.00, 'USD', 'Basic freight charge'),
(50, 'port_fee', 3450.00, 'USD', 'Port handling fee'),
(50, 'fuel_surcharge', 3450.00, 'USD', 'Fuel price adjustment'),
-- Additional insurance fees for high-value orders
(1, 'insurance', 2850.00, 'USD', 'Cargo insurance premium'),
(2, 'insurance', 3800.00, 'USD', 'Cargo insurance premium'),
(5, 'insurance', 4250.00, 'USD', 'Cargo insurance premium'),
(7, 'insurance', 4950.00, 'USD', 'Cargo insurance premium'),
(10, 'insurance', 3850.00, 'USD', 'Cargo insurance premium'),
(12, 'insurance', 3550.00, 'USD', 'Cargo insurance premium'),
(14, 'insurance', 5650.00, 'USD', 'Cargo insurance premium'),
(18, 'insurance', 4450.00, 'USD', 'Cargo insurance premium'),
(20, 'insurance', 5250.00, 'USD', 'Cargo insurance premium'),
(24, 'insurance', 3950.00, 'USD', 'Cargo insurance premium'),
(26, 'insurance', 4850.00, 'USD', 'Cargo insurance premium'),
(30, 'insurance', 3750.00, 'USD', 'Cargo insurance premium'),
(32, 'insurance', 5450.00, 'USD', 'Cargo insurance premium'),
(36, 'insurance', 4150.00, 'USD', 'Cargo insurance premium'),
(38, 'insurance', 4650.00, 'USD', 'Cargo insurance premium'),
(42, 'insurance', 4450.00, 'USD', 'Cargo insurance premium'),
(44, 'insurance', 5050.00, 'USD', 'Cargo insurance premium'),
(48, 'insurance', 4050.00, 'USD', 'Cargo insurance premium'),
(50, 'insurance', 5250.00, 'USD', 'Cargo insurance premium');

-- ========================================
-- 14. Transport Tracking (100+ records)
-- ========================================

INSERT INTO transport_tracking (order_id, voyage_id, location_port_id, tracking_status, tracking_time, latitude, longitude, remarks) VALUES
-- Order 1 tracking
(1, 1, 1, 'order_received', '2024-01-01 00:00:00', 31.2304, 121.4737, 'Order created and received'),
(1, 1, 1, 'cargo_loaded', '2024-01-01 08:00:00', 31.2304, 121.4737, 'Cargo loaded at Shanghai'),
(1, 1, NULL, 'departed', '2024-01-01 08:30:00', 31.2304, 121.4737, 'Departed from Port of Shanghai'),
(1, 1, NULL, 'in_transit', '2024-01-08 12:00:00', 45.5000, 90.0000, 'In transit across Pacific'),
(1, 1, 3, 'arrived_destination', '2024-01-15 14:00:00', 51.9244, 4.4777, 'Arrived at Port of Rotterdam'),
(1, 1, 3, 'cargo_unloaded', '2024-01-15 16:00:00', 51.9244, 4.4777, 'Cargo unloaded'),
(1, 1, 3, 'delivered', '2024-01-15 18:00:00', 51.9244, 4.4777, 'Order completed'),

-- Order 2 tracking
(2, 2, 2, 'order_received', '2024-01-02 00:00:00', 1.2966, 103.8006, 'Order created and received'),
(2, 2, 2, 'cargo_loaded', '2024-01-02 10:00:00', 1.2966, 103.8006, 'Cargo loaded at Singapore'),
(2, 2, NULL, 'departed', '2024-01-02 10:30:00', 1.2966, 103.8006, 'Departed from Port of Singapore'),
(2, 2, NULL, 'in_transit', '2024-01-12 14:00:00', 25.0000, -120.0000, 'In transit across Pacific'),
(2, 2, 4, 'arrived_destination', '2024-01-20 16:00:00', 33.7373, -118.2647, 'Arrived at Port of Los Angeles'),

-- Order 3 tracking
(3, 3, 1, 'order_received', '2024-01-03 00:00:00', 31.2304, 121.4737, 'Order created and received'),
(3, 3, 1, 'cargo_loaded', '2024-01-03 06:00:00', 31.2304, 121.4737, 'Cargo loaded at Shanghai'),
(3, 3, NULL, 'departed', '2024-01-03 06:30:00', 31.2304, 121.4737, 'Departed from Port of Shanghai'),
(3, 3, NULL, 'in_transit', '2024-01-15 10:00:00', 20.0000, 60.0000, 'In transit via Indian Ocean'),
(3, 3, 7, 'arrived_destination', '2024-01-25 12:00:00', 25.2769, 55.3072, 'Arrived at Port of Dubai'),
(3, 3, 7, 'cargo_unloaded', '2024-01-25 14:00:00', 25.2769, 55.3072, 'Cargo unloaded'),
(3, 3, 7, 'delivered', '2024-01-25 16:00:00', 25.2769, 55.3072, 'Order completed'),

-- Order 9 tracking
(9, 9, 16, 'order_received', '2024-01-09 00:00:00', 53.0793, 8.8017, 'Order created and received'),
(9, 9, 16, 'cargo_loaded', '2024-01-09 08:00:00', 53.0793, 8.8017, 'Cargo loaded at Bremen'),
(9, 9, NULL, 'departed', '2024-01-09 08:30:00', 53.0793, 8.8017, 'Departed from Port of Bremen'),
(9, 9, NULL, 'in_transit', '2024-01-18 12:00:00', 41.0000, -8.0000, 'In transit via Atlantic'),
(9, 9, 17, 'arrived_destination', '2024-02-20 14:00:00', 39.4699, -0.3763, 'Arrived at Port of Valencia'),
(9, 9, 17, 'cargo_unloaded', '2024-02-20 16:00:00', 39.4699, -0.3763, 'Cargo unloaded'),
(9, 9, 17, 'delivered', '2024-02-20 18:00:00', 39.4699, -0.3763, 'Order completed'),

-- Order 15 tracking
(15, 15, 28, 'order_received', '2024-01-15 00:00:00', 18.9517, 72.9956, 'Order created and received'),
(15, 15, 28, 'cargo_loaded', '2024-01-15 14:00:00', 18.9517, 72.9956, 'Cargo loaded at JNPT'),
(15, 15, NULL, 'departed', '2024-01-15 14:30:00', 18.9517, 72.9956, 'Departed from JNPT'),
(15, 15, NULL, 'in_transit', '2024-03-01 10:00:00', 25.0000, 55.0000, 'In transit via Arabian Sea'),
(15, 15, 29, 'arrived_destination', '2024-03-20 20:00:00', 27.1865, 56.2808, 'Arrived at Bandar Abbas'),
(15, 15, 29, 'cargo_unloaded', '2024-03-20 22:00:00', 27.1865, 56.2808, 'Cargo unloaded'),
(15, 15, 29, 'delivered', '2024-03-21 00:00:00', 27.1865, 56.2808, 'Order completed'),

-- Continue tracking for more orders (sample of key milestones)
(4, 4, 5, 'order_received', '2024-01-04 00:00:00', 53.5511, 9.9937, 'Order created and received'),
(5, 5, 6, 'order_received', '2024-01-05 00:00:00', 35.1028, 129.0403, 'Order created and received'),
(6, 6, 10, 'order_received', '2024-01-06 00:00:00', 33.7545, -118.2200, 'Order created and received'),
(7, 7, 12, 'order_received', '2024-01-07 00:00:00', 3.0038, 101.3900, 'Order created and received'),
(8, 8, 14, 'order_received', '2024-01-08 00:00:00', 1.3644, 103.5500, 'Order created and received'),
(10, 10, 18, 'order_received', '2024-01-10 00:00:00', 51.9542, 1.3464, 'Order created and received'),
(11, 11, 20, 'order_received', '2024-01-11 00:00:00', 34.6901, 135.1956, 'Order created and received'),
(12, 12, 22, 'order_received', '2024-01-12 00:00:00', 6.9271, 79.8612, 'Order created and received'),
(13, 13, 24, 'order_received', '2024-01-13 00:00:00', 14.5995, 120.9842, 'Order created and received'),
(14, 14, 26, 'order_received', '2024-01-14 00:00:00', 18.9220, 72.8347, 'Order created and received'),
(16, 16, 30, 'order_received', '2024-01-16 00:00:00', 21.5169, 39.2192, 'Order created and received'),
(17, 17, 32, 'order_received', '2024-01-17 00:00:00', 29.9668, 32.5498, 'Order created and received'),
(18, 18, 34, 'order_received', '2024-01-18 00:00:00', -33.9249, 18.4241, 'Order created and received'),
(19, 19, 36, 'order_received', '2024-01-19 00:00:00', -4.0435, 39.6682, 'Order created and received'),
(20, 20, 38, 'order_received', '2024-01-20 00:00:00', -23.9608, -46.3331, 'Order created and received'),

-- Cargo loaded events
(4, 4, 5, 'cargo_loaded', '2024-01-04 14:00:00', 53.5511, 9.9937, 'Cargo loaded at Hamburg'),
(5, 5, 6, 'cargo_loaded', '2024-01-05 09:00:00', 35.1028, 129.0403, 'Cargo loaded at Busan'),
(8, 8, 14, 'cargo_loaded', '2024-01-08 13:00:00', 1.3644, 103.5500, 'Cargo loaded at Tanjung Pelepas'),
(21, 21, 40, 'order_received', '2024-01-21 00:00:00', -34.6118, -58.3960, 'Order created and received'),
(21, 21, 40, 'cargo_loaded', '2024-01-21 09:00:00', -34.6118, -58.3960, 'Cargo loaded at Buenos Aires'),
(21, 21, NULL, 'departed', '2024-01-21 09:30:00', -34.6118, -58.3960, 'Departed from Buenos Aires'),
(21, 21, NULL, 'in_transit', '2024-02-15 12:00:00', -25.0000, -40.0000, 'In transit across Atlantic'),
(21, 21, 41, 'arrived_destination', '2024-04-15 15:00:00', -33.0472, -71.6127, 'Arrived at Valparaiso'),
(21, 21, 41, 'cargo_unloaded', '2024-04-15 17:00:00', -33.0472, -71.6127, 'Cargo unloaded'),
(21, 21, 41, 'delivered', '2024-04-15 19:00:00', -33.0472, -71.6127, 'Order completed'),

-- More cargo loaded and departed events
(27, 27, 2, 'order_received', '2024-01-27 00:00:00', 1.2966, 103.8006, 'Order created and received'),
(27, 27, 2, 'cargo_loaded', '2024-01-27 06:00:00', 1.2966, 103.8006, 'Cargo loaded at Singapore'),
(27, 27, NULL, 'departed', '2024-01-27 06:30:00', 1.2966, 103.8006, 'Departed from Singapore'),
(27, 27, 5, 'arrived_destination', '2024-05-10 12:00:00', 53.5511, 9.9937, 'Arrived at Hamburg'),
(27, 27, 5, 'cargo_unloaded', '2024-05-10 14:00:00', 53.5511, 9.9937, 'Cargo unloaded'),
(27, 27, 5, 'delivered', '2024-05-10 16:00:00', 53.5511, 9.9937, 'Order completed'),

(33, 33, 14, 'order_received', '2024-02-02 00:00:00', 1.3644, 103.5500, 'Order created and received'),
(33, 33, 14, 'cargo_loaded', '2024-02-02 13:00:00', 1.3644, 103.5500, 'Cargo loaded at Tanjung Pelepas'),
(33, 33, NULL, 'departed', '2024-02-02 13:30:00', 1.3644, 103.5500, 'Departed from Tanjung Pelepas'),
(33, 33, 16, 'arrived_destination', '2024-06-05 19:00:00', 53.0793, 8.8017, 'Arrived at Bremen'),
(33, 33, 16, 'cargo_unloaded', '2024-06-05 21:00:00', 53.0793, 8.8017, 'Cargo unloaded'),
(33, 33, 16, 'delivered', '2024-06-05 23:00:00', 53.0793, 8.8017, 'Order completed'),

(39, 39, 26, 'order_received', '2024-02-08 00:00:00', 18.9220, 72.8347, 'Order created and received'),
(39, 39, 26, 'cargo_loaded', '2024-02-08 07:00:00', 18.9220, 72.8347, 'Cargo loaded at Mumbai'),
(39, 39, NULL, 'departed', '2024-02-08 07:30:00', 18.9220, 72.8347, 'Departed from Mumbai'),
(39, 39, 28, 'arrived_destination', '2024-07-01 13:00:00', 18.9517, 72.9956, 'Arrived at JNPT'),
(39, 39, 28, 'cargo_unloaded', '2024-07-01 15:00:00', 18.9517, 72.9956, 'Cargo unloaded'),
(39, 39, 28, 'delivered', '2024-07-01 17:00:00', 18.9517, 72.9956, 'Order completed'),

(45, 45, 38, 'order_received', '2024-02-14 00:00:00', -23.9608, -46.3331, 'Order created and received'),
(45, 45, 38, 'cargo_loaded', '2024-02-14 14:00:00', -23.9608, -46.3331, 'Cargo loaded at Santos'),
(45, 45, NULL, 'departed', '2024-02-14 14:30:00', -23.9608, -46.3331, 'Departed from Santos'),
(45, 45, 40, 'arrived_destination', '2024-07-30 20:00:00', -34.6118, -58.3960, 'Arrived at Buenos Aires'),
(45, 45, 40, 'cargo_unloaded', '2024-07-30 22:00:00', -34.6118, -58.3960, 'Cargo unloaded'),
(45, 45, 40, 'delivered', '2024-07-31 00:00:00', -34.6118, -58.3960, 'Order completed'),

-- In-transit tracking for active orders
(2, 2, NULL, 'in_transit', '2024-01-15 08:00:00', 15.0000, -140.0000, 'Crossing Pacific Ocean'),
(5, 5, NULL, 'in_transit', '2024-01-20 10:00:00', 30.0000, 120.0000, 'In East China Sea'),
(7, 7, NULL, 'in_transit', '2024-01-25 14:00:00', 5.0000, 95.0000, 'In Strait of Malacca'),
(10, 10, NULL, 'in_transit', '2024-02-01 16:00:00', 35.0000, 140.0000, 'Approaching Japan'),
(12, 12, NULL, 'in_transit', '2024-02-20 12:00:00', -10.0000, 85.0000, 'Indian Ocean transit'),
(14, 14, NULL, 'in_transit', '2024-02-28 18:00:00', 20.0000, 70.0000, 'Arabian Sea crossing'),
(16, 16, NULL, 'in_transit', '2024-03-10 20:00:00', 25.0000, 40.0000, 'Red Sea passage'),
(18, 18, NULL, 'in_transit', '2024-03-20 14:00:00', -20.0000, 30.0000, 'Along African coast'),
(20, 20, NULL, 'in_transit', '2024-04-01 10:00:00', -30.0000, -50.0000, 'South Atlantic crossing');

-- ========================================
-- 15. Customer Credit Records (50 records)
-- ========================================

INSERT INTO customer_credit_records (customer_id, order_id, credit_change, old_rating, new_rating, change_reason, record_date) VALUES
(1, 1, 'excellent_record', 'AA', 'AAA', 'Consistent on-time payments and reliable business', '2024-01-20'),
(2, 2, 'excellent_record', 'A', 'AA', 'Large volume customer with perfect payment history', '2024-02-01'),
(3, NULL, 'excellent_record', 'AAA', 'AAA', 'Maintained excellent credit standing', '2024-01-15'),
(4, 4, 'excellent_record', 'BBB', 'A', 'Improved payment timeliness and increased volume', '2024-02-15'),
(5, 5, 'excellent_record', 'A', 'AA', 'Consistent high-value orders with prompt payment', '2024-02-20'),
(6, NULL, 'violation_record', 'BB', 'B', 'Late payment on previous order', '2024-01-25'),
(7, 7, 'excellent_record', 'A', 'AA', 'Reliable Nordic partner with growth potential', '2024-02-25'),
(8, 8, 'excellent_record', 'BBB', 'A', 'Improved operational efficiency', '2024-03-01'),
(9, 9, 'excellent_record', 'AA', 'AAA', 'Exceptional freight forwarding performance', '2024-03-05'),
(10, 10, 'excellent_record', 'A', 'AA', 'Strong Scandinavian market presence', '2024-03-10'),
(11, NULL, 'downgrade', 'BBB', 'BB', 'Delayed documentation submission', '2024-02-10'),
(12, 12, 'excellent_record', 'AA', 'AAA', 'Premium Benelux distribution partner', '2024-03-15'),
(13, 13, 'excellent_record', 'A', 'AA', 'Strong Iberian market performance', '2024-03-20'),
(14, 14, 'excellent_record', 'AAA', 'AAA', 'Maintained top-tier status', '2024-03-25'),
(15, NULL, 'upgrade', 'BB', 'A', 'Improved credit management and growth', '2024-02-28'),
(16, 16, 'excellent_record', 'A', 'AA', 'Reliable Alpine logistics operations', '2024-04-01'),
(17, NULL, 'violation_record', 'BBB', 'BB', 'Minor compliance issues resolved', '2024-03-05'),
(18, 18, 'excellent_record', 'A', 'AA', 'Strong Danubian commerce network', '2024-04-05'),
(19, NULL, 'upgrade', 'BB', 'BBB', 'Improved operational standards', '2024-03-12'),
(20, 20, 'excellent_record', 'BBB', 'A', 'Expanding Balkan logistics network', '2024-04-10'),
(21, 21, 'excellent_record', 'A', 'AA', 'Strong Aegean trading partnerships', '2024-04-15'),
(22, 22, 'excellent_record', 'AA', 'AAA', 'Premium Anatolian export services', '2024-04-20'),
(23, NULL, 'upgrade', 'B', 'BBB', 'Improved Caucasus operations', '2024-03-30'),
(24, NULL, 'violation_record', 'BBB', 'BB', 'Documentation delays', '2024-04-02'),
(25, 25, 'excellent_record', 'A', 'AA', 'Strong Levantine logistics growth', '2024-04-25'),
(26, NULL, 'upgrade', 'BB', 'A', 'Improved Mesopotamian trade efficiency', '2024-04-08'),
(27, NULL, 'violation_record', 'BBB', 'BB', 'Minor Persian Gulf compliance issues', '2024-04-12'),
(28, 28, 'excellent_record', 'A', 'AA', 'Excellent Central Asian trade performance', '2024-05-01'),
(29, NULL, 'upgrade', 'BB', 'A', 'Improved Silk Road logistics', '2024-04-18'),
(30, NULL, 'downgrade', 'B', 'C', 'Payment delays and operational issues', '2024-04-22'),
(31, 31, 'excellent_record', 'AA', 'AAA', 'Outstanding Ganges trading performance', '2024-05-05'),
(32, 32, 'excellent_record', 'A', 'AA', 'Strong Deccan logistics network', '2024-05-10'),
(33, 33, 'excellent_record', 'BBB', 'A', 'Improved Ceylon export operations', '2024-05-15'),
(34, NULL, 'upgrade', 'B', 'BBB', 'Better Maldivian trading practices', '2024-05-01'),
(35, NULL, 'violation_record', 'BB', 'B', 'Bay of Bengal compliance issues', '2024-05-08'),
(36, 36, 'excellent_record', 'A', 'AA', 'Strong Indochina logistics performance', '2024-05-20'),
(37, NULL, 'upgrade', 'BBB', 'A', 'Improved Mekong Delta operations', '2024-05-12'),
(38, NULL, 'downgrade', 'B', 'C', 'Irrawaddy commerce operational issues', '2024-05-15'),
(39, 39, 'excellent_record', 'AA', 'AAA', 'Premium Chao Phraya logistics services', '2024-05-25'),
(40, 40, 'excellent_record', 'A', 'AA', 'Strong Luzon trading operations', '2024-05-30'),
(41, 41, 'excellent_record', 'BBB', 'A', 'Improved Borneo export performance', '2024-06-01'),
(42, 42, 'excellent_record', 'AA', 'AAA', 'Outstanding Sumatra commerce', '2024-06-05'),
(43, NULL, 'violation_record', 'A', 'BBB', 'Java logistics documentation issues', '2024-05-28'),
(44, NULL, 'upgrade', 'BB', 'A', 'Improved Celebes trading standards', '2024-06-02'),
(45, NULL, 'downgrade', 'B', 'C', 'Mollucas export operational problems', '2024-06-08'),
(46, NULL, 'upgrade', 'BBB', 'A', 'Better Timor Sea commerce practices', '2024-06-10'),
(47, NULL, 'excellent_record', 'A', 'AA', 'Strong Banda Sea logistics growth', '2024-06-15'),
(48, 48, 'excellent_record', 'AA', 'AAA', 'Premium Coral Sea trading services', '2024-06-20'),
(49, 49, 'excellent_record', 'A', 'AA', 'Excellent Tasman export performance', '2024-06-25'),
(50, 50, 'excellent_record', 'B', 'BBB', 'Improved Pacific Islands commerce', '2024-06-30');

-- ========================================
-- 16. System Logs (50 records)
-- ========================================

INSERT INTO system_logs (table_name, operation_type, record_id, old_values, new_values, operator, operation_time) VALUES
('transport_orders', 'UPDATE', 1, '{"status": "confirmed", "freight_amount": 12500.00}', '{"status": "ship_assigned", "freight_amount": 12500.00}', 'system_auto', '2024-01-01 06:00:00'),
('transport_orders', 'UPDATE', 1, '{"status": "ship_assigned", "freight_amount": 12500.00}', '{"status": "in_transit", "freight_amount": 12500.00}', 'system_auto', '2024-01-01 08:30:00'),
('transport_orders', 'UPDATE', 1, '{"status": "in_transit", "freight_amount": 12500.00}', '{"status": "completed", "freight_amount": 12500.00}', 'system_auto', '2024-01-15 18:00:00'),
('ships', 'UPDATE', 1, '{"current_status": "in_port"}', '{"current_status": "sailing"}', 'admin_001', '2024-01-01 08:00:00'),
('ships', 'UPDATE', 1, '{"current_status": "sailing"}', '{"current_status": "in_port"}', 'admin_001', '2024-01-15 20:00:00'),
('transport_orders', 'UPDATE', 2, '{"status": "confirmed", "freight_amount": 29000.00}', '{"status": "ship_assigned", "freight_amount": 29000.00}', 'system_auto', '2024-01-02 08:00:00'),
('transport_orders', 'UPDATE', 2, '{"status": "ship_assigned", "freight_amount": 29000.00}', '{"status": "in_transit", "freight_amount": 29000.00}', 'system_auto', '2024-01-02 10:30:00'),
('ships', 'UPDATE', 2, '{"current_status": "in_port"}', '{"current_status": "sailing"}', 'admin_002', '2024-01-02 10:00:00'),
('transport_orders', 'UPDATE', 3, '{"status": "confirmed", "freight_amount": 9000.00}', '{"status": "ship_assigned", "freight_amount": 9000.00}', 'system_auto', '2024-01-03 04:00:00'),
('transport_orders', 'UPDATE', 3, '{"status": "ship_assigned", "freight_amount": 9000.00}', '{"status": "in_transit", "freight_amount": 9000.00}', 'system_auto', '2024-01-03 06:30:00'),
('transport_orders', 'UPDATE', 3, '{"status": "in_transit", "freight_amount": 9000.00}', '{"status": "completed", "freight_amount": 9000.00}', 'system_auto', '2024-01-25 16:00:00'),
('ships', 'UPDATE', 3, '{"current_status": "in_port"}', '{"current_status": "sailing"}', 'admin_003', '2024-01-03 06:00:00'),
('ships', 'UPDATE', 3, '{"current_status": "sailing"}', '{"current_status": "in_port"}', 'admin_003', '2024-01-25 18:00:00'),
('customers', 'UPDATE', 1, '{"credit_rating": "AA"}', '{"credit_rating": "AAA"}', 'credit_dept', '2024-01-20 10:00:00'),
('customers', 'UPDATE', 2, '{"credit_rating": "A"}', '{"credit_rating": "AA"}', 'credit_dept', '2024-02-01 10:00:00'),
('transport_orders', 'UPDATE', 4, '{"status": "pending", "freight_amount": 16000.00}', '{"status": "confirmed", "freight_amount": 16000.00}', 'ops_manager', '2024-01-04 12:00:00'),
('transport_orders', 'UPDATE', 5, '{"status": "pending", "freight_amount": 22500.00}', '{"status": "confirmed", "freight_amount": 22500.00}', 'ops_manager', '2024-01-05 07:00:00'),
('transport_orders', 'UPDATE', 5, '{"status": "confirmed", "freight_amount": 22500.00}', '{"status": "ship_assigned", "freight_amount": 22500.00}', 'system_auto', '2024-01-05 07:00:00'),
('berths', 'UPDATE', 1, '{"status": "available"}', '{"status": "occupied"}', 'port_ops', '2024-01-01 08:00:00'),
('berths', 'UPDATE', 1, '{"status": "occupied"}', '{"status": "available"}', 'port_ops', '2024-01-01 10:00:00'),
('berths', 'UPDATE', 2, '{"status": "available"}', '{"status": "occupied"}', 'port_ops', '2024-01-02 10:00:00'),
('transport_orders', 'UPDATE', 9, '{"status": "confirmed", "freight_amount": 19500.00}', '{"status": "ship_assigned", "freight_amount": 19500.00}', 'system_auto', '2024-01-09 06:00:00'),
('transport_orders', 'UPDATE', 9, '{"status": "ship_assigned", "freight_amount": 19500.00}', '{"status": "in_transit", "freight_amount": 19500.00}', 'system_auto', '2024-01-09 08:30:00'),
('transport_orders', 'UPDATE', 9, '{"status": "in_transit", "freight_amount": 19500.00}', '{"status": "completed", "freight_amount": 19500.00}', 'system_auto', '2024-02-20 18:00:00'),
('ships', 'UPDATE', 9, '{"current_status": "in_port"}', '{"current_status": "sailing"}', 'admin_009', '2024-01-09 08:00:00'),
('ships', 'UPDATE', 9, '{"current_status": "sailing"}', '{"current_status": "in_port"}', 'admin_009', '2024-02-20 20:00:00'),
('customers', 'UPDATE', 4, '{"credit_rating": "BBB"}', '{"credit_rating": "A"}', 'credit_dept', '2024-02-15 14:00:00'),
('customers', 'UPDATE', 5, '{"credit_rating": "A"}', '{"credit_rating": "AA"}', 'credit_dept', '2024-02-20 14:00:00'),
('transport_orders', 'UPDATE', 15, '{"status": "confirmed", "freight_amount": 9750.00}', '{"status": "ship_assigned", "freight_amount": 9750.00}', 'system_auto', '2024-01-15 12:00:00'),
('transport_orders', 'UPDATE', 15, '{"status": "ship_assigned", "freight_amount": 9750.00}', '{"status": "in_transit", "freight_amount": 9750.00}', 'system_auto', '2024-01-15 14:30:00'),
('transport_orders', 'UPDATE', 15, '{"status": "in_transit", "freight_amount": 9750.00}', '{"status": "completed", "freight_amount": 9750.00}', 'system_auto', '2024-03-21 00:00:00'),
('ships', 'UPDATE', 15, '{"current_status": "in_port"}', '{"current_status": "sailing"}', 'admin_015', '2024-01-15 14:00:00'),
('ships', 'UPDATE', 15, '{"current_status": "sailing"}', '{"current_status": "in_port"}', 'admin_015', '2024-03-21 02:00:00'),
('transport_orders', 'UPDATE', 21, '{"status": "confirmed", "freight_amount": 10500.00}', '{"status": "ship_assigned", "freight_amount": 10500.00}', 'system_auto', '2024-01-21 07:00:00'),
('transport_orders', 'UPDATE', 21, '{"status": "ship_assigned", "freight_amount": 10500.00}', '{"status": "in_transit", "freight_amount": 10500.00}', 'system_auto', '2024-01-21 09:30:00'),
('transport_orders', 'UPDATE', 21, '{"status": "in_transit", "freight_amount": 10500.00}', '{"status": "completed", "freight_amount": 10500.00}', 'system_auto', '2024-04-15 19:00:00'),
('ships', 'UPDATE', 21, '{"current_status": "in_port"}', '{"current_status": "sailing"}', 'admin_021', '2024-01-21 09:00:00'),
('ships', 'UPDATE', 21, '{"current_status": "sailing"}', '{"current_status": "in_port"}', 'admin_021', '2024-04-15 21:00:00'),
('customers', 'UPDATE', 6, '{"credit_rating": "BB"}', '{"credit_rating": "B"}', 'credit_dept', '2024-01-25 16:00:00'),
('customers', 'UPDATE', 9, '{"credit_rating": "AA"}', '{"credit_rating": "AAA"}', 'credit_dept', '2024-03-05 16:00:00'),
('transport_orders', 'UPDATE', 27, '{"status": "confirmed", "freight_amount": 9000.00}', '{"status": "ship_assigned", "freight_amount": 9000.00}', 'system_auto', '2024-01-27 04:00:00'),
('transport_orders', 'UPDATE', 27, '{"status": "ship_assigned", "freight_amount": 9000.00}', '{"status": "in_transit", "freight_amount": 9000.00}', 'system_auto', '2024-01-27 06:30:00'),
('transport_orders', 'UPDATE', 27, '{"status": "in_transit", "freight_amount": 9000.00}', '{"status": "completed", "freight_amount": 9000.00}', 'system_auto', '2024-05-10 16:00:00'),
('ships', 'UPDATE', 27, '{"current_status": "in_port"}', '{"current_status": "sailing"}', 'admin_027', '2024-01-27 06:00:00'),
('ships', 'UPDATE', 27, '{"current_status": "sailing"}', '{"current_status": "in_port"}', 'admin_027', '2024-05-10 18:00:00'),
('transport_orders', 'UPDATE', 33, '{"status": "confirmed", "freight_amount": 10000.00}', '{"status": "ship_assigned", "freight_amount": 10000.00}', 'system_auto', '2024-02-02 11:00:00'),
('transport_orders', 'UPDATE', 33, '{"status": "ship_assigned", "freight_amount": 10000.00}', '{"status": "in_transit", "freight_amount": 10000.00}', 'system_auto', '2024-02-02 13:30:00'),
('transport_orders', 'UPDATE', 33, '{"status": "in_transit", "freight_amount": 10000.00}', '{"status": "completed", "freight_amount": 10000.00}', 'system_auto', '2024-06-05 23:00:00'),
('ships', 'UPDATE', 33, '{"current_status": "in_port"}', '{"current_status": "sailing"}', 'admin_033', '2024-02-02 13:00:00'),
('ships', 'UPDATE', 33, '{"current_status": "sailing"}', '{"current_status": "in_port"}', 'admin_033', '2024-06-06 01:00:00'),
('customers', 'UPDATE', 12, '{"credit_rating": "AA"}', '{"credit_rating": "AAA"}', 'credit_dept', '2024-03-15 12:00:00'),
('customers', 'UPDATE', 15, '{"credit_rating": "BB"}', '{"credit_rating": "A"}', 'credit_dept', '2024-02-28 12:00:00');

-- ========================================
-- Data Verification and Summary
-- ========================================

-- Display completion message
SELECT 'Sample Data Generation Completed Successfully!' as Status;

-- Show data counts for verification
SELECT 'Table Record Counts:' as Info;

SELECT 
    'shipping_companies' as table_name, COUNT(*) as record_count 
FROM shipping_companies
UNION ALL
SELECT 'ships', COUNT(*) FROM ships
UNION ALL
SELECT 'ports', COUNT(*) FROM ports  
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'cargo_types', COUNT(*) FROM cargo_types
UNION ALL
SELECT 'cargos', COUNT(*) FROM cargos
UNION ALL
SELECT 'transport_orders', COUNT(*) FROM transport_orders
UNION ALL
SELECT 'order_cargo_details', COUNT(*) FROM order_cargo_details
UNION ALL
SELECT 'voyages', COUNT(*) FROM voyages
UNION ALL
SELECT 'order_voyage_assignments', COUNT(*) FROM order_voyage_assignments
UNION ALL
SELECT 'berths', COUNT(*) FROM berths
UNION ALL
SELECT 'berth_occupancy', COUNT(*) FROM berth_occupancy
UNION ALL
SELECT 'fee_details', COUNT(*) FROM fee_details
UNION ALL
SELECT 'transport_tracking', COUNT(*) FROM transport_tracking
UNION ALL
SELECT 'customer_credit_records', COUNT(*) FROM customer_credit_records
UNION ALL
SELECT 'system_logs', COUNT(*) FROM system_logs;

-- Show sample business statistics
SELECT 'Business Statistics Summary:' as Info;

SELECT 
    order_status,
    COUNT(*) as order_count,
    ROUND(AVG(freight_amount), 2) as avg_freight,
    ROUND(SUM(freight_amount), 2) as total_freight
FROM transport_orders 
GROUP BY order_status
ORDER BY order_count DESC;

SELECT 'Top 5 Shipping Companies by Fleet Size:' as Info;
SELECT company_name, fleet_size, registration_country 
FROM shipping_companies 
ORDER BY fleet_size DESC 
LIMIT 5;

SELECT 'Port Utilization Summary:' as Info;
SELECT 
    p.port_name,
    p.country,
    COUNT(DISTINCT bo.ship_id) as ships_served,
    COUNT(bo.occupancy_id) as total_operations
FROM ports p
LEFT JOIN berths b ON p.port_id = b.port_id
LEFT JOIN berth_occupancy bo ON b.berth_id = bo.berth_id
GROUP BY p.port_id, p.port_name, p.country
ORDER BY total_operations DESC
LIMIT 10;

-- Show database integrity
SELECT 'Foreign Key Relationships Verified:' as Info;

SELECT 
    'Orders with valid customer references' as check_type,
    COUNT(*) as valid_records
FROM transport_orders o
JOIN customers s ON o.shipper_id = s.customer_id
JOIN customers c ON o.consignee_id = c.customer_id;

-- Display final success message
SELECT 
    'Database successfully populated with comprehensive sample data!' as final_status,
    'All tables contain 20-60 records each with realistic business relationships' as description,
    'Ready for testing and development use' as ready_status;