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
    v_customerOrderDetailId   customerorderdetail.customerorderdetailid%type;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.customerOrderParameters(p_customerOrderId);
    
    -- Index'e listenin baslangic index'i atanir.
    v_list_index := p_list_basketProduct.first;
  
    while v_list_index is not null loop
      v_customerOrderDetailId := customerorderdetail_seq.nextval;
      -- Parametre kontrolu yapilir.
      ecpValidate_pkg.customerOrderDetailParameters(p_customerOrderDetailId => v_customerOrderDetailId,
                                                    p_productQuantity => p_list_basketProduct(v_list_index).productQuantity,      
                                                    p_productUnitPrice => p_list_basketProduct(v_list_index).productUnitPrice);
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
         p_list_basketProduct(v_list_index).productId,
         p_list_basketProduct(v_list_index).productQuantity,
         p_list_basketProduct(v_list_index).productUnitPrice);
         
      -- Sýradaki index'e gecilir.
      v_list_index := p_list_basketProduct.Next(v_list_index);
    end loop;
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

end customerOrderDetailManager_pkg;
/
