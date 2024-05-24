create or replace type getCustomerOrderDetail_type as object
(
       brandName          varchar2(100),
       productName        varchar2(100),
       productQuantity    number(10),
       productUnitPrice   number(11,2)
)
-- Siparisteki urunlerin listelenmesi icin bir tip oluþturuldu.
/

create or replace type getCustomerOrderDetailList_type as table of getCustomerOrderDetail_type;



create or replace type getCustomerOrder_type as object
(
      orderNo                 varchar2(30),
      orderDate               date,
      totalPrice              number(11,2),
      orderStatus             varchar2(50),
      fullName                varchar2(200),
      deliveryAddressDetail   varchar2(500),
      phoneNumber             varchar2(20),
      productList             getCustomerOrderDetailList_type
       
)
-- Siparis bilgileri ve urun listesini iceren bir tip olusturuldu.
/

create or replace type getCustomerOrderList_type as table of getCustomerOrder_type;


