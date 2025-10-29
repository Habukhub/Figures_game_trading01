--------------------------------------------------------------------
-- ONE–SHOT DML SCRIPT (INSERT/UPDATE/DELETE EXAMPLES)
-- ใช้กับสคีมา users, catalog(Imgs), bid, purchase, payment
--------------------------------------------------------------------
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRAN;

--------------------------------------------------------------------
-- Q1) INSERT ผู้ใช้ 3 คน
--------------------------------------------------------------------
INSERT INTO users (username, email, password, phone, role)
VALUES 
 ('alice', 'alice@example.com', 'P@ssw0rd!', '081-111-1111', 'customer'),
 ('bob',   'bob@example.com',   'P@ssw0rd!', '082-222-2222', 'customer'),
 ('admin', 'admin@example.com', 'Admin#123', '083-333-3333', 'admin');

-- เก็บ user_id ไว้ใช้ต่อ
DECLARE @uid_alice INT = (SELECT user_id FROM users WHERE username='alice');
DECLARE @uid_bob   INT = (SELECT user_id FROM users WHERE username='bob');

--------------------------------------------------------------------
-- Q2) INSERT สินค้าประกาศขาย 2 รายการ (Imgs เก็บหลาย URL คั่นด้วย '|')
--------------------------------------------------------------------
INSERT INTO catalog (seller_id, Imgs, name, description, price, status)
VALUES
(@uid_alice,
 'https://cdn.example.com/figA1.jpg|https://cdn.example.com/figA2.jpg',
 'Figure A – Limited', 'สภาพดีมาก กล่องครบ', 1500.00, 'active'),
(@uid_bob,
 'https://cdn.example.com/figB1.jpg|https://cdn.example.com/figB2.jpg',
 'Figure B – Rare',    'หายาก มีตำหนินิดหน่อย', 2200.00, 'active');

-- เก็บ item_id ไว้ใช้ต่อ
DECLARE @itemA INT = (SELECT item_id FROM catalog WHERE name='Figure A – Limited');
DECLARE @itemB INT = (SELECT item_id FROM catalog WHERE name='Figure B – Rare');

--------------------------------------------------------------------
-- Q3) INSERT การยื่นบิด (bid) หลายรายการ
--------------------------------------------------------------------
-- bob บิดสินค้าของ alice
INSERT INTO bid (item_id, user_id, amount) VALUES (@itemA, @uid_bob,   1600.00);
INSERT INTO bid (item_id, user_id, amount) VALUES (@itemA, @uid_bob,   1750.00);

-- alice บิดสินค้าของ bob (สมมุติเปิดรับ)
INSERT INTO bid (item_id, user_id, amount) VALUES (@itemB, @uid_alice, 2300.00);

--------------------------------------------------------------------
-- Q4) ปิดดีล: อัปเดตสถานะสินค้า A เป็น 'sold' + บันทึก purchase ด้วยราคาบิดสูงสุด
--------------------------------------------------------------------
DECLARE @winner_id   INT = (
    SELECT TOP 1 user_id FROM bid WHERE item_id=@itemA ORDER BY amount DESC, bid_time ASC
);
DECLARE @win_amount  DECIMAL(12,2) = (
    SELECT TOP 1 amount  FROM bid WHERE item_id=@itemA ORDER BY amount DESC, bid_time ASC
);

UPDATE catalog
SET status = 'sold'
WHERE item_id = @itemA;

INSERT INTO purchase (item_id, buyer_id, total_amount)
VALUES (@itemA, @winner_id, @win_amount);

-- เก็บ purchase_id ของดีลล่าสุดไว้ทำ payment
DECLARE @purchase_id INT = SCOPE_IDENTITY();

--------------------------------------------------------------------
-- Q5) PAYMENT: ชำระสำเร็จ แล้วตัวอย่างเปลี่ยนสถานะเป็น refunded
--------------------------------------------------------------------
INSERT INTO payment (purchase_id, method, amount, status, paid_date)
VALUES (@purchase_id, 'bank', @win_amount, 'success', GETUTCDATE());

-- (ตัวอย่าง) ภายหลังเปลี่ยนเป็นคืนเงิน
UPDATE payment
SET status='refunded', paid_date=GETUTCDATE()
WHERE payment_id = (SELECT TOP 1 payment_id FROM payment WHERE purchase_id=@purchase_id ORDER BY payment_id DESC);

COMMIT;

--------------------------------------------------------------------
