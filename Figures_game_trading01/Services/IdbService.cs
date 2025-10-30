using System.Collections.Generic;
using System.ServiceModel;
using System.ServiceModel.Web;

namespace Figures_game_trading01
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IdbService" in both code and config file together.
    [ServiceContract]
    public interface IdbService
    {
        // Catalog
        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "catalog")]
        Catalog[] GetCatalog();

        // ===== Payment (ทั้งหมด)
        [OperationContract]
        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "payment")]
        Payment[] GetPayment();

        // ===== Users (ทั้งหมด)
        [OperationContract]
        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "users")]
        Users[] GetUsers();

        // ===== Bids ตาม item
        [OperationContract]
        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "bid/by-item/{itemId}")]
        Bid[] GetBidsByItem(string itemId);

        // ===== Purchases (ทั้งหมด)
        [OperationContract]
        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json, UriTemplate = "purchase")]
        Purchase[] GetPurchase();



        // ==== Register ====
        [OperationContract]
        [WebInvoke(Method = "POST", RequestFormat = WebMessageFormat.Json,
               ResponseFormat = WebMessageFormat.Json,
               BodyStyle = WebMessageBodyStyle.Bare, UriTemplate = "users")]
        string CreateUser(RegisterDto req);

        // ==== Login ====
        [OperationContract]
        [WebInvoke(Method = "POST",
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            BodyStyle = WebMessageBodyStyle.Bare,
            UriTemplate = "login")]
        string Login(LoginDto req);

        // (ถ้าคุณมีดู role หลังล็อกอิน แนะนำให้มีแบบอิง email ด้วย)
        [OperationContract]
        [WebInvoke(Method = "GET",
                   ResponseFormat = WebMessageFormat.Json,
                   BodyStyle = WebMessageBodyStyle.Bare,
                   UriTemplate = "user/role-by-email/{email}")]
        string GetRoleByEmail(string email);

        // add_product
        [OperationContract]
        [WebInvoke(Method = "POST", RequestFormat = WebMessageFormat.Json,
           ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare,
           UriTemplate = "catalog")]
        string CreateCatalog(AddProductDto req);

        [OperationContract]
        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json,
                   BodyStyle = WebMessageBodyStyle.Bare, UriTemplate = "catalog/list-view")]
        CatalogView[] GetCatalogListView();

        [OperationContract]
        [WebInvoke(Method = "GET", ResponseFormat = WebMessageFormat.Json,
                   BodyStyle = WebMessageBodyStyle.Bare, UriTemplate = "catalog/{id}/view")]
        CatalogView GetCatalogByIdView(string id);

        [OperationContract]
        [WebInvoke(Method = "POST", RequestFormat = WebMessageFormat.Json,
                   ResponseFormat = WebMessageFormat.Json, BodyStyle = WebMessageBodyStyle.Bare,
                   UriTemplate = "bid")]
        PlaceBidResult PlaceBid(BidDto req);

        [OperationContract]
        [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json,
                   BodyStyle = WebMessageBodyStyle.Bare, UriTemplate = "auction/close-expired")]
        string CloseExpiredAuctions();   // ใช้ปิดดีลที่หมดเวลา (เรียกจาก Bidding ตอนนับถอยหลังหมด)


        [OperationContract]
        [WebInvoke(Method = "GET",
        ResponseFormat = WebMessageFormat.Json,
        BodyStyle = WebMessageBodyStyle.Bare,
        UriTemplate = "history/my-purchases/{email}")]
        Figures_game_trading01.PurchaseView[] GetMyPurchases(string email);


        // Bill
        [OperationContract]
        [WebInvoke(Method = "GET",
         ResponseFormat = WebMessageFormat.Json,
         BodyStyle = WebMessageBodyStyle.Bare,
         UriTemplate = "history/bill/{purchaseId}/{email}")] // ตรวจสิทธิ์ด้วย email ผู้ซื้อ
        BillView GetBillByPurchaseId(string purchaseId, string email);



        // bidding
        [OperationContract]
        [WebInvoke(Method = "GET",
               ResponseFormat = WebMessageFormat.Json,
               BodyStyle = WebMessageBodyStyle.Bare,
               UriTemplate = "catalog/{id}")]
        Catalog GetCatalogById(string id);


        // Admin

        [OperationContract]
        [WebInvoke(Method = "POST",
           BodyStyle = WebMessageBodyStyle.Bare,
           RequestFormat = WebMessageFormat.Json,
           ResponseFormat = WebMessageFormat.Json,
           UriTemplate = "UpdateCatalog")]
        string UpdateCatalog(UpdateCatalogDto req);

        // สำรองอีกเส้นทาง
        [OperationContract]
        [WebInvoke(Method = "POST",
            BodyStyle = WebMessageBodyStyle.Bare,
            RequestFormat = WebMessageFormat.Json,
            ResponseFormat = WebMessageFormat.Json,
            UriTemplate = "catalog/update")]
        string UpdateCatalogAlt(UpdateCatalogDto req);
        // ปิดประมูล
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "catalog/close/{id}", ResponseFormat = WebMessageFormat.Json)]
        string CloseCatalog(string id);

          // ลบสินค้า
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "catalog/delete/{id}", ResponseFormat = WebMessageFormat.Json)]
        string DeleteCatalog(string id);
    }
}



    
