PRINT '=== USERS ===';
SELECT user_id, username, role, created_at FROM users ORDER BY user_id;

PRINT '=== CATALOG ===';
SELECT item_id, seller_id, name, price, status, listed_at, Imgs FROM catalog ORDER BY listed_at DESC;

PRINT '=== BIDS ===';
SELECT b.bid_id, b.item_id, c.name, b.user_id, u.username, b.amount, b.bid_time
FROM bid b
JOIN users u   ON b.user_id = u.user_id
JOIN catalog c ON b.item_id = c.item_id
ORDER BY b.bid_time DESC;

PRINT '=== PURCHASES ===';
SELECT p.purchase_id, p.item_id, c.name, p.buyer_id, u.username, p.total_amount, p.purchased_at
FROM purchase p
JOIN users u   ON p.buyer_id = u.user_id
JOIN catalog c ON p.item_id  = c.item_id
ORDER BY p.purchased_at DESC;

PRINT '=== PAYMENTS ===';
SELECT * FROM payment ORDER BY payment_id DESC;