create or replace noneditionable package customerOrderDetailManager_pkg is

  procedure addBasketProductListToOrderDetail(p_customerOrderId    customerorder.customerorderid%type,
                                              p_list_basketProduct getBasketProductList_type);
                                              
  function getOrderDetailList(p_customerOrderId customerorder.customerorderid%type)
           return getCustomerOrderDetailList_type;
  
  function getTotalPrice(p_customerOrderId customerorderdetail.customerorderid%type) return customerorder.totalprice%type; 
  
  function getCustomerOrderDetailByCustomerOrderId(p_customerOrderId customerorder.customerorderid%type) 
           return sys_refcursor;

end customerOrderDetailManager_pkg;
/
create or replace noneditionable package body customerOrderDetailManager_pkg is

  procedure addBasketProductListToOrderDetail(p_customerOrderId    customerOrder.Customerorderid%type,
                                              p_list_basketProduct getBasketProductList_type) is
    v_list_index            pls_integer;
    v_customerOrderDetailId customerorderdetail.customerorderdetailid%type;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.customerOrderParameters(p_customerOrderId);
  
    -- Index'e listenin baslangic index'i atanir.
    v_list_index := p_list_basketProduct.first;
  
    while v_list_index is not null loop
      begin
        v_customerOrderDetailId := customerorderdetail_seq.nextval;
        -- Parametre kontrolu yapilir.
        ecpValidate_pkg.customerOrderDetailParameters(p_customerOrderDetailId => v_customerOrderDetailId,
                                                      p_productQuantity       => p_list_basketProduct(v_list_index).productQuantity,
                                                      p_productUnitPrice      => p_list_basketProduct(v_list_index).productUnitPrice);
        -- Musteri siparis detayina urunler eklenir.
        insert into customerorderdetail
          (customerorderdetailid,
           customerorderid,
           productid,
           quantity,
           unitprice)
        values
          (v_customerOrderDetailId,
           p_customerOrderId,
           p_list_basketProduct   (v_list_index).productId,
           p_list_basketProduct   (v_list_index).productQuantity,
           p_list_basketProduct   (v_list_index).productUnitPrice);
      
        -- Sýradaki index'e gecilir.
        v_list_index := p_list_basketProduct.Next(v_list_index);
      exception
        when others then
          rollback;
          ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_ORDER_DETAIL_INSERT);
      end;
    end loop;
  
  exception
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
    
  end;

  function getOrderDetailList(p_customerOrderId customerorder.customerorderid%type)
    return getCustomerOrderDetailList_type is
  
    -- Musteriye ait siparislerin icerisindeki urunleri getirir.
    cursor c_customerOrderDetail(cp_customerOrderId customerorderdetail.customerorderid%type) is
      select b.brandname   brandName,
             p.productname productName,
             cod.quantity  productQuantity,
             cod.unitprice productUnitPrice
        from customerorderdetail cod, product p, brand b
       where cod.productid = p.productid
         and p.brandid = b.brandid
         and cod.customerorderid = cp_customerOrderId;
    v_customerOrderDetailList getCustomerOrderDetailList_type := getCustomerOrderDetailList_type();
    v_index                   pls_integer := 0;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.customerOrderParameters(p_customerOrderId => p_customerOrderId);
    for r_customerOrderDetail in c_customerOrderDetail(p_customerOrderId) loop
      -- Siparise ait urun listesi
      v_customerOrderDetailList.extend;
      v_index := v_index + 1;
    
      v_customerOrderDetailList(v_index) := getCustomerOrderDetail_type(brandName        => r_customerOrderDetail.Brandname,
                                                                        productName      => r_customerOrderDetail.Productname,
                                                                        productQuantity  => r_customerOrderDetail.Productquantity,
                                                                        productUnitPrice => r_customerOrderDetail.Productunitprice);
    
    end loop;
    -- Siparise ait urun listesini doner.
    return v_customerOrderDetailList;
  
  exception
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
  end;

  function getTotalPrice(p_customerOrderId customerorderdetail.customerorderid%type)
    return customerorder.totalprice%type is
  
    v_totalPrice customerorder.totalprice%type;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.customerOrderParameters(p_customerOrderId => p_customerOrderId);
  
    -- Siparise ait tum urunlerin toplam fiyati hesaplanir.
    select SUM(cod.quantity * cod.unitprice)
      into v_totalPrice
      from customerorderdetail cod
     where cod.customerorderid = p_customerOrderId;
  
    return v_totalPrice;
  
  exception
    when others then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
    
  end;

  function getCustomerOrderDetailByCustomerOrderId(p_customerOrderId customerorder.customerorderid%type)
    return sys_refcursor is
    c_customerOrderDetail sys_refcursor;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.customerOrderParameters(p_customerOrderId => p_customerOrderId);
    
    -- Frontend'e musteri siparisinin detaylarini gonderir.
    open c_customerOrderDetail for
      select b.brandname   brandName,
             p.productname productName,
             cod.quantity  productQuantity,
             cod.unitprice productUnitPrice
        from customerorderdetail cod, product p, brand b
       where cod.productid = p.productid
         and p.brandid = b.brandid
         and cod.customerorderid = p_customerOrderId;
         
    return c_customerOrderDetail;
  
  exception
    when others then
      if c_customerOrderDetail%isopen then
        close c_customerOrderDetail;
      end if;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
    
  end;

end customerOrderDetailManager_pkg;
/
