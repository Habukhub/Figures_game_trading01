using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Figures_game_trading01
{
    public class Users
    {
        public int id;
        public string name;
        public string email;
        public string password;
        public string phone;
        public string role;
        public string created_at;
    }

    public class Catalog
    {
        public int item_id;
        public int seller_id;
        public string Img;
        public string name;
        public string description;
        public decimal price;
        public string status;
        public string listed_at;
    }

    public class Bid 
    {
        public int bid_id;
        public int item_id;
        public int user_id;
        public decimal amount;
        public string bid_time;
    }

    public class Purchase
    {
        public int purchase;
        public int item_id;
        public int buyer_id;
        public decimal total_amount;
        public string purchase_at;
        
    }

    public class Payment
    {
        public int payment_id;
        public int purchase_id;
        public string method;
        public decimal amount;
        public string status;
        public DateTime paid_date;
    }

    public class RegisterDto
    {
        public string username;
        public string email;
        public string password;
        public string phone;
    }

    public class LoginDto
    {
        public string email;  // ให้ใส่ได้ทั้งคู่
        public string password;
    }


    // ใช้กับ Add Product
    public class AddProductDto
    {
        public string adminEmail;
        public string name;
        public decimal price;
        public string imageUrl;
        public string endsAtISO;      // รับค่า datetime-local จากหน้าเว็บ (ISO)
        public string endsAfterText;
    }

    public class CatalogView
    {
        public int item_id;
        public string name;
        public string Img;
        public decimal price;
        public string status;
        public string ends_at;           // ISO string
        public long remaining_seconds;   // เหลือเวลา (วินาที)
        public decimal top_bid;          // ราคาสูงสุดตอนนี้ (ถ้าไม่มี = 0)
    }

    public class BidDto
    {
        public string email;   // ผู้บิด
        public int item_id;
        public decimal amount;
    }

    public class PlaceBidResult
    {
        public string status;      // success|ended|too_low|not_found|forbidden|db_error
        public decimal top_bid;    // ราคาสูงสุดล่าสุด
    }

    public class PurchaseView
    {
        public int purchase_id;
        public int item_id;
        public string item_name;
        public string img;               // รูปแรกจาก Imgs
        public decimal total_amount;     // ราคาปิดดีล
        public string purchased_at;      // ISO (ToString("s"))
        public string payment_status;    // pending/success/failed/refunded หรือ "-"
        public decimal payment_amount;   // ถ้ามี payment
        public string payment_method;    // ถ้ามี payment
        public string seller_name;       // ชื่อผู้ขาย
        public string bill_url;
    }

    public class BillView
    {
        public int purchase_id;
        public string purchased_at;     // ISO
        public decimal total_amount;

        public int item_id;
        public string item_name;
        public string img;

        public string seller_name;
        public string buyer_name;
        public string buyer_email;

        public string payment_status;   // -, pending, success...
        public decimal payment_amount;
        public string payment_method;
    }

    public class UpdateCatalogDto
    {
        public string adminEmail;
        public int item_id;
        public string name;
        public decimal? price;
        public string Imgs;
        public string status;
        public string endsAtISO;
    }

}

