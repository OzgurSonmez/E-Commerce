create or replace noneditionable package customerOrderManager_pkg is

  function addCustomerOrder(p_customerId        customerOrder.Customerid%type,
                            p_deliveryAddressId customerOrder.Deliveryaddressid%type)
    return customerOrder.Customerorderid%type;

  procedure updateTotalPriceToCustomerOrder(p_customerOrderId customerorder.customerid%type,
                                            p_totalPrice      customerorder.totalprice%type);

  function getCustomerOrderList(p_customerId customerOrder.customerid%type) 
           return getCustomerOrderList_type;
  
  function getCustomerOrderByCustomerId(p_customerId customerOrder.customerid%type) 
           return sys_refcursor;

end customerOrderManager_pkg;
/
create or replace noneditionable package body customerOrderManager_pkg is

  function addCustomerOrder(p_customerId        customerOrder.customerid%type,
                            p_deliveryAddressId customerOrder.deliveryaddressid%type)
    return customerOrder.customerorderid%type is
    v_customerOrderId customerOrder.customerorderid%type;
    v_orderNo         customerOrder.orderno%type;
  begin
    v_customerOrderId := customerOrder_seq.nextval;
    v_orderNo         := orderNo_seq.nextval;
  
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.customerOrderParameters(p_customerOrderId => v_customerOrderId,
                                            p_orderNo         => v_orderNo);
  
    -- Siparis numarasý olusturulur.
    insert into customerOrder
      (customerorderid,
       customerid,
       orderno,
       orderdate,
       totalprice,
       orderstatustypeid,
       deliveryaddressid)
    values
      (v_customerOrderId,
       p_customerId,
       v_orderNo,
       sysdate,
       0,
       1,
       p_deliveryAddressId);
    return v_customerOrderId;
  
  exception
    when dup_val_on_index then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_ORDER_NO_DUPLICATE);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_ORDER_INSERT);
    
  end;

  procedure updateTotalPriceToCustomerOrder(p_customerOrderId customerorder.customerid%type,
                                            p_totalPrice      customerorder.totalprice%type) is
    v_currentTotalPrice                     customerorder.totalprice%type;
    err_customer_order_not_found_for_update exception;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.customerOrderParameters(p_customerOrderId => p_customerOrderId,
                                            p_totalPrice      => p_totalPrice);
  
    -- Guncellenecek satiri kilitler.
    select co.totalprice
           into v_currentTotalPrice
      from customerorder co
           where co.customerorderid = p_customerOrderId
           for update;
    
    -- Siparisin toplam tutarini gunceller.
     update customerorder co set co.totalprice = p_totalPrice
            where co.customerorderid = p_customerOrderId;
    -- Guncellenecek musteri siparisi bulunamazsa hata verir.
    if sql%notfound then
      raise err_customer_order_not_found_for_update;
    end if;
  
  exception
    when err_customer_order_not_found_for_update then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_ORDER_NOT_FOUND_FOR_UPDATE);
    when others then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
  end;

  function getCustomerOrderList(p_customerId customerOrder.customerid%type)
    return getCustomerOrderList_type is
  
    -- Musteriye ait siparisleri getirir.
    cursor c_customerOrder(cp_customerId customerorder.customerid%type) is
      select co.customerorderid customerOrderId,
             co.orderno orderNo,
             co.orderdate orderDate,
             co.totalprice totalPrice,
             ost.typename orderStatus,
             (c.firstname || ' ' || c.lastname) fullName,
             (a.addressdesciption || ' ' || d.districtname || ' / ' ||
             city.cityname || ' / ' || country.countryname) DeliveryAddressDetail,
             p.phonenumber phoneNumber
        from customerorder   co,
             customer        c,
             orderstatustype ost,
             deliveryaddress da,
             address         a,
             district        d,
             city,
             country,
             phone           p
       where co.orderstatustypeid = ost.orderstatustypeid
         and co.deliveryaddressid = da.deliveryaddressid
         and co.customerid = c.customerid
         and da.addressid = a.addressid
         and a.districtid = d.districtid
         and d.cityid = city.cityid
         and city.countryid = country.countryid
         and da.phoneid = p.phoneid
         and co.customerid = cp_customerId;
  
    v_customerOrderList       getCustomerOrderList_type := getCustomerOrderList_type();
    v_customerOrderDetailList getCustomerOrderDetailList_type := getCustomerOrderDetailList_type();
  
    v_index pls_integer := 0;
  
  begin
    -- Parametre kontrolu
    ecpValidate_pkg.customerParameters(p_customerId => p_customerId);
  
    -- Siparis listesini olusturur ve siparis icerisindeki urunleri listeye ekler.
    for r_customerOrder in c_customerOrder(p_customerId) loop
    
      -- Siparise ait urunlerin detaylarini getirir.
      v_customerOrderDetailList := customerOrderDetailManager_pkg.getOrderDetailList(p_customerOrderId => r_customerOrder.customerorderid);
    
      v_customerOrderList.extend;
      v_index := v_index + 1;
      -- Siparisin detaylarini ekler.
      v_customerOrderList(v_index) := getCustomerOrder_type(orderNo               => r_customerOrder.orderNo,
                                                            orderDate             => r_customerOrder.orderDate,
                                                            totalPrice            => r_customerOrder.totalPrice,
                                                            orderStatus           => r_customerOrder.orderStatus,
                                                            fullName              => r_customerOrder.fullName,
                                                            deliveryAddressDetail => r_customerOrder.DeliveryAddressDetail,
                                                            phoneNumber           => r_customerOrder.phoneNumber,
                                                            productList           => v_customerOrderDetailList);
    
    end loop;
  
    return v_customerOrderList;
  
  exception
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
  end;

  function getCustomerOrderByCustomerId(p_customerId customerOrder.customerid%type)
    return sys_refcursor is
  
    c_customerOrder sys_refcursor;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.customerParameters(p_customerId => p_customerId);
  
    --Frontend'e musteri siparislerini gonderir.
    open c_customerOrder for
      select co.customerorderid customerOrderId,
             co.orderno orderNo,
             co.orderdate orderDate,
             co.totalprice totalPrice,
             ost.typename orderStatus,
             (c.firstname || ' ' || c.lastname) fullName,
             (a.addressdesciption || ' ' || d.districtname || ' / ' ||
             city.cityname || ' / ' || country.countryname) deliveryAddressDetail,
             p.phonenumber phoneNumber
        from customerorder   co,
             customer        c,
             orderstatustype ost,
             deliveryaddress da,
             address         a,
             district        d,
             city,
             country,
             phone           p
       where co.orderstatustypeid = ost.orderstatustypeid
         and co.deliveryaddressid = da.deliveryaddressid
         and co.customerid = c.customerid
         and da.addressid = a.addressid
         and a.districtid = d.districtid
         and d.cityid = city.cityid
         and city.countryid = country.countryid
         and da.phoneid = p.phoneid
         and co.customerid = p_customerId
       order by orderDate desc;
  
    return c_customerOrder;
  
  exception
    when others then
      if c_customerOrder%isopen then
        close c_customerOrder;
      end if;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
    
  end;

end customerOrderManager_pkg;
/
