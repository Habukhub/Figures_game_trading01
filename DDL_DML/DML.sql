/* ---------- INSERT: USERS (100 แถว) ---------- */
INSERT INTO dbo.[users] (username,email,[password],phone,[role])
SELECT v.username, v.email, 'P@ssw0rd!' AS [password], v.phone,
       CASE WHEN v.i IN (5,20,35,50,65,80,95,100) THEN 'admin' ELSE 'customer' END
FROM (
    SELECT n AS i,
           'user' + RIGHT('000'+CAST(n AS varchar(3)),3) AS username,
           'user' + RIGHT('000'+CAST(n AS varchar(3)),3) + '@example.com' AS email,
           '06' + RIGHT('0'+CAST((n%10)+1 AS varchar(2)),2) + '-' +
           RIGHT('000'+CAST((1000+n) AS varchar(4)),4) AS phone
    FROM (
        SELECT TOP (100) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
        FROM sys.objects
    ) AS x
) AS v;

/* ---------- INSERT: CATALOG (100 แถว) - inlined images from Models_pic.xlsx ---------- */
DECLARE @catalog_images TABLE (item_number INT PRIMARY KEY, Imgs NVARCHAR(MAX));

INSERT INTO @catalog_images (item_number, Imgs)
VALUES
    (1, N'https://imgs.search.brave.com/FFImtN6Y9Jg3nLAeMrHIVGzyDSur_pRoQBohL7yQS8o/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9jZG4x/MS5iaWdjb21tZXJj/ZS5jb20vcy04OWZm/ZC9pbWFnZXMvc3Rl/bmNpbC9vcmlnaW5h/bC9pbWFnZS1tYW5h/Z2VyL2ltYWdlLTUt/LmpwZz90PTE3MzQx/MTkwODI'),
(2, N'https://imgs.search.brave.com/oe-tnow0s38-a_xLjUj6Tb8kmHIykPo09p7wt4OPBPo/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tLm1l/ZGlhLWFtYXpvbi5j/b20vaW1hZ2VzL0kv/NjF5QmNvcEgyeUwu/anBn'),
(3, N'https://imgs.search.brave.com/xQNh1T19wmwmuQKFUlMbtRYp7f0UZc4R-LvFNj12jKk/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tLm1l/ZGlhLWFtYXpvbi5j/b20vaW1hZ2VzL0kv/NTFPUEtaWDl1OEwu/anBn'),
(4, N'https://imgs.search.brave.com/1kMP0v21KlRoditdYGdeAwXp-wZlcS4C0nBgo2RbxZc/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9wb2dn/ZXJzLmNvbS9jZG4v/c2hvcC9maWxlcy9C/bGFjay1DbG92ZXIt/V2lsbGlhbS1WYW5n/ZWFuY2UtRmlndXJl/LTRfOS1GdW5rby1Q/b3AtQW5pbWF0aW9u/LVNlcmllcy0xNzE4/LTJfNTEyeDUxMi53/ZWJwP3Y9MTc1MjIz/MzkzMA'),
(5, N'https://imgs.search.brave.com/wdBaxHT4qVTa2En8NIeJ20DjC6fYfYSgb7j4eJki6T8/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9wb2dn/ZXJzLmNvbS9jZG4v/c2hvcC9maWxlcy9C/bGFjay1DbG92ZXIt/WXVuby1GaWd1cmUt/RnVua28tUE9QLUFu/aW1hdGlvbi1TZXJp/ZXMtMTEwMS0yXzUx/Mng1MTIud2VicD92/PTE3MzE0OTgxMzg'),
(6, N'https://imgs.search.brave.com/Jzb_9kvjgSiF5Y4lTjFcWxWjM0HXZ8-H7kKqtkBGESM/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9jMS5u/ZXdlZ2dpbWFnZXMu/Y29tL3Byb2R1Y3Rp/bWFnZS9uYjMwMC84/Ni03MzEtMjI3LTAx/LnBuZw'),
(7, N'https://imgs.search.brave.com/-lz94F5E2W8p6uj3NH3mQ9AhgB9gENIY5zxDNqGrKP8/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9mdW5r/by5jb20vZHcvaW1h/Z2UvdjIvQkdUU19Q/UkQvb24vZGVtYW5k/d2FyZS5zdGF0aWMv/LS9TaXRlcy1mdW5r/by1tYXN0ZXItY2F0/YWxvZy9kZWZhdWx0/L2R3ODk2YzhhYTEv/aW1hZ2VzL2Z1bmtv/L3VwbG9hZC8xLzg4/Mjk5X09QX1MxMl9M/dWZmeU1UX1BPUF9Q/TFVTX0dMQU0tV0VC/LnBuZz9zdz0zNDYm/c2g9MzQ2'),
(8, N'https://imgs.search.brave.com/CJ4bZcFqx55XrtVpQOPjmPXTyEn3hGCZcAbCycRODs0/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly93d3cu/dG95c2huaXAuY29t/L2Nkbi9zaG9wL2Zp/bGVzL2ludmluY2li/bGUtZGVsdXhlLWFj/dGlvbi1maWd1cmUt/c2VsZWN0LWZpZ3Vy/ZXMtZGlhbW9uZC1z/ZWxlY3QtdG95c2hu/aXAtMzE1NTgzLmpw/Zz9mb3JtYXQ9d2Vi/cCZ2PTE3NDExMzU5/NjEmd2lkdGg9MTAw/MA'),
(9, N'https://imgs.search.brave.com/wPMhHac08dH6ndrXhwfxniXySb3igo0-YXa_JSAH6Fs/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tLm1l/ZGlhLWFtYXpvbi5j/b20vaW1hZ2VzL0kv/NjEydk8yelBtMkwu/anBn'),
(10, N'https://imgs.search.brave.com/LGlnFg5gdlVKgvw5JvmfUAEHw9iFuQ1n2cAbNPTTPm8/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9wcmV2/aWV3LnJlZGQuaXQv/YnV5aW5nLWZpZ3Vy/ZXMtZnJvbS1zaG93/cy1nYW1lcy15b3Ut/ZG9udC13YXRjaC1w/bGF5LXYwLWllZGZw/aHF3aDllZDEucG5n/P3dpZHRoPTY0MCZj/cm9wPXNtYXJ0JmF1/dG89d2VicCZzPTc5/MjRjZTMxYmFkZmEx/OTBkM2Y2NjI1NTA0/ZjQxY2I2ZTdjMzMy/MTU'),
(11, N'https://imgs.search.brave.com/IfrdH2juD39-CDxqO6RhGBifmtFuuOo4hs2T457-T5w/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YTMubmluLW5pbi1n/YW1lLmNvbS80ODM5/OTgtcG9zX3Byb2R1/Y3QvZmlnbWEtNjQz/LW5pZXItYXV0b21h/dGEtdmVyLTExYS0y/Yi15b3JoYS1ubzIt/dHlwZS1iLWdvb2Qt/c21pbGUtY29tcGFu/eS0uanBn'),
(12, N'https://images.bigbadtoystore.com/images/p/full/2025/10/764f7b97-73e7-4977-a210-089e7d31d26e.jpg'),
(13, N'https://images.bigbadtoystore.com/images/p/full/2025/10/cd9ff239-552c-4a7f-ad3d-c79738ee8bd0.jpg'),
(14, N'https://images.bigbadtoystore.com/images/p/full/2025/10/b7ce94e1-d80b-4406-b218-13a911955c24.jpg'),
(15, N'https://www.sideshow.com/cdn-cgi/image/height=850,quality=90,f=auto/https://www.sideshow.com/storage/product-images/913936/tamashii-nations-macross-tornado-messiah-valkyrie-alto-saotome-use-revival-ver-action-figure-gallery-672916647719e.jpg'),
(16, N'https://i.pinimg.com/1200x/54/cc/05/54cc05aa29325c39850ade0c123f5aec.jpg'),
(17, N'https://i.pinimg.com/736x/08/30/3e/08303e5341b4d4ebbf7bbfade17afce2.jpg'),
(18, N'https://i.pinimg.com/1200x/b3/4b/05/b34b05c87cdf0f971453868c3f499080.jpg'),
(19, N'https://i.pinimg.com/1200x/58/77/4f/58774f621432b27b27af9ade6b96e568.jpg'),
(20, N'https://i.pinimg.com/1200x/b8/86/cf/b886cf7a3f91fdac9d3143b0de3b808a.jpg'),
(21, N'https://i.pinimg.com/1200x/52/64/f7/5264f7960a09d302d9885affa44285fb.jpg'),
(22, N'https://i.pinimg.com/1200x/e5/b0/a2/e5b0a22631fc313a9e493236181edc16.jpg'),
(23, N'https://i.pinimg.com/736x/20/a0/b3/20a0b38177fdc570c07c4c4a42060337.jpg'),
(24, N'https://i.pinimg.com/1200x/f3/75/3b/f3753b560d4a9cbc8f0aba8a29b9fa4f.jpg'),
(25, N'https://i.pinimg.com/736x/97/3c/29/973c29e724cf734cf594769e1ff8c3ec.jpg'),
(26, N'https://i.pinimg.com/1200x/60/c5/26/60c5269d70207ddd9c726aad273de480.jpg'),
(27, N'https://i.pinimg.com/1200x/61/49/a8/6149a8977b4365b9f6c1ae8ef673606b.jpg'),
(28, N'https://i.pinimg.com/1200x/3e/56/99/3e569994515865576a94a5614285e96c.jpg'),
(29, N'https://i.pinimg.com/736x/2d/8c/0e/2d8c0e28035e7c5068f159d5996741e8.jpg'),
(30, N'https://i.pinimg.com/736x/e1/c3/36/e1c3360cb5d3bf1e8c3e6d748e584388.jpg'),
(31, N'https://i.pinimg.com/736x/99/9a/5a/999a5afa9bc351554a5effba1d4daf0d.jpg'),
(32, N'https://i.pinimg.com/736x/82/35/33/823533e879e31c3e763f8b1e677f018b.jpg'),
(33, N'https://i.pinimg.com/1200x/b4/09/d5/b409d5db96422774b59c0884644df024.jpg'),
(34, N'https://i.pinimg.com/736x/34/71/d6/3471d6abd82589fa3dbcf3be60af04a9.jpg'),
(35, N'https://i.pinimg.com/1200x/35/3f/83/353f83b6ba969030e4e5ea74cc6f5fe2.jpg'),
(36, N'https://i.pinimg.com/736x/5c/d3/ea/5cd3eaa019ccc1a2619a4bb992abc8a6.jpg'),
(37, N'https://i.pinimg.com/736x/e7/c0/98/e7c098748b9b1904a760b6eea6823dc9.jpg'),
(38, N'https://i.pinimg.com/736x/87/50/a8/8750a8ad700a3a3f121c95fd3cc6c815.jpg'),
(39, N'https://i.pinimg.com/1200x/f4/f8/2c/f4f82cff5ee0fb3ef981f7dadcf61cd0.jpg'),
(40, N'https://i.pinimg.com/1200x/d0/03/d3/d003d37e342616da4ae23ec4e4131e09.jpg'),
(41, N'https://i.pinimg.com/736x/de/cd/09/decd09824cbbbf56ccba0dba5c84348b.jpg'),
(42, N'https://i.pinimg.com/1200x/8e/dc/98/8edc980d7683dcd372b9db722f0977a0.jpg'),
(43, N'https://i.pinimg.com/736x/4a/0c/72/4a0c72759298e0948c849445fc0db69a.jpg'),
(44, N'https://i.pinimg.com/736x/5e/87/de/5e87de6e4b0d2963f5dd5b55f73a68ca.jpg'),
(45, N'https://i.pinimg.com/736x/8d/66/b0/8d66b0d0181e04ddd64366584700ceeb.jpg'),
(46, N'https://i.pinimg.com/1200x/86/10/aa/8610aae26a903617a78c90df6a054962.jpg'),
(47, N'https://i.pinimg.com/736x/48/c9/e9/48c9e90e51b55fda76244abdd3f58de7.jpg'),
(48, N'https://i.pinimg.com/1200x/65/5f/9e/655f9ea3f4a1bf36bdaaaf9aa986404f.jpg'),
(49, N'https://i.pinimg.com/1200x/5f/aa/2c/5faa2c371e64db7ab0e9b28f095c413e.jpg'),
(50, N'https://i.pinimg.com/1200x/ae/7b/9e/ae7b9ebc270ec2f8732c576387150cd1.jpg'),
(51, N'https://i.pinimg.com/1200x/85/73/2b/85732b284daa9ec45f2d613e828644cf.jpg'),
(52, N'https://i.pinimg.com/1200x/db/01/48/db01482628b8bbea302dc4c72a7c46c9.jpg'),
(53, N'https://i.pinimg.com/736x/92/3e/dc/923edc2c4f6314a6350e8146ff4525fd.jpg'),
(54, N'https://i.pinimg.com/736x/5e/c6/bb/5ec6bbfc38565659e8751cdbac844e01.jpg'),
(55, N'https://i.pinimg.com/1200x/f5/da/93/f5da93216eb024ce83faa6617b1acc2f.jpg'),
(56, N'https://i.pinimg.com/1200x/0c/af/46/0caf462fd7fb8e9d5b1afe17a21937b4.jpg'),
(57, N'https://i.pinimg.com/1200x/ea/2e/5e/ea2e5e69eaeb5a2b9f89c6de6e661608.jpg'),
(58, N'https://i.pinimg.com/1200x/6a/60/0f/6a600fc528564e54e0935cd7421e7c3e.jpg'),
(59, N'https://i.pinimg.com/1200x/d0/c2/ef/d0c2ef69f17afabd172fb6dd96dfebf2.jpg'),
(60, N'https://i.pinimg.com/1200x/7f/1d/ae/7f1daeb38c0fbba446cb496f06b270d8.jpg'),
(61, N'https://i.pinimg.com/736x/2e/24/6c/2e246c1d9e4dba490214b56b9ed1e16e.jpg'),
(62, N'https://i.pinimg.com/1200x/2b/a6/5b/2ba65b6936f76006f5d69227aa5bbfc1.jpg'),
(63, N'https://i.pinimg.com/1200x/3e/dd/74/3edd74e9eb8c24898911351b939ac012.jpg'),
(64, N'https://i.pinimg.com/1200x/85/73/2b/85732b284daa9ec45f2d613e828644cf.jpg'),
(65, N'https://i.pinimg.com/736x/86/85/b0/8685b069266f200ed5be9a8f09fe200e.jpg'),
(66, N'https://i.pinimg.com/1200x/b7/54/d4/b754d401599bc6e3105274845483d365.jpg'),
(67, N'https://i.pinimg.com/1200x/cb/aa/5a/cbaa5a38d95ac188f604befa37042d39.jpg'),
(68, N'https://i.pinimg.com/1200x/7c/76/16/7c761697c768ef998a88912043157144.jpg'),
(69, N'https://i.pinimg.com/1200x/ea/8c/2d/ea8c2deb8f37106f33c41e217a5fcdb9.jpg'),
(70, N'https://i.pinimg.com/736x/b7/50/1f/b7501f0ee04aca04b70aee1a7c3f896a.jpg'),
(71, N'https://i.pinimg.com/1200x/f2/92/36/f29236c51cf1409bbaf184963d14d0e0.jpg'),
(72, N'https://i.pinimg.com/736x/88/8c/75/888c75b9ae931657c5a74ada707e3946.jpg'),
(73, N'https://i.pinimg.com/1200x/1d/ad/4b/1dad4b33ad608a70878cabfa3a8faa9e.jpg'),
(74, N'https://i.pinimg.com/1200x/6a/e5/35/6ae5353c1ad5f4b17765eebdce55cb8f.jpg'),
(75, N'https://i.pinimg.com/1200x/de/aa/9d/deaa9d8d98ac72ec91b5c4bfc5d175ec.jpg'),
(76, N'https://i.pinimg.com/736x/58/b2/6c/58b26c13ac12f81ba897d88d9e71369b.jpg'),
(77, N'https://i.pinimg.com/1200x/2c/1c/b9/2c1cb9815d240d9ce279f0fd6421a6f4.jpg'),
(78, N'https://i.pinimg.com/1200x/aa/c4/50/aac450872e984e2f2d2387573d897f3e.jpg'),
(79, N'https://i.pinimg.com/1200x/3f/39/98/3f3998ca3a91ec2e2d65fc0768c64942.jpg'),
(80, N'https://i.pinimg.com/1200x/2f/21/0d/2f210d4d78ceeea5a12dd3fd4fafaab7.jpg'),
(81, N'https://i.pinimg.com/1200x/07/ca/83/07ca8371023ab1c594b154523de09417.jpg'),
(82, N'https://i.pinimg.com/1200x/25/f8/34/25f83438344791e21b64f8801cc83f0e.jpg'),
(83, N'https://i.pinimg.com/1200x/a1/f4/18/a1f418b8226e24722415ae4d68af5f7a.jpg'),
(84, N'https://i.pinimg.com/1200x/5d/e2/0e/5de20e804d6bc00f3f18843a78228c13.jpg'),
(85, N'https://i.pinimg.com/1200x/86/b0/20/86b0207346bf810d66cded3c79a8abb0.jpg'),
(86, N'https://i.pinimg.com/1200x/5f/3d/39/5f3d3960d880a85fb8b719f833172dc9.jpg'),
(87, N'https://i.pinimg.com/1200x/6b/b0/24/6bb024b2a1db136760cf5bcc97b4caf4.jpg'),
(88, N'https://i.pinimg.com/474x/50/85/07/50850779b2a97b86ba1d2cc121102ebc.jpg'),
(89, N'https://kumagameshop.com/cdn/shop/files/O1CN01JWVttW1fEbCxWRR9j__3249253975.jpg?v=1690622147&width=990'),
(90, N'https://i.pinimg.com/1200x/ad/f7/3e/adf73e0e8a3a3ea879cda6ae255e578d.jpg'),
(91, N'https://i.pinimg.com/736x/f2/fb/0a/f2fb0af417b3f25f050c561884a9a1a4.jpg'),
(92, N'https://i.pinimg.com/1200x/f7/31/e7/f731e7b9e2fe0b52141732b845ad9268.jpg'),
(93, N'https://i.pinimg.com/736x/67/9c/6b/679c6bf5ccdceb1fec7b846c9c9c4cca.jpg'),
(94, N'https://i.pinimg.com/1200x/e4/89/96/e48996b196ff54b3091a5630c199c410.jpg'),
(95, N'https://i.pinimg.com/1200x/ce/7a/05/ce7a0550968e3c93833312d48c715990.jpg'),
(96, N'https://i.pinimg.com/1200x/55/3c/31/553c31d25d8a9399b2b1e23031037653.jpg'),
(97, N'https://i.pinimg.com/1200x/12/7a/64/127a64809cf7b27dcabc34abfbadcd3f.jpg'),
(98, N'https://i.pinimg.com/1200x/31/c3/57/31c35794bac51aa66adec1390d878b12.jpg'),
(99, N'https://i.pinimg.com/736x/2d/8c/0e/2d8c0e28035e7c5068f159d5996741e8.jpg'),
(100, N'https://i.pinimg.com/1200x/2f/21/0d/2f210d4d78ceeea5a12dd3fd4fafaab7.jpg')
;

INSERT INTO dbo.catalog (seller_id,Imgs,name,description,price,status,listed_at,starts_at,ends_at)
SELECT
  v.i,
  COALESCE(ci.Imgs,
    'https://cdn.example.com/i' + RIGHT('000' + CAST(v.i AS varchar(3)),3) + 'a.jpg'
    + '|' +
    'https://cdn.example.com/i' + RIGHT('000' + CAST(v.i AS varchar(3)),3) + 'b.jpg'
  ) AS Imgs,
  'Figure #' + RIGHT('000' + CAST(v.i AS varchar(3)),3) AS name,
  'Sample item ' + RIGHT('000' + CAST(v.i AS varchar(3)),3) AS description,
  CAST(ROUND(100 + (v.i*10.50), 2) AS decimal(12,2)) AS price,
  CASE (v.i % 4) WHEN 0 THEN 'active' WHEN 1 THEN 'ended' WHEN 2 THEN 'sold' ELSE 'archived' END AS status,
  SYSUTCDATETIME() AS listed_at,
  DATEADD(HOUR, -v.i, SYSUTCDATETIME()) AS starts_at,
  DATEADD(DAY, (v.i % 7)+1, DATEADD(HOUR, -v.i, SYSUTCDATETIME())) AS ends_at
FROM (
    SELECT TOP (100) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS i
    FROM sys.objects
) AS v
LEFT JOIN @catalog_images ci ON ci.item_number = v.i;


/* ---------- INSERT: BID (100 แถว) ---------- */
INSERT INTO dbo.bid (item_id,user_id,amount,bid_time)
SELECT
  v.i,
  ((v.i + 5 - 1) % 100) + 1,
  CAST(ROUND((100 + (v.i*10.50)) * 1.20, 2) AS decimal(12,2)),
  DATEADD(HOUR, 2, DATEADD(HOUR, -v.i, SYSUTCDATETIME()))
FROM (
    SELECT TOP (100) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS i
    FROM sys.objects
) AS v;

/* ---------- INSERT: PURCHASE (100 แถว) ---------- */
INSERT INTO dbo.purchase (item_id,buyer_id,total_amount,purchased_at)
SELECT
  v.i,
  ((v.i + 10 - 1) % 100) + 1,
  CAST(ROUND((100 + (v.i*10.50)) * 1.35, 2) AS decimal(12,2)),
  DATEADD(HOUR, 1, DATEADD(DAY, (v.i % 7)+1, DATEADD(HOUR, -v.i, SYSUTCDATETIME())))
FROM (
    SELECT TOP (100) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS i
    FROM sys.objects
) AS v;

/* ---------- INSERT: PAYMENT (100 แถว) ---------- */
INSERT INTO dbo.payment (purchase_id,method,amount,status,paid_date)
SELECT
  v.i,
  CASE (v.i % 3) WHEN 1 THEN 'card' WHEN 2 THEN 'bank' ELSE 'wallet' END,
  p.total_amount,
  CASE (v.i % 4) WHEN 1 THEN 'pending' WHEN 2 THEN 'success' WHEN 3 THEN 'failed' ELSE 'refunded' END,
  DATEADD(HOUR, 3, p.purchased_at)
FROM (
    SELECT TOP (100) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS i
    FROM sys.objects
) AS v
JOIN dbo.purchase AS p ON p.purchase_id = v.i;

COMMIT;