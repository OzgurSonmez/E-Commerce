create or replace noneditionable package orderManagement_pkg is

  procedure completeOrder(p_customerId        customer.customerid%type,
                          p_deliveryAddressId deliveryaddress.deliveryaddressid%type);
                          
  function getCustomerOrderList(p_customerId customer.customerid%type) 
           return getCustomerOrderList_type;

end orderManagement_pkg;
/
create or replace noneditionable package body orderManagement_pkg is

  procedure completeOrder(p_customerId        customer.customerid%type,
                          p_deliveryAddressId deliveryaddress.deliveryaddressid%type) is
    v_basketId           basket.basketid%type;
    v_customerOrderId    customerorder.customerorderid%type;
    v_list_basketProduct getBasketProductList_type := getBasketProductList_type();
    v_totalPrice         customerorderdetail.unitprice%type;
    V_TAXNAME CONSTANT VARCHAR2(50) := 'KDV';
    v_taxPercentage tax.taxpercentage%type;
    v_totalPriceWithTax customerorder.totalprice%type;
  begin
  
    v_basketId := basketManager_pkg.getBasketIdByCustomerId(p_customerId => p_customerId);
  
    v_list_basketProduct := basketProductManager_pkg.getSelectedBasketProductByBasketId(p_basketId => v_basketId);
  
    v_customerOrderId := customerOrderManager_pkg.addCustomerOrder(p_customerId        => p_customerId,
                                                                   p_deliveryAddressId => p_deliveryAddressId);
  
    customerOrderDetailManager_pkg.addBasketProductListToOrderDetail(p_customerOrderId    => v_customerOrderId,
                                                                     p_list_basketProduct => v_list_basketProduct);
  
    v_totalPrice    := customerorderdetailManager_pkg.getTotalPrice(p_customerOrderId => v_customerOrderId);
    v_taxPercentage := taxManager_pkg.getTaxPercentage(p_taxName => V_TAXNAME);
    v_totalPriceWithTax :=  v_totalPrice *(100 + v_taxPercentage) / 100;
    
    customerOrderManager_Pkg.updateTotalPriceToCustomerOrder(p_customerOrderId => v_customerOrderId,
                                                             p_totalPrice      => v_totalPriceWithTax);
                                                             
    
    basketProductManager_pkg.deleteProductListFromBasket(p_list_basketProduct =>  v_list_basketProduct); 
                                                          
    commit;
    
    exception
      when no_data_found then
         raise_application_error(-20100, 'Data bulunamadi');
      when others then
         raise_application_error(-20105, 'Beklenmeyen bir hata olustu. Hata kodu: ' || sqlerrm);                                                        
  
  end;

  function getCustomerOrderList(p_customerId customer.customerid%type) 
           return getCustomerOrderList_type is
   v_customerOrderList getCustomerOrderList_type;
   begin
     v_customerOrderList := customerOrderManager_pkg.getCustomerOrderList(p_customerId => p_customerId);
     return v_customerOrderList;
   end;

end orderManagement_pkg;
/