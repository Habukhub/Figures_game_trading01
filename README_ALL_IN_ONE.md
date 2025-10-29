# All-in-One README — Figure Auction System

**Generated:** 2025-10-29 09:28

This single README bundles:
- Per-file README for all 13 files
- Global README (overview)
- System Analysis & Design (scope, ERD, relational schema/3NF)
- Database scripts (DDL) and DML samples/guidance
- 10 complex SQL queries
- Simple UI guide & How to run locally


## Project Structure & Presence Check

- **HomePage.html** ✅
- **Login.html** ✅
- **Register.html** ✅
- **Catalogs.html** ✅
- **Bidding.html** ✅
- **History.html** ✅
- **AddProduct.html** ✅
- **EditProduct.html** ✅
- **Admin.html** ✅
- **dataContract.cs** ✅
- **IdbService.cs** ✅
- **dbService.svc** ✅
- **dbService.svc.cs** ✅



## File-by-File README (13)

### Frontend

**1) HomePage.html**
- Role: Landing page; public.
- Links: Login / Register.
- Notes: Pure UI; no service calls expected.

**2) Login.html**
- Role: Sign in.
- Flow: POST credentials → store `email/role/username` in `localStorage` → redirect by role.
- Security: Always re-check on server.

**3) Register.html**
- Role: Sign up new users.
- Flow: POST register payload; success → go to Login.

**4) Catalogs.html**
- Role: Browse all items.
- Service: GET list-view with current top bid.
- UI: Bootstrap cards; admin menu toggled by localStorage.role.

**5) Bidding.html**
- Role: One item page & place bid.
- Service: GET item detail; POST bid; POST close-expired (optional).
- Logic: bid must be greater than current top.

**6) History.html**
- Role: My purchases.
- Service: GET purchases by my email.

**7) AddProduct.html**
- Role: Admin creates new catalog.
- Service: POST create (`AddProductDto`).

**8) EditProduct.html**
- Role: Admin edits existing item.
- Service: GET detail; POST/PUT update (`UpdateCatalogDto`).

**9) Admin.html**
- Role: Admin dashboard (list, modal edit, delete, force-close).
- Service: list, update, delete.

### Service / Contracts

**10) dataContract.cs**
- DTOs / View Models: Users, RegisterDto, LoginDto, AddProductDto, UpdateCatalogDto, BidDto, PlaceBidResult, CatalogView, PurchaseView, etc.

**11) IdbService.cs**
- WCF contract; `[WebInvoke]/[WebGet]` endpoints; JSON BodyStyle Bare.

**12) dbService.svc**
- WCF endpoint host; points to service class (IIS/IIS Express).

**13) dbService.svc.cs**
- Implements business logic & data access via LINQ to SQL:
  - Login/Role lookup
  - Catalog list/detail
  - PlaceBid (validate > top)
  - CloseExpiredAuctions → create purchase/payment
  - Admin CRUD and deletes


## API Endpoints (extracted from `IdbService.cs`)

- **GET** `catalog`  →  `Catalog[] GetCatalog()`  *(via [WebInvoke])*
- **GET** `payment`  →  `Payment[] GetPayment()`  *(via [WebInvoke])*
- **GET** `users`  →  `Users[] GetUsers()`  *(via [WebInvoke])*
- **GET** `bid/by-item/{itemId}`  →  `Bid[] GetBidsByItem(string itemId)`  *(via [WebInvoke])*
- **GET** `purchase`  →  `Purchase[] GetPurchase()`  *(via [WebInvoke])*
- **POST** `users`  →  `string CreateUser(RegisterDto req)`  *(via [WebInvoke])*
- **POST** `login`  →  `string Login(LoginDto req)`  *(via [WebInvoke])*
- **GET** `user/role-by-email/{email}`  →  `string GetRoleByEmail(string email)`  *(via [WebInvoke])*
- **POST** `catalog`  →  `string CreateCatalog(AddProductDto req)`  *(via [WebInvoke])*
- **GET** `catalog/list-view`  →  `CatalogView[] GetCatalogListView()`  *(via [WebInvoke])*
- **GET** `catalog/{id}/view`  →  `CatalogView GetCatalogByIdView(string id)`  *(via [WebInvoke])*
- **POST** `bid`  →  `PlaceBidResult PlaceBid(BidDto req)`  *(via [WebInvoke])*
- **POST** `auction/close-expired`  →  `string CloseExpiredAuctions()`  *(via [WebInvoke])*
- **GET** `history/my-purchases/{email}`  →  `Figures_game_trading01.PurchaseView[] GetMyPurchases(string email)`  *(via [WebInvoke])*
- **GET** `catalog/{id}`  →  `Catalog GetCatalogById(string id)`  *(via [WebInvoke])*
- **POST** `UpdateCatalog`  →  `string UpdateCatalog(UpdateCatalogDto req)`  *(via [WebInvoke])*
- **POST** `catalog/update`  →  `string UpdateCatalogAlt(UpdateCatalogDto req)`  *(via [WebInvoke])*
- **POST** `catalog/close/{id}`  →  `string CloseCatalog(string id)`  *(via [WebInvoke])*
- **POST** `catalog/delete/{id}`  →  `string DeleteCatalog(string id)`  *(via [WebInvoke])*


### HTML fetch() diagnostics

- **HomePage.html**: fetch() calls = 0, `new URL(...)` defs = 0
- **Login.html**: fetch() calls = 3, `new URL(...)` defs = 1
- **Register.html**: fetch() calls = 1, `new URL(...)` defs = 1
- **Catalogs.html**: fetch() calls = 2, `new URL(...)` defs = 1
- **Bidding.html**: fetch() calls = 3, `new URL(...)` defs = 1
- **History.html**: fetch() calls = 1, `new URL(...)` defs = 1
- **AddProduct.html**: fetch() calls = 2, `new URL(...)` defs = 2
- **EditProduct.html**: fetch() calls = 2, `new URL(...)` defs = 1
- **Admin.html**: fetch() calls = 3, `new URL(...)` defs = 2



## System Analysis & Design

### Functional Scope
- Auth: register, login, role.
- Auction: list, per-item, place bid, server validation, close auctions.
- Admin: create/update/delete items; force close; status review.
- History: show purchases and payments.

### ER Diagram
```mermaid
erDiagram

    USERS ||--o{ CATALOGS : "creates (admin/seller)"
    USERS ||--o{ BIDS : "places"
    USERS ||--o{ PURCHASES : "wins/buys"

    CATALOGS ||--o{ BIDS : "is bidded on"
    CATALOGS ||--o{ PURCHASES : "is sold as"

    PURCHASES ||--o{ PAYMENTS : "paid by"

    USERS {
        int user_id PK
        string name
        string email UNIQUE
        string password_hash
        string phone
        string role
        datetime created_at
    }

    CATALOGS {
        int item_id PK
        int seller_id FK -> USERS.user_id
        string name
        decimal start_price
        string imgs
        string status
        datetime created_at
        datetime ends_at
    }

    BIDS {
        int bid_id PK
        int item_id FK -> CATALOGS.item_id
        int bidder_id FK -> USERS.user_id
        decimal amount
        datetime bid_time
    }

    PURCHASES {
        int purchase_id PK
        int item_id FK -> CATALOGS.item_id
        int buyer_id FK -> USERS.user_id
        decimal total_amount
        datetime purchase_at
    }

    PAYMENTS {
        int payment_id PK
        int purchase_id FK -> PURCHASES.purchase_id
        string method
        decimal amount
        string status
        datetime paid_date
    }
```

### Relational Schema (3NF)
- USERS(user_id PK, name, email UNIQUE, password_hash, phone, role CHECK('admin','user'), created_at)
- CATALOGS(item_id PK, seller_id FK→USERS, name, start_price, imgs, status CHECK('active','ended','sold','archived'), created_at, ends_at)
- BIDS(bid_id PK, item_id FK→CATALOGS, bidder_id FK→USERS, amount, bid_time)
- PURCHASES(purchase_id PK, item_id FK→CATALOGS, buyer_id FK→USERS, total_amount, purchase_at)
- PAYMENTS(payment_id PK, purchase_id FK→PURCHASES, method, amount, status CHECK('pending','success','failed','refunded'), paid_date)

### Database Scripts

#### DDL (CREATE TABLE)
```sql
CREATE TABLE dbo.Users (
    user_id       INT IDENTITY(1,1) PRIMARY KEY,
    name          NVARCHAR(100) NOT NULL,
    email         NVARCHAR(150) NOT NULL UNIQUE,
    password_hash NVARCHAR(200) NOT NULL,
    phone         NVARCHAR(20) NULL,
    role          NVARCHAR(20) NOT NULL
                  CHECK (role IN ('admin','user')),
    created_at    DATETIME NOT NULL DEFAULT (GETUTCDATE())
);

CREATE TABLE dbo.Catalogs (
    item_id      INT IDENTITY(1,1) PRIMARY KEY,
    seller_id    INT NOT NULL,
    name         NVARCHAR(200) NOT NULL,
    start_price  DECIMAL(12,2) NOT NULL,
    imgs         NVARCHAR(MAX) NULL,
    status       NVARCHAR(20) NOT NULL
                 CHECK (status IN ('active','ended','sold','archived')),
    created_at   DATETIME NOT NULL DEFAULT (GETUTCDATE()),
    ends_at      DATETIME NOT NULL,
    CONSTRAINT FK_Catalogs_Users
        FOREIGN KEY (seller_id) REFERENCES dbo.Users(user_id)
);

CREATE TABLE dbo.Bids (
    bid_id    INT IDENTITY(1,1) PRIMARY KEY,
    item_id   INT NOT NULL,
    bidder_id INT NOT NULL,
    amount    DECIMAL(12,2) NOT NULL,
    bid_time  DATETIME NOT NULL DEFAULT (GETUTCDATE()),
    CONSTRAINT FK_Bids_Catalogs
        FOREIGN KEY (item_id) REFERENCES dbo.Catalogs(item_id),
    CONSTRAINT FK_Bids_Users
        FOREIGN KEY (bidder_id) REFERENCES dbo.Users(user_id)
);

CREATE TABLE dbo.Purchases (
    purchase_id   INT IDENTITY(1,1) PRIMARY KEY,
    item_id       INT NOT NULL,
    buyer_id      INT NOT NULL,
    total_amount  DECIMAL(12,2) NOT NULL,
    purchase_at   DATETIME NOT NULL DEFAULT (GETUTCDATE()),
    CONSTRAINT FK_Purchases_Catalogs
        FOREIGN KEY (item_id) REFERENCES dbo.Catalogs(item_id),
    CONSTRAINT FK_Purchases_Users
        FOREIGN KEY (buyer_id) REFERENCES dbo.Users(user_id)
);

CREATE TABLE dbo.Payments (
    payment_id   INT IDENTITY(1,1) PRIMARY KEY,
    purchase_id  INT NOT NULL,
    method       NVARCHAR(50) NOT NULL,
    amount       DECIMAL(12,2) NOT NULL,
    status       NVARCHAR(20) NOT NULL
                  CHECK (status IN ('pending','success','failed','refunded')),
    paid_date    DATETIME NULL,
    CONSTRAINT FK_Payments_Purchases
        FOREIGN KEY (purchase_id) REFERENCES dbo.Purchases(purchase_id)
);
```

#### DML Samples & Data Generation Notes
```sql
-- USERS (sample)
INSERT INTO dbo.Users (name, email, password_hash, phone, role) VALUES
('AdminOne', 'admin@example.com', 'HASHED_pw_admin', '0811111111', 'admin'),
('Alice',    'alice@example.com', 'HASHED_pw_alice', '0822222222', 'user'),
('Bob',      'bob@example.com',   'HASHED_pw_bob',   '0833333333', 'user'),
('Carol',    'carol@example.com', 'HASHED_pw_carol', '0844444444', 'user'),
('Dave',     'dave@example.com',  'HASHED_pw_dave',  '0855555555', 'user');

-- CATALOGS (sample)
INSERT INTO dbo.Catalogs (seller_id, name, start_price, imgs, status, ends_at) VALUES
(1, 'Nendoroid Mikasa Ackerman',   1500.00, 'https://img/mikasa1.jpg|https://img/mikasa2.jpg', 'active',  '2025-10-31T15:30:00'),
(1, 'Gundam RX-78-2 Master Grade', 2200.00, 'https://img/rx78.jpg',                               'active',  '2025-11-01T12:00:00'),
(1, 'Luffy Gear 5 Figure',         3200.00, 'https://img/luffy5-1.jpg|https://img/luffy5-2.jpg', 'ended',   '2025-10-20T10:00:00');

-- BIDS (sample)
INSERT INTO dbo.Bids (item_id, bidder_id, amount, bid_time) VALUES
(1, 2, 1600.00, '2025-10-28T10:00:00'),
(1, 3, 1700.00, '2025-10-28T10:05:00'),
(1, 2, 1850.00, '2025-10-28T10:10:00'),
(2, 4, 2300.00, '2025-10-28T11:00:00'),
(2, 5, 2500.00, '2025-10-28T11:15:00');

-- PURCHASES / PAYMENTS (sample)
INSERT INTO dbo.Purchases (item_id, buyer_id, total_amount, purchase_at) VALUES
(3, 2, 4000.00, '2025-10-20T10:01:00');

INSERT INTO dbo.Payments (purchase_id, method, amount, status, paid_date) VALUES
(1, 'bank_transfer', 4000.00, 'success', '2025-10-20T11:00:00');
```

### Complex SQL Queries (10)
```sql
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
```



## Known Issues & Recommendations
1) **Editing start price after bids exist**: treat `start_price` as immutable post-first-bid; compute `current_top_bid` from `MAX(bids.amount)` only.
2) **Authorization**: never trust localStorage alone. Validate role server-side by email/token.
3) **UTC time**: keep `ends_at` UTC; convert in UI.
4) **Cascading deletes**: prefer soft delete in production.
5) **Passwords**: use hash+salt; never store plain text.



## Simple UI Guide
- Auth: Register → Login → localStorage saves session info.
- User: Catalogs → Bidding → bid → end → History.
- Admin: AddProduct/EditProduct/Admin dashboard.
- Contract: JSON DTOs defined in `dataContract.cs`.

### Run Locally
**Prereqs**
- .NET Framework 4.7.2, IIS Express/IIS
- SQL Server
- Proper `FiguresConnectionString` in web.config

**Steps**
1) Run DDL; insert DML samples (or bulk-generate).
2) Host `dbService.svc` (IIS Express). Test a GET endpoint.
3) Serve HTML files (VS Code Live Server).
4) Try: Register → Login → Catalogs → Bidding (place bid) → close expired → History.


## Changelog
- Initial consolidated README generated.
