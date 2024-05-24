create or replace noneditionable package customerOrderManager_pkg is

  function addCustomerOrder(p_customerId        customerOrder.Customerid%type,
                            p_deliveryAddressId customerOrder.Deliveryaddressid%type)
    return customerOrder.Customerorderid%type;

  procedure updateTotalPriceToCustomerOrder(p_customerOrderId customerorder.customerid%type,
                                            p_totalPrice      customerorder.totalprice%type);

  function getCustomerOrderList(p_customerId customerOrder.customerid%type) 
           return getCustomerOrderList_type;

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
  end;

  procedure updateTotalPriceToCustomerOrder(p_customerOrderId customerorder.customerid%type,
                                            p_totalPrice      customerorder.totalprice%type) is
  begin
    update customerorder co
       set co.totalprice = p_totalPrice
     where co.customerorderid = p_customerOrderId;
  
  exception
    when no_data_found then
      raise_application_error(-20100, 'Uygun siparis bulunamadý');
    when others then
      raise_application_error(-20105,
                              'Beklenmeyen bir hata olustu. Hata kodu: ' ||
                              sqlerrm);
  end;

  function getCustomerOrderList(p_customerId customerOrder.customerid%type)
    return getCustomerOrderList_type is
  
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
  
    cursor c_customerOrderDetail(cp_customerOrderId customerorderdetail.customerorderid%type) is
      select b.brandname   brandName,
             p.productname productName,
             cod.quantity  productQuantity,
             cod.unitprice productUnitPrice
        from customerorderdetail cod, product p, brand b
       where cod.productid = p.productid
         and p.brandid = b.brandid
         and cod.customerorderid = cp_customerOrderId;
  
    v_customerOrderList       getCustomerOrderList_type := getCustomerOrderList_type();
    v_customerOrderDetailList getCustomerOrderDetailList_type := getCustomerOrderDetailList_type();
  
    v_index_customerOrderList       pls_integer := 0;
    v_index_customerOrderDetailList pls_integer := 0;
  begin
  
    for r_customerOrder in c_customerOrder(p_customerId) loop
    
      for r_customerOrderDetail in c_customerOrderDetail(r_customerOrder.customerorderid) loop
      
        v_customerOrderDetailList.extend;
        v_index_customerOrderDetailList := v_index_customerOrderDetailList + 1;
      
        v_customerOrderDetailList(v_index_customerOrderDetailList) := getCustomerOrderDetail_type(brandName        => r_customerOrderDetail.Brandname,
                                                                                                  productName      => r_customerOrderDetail.Productname,
                                                                                                  productQuantity  => r_customerOrderDetail.Productquantity,
                                                                                                  productUnitPrice => r_customerOrderDetail.Productunitprice);
      
      end loop;
    
      v_customerOrderList.extend;
      v_index_customerOrderList := v_index_customerOrderList + 1;
    
      v_customerOrderList(v_index_customerOrderList) := getCustomerOrder_type(orderNo               => r_customerOrder.orderNo,
                                                                              orderDate             => r_customerOrder.orderDate,
                                                                              totalPrice            => r_customerOrder.totalPrice,
                                                                              orderStatus           => r_customerOrder.orderStatus,
                                                                              fullName              => r_customerOrder.fullName,
                                                                              deliveryAddressDetail => r_customerOrder.DeliveryAddressDetail,
                                                                              phoneNumber           => r_customerOrder.phoneNumber,
                                                                              productList           => v_customerOrderDetailList);
    
      v_customerOrderDetailList.delete;
      v_index_customerOrderDetailList := 0;
    end loop;
  
    return v_customerOrderList;
  
  end;

end customerOrderManager_pkg;
/
