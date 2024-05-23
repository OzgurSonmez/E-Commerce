create or replace noneditionable package customerOrderDetailManager_pkg is

  procedure addBasketProductListToOrderDetail(p_customerOrderId    customerOrder.Customerorderid%type,
                                              p_list_basketProduct getBasketProductList_type);
  
  function getTotalPrice(p_customerOrderId customerorderdetail.customerorderid%type) return customerorder.totalprice%type; 

end customerOrderDetailManager_pkg;
/
create or replace noneditionable package body customerOrderDetailManager_pkg is

  procedure addBasketProductListToOrderDetail(p_customerOrderId    customerOrder.Customerorderid%type,
                                              p_list_basketProduct getBasketProductList_type) is
    v_list_index pls_integer;
  begin
    v_list_index := p_list_basketProduct.first;
  
    while v_list_index is not null loop
    
      insert into customerorderdetail
        (customerorderdetailid,
         customerorderid,
         productid,
         quantity,
         unitprice)
      values
        (customerorderdetail_seq.nextval,
         p_customerOrderId,
         p_list_basketProduct(v_list_index).productId,
         p_list_basketProduct(v_list_index).productQuantity,
         p_list_basketProduct(v_list_index).productUnitPrice);
    
      v_list_index := p_list_basketProduct.Next(v_list_index);
    end loop;
  
  end;

  function getTotalPrice(p_customerOrderId customerorderdetail.customerorderid%type)
    return customerorder.totalprice%type is
  
    v_totalPrice customerorder.totalprice%type;
  begin
    select SUM(cod.quantity * cod.unitprice)
      into v_totalPrice
      from customerorderdetail cod
     where cod.customerorderid = p_customerOrderId;
  
    return v_totalPrice;
  
  exception
    when no_data_found then
      raise_application_error(-20100, 'Data bulunamadi');
    when others then
      raise_application_error(-20105,
                              'Beklenmeyen bir hata olustu. Hata kodu: ' ||
                              sqlerrm);
    
  end;

end customerOrderDetailManager_pkg;
/
