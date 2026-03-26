CREATE TABLE customers (
    customer_id   SERIAL PRIMARY KEY,
    name          VARCHAR(100)  NOT NULL,
    email         VARCHAR(150)  UNIQUE NOT NULL,
    phone         VARCHAR(20),
    city          VARCHAR(50),
    tier          VARCHAR(20)   DEFAULT 'standard',
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);
 
CREATE TABLE products (
    product_id    SERIAL PRIMARY KEY,
    name          VARCHAR(200)  NOT NULL,
    category      VARCHAR(50),
    price         NUMERIC(12,2) NOT NULL,
    stock_qty     INT           DEFAULT 0,
    is_active     BOOLEAN       DEFAULT TRUE
);
 
CREATE TABLE orders (
    order_id      SERIAL PRIMARY KEY,
    customer_id   INT           REFERENCES customers(customer_id),
    order_date    DATE          NOT NULL,
    status        VARCHAR(20)   NOT NULL,
    shipping_city VARCHAR(50),
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);
 
CREATE TABLE order_items (
    item_id       SERIAL PRIMARY KEY,
    order_id      INT           REFERENCES orders(order_id),
    product_id    INT           REFERENCES products(product_id),
    quantity      INT           NOT NULL CHECK (quantity > 0),
    unit_price    NUMERIC(12,2) NOT NULL,
    discount_pct  NUMERIC(5,2)  DEFAULT 0
);
 
CREATE TABLE reviews (
    review_id     SERIAL PRIMARY KEY,
    customer_id   INT           REFERENCES customers(customer_id),
    product_id    INT           REFERENCES products(product_id),
    rating        INT           CHECK (rating BETWEEN 1 AND 5),
    comment       TEXT,
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);
 
-- ── BƯỚC 2: INSERT DATA ──────────────────────────────────────
 
-- CUSTOMERS (30 khách hàng)
INSERT INTO customers (name, email, phone, city, tier, created_at) VALUES
('Nguyễn Văn An',       'an.nguyen@gmail.com',      '0901234567', 'HCM',      'gold',     '2023-01-15 08:00:00'),
('Trần Thị Bảo',        'bao.tran@gmail.com',        '0912345678', 'Hà Nội',   'platinum', '2023-01-20 09:30:00'),
('Lê Minh Cường',       'cuong.le@yahoo.com',        '0923456789', 'Đà Nẵng',  'standard', '2023-02-01 10:00:00'),
('Phạm Thị Dung',       'dung.pham@gmail.com',       '0934567890', 'HCM',      'gold',     '2023-02-10 11:00:00'),
('Hoàng Văn Em',        'em.hoang@hotmail.com',      NULL,         'Hà Nội',   'standard', '2023-02-15 12:00:00'),
('Vũ Thị Phương',       'phuong.vu@gmail.com',       '0956789012', 'Cần Thơ',  'standard', '2023-03-01 08:30:00'),
('Đặng Quốc Giang',     'giang.dang@gmail.com',      '0967890123', 'HCM',      'platinum', '2023-03-05 09:00:00'),
('Bùi Thị Hoa',         'hoa.bui@gmail.com',         '0978901234', 'Hà Nội',   'gold',     '2023-03-10 10:30:00'),
('Ngô Văn Inh',         'inh.ngo@yahoo.com',         NULL,         'HCM',      'standard', '2023-03-20 11:00:00'),
('Đinh Thị Khanh',      'khanh.dinh@gmail.com',      '0990123456', 'Đà Nẵng',  'standard', '2023-04-01 08:00:00'),
('Trương Minh Long',    'long.truong@gmail.com',     '0901111222', 'HCM',      'gold',     '2023-04-05 09:30:00'),
('Mai Thị Mỹ',          'my.mai@gmail.com',          '0912222333', 'Hà Nội',   'standard', '2023-04-10 10:00:00'),
('Lý Văn Nam',          'nam.ly@hotmail.com',        '0923333444', 'Cần Thơ',  'platinum', '2023-04-15 11:30:00'),
('Cao Thị Oanh',        'oanh.cao@gmail.com',        NULL,         'HCM',      'standard', '2023-05-01 08:00:00'),
('Hồ Văn Phúc',         'phuc.ho@gmail.com',         '0945555666', 'Hà Nội',   'gold',     '2023-05-05 09:00:00'),
('Tô Thị Quỳnh',        'quynh.to@gmail.com',        '0956666777', 'Đà Nẵng',  'standard', '2023-05-10 10:30:00'),
('Phan Văn Rạng',       'rang.phan@yahoo.com',       '0967777888', 'HCM',      'standard', '2023-05-15 11:00:00'),
('Đỗ Thị Sương',        'suong.do@gmail.com',        '0978888999', 'Hà Nội',   'gold',     '2023-06-01 08:30:00'),
('Lưu Văn Thắng',       'thang.luu@gmail.com',       NULL,         'HCM',      'platinum', '2023-06-05 09:00:00'),
('Kiều Thị Uyên',       'uyen.kieu@gmail.com',       '0990000111', 'Cần Thơ',  'standard', '2023-06-10 10:00:00'),
('Trịnh Văn Vinh',      'vinh.trinh@gmail.com',      '0901000200', 'Hà Nội',   'gold',     '2023-07-01 08:00:00'),
('Hà Thị Xuân',         'xuan.ha@gmail.com',         '0912000300', 'HCM',      'standard', '2023-07-05 09:30:00'),
('Dương Văn Yên',       'yen.duong@yahoo.com',       '0923000400', 'Đà Nẵng',  'standard', '2023-07-10 10:00:00'),
('Nghiêm Thị Zung',     'zung.nghiem@gmail.com',     NULL,         'HCM',      'gold',     '2023-07-15 11:00:00'),
('Lê Quang Anh',        'anh.lequang@gmail.com',     '0945000600', 'Hà Nội',   'platinum', '2023-08-01 08:30:00'),
('Phùng Thị Bình',      'binh.phung@gmail.com',      '0956000700', 'HCM',      'standard', '2023-08-05 09:00:00'),
('Cù Văn Chiến',        'chien.cu@hotmail.com',      '0967000800', 'Cần Thơ',  'standard', '2023-08-10 10:30:00'),
('Vương Thị Diễm',      'diem.vuong@gmail.com',      '0978000900', 'Hà Nội',   'gold',     '2023-09-01 08:00:00'),
('Mạc Văn Ẹm',          'em.mac@gmail.com',          NULL,         'HCM',      'standard', '2023-09-05 09:00:00'),
('Tạ Thị Phấn',         'phan.ta@gmail.com',         '0990001100', 'Đà Nẵng',  'standard', '2023-09-10 10:00:00');
 
-- PRODUCTS (25 sản phẩm)
INSERT INTO products (name, category, price, stock_qty, is_active) VALUES
('iPhone 15 Pro Max 256GB',     'Mobile',      32000000, 50,  TRUE),
('Samsung Galaxy S24 Ultra',    'Mobile',      28000000, 35,  TRUE),
('Oppo Find X7 Pro',            'Mobile',      18000000, 40,  TRUE),
('Xiaomi 14 Ultra',             'Mobile',      22000000, 20,  TRUE),
('Vivo X100 Pro',               'Mobile',      19000000, 15,  TRUE),
('MacBook Pro 14 M3',           'Laptop',      52000000, 25,  TRUE),
('Dell XPS 15 9530',            'Laptop',      42000000, 20,  TRUE),
('Asus ROG Zephyrus G14',       'Laptop',      38000000, 30,  TRUE),
('Lenovo ThinkPad X1 Carbon',   'Laptop',      45000000, 15,  TRUE),
('HP Spectre x360',             'Laptop',      35000000, 18,  TRUE),
('iPad Pro 12.9 M2',            'Tablet',      28000000, 40,  TRUE),
('Samsung Galaxy Tab S9 Ultra', 'Tablet',      22000000, 35,  TRUE),
('Sony WH-1000XM5',             'Audio',        8500000, 60,  TRUE),
('Apple AirPods Pro 2',         'Audio',        6500000, 80,  TRUE),
('Bose QuietComfort 45',        'Audio',        7200000, 45,  TRUE),
('LG OLED 55" C3',              'TV',          35000000, 10,  TRUE),
('Samsung Neo QLED 65"',        'TV',          42000000,  8,  TRUE),
('Dell 27" 4K Monitor U2723D',  'Monitor',     15000000, 22,  TRUE),
('LG 32" UltraFine 4K',         'Monitor',     18000000, 18,  TRUE),
('Logitech MX Master 3S',       'Accessories',  2200000, 100, TRUE),
('Keychron K2 Pro Keyboard',    'Accessories',  2800000, 75,  TRUE),
('Anker 737 Charger 120W',      'Accessories',   980000, 150, TRUE),
('DJI Mini 4 Pro Drone',        'Camera',      18500000, 12,  TRUE),
('Sony A7 IV Camera',           'Camera',      65000000,  5,  TRUE),
('GoPro Hero 12 Black',         'Camera',       9500000, 25,  FALSE);
 
-- ORDERS (60 đơn hàng)
INSERT INTO orders (customer_id, order_date, status, shipping_city) VALUES
-- 2023 Q4
(1,  '2023-10-05', 'completed', 'HCM'),
(2,  '2023-10-08', 'completed', 'Hà Nội'),
(3,  '2023-10-10', 'completed', 'Đà Nẵng'),
(4,  '2023-10-15', 'cancelled', 'HCM'),
(5,  '2023-10-20', 'completed', 'Hà Nội'),
(1,  '2023-11-01', 'completed', 'HCM'),
(7,  '2023-11-05', 'completed', 'HCM'),
(8,  '2023-11-10', 'returned',  'Hà Nội'),
(2,  '2023-11-15', 'completed', 'Hà Nội'),
(10, '2023-11-20', 'completed', 'Đà Nẵng'),
(11, '2023-12-01', 'completed', 'HCM'),
(13, '2023-12-05', 'completed', 'Cần Thơ'),
(4,  '2023-12-10', 'completed', 'HCM'),
(15, '2023-12-15', 'pending',   'Hà Nội'),
(7,  '2023-12-20', 'completed', 'HCM'),
-- 2024 Q1
(1,  '2024-01-05', 'completed', 'HCM'),
(2,  '2024-01-08', 'completed', 'Hà Nội'),
(3,  '2024-01-10', 'cancelled', 'Đà Nẵng'),
(6,  '2024-01-15', 'completed', 'Cần Thơ'),
(8,  '2024-01-20', 'completed', 'Hà Nội'),
(11, '2024-01-25', 'completed', 'HCM'),
(13, '2024-02-01', 'completed', 'Cần Thơ'),
(2,  '2024-02-05', 'completed', 'Hà Nội'),
(4,  '2024-02-10', 'completed', 'HCM'),
(16, '2024-02-14', 'returned',  'Đà Nẵng'),
(7,  '2024-02-20', 'completed', 'HCM'),
(19, '2024-02-25', 'completed', 'HCM'),
(21, '2024-03-01', 'completed', 'Hà Nội'),
(1,  '2024-03-05', 'completed', 'HCM'),
(25, '2024-03-10', 'completed', 'Hà Nội'),
-- 2024 Q2
(2,  '2024-04-01', 'completed', 'Hà Nội'),
(4,  '2024-04-05', 'completed', 'HCM'),
(7,  '2024-04-10', 'completed', 'HCM'),
(13, '2024-04-15', 'cancelled', 'Cần Thơ'),
(8,  '2024-04-20', 'completed', 'Hà Nội'),
(11, '2024-05-01', 'completed', 'HCM'),
(15, '2024-05-05', 'completed', 'Hà Nội'),
(19, '2024-05-10', 'completed', 'HCM'),
(1,  '2024-05-15', 'completed', 'HCM'),
(25, '2024-05-20', 'completed', 'Hà Nội'),
(2,  '2024-06-01', 'completed', 'Hà Nội'),
(7,  '2024-06-05', 'completed', 'HCM'),
(4,  '2024-06-10', 'returned',  'HCM'),
(28, '2024-06-15', 'completed', 'Hà Nội'),
(13, '2024-06-20', 'completed', 'Cần Thơ'),
-- 2024 Q3
(1,  '2024-07-01', 'completed', 'HCM'),
(2,  '2024-07-05', 'completed', 'Hà Nội'),
(7,  '2024-07-10', 'completed', 'HCM'),
(11, '2024-07-15', 'pending',   'HCM'),
(25, '2024-07-20', 'completed', 'Hà Nội'),
(4,  '2024-08-01', 'completed', 'HCM'),
(8,  '2024-08-05', 'completed', 'Hà Nội'),
(19, '2024-08-10', 'completed', 'HCM'),
(13, '2024-08-15', 'completed', 'Cần Thơ'),
(28, '2024-08-20', 'cancelled', 'Hà Nội'),
(1,  '2024-09-01', 'completed', 'HCM'),
(2,  '2024-09-05', 'completed', 'Hà Nội'),
(7,  '2024-09-10', 'completed', 'HCM'),
(15, '2024-09-15', 'completed', 'Hà Nội'),
(4,  '2024-09-20', 'pending',   'HCM');
 
-- ORDER_ITEMS (120 items)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_pct) VALUES
-- Orders 1-10
(1,  1,  1, 32000000, 0),
(1,  14, 1,  6500000, 5),
(2,  6,  1, 52000000, 0),
(2,  20, 2,  2200000, 0),
(3,  2,  1, 28000000, 0),
(3,  13, 1,  8500000, 10),
(4,  11, 1, 28000000, 0),
(5,  8,  1, 38000000, 0),
(5,  21, 1,  2800000, 0),
(6,  1,  1, 32000000, 5),
(7,  7,  1, 42000000, 0),
(7,  18, 1, 15000000, 0),
(8,  16, 1, 35000000, 0),
(9,  6,  1, 52000000, 0),
(9,  13, 1,  8500000, 0),
(10, 3,  1, 18000000, 0),
(10, 22, 1,   980000, 0),
-- Orders 11-20
(11, 9,  1, 45000000, 0),
(11, 20, 1,  2200000, 0),
(12, 4,  1, 22000000, 0),
(12, 14, 2,  6500000, 5),
(13, 1,  1, 32000000, 10),
(13, 21, 1,  2800000, 0),
(14, 17, 1, 42000000, 0),
(15, 6,  1, 52000000, 5),
(15, 20, 2,  2200000, 0),
(16, 2,  1, 28000000, 0),
(16, 13, 1,  8500000, 0),
(17, 6,  1, 52000000, 0),
(17, 19, 1, 18000000, 0),
(18, 5,  1, 19000000, 0),
(19, 12, 1, 22000000, 0),
(20, 7,  1, 42000000, 0),
-- Orders 21-30
(21, 1,  1, 32000000, 0),
(21, 22, 2,   980000, 0),
(22, 11, 1, 28000000, 0),
(22, 20, 1,  2200000, 5),
(23, 6,  1, 52000000, 0),
(23, 14, 1,  6500000, 0),
(24, 3,  1, 18000000, 0),
(24, 21, 1,  2800000, 0),
(25, 16, 1, 35000000, 0),
(26, 2,  1, 28000000, 5),
(26, 13, 1,  8500000, 0),
(27, 9,  1, 45000000, 0),
(28, 8,  1, 38000000, 0),
(28, 20, 1,  2200000, 0),
(29, 1,  2, 32000000, 10),
(30, 7,  1, 42000000, 0),
-- Orders 31-40
(31, 6,  1, 52000000, 0),
(31, 19, 1, 18000000, 5),
(32, 2,  1, 28000000, 0),
(32, 22, 3,   980000, 0),
(33, 1,  1, 32000000, 0),
(33, 14, 1,  6500000, 0),
(34, 12, 1, 22000000, 0),
(35, 7,  1, 42000000, 0),
(35, 21, 2,  2800000, 0),
(36, 4,  1, 22000000, 0),
(36, 13, 1,  8500000, 5),
(37, 6,  1, 52000000, 0),
(37, 20, 1,  2200000, 0),
(38, 9,  1, 45000000, 0),
(39, 1,  1, 32000000, 5),
(39, 14, 2,  6500000, 0),
(40, 7,  1, 42000000, 0),
(41, 6,  1, 52000000, 0),
(41, 18, 1, 15000000, 0),
(42, 2,  1, 28000000, 0),
-- Orders 43-52
(43, 11, 1, 28000000, 0),
(44, 8,  1, 38000000, 5),
(44, 20, 1,  2200000, 0),
(45, 1,  1, 32000000, 0),
(45, 22, 2,   980000, 0),
(46, 1,  1, 32000000, 0),
(46, 13, 1,  8500000, 0),
(47, 6,  1, 52000000, 0),
(47, 14, 1,  6500000, 5),
(48, 2,  1, 28000000, 0),
(48, 21, 1,  2800000, 0),
(49, 4,  1, 22000000, 0),
(50, 7,  1, 42000000, 0),
(50, 20, 2,  2200000, 0),
(51, 1,  1, 32000000, 0),
(52, 9,  1, 45000000, 5),
(53, 6,  1, 52000000, 0),
(53, 19, 1, 18000000, 0),
(54, 3,  1, 18000000, 0),
(54, 22, 1,   980000, 0),
-- Orders 53-60
(55, 12, 1, 22000000, 0),
(56, 1,  1, 32000000, 0),
(56, 14, 1,  6500000, 5),
(57, 6,  1, 52000000, 0),
(57, 20, 1,  2200000, 0),
(58, 8,  1, 38000000, 0),
(59, 2,  1, 28000000, 0),
(59, 13, 1,  8500000, 0),
(60, 4,  1, 22000000, 0),
(60, 21, 1,  2800000, 0);
 
-- REVIEWS (40 reviews)
INSERT INTO reviews (customer_id, product_id, rating, comment, created_at) VALUES
(1,  1,  5, 'iPhone 15 Pro Max tuyệt vời, camera siêu đỉnh!',              '2023-10-20 10:00:00'),
(2,  6,  5, 'MacBook Pro M3 chạy mượt mà, pin trâu bò.',                   '2023-10-25 11:00:00'),
(3,  2,  4, 'Samsung Galaxy S24 Ultra ngon, màn hình đẹp.',                '2023-10-28 12:00:00'),
(4,  11, 3, 'iPad Pro tốt nhưng giá hơi cao so với nhu cầu.',              '2023-11-05 09:00:00'),
(5,  8,  5, 'Asus ROG Zephyrus chơi game mượt, hiệu năng khủng.',          '2023-11-10 14:00:00'),
(7,  7,  4, 'Dell XPS 15 build quality tốt, nhưng hơi nóng.',             '2023-11-20 15:00:00'),
(8,  16, 2, 'LG OLED đẹp nhưng bị lỗi panel sau 2 tuần.',                 '2023-11-25 16:00:00'),
(2,  13, 5, 'Sony WH-1000XM5 chống ồn cực tốt, âm thanh hay.',             '2023-12-01 10:00:00'),
(10, 3,  4, 'Oppo Find X7 Pro camera tốt, giá hợp lý.',                   '2023-12-05 11:00:00'),
(11, 9,  5, 'Lenovo ThinkPad X1 Carbon siêu nhẹ, bàn phím gõ sướng.',     '2023-12-15 12:00:00'),
(13, 4,  5, 'Xiaomi 14 Ultra camera Leica đỉnh của đỉnh!',                '2023-12-20 13:00:00'),
(1,  14, 4, 'AirPods Pro 2 âm thanh tốt, fit tai thoải mái.',             '2024-01-10 09:00:00'),
(2,  6,  5, 'Lần 2 mua MacBook, vẫn không thất vọng.',                    '2024-01-15 10:00:00'),
(8,  7,  3, 'Dell XPS 15 tốt nhưng giá cao.',                             '2024-01-25 11:00:00'),
(11, 1,  5, 'iPhone 15 Pro Max là smartphone tốt nhất tôi từng dùng.',    '2024-01-30 12:00:00'),
(13, 14, 5, 'AirPods Pro 2 với iPhone là combo không thể thiếu.',         '2024-02-10 09:00:00'),
(4,  1,  4, 'iPhone 15 camera đẹp, nhưng giá hơi cao.',                   '2024-02-15 10:00:00'),
(7,  6,  5, 'MacBook Pro M3 xử lý video editing siêu nhanh.',             '2024-02-25 11:00:00'),
(16, 16, 1, 'TV LG OLED bị lỗi, đã đổi trả.',                            '2024-03-05 12:00:00'),
(19, 9,  5, 'ThinkPad X1 Carbon pin 12 tiếng, tuyệt vời cho di chuyển.', '2024-03-15 13:00:00'),
(21, 8,  4, 'Asus ROG G14 gaming performance tốt, price-to-performance cao.', '2024-04-05 09:00:00'),
(25, 7,  5, 'Dell XPS 15 màn hình OLED đẹp không có đối thủ.',           '2024-04-15 10:00:00'),
(2,  2,  4, 'Samsung S24 Ultra S Pen tiện, camera zoom 10x rất hay.',     '2024-05-05 11:00:00'),
(4,  13, 5, 'Sony WH-1000XM5 là tai nghe over-ear tốt nhất thị trường.', '2024-05-10 12:00:00'),
(7,  2,  5, 'Samsung S24 Ultra màn hình 6.8" đẹp, gaming cực đỉnh.',     '2024-05-20 13:00:00'),
(1,  1,  5, 'iPhone 15 Pro Max lần 3 mua, không bao giờ thất vọng.',     '2024-06-05 09:00:00'),
(2,  6,  4, 'MacBook Pro M3 tốt nhưng RAM 16GB cảm giác hơi ít.',        '2024-06-10 10:00:00'),
(28, 8,  5, 'Asus ROG G14 compact nhưng mạnh, balo đeo đi làm được.',    '2024-06-20 11:00:00'),
(13, 11, 4, 'iPad Pro M2 vẽ tay với Pencil 2 rất mượt.',                 '2024-07-05 12:00:00'),
(1,  14, 5, 'AirPods Pro 2 noise cancelling tốt hơn bose QuietComfort.', '2024-07-10 13:00:00'),
(2,  13, 4, 'Sony WH-1000XM5 đã sở hữu 1 năm vẫn ngon như mới.',        '2024-07-15 09:00:00'),
(7,  1,  5, 'iPhone 15 Pro Max Action Button tiện hơn mình nghĩ.',       '2024-07-20 10:00:00'),
(25, 6,  5, 'MacBook Pro M3 xử lý code compile siêu nhanh.',             '2024-08-05 11:00:00'),
(4,  20, 5, 'Logitech MX Master 3S scroll bánh xe vô cùng mượt.',        '2024-08-10 12:00:00'),
(8,  7,  4, 'Dell XPS 15 sau 6 tháng dùng vẫn rất tốt.',                '2024-08-15 13:00:00'),
(19, 6,  5, 'MacBook Pro M3 là cỗ máy làm việc hoàn hảo.',              '2024-09-05 09:00:00'),
(15, 1,  4, 'iPhone 15 Pro Max tốt nhưng nặng hơn 14 Pro Max.',         '2024-09-10 10:00:00'),
(2,  14, 5, 'AirPods Pro 2 đã thay gen 1, cải thiện rõ rệt.',           '2024-09-15 11:00:00'),
(7,  9,  5, 'ThinkPad X1 Carbon bàn phím là tốt nhất trong laptop.',     '2024-09-18 12:00:00'),
(1,  13, 5, 'Sony WH-1000XM5 đáng từng đồng, không tiếc khi mua.',      '2024-09-22 13:00:00');
 
-- JOIN — Kết hợp nhiều bảng
-- tư duy trc khi join
-- Bước 1 — Xác định bảng:
--    Tôi cần data từ bảng nào? Bảng nào là 'chính' (driving table)?
--Bước 2 — Xác định relationship:
--    Bảng A và B liên kết qua column nào? 1-to-1, 1-to-many, hay many-to-many?
--Bước 3 — Chọn loại JOIN:
--    Tôi có muốn giữ rows từ bảng trái dù không có match không? → LEFT JOIN. Chỉ lấy rows có match ở cả hai? → INNER JOIN.
--Bước 4 — Verify kết quả:
--    Số rows có hợp lý không? Có bị duplicate không? NULL ở đâu là đúng?

-- INNER JOIN - chỉ lấy rows có dữ liệu ko chứa null
-- lấy orders kèm thông tin customers
SELECT o.order_id, o.status, c.name
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id; -- ko cần viết INNER  VÌ JOIN = INNER JOIN 

-- JOIN 3 bảng
SELECT o.order_id,
c.name, 
p.name, 
oi.quantity * oi.unit_price AS line_total
FROM orders o 
JOIN customers c ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.status = 'completed'
ORDER BY o.order_id DESC; 

-- JOIN với nhiều điều kiện
SELECT *
FROM orders o 
JOIN customers c ON o.customer_id = o.customer_id
AND o.shipping_city = c.city -- điều kiện bổ sung
WHERE o.status = 'completed';

-- LEFT JOIN - giữ all rows  từ bảng trái, dù có match ở bảng phải hay không. Rows không có match → columns bảng phải là NULL.
-- tìm customer chưa từng đặt hàng 
-- cách tui tự nghĩ
SELECT customer_id, name
FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM orders); -- cách tui tự nghĩ
-- cách lời giải
SELECT
    c.customer_id,
    c.name,
    c.email,
    o.order_id      -- NULL nếu chưa đặt hàng
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL-- filter: chỉ giữ rows không có match
ORDER BY c.customer_id ASC;
-- Đây là pattern 'anti-join' — cực hay dùng trong DE

--lấy all customer + số đơn hàng kể cả 0 đơn 
SELECT c.customer_id, c.name,
COUNT(o.order_id) AS order_count,
COALESCE(SUM(oi.unit_price * oi.quantity), 0) AS total
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.name
ORDER BY total DESC;
-- ⚠️ Lỗi hay gặp: đặt filter cho bảng RIGHT trong WHERE thay vì ON

-- SAI — biến LEFT JOIN thành INNER JOIN!

SELECT c.*, o.*
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'completed';  -- loại bỏ customers ko có order
-- ĐÚNG — filter trong ON condition
SELECT c.*, o.*
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
AND o.status = 'completed';  -- customers không có ordẻ vẫn còn


-- REIGHT JOIN, FULL JOIN AND CROSS JOIN
-- RIGHT JOIN - giữ lại rất cả rows bên phải
-- Ít dùng hơn LEFT JOIN, vì có thể rewrite thành LEFT JOIN bằng đổi thứ tự
SELECT c.name, o.order_id
FROM orders o
RIGHT JOIN customers c ON o.customer_id = c.customer_id;
-- = viết lại bằng LEFT JOIN:
SELECT c.name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
-- FULL JOIN - lấy tât cả 2 bảng
SELECT c.customer_id, c.name, o.order_id, o.status
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;
-- Dùng khi: đồng bộ data, tìm inconsistencies giữa 2 nguồn

-- CROSS JOIN — tích Cartesian (mọi combination)
SELECT c.name, p.name AS product
FROM customers c
CROSS JOIN products p;
-- như kiểu nhân phân phối ấy
-- Ví dụ thực tế: tạo tất cả combinations customer + month
WITH months AS (
    SELECT generate_series('2024-01-01'::DATE, '2024-12-01', '1 month') AS month
)
SELECT c.customer_id, c.name, m.month
FROM customers c
CROSS JOIN months m
ORDER BY c.customer_id, m.month;

-- SELF JOIN — Bảng JOIN với chính nó
-- vidu tìm customner cùng thành phố
SELECT c.name, c.city, m.name
FROM customers c 
JOIN customers m ON m.city = c.city 
AND c.customer_id < m.customer_id;  -- tránh duplicate pairs (c,m) và (m,c)

-- Ví dụ thực tế: tìm products có giá gần nhau (chênh < 10%)
SELECT p.name, pr.name,
ABS(p.price - pr.price) / p.price*100 AS ti_le_pt -- đưa về tỉ lệ % chênh lêchj giá giữa 2 sp
FROM products p 
JOIN products pr ON pr.category = p.category
AND p.product_id < pr.product_id
AND ABS(p.price - pr.price) / p.price < 0.1
ORDER BY ti_le_pt ;







