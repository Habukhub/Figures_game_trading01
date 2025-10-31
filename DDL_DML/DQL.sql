-- 1) Active auctions with current top bid & time left
SELECT
    c.item_id, c.name, c.start_price,
    MAX(b.amount) AS top_bid,
    DATEDIFF(SECOND, GETUTCDATE(), c.ends_at) AS seconds_left
FROM dbo.Catalogs c
LEFT JOIN dbo.Bids b ON c.item_id = b.item_id
WHERE c.status = 'active'
GROUP BY c.item_id, c.name, c.start_price, c.ends_at;

-- 2) Top 5 heavy bidders by total
SELECT TOP 5 u.user_id, u.name,
       SUM(b.amount) AS total_bid_amount, COUNT(*) AS bid_count
FROM dbo.Bids b JOIN dbo.Users u ON b.bidder_id = u.user_id
GROUP BY u.user_id, u.name
ORDER BY total_bid_amount DESC;

-- 3) Active items with zero bids
SELECT c.item_id, c.name, c.start_price, c.ends_at
FROM dbo.Catalogs c
LEFT JOIN dbo.Bids b ON c.item_id = b.item_id
WHERE c.status = 'active'
GROUP BY c.item_id, c.name, c.start_price, c.ends_at
HAVING COUNT(b.bid_id) = 0;

-- 4) Purchase history with latest payment
SELECT p.purchase_id, c.name AS item_name, p.total_amount, p.purchase_at,
       pay.status AS payment_status, pay.amount AS payment_amount
FROM dbo.Purchases p
JOIN dbo.Catalogs c ON p.item_id = c.item_id
JOIN dbo.Users u ON p.buyer_id = u.user_id
LEFT JOIN dbo.Payments pay ON pay.purchase_id = p.purchase_id
WHERE u.email = 'alice@example.com'
ORDER BY p.purchase_at DESC;

-- 5) Daily revenue
SELECT CONVERT(date, p.purchase_at) AS purchase_date,
       SUM(p.total_amount) AS daily_revenue
FROM dbo.Purchases p
GROUP BY CONVERT(date, p.purchase_at)
ORDER BY purchase_date DESC;

-- 6) Start vs final price uplift
SELECT c.item_id, c.name, c.start_price,
       p.total_amount AS final_price,
       (p.total_amount - c.start_price) AS diff_amount,
       CASE WHEN c.start_price = 0 THEN NULL
            ELSE ((p.total_amount - c.start_price) / c.start_price) * 100.0
       END AS percent_increase
FROM dbo.Purchases p
JOIN dbo.Catalogs c ON p.item_id = c.item_id
ORDER BY percent_increase DESC;

-- 7) Item counts by status
SELECT c.status, COUNT(*) AS total_items
FROM dbo.Catalogs c
GROUP BY c.status;

-- 8) Latest bid per item
WITH x AS (
  SELECT b.*,
         ROW_NUMBER() OVER (PARTITION BY b.item_id ORDER BY b.bid_time DESC, b.bid_id DESC) rn
  FROM dbo.Bids b
)
SELECT x.item_id, x.bid_id, x.amount, x.bid_time, u.name AS bidder_name
FROM x JOIN dbo.Users u ON x.bidder_id = u.user_id
WHERE rn = 1;

-- 9) Items with >10 bids and still active
SELECT c.item_id, c.name, COUNT(b.bid_id) AS bid_count
FROM dbo.Catalogs c JOIN dbo.Bids b ON c.item_id = b.item_id
WHERE c.status = 'active'
GROUP BY c.item_id, c.name
HAVING COUNT(b.bid_id) > 10;

-- 10) Winner for an item_id (pure SQL)
DECLARE @item INT = 1;
WITH RankedBids AS (
  SELECT b.*,
         ROW_NUMBER() OVER (
            PARTITION BY b.item_id ORDER BY b.amount DESC, b.bid_time ASC
         ) AS rn
  FROM dbo.Bids b
  WHERE b.item_id = @item
)
SELECT rb.item_id, u.user_id AS winner_user_id, u.name AS winner_name,
       rb.amount AS winning_amount, rb.bid_time
FROM RankedBids rb
JOIN dbo.Users u ON rb.bidder_id = u.user_id
WHERE rb.rn = 1;