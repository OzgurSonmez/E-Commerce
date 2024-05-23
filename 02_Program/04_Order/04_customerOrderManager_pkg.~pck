create or replace noneditionable package customerOrderManager_pkg is

  function addCustomerOrder(p_customerId        customerOrder.Customerid%type,
                            p_deliveryAddressId customerOrder.Deliveryaddressid%type)
    return customerOrder.Customerorderid%type;

  procedure updateTotalPriceToCustomerOrder(p_customerOrderId customerorder.customerid%type,
                                            p_totalPrice      customerorder.totalprice%type);

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

end customerOrderManager_pkg;
/
