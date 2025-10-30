using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlTypes;
using System.Linq;
using System.ServiceModel;
using System.ServiceModel.Web;

namespace Figures_game_trading01
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "dbService" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select dbService.svc or dbService.svc.cs at the Solution Explorer and start debugging.
    public class dbService : IdbService
    {
        private readonly DataClasses1DataContext db;

        public dbService()
        {
            var conn = ConfigurationManager.ConnectionStrings["FiguresConnectionString"].ConnectionString;
            db = new DataClasses1DataContext(conn);
        }

        // Catalog
        public Catalog[] GetCatalog()
        {
            // 1) เขียน query แบบ LINQ ปกติ เรียงใหม่สุดก่อน
            var query =
                from c in db.catalogs
                orderby c.listed_at descending
                select new Catalog
                {
                    item_id = c.item_id,
                    seller_id = c.seller_id,
                    Img = c.Imgs ?? "",           // URL รูปที่เก็บในคอลัมน์ของ catalog
                    name = c.name,
                    description = c.description,
                    price = c.price,
                    status = c.status,
                    listed_at = c.listed_at.ToString(),
                };

            return query.ToArray();
        }


        // ======================
        // Payment : ทั้งหมด
        // ======================
        public Payment[] GetPayment()
        {
            // 1) ดึงดิบๆ จาก DB ก่อน (ยังไม่แตะ DateTime.MinValue ใน query)
            var rows = (from p in db.payments
                        orderby p.payment_id descending
                        select new
                        {
                            p.payment_id,
                            p.purchase_id,
                            p.method,
                            p.amount,
                            p.status,
                            p.paid_date  // DateTime? (nullable) จากฐานข้อมูล
                        })
                        .ToList();   // <<-- materialize ออกมาก่อน

            // 2) map เป็นโมเดล Payment ในหน่วยความจำ (กำหนดค่า fallback ภายในช่วงที่ SQL รับได้)
            var safeMin = SqlDateTime.MinValue.Value; // 1753-01-01

            var result = rows.Select(p => new Payment
            {
                payment_id = p.payment_id,
                purchase_id = p.purchase_id,
                method = p.method,
                amount = p.amount,
                status = p.status,
                paid_date = p.paid_date ?? safeMin
            })
            .ToArray();

            return result;
        }

        // ======================
        // Users : ทั้งหมด
        // ======================
        public Users[] GetUsers()
        {
            var query =
                from u in db.users
                orderby u.user_id
                select new Users
                {
                    id         = u.user_id,
                    name       = u.username,   // map -> Users.name
                    email      = u.email,
                    password   = u.password,         // ไม่ส่งรหัสผ่านกลับ
                    phone      = u.phone,
                    role       = u.role,
                    created_at = u.created_at.ToString()
                };

            return query.ToArray();
        }

        // ======================
        // Bids : ตาม item
        // ======================
        public Bid[] GetBidsByItem(string itemId)
        {
            int id = 0;
            int.TryParse(itemId, out id);

            var query =
                from b in db.bids
                where b.item_id == id
                orderby b.amount descending, b.bid_time ascending
                select new Bid
                {
                    bid_id   = b.bid_id,
                    item_id  = b.item_id,
                    user_id  = b.user_id,
                    amount   = b.amount,
                    bid_time = b.bid_time.ToString()
                };

            return query.ToArray();
        }

        // ======================
        // Purchases : ทั้งหมด
        // ======================
        public Purchase[] GetPurchase()
        {
            var query =
                from p in db.purchases
                orderby p.purchased_at descending
                select new Purchase
                {
                    // โมเดลคุณใช้ชื่อ 'purchase' (ควรเป็น purchase_id)
                    purchase    = p.purchase_id,
                    item_id     = p.item_id,
                    buyer_id    = p.buyer_id,
                    total_amount= p.total_amount,
                    purchase_at = p.purchased_at.ToString()
                };

            return query.ToArray();
        }

        // REGISTER (ไม่ hash)
        public string CreateUser(RegisterDto req)
        {
            try
            {
                if (req == null ||
                    string.IsNullOrWhiteSpace(req.username) ||
                    string.IsNullOrWhiteSpace(req.password))
                    return "fail";

                if (db.users.Any(x => x.username == req.username)) return "fail";

                string email = string.IsNullOrWhiteSpace(req.email)
                               ? (req.username + "@local")
                               : req.email;

                // หมายเหตุ: ชื่อคลาส entity จาก .dbml มักเป็นเอกพจน์ 'user'
                var entity = new user
                {
                    username = req.username,
                    email = email,
                    password = req.password,
                    phone = string.IsNullOrWhiteSpace(req.phone) ? null : req.phone,
                    role = "customer",        // ← บังคับเป็น customer เสมอ
                    created_at = DateTime.UtcNow
                };

                db.users.InsertOnSubmit(entity);
                db.SubmitChanges();
                return "success";
            }
            catch { return "fail"; }
        }

        // ===== LOGIN (แบบเดิมของคุณ) =====
        public string Login(LoginDto req)
        {
            try
            {
                if (req == null ||
                    string.IsNullOrWhiteSpace(req.email) ||
                    string.IsNullOrWhiteSpace(req.password))
                    return "fail";

                var acc = db.users.FirstOrDefault(x => x.email == req.email);
                if (acc == null) return "fail";
                if (!string.Equals(acc.password, req.password)) return "fail";

                return "success";
            }
            catch { return "fail"; }
        }

        public string GetRoleByEmail(string email)
        {
            if (string.IsNullOrWhiteSpace(email)) return "";
            var u = db.users.FirstOrDefault(x => x.email == email);
            return u?.role ?? "";
        }


        // add_product
        

        private static bool TryParseDurationMinutes(string s, out int minutes)
        {
            minutes = 0;
            if (string.IsNullOrWhiteSpace(s)) return false;

            // รับทั้ง d|day|days|วัน, h|hr|hour|ชั่วโมง, m|min|minute|นาที
            var text = s.Trim().ToLowerInvariant();

            // กรณีเป็นเลขล้วน = นาที
            if (int.TryParse(text, out var onlyMin))
            {
                minutes = onlyMin;
                return minutes >= 1;
            }

            int d = 0, h = 0, m = 0;
            // match ตัวเลข+หน่วย หลายๆ ชุด
            var rx = new System.Text.RegularExpressions.Regex(@"\s*(\d+)\s*(d|day|days|วัน|h|hr|hour|hours|ชั่วโมง|m|min|mins|minute|minutes|นาที)\s*",
                                                              System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            var mc = rx.Matches(text);
            if (mc.Count == 0) return false;

            foreach (System.Text.RegularExpressions.Match mm in mc)
            {
                var val = int.Parse(mm.Groups[1].Value);
                var u = mm.Groups[2].Value.ToLowerInvariant();

                if (u.StartsWith("d") || u == "วัน") d += val;
                else if (u.StartsWith("h") || u == "ชั่วโมง") h += val;
                else m += val; // นาที
            }

            long total = (long)d * 24 * 60 + (long)h * 60 + m;
            if (total < 1) return false;
            if (total > int.MaxValue) total = int.MaxValue; // กัน overflow
            minutes = (int)total;
            return true;
        }

        public string CreateCatalog(AddProductDto req)
        {
            try
    {
        if (req == null || string.IsNullOrWhiteSpace(req.adminEmail) ||
            string.IsNullOrWhiteSpace(req.name) || req.price <= 0)
            return "bad_input";

        var admin = db.users.FirstOrDefault(u => u.email == req.adminEmail);
        if (admin == null) return "no_user";
        if (!string.Equals(admin.role, "admin", StringComparison.OrdinalIgnoreCase))
            return "forbidden";

        DateTime endsUtc;

        // 1) new: endsAfterText > คำนวณจาก UtcNow
        if (!string.IsNullOrWhiteSpace(req.endsAfterText))
        {
            if (!TryParseDurationMinutes(req.endsAfterText, out var mins)) return "bad_time";
            endsUtc = DateTime.UtcNow.AddMinutes(mins);
        }
        // 2) รองรับแบบเก่า ISO datetime-local
        else if (!string.IsNullOrWhiteSpace(req.endsAtISO))
        {
            if (!DateTime.TryParse(req.endsAtISO, out var endsLocal)) return "bad_time";
            endsUtc = endsLocal.ToUniversalTime();
        }
        else
        {
            return "bad_time";
        }

        if (endsUtc <= DateTime.UtcNow) return "bad_time";

        var img = string.IsNullOrWhiteSpace(req.imageUrl)
                    ? "https://placehold.co/800x600?text=No+Image" : req.imageUrl.Trim();

        var row = new catalog
        {
            seller_id = admin.user_id,
            Imgs      = img,
            name      = req.name.Trim(),
            description = null,
            price     = req.price,
            status    = "active",
            starts_at = DateTime.UtcNow,
            ends_at   = endsUtc,
            listed_at = DateTime.UtcNow
        };

        db.catalogs.InsertOnSubmit(row);
        db.SubmitChanges();
        return "success";
    }
    catch { return "db_error"; }
        }

        // helper ใช้ได้หลายที่
        private static string FirstImgOrNull(string imgs)
        {
            if (string.IsNullOrWhiteSpace(imgs)) return null;
            var parts = imgs.Split('|');
            return parts.Length > 0 ? parts[0] : imgs;
        }

        public CatalogView[] GetCatalogListView()
        {
            var now = DateTime.UtcNow;

            // 1) สร้าง query ที่ SQL แปลได้ทั้งหมด (ห้าม Split/FirstOrDefault ในนี้)
            var qDb =
                from c in db.catalogs
                orderby c.listed_at descending
                let top = db.bids.Where(b => b.item_id == c.item_id)
                                 .OrderByDescending(b => b.amount)
                                 .ThenBy(b => b.bid_time)
                                 .Select(b => (decimal?)b.amount)
                                 .FirstOrDefault()
                select new
                {
                    c.item_id,
                    c.name,
                    c.Imgs,               // เก็บมาทั้งสตริงก่อน
                    c.price,
                    c.status,
                    c.ends_at,
                    top
                };

            // 2) ดึงออกมาเป็น list แล้วค่อย map เป็น CatalogView โดย split ฝั่ง C#
            var list = qDb.ToList();

            var result = list.Select(x => new CatalogView
            {
                item_id = x.item_id,
                name = x.name,
                Img = FirstImgOrNull(x.Imgs),                        // <-- split ที่นี่
                price = x.price,
                status = x.status,
                ends_at = x.ends_at.ToString("s"),
                remaining_seconds = (long)Math.Max(0, (x.ends_at - now).TotalSeconds),
                top_bid = x.top ?? 0m
            }).ToArray();

            return result;
        }

        public CatalogView GetCatalogByIdView(string id)
        {
            if (!int.TryParse(id, out var itemId)) return null;
            var now = DateTime.UtcNow;

            var qDb =
                from c in db.catalogs
                where c.item_id == itemId
                let top = db.bids.Where(b => b.item_id == c.item_id)
                                 .OrderByDescending(b => b.amount)
                                 .ThenBy(b => b.bid_time)
                                 .Select(b => (decimal?)b.amount)
                                 .FirstOrDefault()
                select new { c.item_id, c.name, c.Imgs, c.price, c.status, c.ends_at, top };

            var x = qDb.FirstOrDefault();
            if (x == null) return null;

            return new CatalogView
            {
                item_id = x.item_id,
                name = x.name,
                Img = FirstImgOrNull(x.Imgs),
                price = x.price,
                status = x.status,
                ends_at = x.ends_at.ToString("s"),
                remaining_seconds = (long)Math.Max(0, (x.ends_at - now).TotalSeconds),
                top_bid = x.top ?? 0m
            };
        }

        public PlaceBidResult PlaceBid(BidDto req)
        {
            var res = new PlaceBidResult { status = "db_error", top_bid = 0m };
            try
            {
                if (req == null || req.item_id <= 0 || req.amount <= 0 || string.IsNullOrWhiteSpace(req.email)) { res.status = "bad_input"; return res; }

                var user = db.users.FirstOrDefault(u => u.email == req.email);
                if (user == null) { res.status = "no_user"; return res; }

                var c = db.catalogs.FirstOrDefault(x => x.item_id == req.item_id);
                if (c == null) { res.status = "not_found"; return res; }
                if (!string.Equals(c.status, "active", StringComparison.OrdinalIgnoreCase)) { res.status = "ended"; return res; }
                if (DateTime.UtcNow >= c.ends_at) { res.status = "ended"; return res; }

                var top = db.bids.Where(b => b.item_id == c.item_id)
                                 .OrderByDescending(b => b.amount)
                                 .ThenBy(b => b.bid_time)
                                 .Select(b => (decimal?)b.amount).FirstOrDefault() ?? c.price;

                if (req.amount <= top) { res.status = "too_low"; res.top_bid = top; return res; }

                var row = new bid { item_id = c.item_id, user_id = user.user_id, amount = req.amount, bid_time = DateTime.UtcNow };
                db.bids.InsertOnSubmit(row);
                db.SubmitChanges();

                res.status = "success";
                res.top_bid = req.amount;
                return res;
            }
            catch { return res; }
        }

        public string CloseExpiredAuctions()
        {
            try
            {
                var now = DateTime.UtcNow;
                var targets = db.catalogs.Where(c => c.status == "active" && c.ends_at <= now).ToList();

                foreach (var c in targets)
                {
                    // หาผู้ชนะ
                    var win = db.bids.Where(b => b.item_id == c.item_id)
                                     .OrderByDescending(b => b.amount).ThenBy(b => b.bid_time)
                                     .Select(b => new { b.user_id, b.amount }).FirstOrDefault();

                    if (win != null)
                    {
                        c.status = "sold";
                        var pur = new purchase
                        {
                            item_id = c.item_id,
                            buyer_id = win.user_id,
                            total_amount = win.amount,
                            purchased_at = DateTime.UtcNow
                        };
                        db.purchases.InsertOnSubmit(pur);
                    }
                    else
                    {
                        c.status = "ended"; // ไม่มีคนบิด
                    }
                }
                db.SubmitChanges();
                return "ok";
            }
            catch { return "fail"; }
        }

        public PurchaseView[] GetMyPurchases(string email)
        {
            if (string.IsNullOrWhiteSpace(email)) return new PurchaseView[0];

            var u = db.users.FirstOrDefault(x => x.email == email);
            if (u == null) return new PurchaseView[0];

            // 1) query ที่ SQL แปลได้ (ยังไม่เรียก ToString/ Split ในนี้)
            var qDb =
                from p in db.purchases
                where p.buyer_id == u.user_id
                join c in db.catalogs on p.item_id equals c.item_id
                join s in db.users on c.seller_id equals s.user_id
                select new
                {
                    p.purchase_id,
                    c.item_id,
                    item_name = c.name,
                    c.Imgs,
                    p.total_amount,
                    p.purchased_at,
                    seller_name = s.username,
                    // payment ล่าสุด (ถ้ามี)
                    lastPay = db.payments
                                .Where(pay => pay.purchase_id == p.purchase_id)
                                .OrderByDescending(pay => pay.paid_date.HasValue) // มีวันที่ก่อน (true > false)
                                .ThenByDescending(pay => pay.paid_date)           // วันที่ใหม่สุด
                                .ThenByDescending(pay => pay.payment_id)          // เผื่อวันที่เท่ากัน
                                .Select(pay => new { pay.status, pay.amount, pay.method })
                                .FirstOrDefault()
                };

            // 2) ดึงออกมาก่อน แล้ว map เป็น ViewModel (ค่อย ToString / Split ที่นี่)
            var list = qDb.OrderByDescending(x => x.purchased_at).ToList();

            return list.Select(x => new PurchaseView
            {
                purchase_id = x.purchase_id,
                item_id = x.item_id,
                item_name = x.item_name,
                img = FirstImgOrNull(x.Imgs),
                total_amount = x.total_amount,
                purchased_at = x.purchased_at.ToString("s"),
                seller_name = x.seller_name,
                payment_status = x.lastPay?.status ?? "-",
                payment_amount = x.lastPay?.amount ?? 0m,
                payment_method = x.lastPay?.method,
                bill_url = $"bill.html?pid={x.purchase_id}"
            }).ToArray();
        }




        // bidding
        public Catalog GetCatalogById(string id)
        {
            if (!int.TryParse(id, out var itemId)) return null;
            var c = db.catalogs.FirstOrDefault(x => x.item_id == itemId);
            if (c == null) return null;
            return new Catalog
            {
                item_id = c.item_id,
                seller_id = c.seller_id,
                Img = string.IsNullOrEmpty(c.Imgs) ? null : c.Imgs.Split('|')[0],
                name = c.name,
                description = c.description,
                price = c.price,
                status = c.status,
                listed_at = c.listed_at.ToString("s")
            };
        }

        //Bill
        public BillView GetBillByPurchaseId(string purchaseId, string email)
        {
            if (!int.TryParse(purchaseId, out var pid)) return null;
            if (string.IsNullOrWhiteSpace(email)) return null;

            var buyer = db.users.FirstOrDefault(u => u.email == email);
            if (buyer == null) return null;

            // join purchase + catalog + seller
            var q =
                from p in db.purchases
                where p.purchase_id == pid
                join c in db.catalogs on p.item_id equals c.item_id
                join s in db.users on c.seller_id equals s.user_id
                select new
                {
                    p,
                    c,
                    seller_name = s.username,
                    buyer_id = p.buyer_id,
                    lastPay = db.payments
                        .Where(pay => pay.purchase_id == p.purchase_id)
                        .OrderByDescending(pay => pay.paid_date.HasValue)
                        .ThenByDescending(pay => pay.paid_date)
                        .ThenByDescending(pay => pay.payment_id)
                        .Select(pay => new { pay.status, pay.amount, pay.method })
                        .FirstOrDefault()
                };

            var x = q.FirstOrDefault();
            if (x == null) return null;

            // อนุญาตเฉพาะเจ้าของบิล
            if (x.buyer_id != buyer.user_id) return null;

            return new BillView
            {
                purchase_id = x.p.purchase_id,
                purchased_at = x.p.purchased_at.ToString("s"),
                total_amount = x.p.total_amount,
                item_id = x.c.item_id,
                item_name = x.c.name,
                img = FirstImgOrNull(x.c.Imgs),
                seller_name = x.seller_name,
                buyer_name = buyer.username,
                buyer_email = buyer.email,
                payment_status = x.lastPay?.status ?? "-",
                payment_amount = x.lastPay?.amount ?? 0m,
                payment_method = x.lastPay?.method
            };
        }

        //Admin

        public string UpdateCatalog(UpdateCatalogDto req) => DoUpdateCatalog(req);
        public string UpdateCatalogAlt(UpdateCatalogDto req) => DoUpdateCatalog(req);

        // === ตัวช่วยทำงานจริง ===
        private string DoUpdateCatalog(UpdateCatalogDto req)
        {
            try
            {
                if (req == null || req.item_id <= 0 || string.IsNullOrWhiteSpace(req.adminEmail))
                    return "bad_input";

                var admin = db.users.FirstOrDefault(u => u.email == req.adminEmail);
                if (admin == null) return "no_user";
                if (!string.Equals(admin.role, "admin", StringComparison.OrdinalIgnoreCase))
                    return "forbidden";

                var c = db.catalogs.FirstOrDefault(x => x.item_id == req.item_id);
                if (c == null) return "not_found";

                if (!string.IsNullOrWhiteSpace(req.name)) c.name = req.name.Trim();
                if (req.price.HasValue && req.price.Value >= 0) c.price = req.price.Value;
                if (!string.IsNullOrWhiteSpace(req.Imgs)) c.Imgs = req.Imgs.Trim();
                if (!string.IsNullOrWhiteSpace(req.status)) c.status = req.status.Trim();

                if (!string.IsNullOrWhiteSpace(req.endsAtISO))
                {
                    if (!DateTime.TryParse(req.endsAtISO, out var endsLocal)) return "bad_time";
                    var endsUtc = DateTime.SpecifyKind(endsLocal, DateTimeKind.Local).ToUniversalTime();
                    if (endsUtc <= DateTime.UtcNow) return "bad_time";
                    c.ends_at = endsUtc;
                }

                db.SubmitChanges();
                return "success";
            }
            catch
            {
                return "db_error";
            }
        }

        public string CloseCatalog(string id)
        {
            try
            {
                if (!int.TryParse(id, out var itemId)) return "bad_id";
                var c = db.catalogs.SingleOrDefault(x => x.item_id == itemId);
                if (c == null) return "not_found";
                if (string.Equals(c.status, "sold", StringComparison.OrdinalIgnoreCase)) return "already_sold";

                c.status = "ended";
                c.ends_at = DateTime.UtcNow; // ปิดทันที
                db.SubmitChanges();
                return "success";
            }
            catch { return "db_error"; }
        }

        public string DeleteCatalog(string id)
        {
            try
            {
                if (!int.TryParse(id, out var itemId)) return "bad_id";
                var c = db.catalogs.SingleOrDefault(x => x.item_id == itemId);
                if (c == null) return "not_found";

                // ลบ bid/purchase/payment ที่เกี่ยวข้อง (ถ้ามี FK cascade ก็ไม่ต้อง)
                var bids = db.bids.Where(b => b.item_id == itemId);
                db.bids.DeleteAllOnSubmit(bids);

                var pur = db.purchases.Where(p => p.item_id == itemId).ToList();
                foreach (var p in pur)
                {
                    var pays = db.payments.Where(x => x.purchase_id == p.purchase_id);
                    db.payments.DeleteAllOnSubmit(pays);
                }
                db.purchases.DeleteAllOnSubmit(pur);

                db.catalogs.DeleteOnSubmit(c);
                db.SubmitChanges();
                return "success";
            }
            catch { return "db_error"; }
        }

    }
}
