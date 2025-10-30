/* ---------- INSERT: USERS (50 ???) ---------- */
INSERT INTO dbo.[users] (username,email,[password],phone,[role])
SELECT v.username, v.email, 'P@ssw0rd!' AS [password], v.phone,
       CASE WHEN v.i IN (5,20,35,50) THEN 'admin' ELSE 'customer' END
FROM (VALUES
 ( 1,'user001','user001@example.com','060-101-1001'),
 ( 2,'user002','user002@example.com','061-108-1098'),
 ( 3,'user003','user003@example.com','062-115-1195'),
 ( 4,'user004','user004@example.com','063-122-1292'),
 ( 5,'user005','user005@example.com','064-129-1389'),
 ( 6,'user006','user006@example.com','065-136-1486'),
 ( 7,'user007','user007@example.com','066-143-1583'),
 ( 8,'user008','user008@example.com','067-150-1680'),
 ( 9,'user009','user009@example.com','068-157-1777'),
 (10,'user010','user010@example.com','069-164-1874'),
 (11,'user011','user011@example.com','070-171-1971'),
 (12,'user012','user012@example.com','071-178-1068'),
 (13,'user013','user013@example.com','072-185-1165'),
 (14,'user014','user014@example.com','073-192-1262'),
 (15,'user015','user015@example.com','074-199-1359'),
 (16,'user016','user016@example.com','075-206-1456'),
 (17,'user017','user017@example.com','076-213-1553'),
 (18,'user018','user018@example.com','077-220-1650'),
 (19,'user019','user019@example.com','078-227-1747'),
 (20,'user020','user020@example.com','079-234-1844'),
 (21,'user021','user021@example.com','080-241-1941'),
 (22,'user022','user022@example.com','081-248-1038'),
 (23,'user023','user023@example.com','082-255-1135'),
 (24,'user024','user024@example.com','083-262-1232'),
 (25,'user025','user025@example.com','084-269-1329'),
 (26,'user026','user026@example.com','085-276-1426'),
 (27,'user027','user027@example.com','086-283-1523'),
 (28,'user028','user028@example.com','087-290-1620'),
 (29,'user029','user029@example.com','088-297-1717'),
 (30,'user030','user030@example.com','089-204-1814'),
 (31,'user031','user031@example.com','090-211-1911'),
 (32,'user032','user032@example.com','091-218-1008'),
 (33,'user033','user033@example.com','092-225-1105'),
 (34,'user034','user034@example.com','093-232-1202'),
 (35,'user035','user035@example.com','094-239-1299'),
 (36,'user036','user036@example.com','095-246-1396'),
 (37,'user037','user037@example.com','096-253-1493'),
 (38,'user038','user038@example.com','097-260-1590'),
 (39,'user039','user039@example.com','098-267-1687'),
 (40,'user040','user040@example.com','099-274-1784'),
 (41,'user041','user041@example.com','060-281-1881'),
 (42,'user042','user042@example.com','061-288-1978'),
 (43,'user043','user043@example.com','062-295-1075'),
 (44,'user044','user044@example.com','063-202-1172'),
 (45,'user045','user045@example.com','064-209-1269'),
 (46,'user046','user046@example.com','065-216-1366'),
 (47,'user047','user047@example.com','066-223-1463'),
 (48,'user048','user048@example.com','067-230-1560'),
 (49,'user049','user049@example.com','068-237-1657'),
 (50,'user050','user050@example.com','069-244-1754')
) AS v(i,username,email,phone);

/* ---------- INSERT: CATALOG (50 ???) ---------- */
INSERT INTO dbo.catalog (seller_id,Imgs,name,description,price,status,listed_at,starts_at,ends_at)
SELECT
  v.i,
  'https://cdn.example.com/i'+RIGHT('000'+CAST(v.i AS varchar(3)),3)+'a.jpg'
  +'|'+'https://cdn.example.com/i'+RIGHT('000'+CAST(v.i AS varchar(3)),3)+'b.jpg',
  'Figure #'+RIGHT('000'+CAST(v.i AS varchar(3)),3),
  'Sample item '+RIGHT('000'+CAST(v.i AS varchar(3)),3),
  CAST(ROUND(100 + (v.i*10.50), 2) AS decimal(12,2)),
  CASE (v.i % 4) WHEN 0 THEN 'active' WHEN 1 THEN 'ended' WHEN 2 THEN 'sold' ELSE 'archived' END,
  SYSUTCDATETIME(),
  DATEADD(HOUR, -v.i, SYSUTCDATETIME()),
  DATEADD(DAY, (v.i % 7)+1, DATEADD(HOUR, -v.i, SYSUTCDATETIME()))
FROM (VALUES
 (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
 (11),(12),(13),(14),(15),(16),(17),(18),(19),(20),
 (21),(22),(23),(24),(25),(26),(27),(28),(29),(30),
 (31),(32),(33),(34),(35),(36),(37),(38),(39),(40),
 (41),(42),(43),(44),(45),(46),(47),(48),(49),(50)
) AS v(i);

/* ---------- INSERT: BID (50 ???) ---------- */
INSERT INTO dbo.bid (item_id,user_id,amount,bid_time)
SELECT
  v.i,
  ((v.i + 5 - 1) % 50) + 1,
  CAST(ROUND((100 + (v.i*10.50)) * 1.20, 2) AS decimal(12,2)),
  DATEADD(HOUR, 2, DATEADD(HOUR, -v.i, SYSUTCDATETIME()))
FROM (VALUES
 (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
 (11),(12),(13),(14),(15),(16),(17),(18),(19),(20),
 (21),(22),(23),(24),(25),(26),(27),(28),(29),(30),
 (31),(32),(33),(34),(35),(36),(37),(38),(39),(40),
 (41),(42),(43),(44),(45),(46),(47),(48),(49),(50)
) AS v(i);

/* ---------- INSERT: PURCHASE (50 ???) ---------- */
INSERT INTO dbo.purchase (item_id,buyer_id,total_amount,purchased_at)
SELECT
  v.i,
  ((v.i + 10 - 1) % 50) + 1,
  CAST(ROUND((100 + (v.i*10.50)) * 1.35, 2) AS decimal(12,2)),
  DATEADD(HOUR, 1, DATEADD(DAY, (v.i % 7)+1, DATEADD(HOUR, -v.i, SYSUTCDATETIME())))
FROM (VALUES
 (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
 (11),(12),(13),(14),(15),(16),(17),(18),(19),(20),
 (21),(22),(23),(24),(25),(26),(27),(28),(29),(30),
 (31),(32),(33),(34),(35),(36),(37),(38),(39),(40),
 (41),(42),(43),(44),(45),(46),(47),(48),(49),(50)
) AS v(i);

/* ---------- INSERT: PAYMENT (50 ???) ---------- */
INSERT INTO dbo.payment (purchase_id,method,amount,status,paid_date)
SELECT
  v.i,
  CASE (v.i % 3) WHEN 1 THEN 'card' WHEN 2 THEN 'bank' ELSE 'wallet' END,
  p.total_amount,
  CASE (v.i % 4) WHEN 1 THEN 'pending' WHEN 2 THEN 'success' WHEN 3 THEN 'failed' ELSE 'refunded' END,
  DATEADD(HOUR, 3, p.purchased_at)
FROM (VALUES
 (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
 (11),(12),(13),(14),(15),(16),(17),(18),(19),(20),
 (21),(22),(23),(24),(25),(26),(27),(28),(29),(30),
 (31),(32),(33),(34),(35),(36),(37),(38),(39),(40),
 (41),(42),(43),(44),(45),(46),(47),(48),(49),(50)
) AS v(i)
JOIN dbo.purchase AS p ON p.purchase_id = v.i;

COMMIT;