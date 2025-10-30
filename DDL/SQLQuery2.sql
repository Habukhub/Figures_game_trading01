/* ---------- DROP (?????) ---------- */
IF OBJECT_ID('dbo.payment')  IS NOT NULL DROP TABLE dbo.payment;
IF OBJECT_ID('dbo.purchase') IS NOT NULL DROP TABLE dbo.purchase;
IF OBJECT_ID('dbo.bid')      IS NOT NULL DROP TABLE dbo.bid;
IF OBJECT_ID('dbo.catalog')  IS NOT NULL DROP TABLE dbo.catalog;
IF OBJECT_ID('dbo.users')    IS NOT NULL DROP TABLE dbo.users;

/* ========== USERS ========== */
CREATE TABLE users (
    user_id    INT IDENTITY(1,1) NOT NULL,
    username   VARCHAR(100) NOT NULL,
    email      VARCHAR(100) NOT NULL,
    password   VARCHAR(100) NOT NULL,
    phone      VARCHAR(20),
    role VARCHAR(20) NOT NULL CHECK (role IN ('customer', 'admin')) DEFAULT 'customer',
    created_at DATETIME NOT NULL DEFAULT (GETUTCDATE()),
    PRIMARY KEY (user_id),
    UNIQUE (username),
    UNIQUE (email)
);



/* ========== CATALOG ========== */
CREATE TABLE catalog (
    item_id     INT IDENTITY(1,1) NOT NULL,
    seller_id   INT NOT NULL, 
    Imgs         VARCHAR(MAX) NOT NULL,
    name        VARCHAR(150) NOT NULL,
    description VARCHAR(MAX),
    price       DECIMAL(12,2) NOT NULL,
    status      VARCHAR(20) NOT NULL,   -- active|ended|sold|archived
    listed_at   DATETIME NOT NULL DEFAULT (GETUTCDATE()),
    starts_at   DATETIME NOT NULL,
    ends_at     DATETIME NOT NULL,
    PRIMARY KEY (item_id),
    FOREIGN KEY (seller_id) REFERENCES users(user_id)
);

/* ========== BID ========== */
CREATE TABLE bid (
    bid_id   INT IDENTITY(1,1) NOT NULL,
    item_id  INT NOT NULL,
    user_id  INT NOT NULL,
    amount   DECIMAL(12,2) NOT NULL,
    bid_time DATETIME NOT NULL DEFAULT (GETUTCDATE()),
    PRIMARY KEY (bid_id),
    FOREIGN KEY (item_id) REFERENCES catalog(item_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    
);

/* ========== PURCHASE ========== */
CREATE TABLE purchase (
    purchase_id  INT IDENTITY(1,1) NOT NULL,
    item_id      INT NOT NULL,
    buyer_id     INT NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    purchased_at DATETIME NOT NULL DEFAULT (GETUTCDATE()),
    PRIMARY KEY (purchase_id),
    FOREIGN KEY (item_id) REFERENCES catalog(item_id),
    FOREIGN KEY (buyer_id) REFERENCES users(user_id)
    -- ??????????? 1 item ????????????????: UNIQUE(item_id)
);

/* ========== PAYMENT ========== */
CREATE TABLE payment (
    payment_id  INT IDENTITY(1,1) NOT NULL,
    purchase_id INT NOT NULL,
    method      VARCHAR(30) NOT NULL,    -- card|bank|wallet...
    amount      DECIMAL(12,2) NOT NULL,
    status      VARCHAR(20) NOT NULL,    -- pending|success|failed|refunded
    paid_date   DATETIME NULL,
    PRIMARY KEY (payment_id),
    FOREIGN KEY (purchase_id) REFERENCES purchase(purchase_id)
);
