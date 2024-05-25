create or replace noneditionable package orderManagement_pkg is

  procedure completeOrder(p_customerId        customer.customerid%type,
                          p_deliveryAddressId deliveryaddress.deliveryaddressid%type);

  function getCustomerOrderList(p_customerId customer.customerid%type)
    return getCustomerOrderList_type;

  procedure getCustomerOrderList_csvFile(p_customerId customer.customerid%type);

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
    v_taxPercentage     tax.taxpercentage%type;
    v_totalPriceWithTax customerorder.totalprice%type;
  begin
  
    v_basketId := basketManager_pkg.getBasketIdByCustomerId(p_customerId => p_customerId);
  
    v_list_basketProduct := basketProductManager_pkg.getSelectedBasketProductByBasketId(p_basketId => v_basketId);
  
    v_customerOrderId := customerOrderManager_pkg.addCustomerOrder(p_customerId        => p_customerId,
                                                                   p_deliveryAddressId => p_deliveryAddressId);
  
    customerOrderDetailManager_pkg.addBasketProductListToOrderDetail(p_customerOrderId    => v_customerOrderId,
                                                                     p_list_basketProduct => v_list_basketProduct);
  
    v_totalPrice        := customerorderdetailManager_pkg.getTotalPrice(p_customerOrderId => v_customerOrderId);
    v_taxPercentage     := taxManager_pkg.getTaxPercentage(p_taxName => V_TAXNAME);
    v_totalPriceWithTax := v_totalPrice * (100 + v_taxPercentage) / 100;
  
    customerOrderManager_Pkg.updateTotalPriceToCustomerOrder(p_customerOrderId => v_customerOrderId,
                                                             p_totalPrice      => v_totalPriceWithTax);
  
    basketProductManager_pkg.deleteProductListFromBasket(p_list_basketProduct => v_list_basketProduct);
  
    commit;
  
  exception
    when no_data_found then
      raise_application_error(-20100, 'Data bulunamadi');
    when others then
      raise_application_error(-20105,
                              'Beklenmeyen bir hata olustu. Hata kodu: ' ||
                              sqlerrm);
    
  end;

  function getCustomerOrderList(p_customerId customer.customerid%type)
    return getCustomerOrderList_type is
    v_customerOrderList getCustomerOrderList_type;
  begin
    v_customerOrderList := customerOrderManager_pkg.getCustomerOrderList(p_customerId => p_customerId);
    return v_customerOrderList;
  end;

  procedure getCustomerOrderList_csvFile(p_customerId customer.customerid%type) is
    v_customerOrderList getCustomerOrderList_type;
    v_file              utl_file.file_type;
  
    i pls_integer := 0;
    j pls_integer := 0;
  begin
    v_customerOrderList := getCustomerOrderList(p_customerId => p_customerId);
  
    -- CSV dosyasýný oluþturur
    v_file := utl_file.fopen('MY_DIRECTORY','customerId_' ||  p_customerId || '_CustomerOrderList.csv','W');
                            
  
    -- Baþlýk satýrýný yazar
    utl_file.put_line(v_file, '''''OrderNo'''', ''''OrderDate'''', ''''OrderStatus'''', ''''TotalPrice'''', ''''FullName'''', ''''DeliveryAddressDetail'''', ''''PhoneNumber'''', ''''BrandName, ''''ProductName'''', ''''ProductQuantity'''', ''''ProductUnitPrice''''');
  
    i := v_customerOrderList.first;
  
    while i is not null loop
      -- Tum satirlar dosyaya eklenir
      j := v_customerOrderList(i).productList.first;
      while j is not null loop
        utl_file.put_line(v_file, '''''' ||
                        v_customerOrderList(i).orderNo || ''''', ''''' || 
                        v_customerOrderList(i).orderDate || ''''', ''''' ||
                        v_customerOrderList(i).orderStatus || ''''', ''''' || 
                        v_customerOrderList(i).totalPrice ||''''',  ''''' || 
                        v_customerOrderList(i).fullName || ''''', ''''' || 
                        v_customerOrderList(i).DeliveryAddressDetail || ''''', ''''' ||
                        v_customerOrderList(i).phoneNumber || ''''', ''''' ||  
                        v_customerOrderList(i).productList(j).Brandname || ''''', ''''' ||
                        v_customerOrderList(i).productList(j).Productname || ''''', ''''' ||
                        v_customerOrderList(i).productList(j).Productquantity || ''''', ''''' ||
                        v_customerOrderList(i).productList(j).Productunitprice || '''''');                        

        j := v_customerOrderList(i).productList.next(j);
      end loop;
      i := v_customerOrderList.next(i);
    end loop;
  
    -- Dosyayý kapat
    utl_file.fclose(v_file);
  exception
    when others then
      if utl_file.is_open(v_file) then
        utl_file.fclose(v_file);
      end if;
      raise;
  end;

end orderManagement_pkg;
/
