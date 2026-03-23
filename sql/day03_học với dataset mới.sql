
DROP TABLE IF EXISTS reviews      CASCADE;
DROP TABLE IF EXISTS order_items  CASCADE;
DROP TABLE IF EXISTS orders       CASCADE;
DROP TABLE IF EXISTS coupons      CASCADE;
DROP TABLE IF EXISTS addresses    CASCADE;
DROP TABLE IF EXISTS customers    CASCADE;
DROP TABLE IF EXISTS products     CASCADE;
DROP TABLE IF EXISTS categories   CASCADE;

-- ============================================================
-- 1. CATEGORIES  (~20 rows)
-- ============================================================
CREATE TABLE categories (
    category_id   SERIAL PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    slug          VARCHAR(100) NOT NULL UNIQUE,
    parent_id     INT REFERENCES categories(category_id),
    created_at    TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO categories (name, slug, parent_id) VALUES
-- Cấp 1
('Điện tử',            'dien-tu',           NULL),
('Thời trang',         'thoi-trang',        NULL),
('Nhà cửa & Đời sống','nha-cua-doi-song',  NULL),
('Sách',               'sach',              NULL),
('Thể thao',           'the-thao',          NULL),
('Mỹ phẩm & Làm đẹp', 'my-pham-lam-dep',   NULL),
('Thực phẩm',          'thuc-pham',         NULL),
-- Cấp 2 – Điện tử
('Điện thoại',         'dien-thoai',        1),
('Laptop & PC',        'laptop-pc',         1),
('Tai nghe',           'tai-nghe',          1),
('Máy tính bảng',      'may-tinh-bang',     1),
('Phụ kiện điện tử',   'phu-kien-dien-tu',  1),
-- Cấp 2 – Thời trang
('Áo nam',             'ao-nam',            2),
('Quần nam',           'quan-nam',          2),
('Áo nữ',              'ao-nu',             2),
('Quần nữ',            'quan-nu',           2),
('Giày dép',           'giay-dep',          2),
-- Cấp 2 – Nhà cửa
('Nội thất',           'noi-that',          3),
('Nhà bếp',            'nha-bep',           3),
('Trang trí',          'trang-tri',         3);


-- ============================================================
-- 2. PRODUCTS  (~500 rows)
-- ============================================================
CREATE TABLE products (
    product_id   SERIAL PRIMARY KEY,
    category_id  INT NOT NULL REFERENCES categories(category_id),
    name         VARCHAR(255) NOT NULL,
    slug         VARCHAR(255) NOT NULL UNIQUE,
    sku          VARCHAR(50)  NOT NULL UNIQUE,
    price        NUMERIC(12,2) NOT NULL,
    cost         NUMERIC(12,2) NOT NULL,
    stock        INT NOT NULL DEFAULT 0,
    weight_gram  INT,
    is_active    BOOLEAN DEFAULT TRUE,
    created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- Sinh 500 sản phẩm ngẫu nhiên theo từng danh mục cấp 2
INSERT INTO products (category_id, name, slug, sku, price, cost, stock, weight_gram)
SELECT
    cat.category_id,
    cat.name || ' ' || adj.adj || ' ' || g.i::text  AS name,
    lower(replace(cat.name,' ','-')) || '-' || lower(adj.adj) || '-' || g.i::text  AS slug,
    'SKU-' || lpad(g.i::text, 6, '0')               AS sku,
    round((random() * 4900 + 100)::numeric, 2)      AS price,
    round((random() * 2000 + 50)::numeric, 2)       AS cost,
    (random() * 500)::int                           AS stock,
    (random() * 2000 + 50)::int                     AS weight_gram
FROM generate_series(1, 500) AS g(i)
CROSS JOIN LATERAL (
    SELECT category_id, name
    FROM categories
    WHERE parent_id IS NOT NULL
    ORDER BY random()
    LIMIT 1
) AS cat
CROSS JOIN LATERAL (
    SELECT adj
    FROM (VALUES ('Pro'),('Max'),('Lite'),('Ultra'),('Plus'),
                 ('Mini'),('Elite'),('Basic'),('Premium'),('Classic')) AS t(adj)
    ORDER BY random()
    LIMIT 1
) AS adj;


-- ============================================================
-- 3. CUSTOMERS  (~1.000 rows)
-- ============================================================
CREATE TABLE customers (
    customer_id  SERIAL PRIMARY KEY,
    email        VARCHAR(255) NOT NULL UNIQUE,
    full_name    VARCHAR(150) NOT NULL,
    phone        VARCHAR(20),
    gender       CHAR(1) CHECK (gender IN ('M','F','O')),
    birth_date   DATE,
    tier         VARCHAR(20) DEFAULT 'standard'
                     CHECK (tier IN ('standard','silver','gold','platinum')),
    is_active    BOOLEAN DEFAULT TRUE,
    created_at   TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO customers (email, full_name, phone, gender, birth_date, tier)
SELECT
    'user' || g.i || '@example.com'            AS email,
    (ARRAY['Nguyễn','Trần','Lê','Phạm','Hoàng','Vũ','Đặng','Bùi','Đỗ','Hồ'])[floor(random()*10)::int+1]
    || ' '
    || (ARRAY['Văn','Thị','Đức','Minh','Hồng','Quốc','Thanh','Anh','Bảo','Tú'])[floor(random()*10)::int+1]
    || ' '
    || (ARRAY['An','Bình','Cường','Dũng','Em','Giang','Hùng','Linh','Nam','Oanh'])[floor(random()*10)::int+1]
                                               AS full_name,
    '09' || lpad((random()*99999999)::int::text, 8, '0') AS phone,
    (ARRAY['M','F','O'])[floor(random()*3)::int+1]       AS gender,
    (NOW() - (random()*365*40 + 365*18) * INTERVAL '1 day')::date AS birth_date,
    (ARRAY['standard','silver','gold','platinum'])[
        CASE WHEN random() < 0.60 THEN 1
             WHEN random() < 0.80 THEN 2
             WHEN random() < 0.95 THEN 3
             ELSE 4 END]                                  AS tier
FROM generate_series(1, 1000) AS g(i);


-- ============================================================
-- 4. ADDRESSES  (~1.500 rows – trung bình 1-2 địa chỉ/khách)
-- ============================================================
CREATE TABLE addresses (
    address_id   SERIAL PRIMARY KEY,
    customer_id  INT NOT NULL REFERENCES customers(customer_id),
    label        VARCHAR(50) DEFAULT 'home',
    full_name    VARCHAR(150),
    phone        VARCHAR(20),
    street       TEXT,
    ward         VARCHAR(100),
    district     VARCHAR(100),
    city         VARCHAR(100),
    is_default   BOOLEAN DEFAULT FALSE,
    created_at   TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO addresses (customer_id, label, full_name, phone, street, ward, district, city, is_default)
SELECT
    g.i                                        AS customer_id,
    (ARRAY['home','office','other'])[floor(random()*3)::int+1] AS label,
    'Người nhận ' || g.i,
    '09' || lpad((random()*99999999)::int::text,8,'0'),
    (g.i * 7 % 200 + 1)::text || ' Đường '
        || (ARRAY['Nguyễn Huệ','Lê Lợi','Hai Bà Trưng','Trần Hưng Đạo',
                   'Đinh Tiên Hoàng','Lý Thường Kiệt','Pasteur','Nam Kỳ Khởi Nghĩa'])[floor(random()*8)::int+1],
    'Phường ' || (floor(random()*20+1))::int,
    (ARRAY['Quận 1','Quận 2','Quận 3','Quận 7','Bình Thạnh','Gò Vấp','Tân Bình','Thủ Đức'])[floor(random()*8)::int+1],
    (ARRAY['TP.HCM','Hà Nội','Đà Nẵng','Cần Thơ','Hải Phòng'])[floor(random()*5)::int+1],
    TRUE
FROM generate_series(1, 1000) AS g(i)
UNION ALL
SELECT
    floor(random()*1000+1)::int,
    'home',
    'Người nhận phụ ' || g.i,
    '09' || lpad((random()*99999999)::int::text,8,'0'),
    (g.i * 13 % 300 + 1)::text || ' Đường Phụ ' || g.i,
    'Phường ' || (floor(random()*20+1))::int,
    (ARRAY['Quận 4','Quận 5','Quận 6','Quận 8','Quận 9','Quận 10','Quận 11','Quận 12'])[floor(random()*8)::int+1],
    (ARRAY['TP.HCM','Hà Nội','Đà Nẵng','Cần Thơ'])[floor(random()*4)::int+1],
    FALSE
FROM generate_series(1, 500) AS g(i);


-- ============================================================
-- 5. COUPONS  (~50 rows)
-- ============================================================
CREATE TABLE coupons (
    coupon_id    SERIAL PRIMARY KEY,
    code         VARCHAR(30) NOT NULL UNIQUE,
    type         VARCHAR(20) CHECK (type IN ('percent','fixed')),
    value        NUMERIC(10,2) NOT NULL,
    min_order    NUMERIC(12,2) DEFAULT 0,
    max_uses     INT DEFAULT 100,
    used_count   INT DEFAULT 0,
    valid_from   DATE NOT NULL,
    valid_until  DATE NOT NULL,
    is_active    BOOLEAN DEFAULT TRUE
);

INSERT INTO coupons (code, type, value, min_order, max_uses, valid_from, valid_until)
SELECT
    'CODE' || lpad(g.i::text,3,'0'),
    (ARRAY['percent','fixed'])[floor(random()*2)::int+1],
    CASE WHEN random() < 0.5 THEN round((random()*30+5)::numeric,0)
         ELSE round((random()*200000+10000)::numeric,-3) END,
    round((random()*500000)::numeric,-3),
    (random()*500+10)::int,
    (NOW() - (random()*180)*INTERVAL '1 day')::date,
    (NOW() + (random()*180)*INTERVAL '1 day')::date
FROM generate_series(1,50) AS g(i);


-- ============================================================
-- 6. ORDERS  (~5.000 rows)
-- ============================================================
CREATE TABLE orders (
    order_id      SERIAL PRIMARY KEY,
    customer_id   INT NOT NULL REFERENCES customers(customer_id),
    address_id    INT REFERENCES addresses(address_id),
    coupon_id     INT REFERENCES coupons(coupon_id),
    status        VARCHAR(30) NOT NULL DEFAULT 'pending'
                      CHECK (status IN ('pending','confirmed','processing',
                                        'shipped','delivered','cancelled','refunded')),
    payment_method VARCHAR(30) CHECK (payment_method IN ('cod','bank_transfer','momo','vnpay','credit_card')),
    subtotal      NUMERIC(14,2) NOT NULL,
    discount      NUMERIC(14,2) DEFAULT 0,
    shipping_fee  NUMERIC(10,2) DEFAULT 30000,
    total         NUMERIC(14,2) NOT NULL,
    note          TEXT,
    created_at    TIMESTAMPTZ DEFAULT NOW(),
    updated_at    TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO orders (customer_id, address_id, coupon_id, status, payment_method,
                    subtotal, discount, shipping_fee, total, created_at)
SELECT
    floor(random()*1000+1)::int                     AS customer_id,
    floor(random()*1500+1)::int                     AS address_id,
    CASE WHEN random() < 0.2 THEN floor(random()*50+1)::int ELSE NULL END AS coupon_id,
    (ARRAY['pending','confirmed','processing','shipped','delivered','cancelled','refunded'])[
        floor(random()*7+1)::int]                   AS status,
    (ARRAY['cod','bank_transfer','momo','vnpay','credit_card'])[floor(random()*5+1)::int],
    0,   -- subtotal, sẽ cập nhật sau
    CASE WHEN random() < 0.2 THEN round((random()*100000)::numeric,-3) ELSE 0 END AS discount,
    (ARRAY[0, 15000, 25000, 30000, 40000])[floor(random()*5+1)::int]::numeric,
    0,   -- total, sẽ cập nhật sau
    NOW() - (random()*730)*INTERVAL '1 day'
FROM generate_series(1,5000) AS g(i);


-- ============================================================
-- 7. ORDER_ITEMS  (~15.000 rows – trung bình 3 items/đơn)
-- ============================================================
CREATE TABLE order_items (
    item_id      SERIAL PRIMARY KEY,
    order_id     INT NOT NULL REFERENCES orders(order_id),
    product_id   INT NOT NULL REFERENCES products(product_id),
    quantity     INT NOT NULL DEFAULT 1,
    unit_price   NUMERIC(12,2) NOT NULL,
    subtotal     NUMERIC(14,2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT
    o.order_id,
    floor(random()*500+1)::int                AS product_id,
    floor(random()*4+1)::int                  AS quantity,
    round((random()*4900+100)::numeric, 2)    AS unit_price
FROM orders o
CROSS JOIN generate_series(1, floor(random()*4+1)::int) AS g(i);


-- ============================================================
-- Cập nhật subtotal & total cho orders
-- ============================================================
UPDATE orders o
SET
    subtotal = agg.s,
    total    = GREATEST(agg.s - o.discount + o.shipping_fee, 0)
FROM (
    SELECT order_id, COALESCE(SUM(subtotal),0) AS s
    FROM order_items
    GROUP BY order_id
) agg
WHERE o.order_id = agg.order_id;


-- ============================================================
-- 8. REVIEWS  (~3.000 rows)
-- ============================================================
CREATE TABLE reviews (
    review_id    SERIAL PRIMARY KEY,
    product_id   INT NOT NULL REFERENCES products(product_id),
    customer_id  INT NOT NULL REFERENCES customers(customer_id),
    order_id     INT REFERENCES orders(order_id),
    rating       SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    title        VARCHAR(200),
    body         TEXT,
    is_verified  BOOLEAN DEFAULT FALSE,
    created_at   TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO reviews (product_id, customer_id, order_id, rating, title, body, is_verified, created_at)
SELECT
    floor(random()*500+1)::int                 AS product_id,
    floor(random()*1000+1)::int                AS customer_id,
    floor(random()*5000+1)::int                AS order_id,
    (ARRAY[1,2,3,4,4,4,5,5,5,5])[floor(random()*10+1)::int] AS rating,
    (ARRAY[
        'Sản phẩm tuyệt vời!',
        'Chất lượng ổn với giá tiền',
        'Giao hàng nhanh, hài lòng',
        'Sẽ mua lại lần sau',
        'Không như mong đợi',
        'Đóng gói cẩn thận',
        'Giá hơi cao nhưng chất lượng tốt',
        'Bình thường thôi',
        'Rất hài lòng!'
    ])[floor(random()*9+1)::int]               AS title,
    (ARRAY[
        'Mình dùng được 2 tuần, chất lượng khá ổn.',
        'Giao hàng đúng hẹn, sản phẩm đúng mô tả.',
        'Giá tốt, sẽ giới thiệu cho bạn bè.',
        'Mầu hơi khác ảnh nhưng chấp nhận được.',
        'Ship nhanh, đóng gói chắc chắn.',
        'Dùng thử thấy ổn, sẽ mua thêm.',
        'Hàng đẹp, đúng size.',
        NULL, NULL
    ])[floor(random()*9+1)::int]               AS body,
    random() < 0.7                             AS is_verified,
    NOW() - (random()*365)*INTERVAL '1 day'
FROM generate_series(1,3000) AS g(i);


-- ============================================================
-- INDEX gợi ý để luyện tập query nhanh hơn
-- ============================================================
CREATE INDEX idx_orders_customer   ON orders(customer_id);
CREATE INDEX idx_orders_status     ON orders(status);
CREATE INDEX idx_orders_created    ON orders(created_at DESC);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_prod  ON order_items(product_id);
CREATE INDEX idx_reviews_product   ON reviews(product_id);
CREATE INDEX idx_products_category ON products(category_id);
-- bài tập
-- câu 1: Lấy danh sách tất cả sản phẩm đang active và còn tồn kho > 0, hiển thị tên, giá, tồn kho. Sắp xếp theo giá giảm dần.
SELECT name,
price,
stock
FROM products
WHERE stock > 0
ORDER BY price DESC;
-- câu 2: Lấy tất cả đơn hàng của khách customer_id = 5, hiển thị order_id, status, total, created_at. Sắp xếp mới nhất lên đầu.
SELECT order_id, status, total, created_at
FROM orders 
WHERE customer_id = 5;
-- câu 3: Đếm tổng số đơn hàng theo từng status. Sắp xếp theo số lượng giảm dần.
SELECT status, SUM(order_id) AS total
FROM orders
GROUP BY status
ORDER BY total DESC;
-- câu 4: Tính giá trị đơn hàng trung bình theo từng payment_method. Chỉ tính đơn có trạng thái delivered.
SELECT status , payment_method, AVG(total) AS gia_tri_hang
FROM orders
GROUP BY  status, payment_method 
HAVING status = 'delivered';
-- câu 5: Tìm những khách hàng chưa bao giờ đặt đơn, trả về customer_id, full_name, email.
SELECT customer_id, full_name, email
FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM orders);

-- câu 6: Tìm 10 sản phẩm có tổng số lượng bán cao nhất (chỉ tính đơn delivered), hiển thị tên sản phẩm, danh mục, tổng số lượng bán, tổng doanh thu.
SELECT p.name, c.name,
SUM(oi.quantity) AS total,
SUM(oi.quantity*oi.unit_price) AS total_doanhthu
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
JOIN categories c ON c.category_id = p.category_id
WHERE o.status = 'delivered'
GROUP BY p.name, c.name
ORDER BY total DESC LIMIT 10;
-- câu 7: Thống kê theo từng tháng: số đơn thành công, tổng doanh thu, doanh thu trung bình/đơn. Chỉ lấy 12 tháng gần nhất, không tính đơn bị huỷ/hoàn.
SELECT DATE_TRUNC('month', created_at)::date AS thang_dat_don,
COUNT(*) AS so_don_thanh_cong,
SUM(total) AS tong_doanh_thu,
ROUND(AVG(total), 1) AS doanh_thu_tb
FROM orders 
WHERE status NOT IN ('cancelled','refunded') 
AND created_at >= NOW() - INTERVAL '12 months'
GROUP BY DATE_TRUNC('month', created_at)
ORDER BY thang_dat_don;
-- câu 8: Tính tổng chi tiêu của mỗi khách (đơn delivered), sau đó phân loại: VIP: >= 5.000.000đ, Loyal: 2.000.000đ – 4.999.999đ, Normal: < 2.000.000đ, Đếm số khách mỗi nhóm.
WITH customer_chitieu AS (
SELECT customer_id, 
SUM(total) AS tong_chitieu,
CASE 
	WHEN SUM(total) >= 5000000 THEN 'vip'
	WHEN SUM(total) >= 2000000 THEN 'loyal'
	ELSE 'normal'
END AS segment
FROM orders
WHERE status = 'delivered'
GROUP BY customer_id) 
SELECT segment,
COUNT(*) AS so_khach_hang,
AVG(tong_chitieu) AS chitieutb
FROM customer_chitieu
GROUP BY segment
ORDER BY chitieutb DESC;
-- câu 9: Tính tỷ lệ % đơn bị huỷ cho từng danh mục cấp 2 (có parent_id). Chỉ hiển thị danh mục có ít nhất 50 đơn.
SELECT cate.name, cate.parent_id ,
ROUND(100 * (COUNT(*) FILTER (WHERE o.status = 'cancelled')) / COUNT(*), 2) AS ti_le
FROM categories cate
JOIN products p ON p.category_id = cate.category_id
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id 
WHERE cate.parent_id = 2
GROUP BY cate.name, cate.parent_id;
-- cách đúng của bạn claude
SELECT cat.name,
       COUNT(DISTINCT o.order_id) AS total_orders,
       COUNT(DISTINCT o.order_id) FILTER (WHERE o.status = 'cancelled') AS cancelled,
       ROUND(100.0 * COUNT(DISTINCT o.order_id) FILTER (WHERE o.status = 'cancelled')
             / COUNT(DISTINCT o.order_id), 2) AS ti_le_huy_pct
FROM categories cat
JOIN products    p  ON p.category_id  = cat.category_id
JOIN order_items oi ON oi.product_id  = p.product_id
JOIN orders      o  ON o.order_id     = oi.order_id
WHERE cat.parent_id IS NOT NULL
GROUP BY cat.category_id, cat.name
HAVING COUNT(DISTINCT o.order_id) >= 50
ORDER BY ti_le_huy_pct DESC;

-- câu 10: Tìm các khách hàng có ít nhất 2 đơn hàng trong vòng 30 ngày liên tiếp bất kỳ. Trả về customer_id, full_name, số lần mua lặp.
-- câu 11: Tìm các sản phẩm có rating trung bình >= 4.5 nhưng số review từ 5–20 — đây là "hidden gem" chưa được nhiều người biết đến. Sắp xếp theo rating giảm dần.
-- câu 12: Xếp hạng sản phẩm theo doanh thu trong từng danh mục. Chỉ lấy top 3 mỗi danh mục. Hiển thị hạng, tên danh mục, tên sản phẩm, doanh thu.
-- câu 13: Tính % tăng trưởng doanh thu so với tháng trước (MoM Growth). Hiển thị tháng, doanh thu, doanh thu tháng trước, % tăng trưởng.
-- câu 14: Tính retention: trong số khách đăng ký tháng X, bao nhiêu % quay lại mua ít nhất 1 đơn trong tháng X+1?
-- câu 15: Tìm cặp sản phẩm thường được mua chung trong cùng 1 đơn hàng nhiều nhất (top 10 cặp). Đây là bài toán gợi ý "Mua kèm sản phẩm này".
-- câu 16: Tính doanh thu tích lũy (running total) theo từng ngày trong năm hiện tại. Hiển thị ngày, doanh thu ngày đó, và tổng tích lũy.
-- câu 17: Định nghĩa: Khách churned nếu đơn hàng cuối cùng cách đây > 90 ngày và họ đã từng mua ít nhất 2 đơn. Tính: Tổng số khách churned, Phân bổ theo tier (standard/silver/gold/platinum), Trung bình số ngày kể từ đơn cuối
-- câu 18: Phân tích hiệu quả coupon: So sánh đơn có dùng coupon vs không dùng coupon về: Giá trị đơn trung bình, Tỷ lệ đơn delivered thành công, Tổng discount đã phát ra, ROI ước tính (revenue - discount)
-- câu 19: Tính tốc độ bán trung bình mỗi ngày của từng sản phẩm (30 ngày qua), sau đó ước tính còn bao nhiêu ngày nữa hết hàng. Cảnh báo các sản phẩm: Tồn kho < 50 đơn vị VÀ, Sẽ hết hàng trong < 14 ngày, Sắp xếp theo ngày hết hàng tăng dần (cháy hàng sớm nhất lên đầu). 
-- câu 20: Đây là bài toán phân tích khách hàng chuẩn production tại các công ty e-commerce:
-- Tính R (Recency): số ngày kể từ đơn cuối (càng ít càng tốt)
-- Tính F (Frequency): tổng số đơn thành công
--Tính M (Monetary): tổng chi tiêu
-- Dùng NTILE(4) chia mỗi chiều thành 4 nhóm (1=tệ nhất, 4=tốt nhất), lưu ý R ngược: recency thấp → điểm cao
-- Tính rfm_score = r_score + f_score + m_score (3–12 điểm)
-- Phân loại segment:
-- Champions (11–12): Mua gần đây, thường xuyên, chi nhiều
-- Loyal (9–10): Khách trung thành
-- At Risk (6–8): Từng mua nhiều, lâu rồi không quay lại
-- Lost (3–5): Mất khách
-- Xuất ra bảng tổng hợp: segment, số khách, avg LTV, avg recency days.






