create or replace noneditionable package orderManagement_pkg is

  procedure completeOrder(p_customerId        customer.customerid%type,
                          p_deliveryAddressId deliveryaddress.deliveryaddressid%type);

  function getCustomerOrderList(p_customerId customer.customerid%type)
    return getCustomerOrderList_type;
    
  function getTotalPriceWithTax(p_customerOrderId customerorder.customerorderid%type)
    return customerorder.totalprice%type;

  procedure getCustomerOrderList_csvFile(p_customerId customer.customerid%type);

end orderManagement_pkg;
/
create or replace noneditionable package body orderManagement_pkg is

  procedure completeOrder(p_customerId        customer.customerid%type,
                          p_deliveryAddressId deliveryaddress.deliveryaddressid%type) is
    v_basketId           basket.basketid%type;
    v_customerOrderId    customerorder.customerorderid%type;
    v_list_basketProduct getBasketProductList_type := getBasketProductList_type();
    v_totalPriceWithTax  customerorder.totalprice%type;
  begin
    -- CustomerId'ye gore BasketId'yi getirir.
    v_basketId := basketManager_pkg.getBasketIdByCustomerId(p_customerId => p_customerId);
  
    -- BasketId'ye gore sepetteki secili olan urunlerin listesini getirir. 
    v_list_basketProduct := basketProductManager_pkg.getSelectedBasketProductByBasketId(p_basketId => v_basketId);
  
    -- Musteri siparisi olusturulur.
    v_customerOrderId := customerOrderManager_pkg.addCustomerOrder(p_customerId        => p_customerId,
                                                                   p_deliveryAddressId => p_deliveryAddressId);
  
    -- Olusturulan musteri siparisine sepetten gelen urunler eklenir.
    customerOrderDetailManager_pkg.addBasketProductListToOrderDetail(p_customerOrderId    => v_customerOrderId,
                                                                     p_list_basketProduct => v_list_basketProduct);
  
    -- KDV dahil toplam siparis tutari hesaplanir.
    v_totalPriceWithTax := getTotalPriceWithTax(p_customerOrderId => v_customerOrderId);
  
    -- Siparis ayrintisinda toplam siparis tutari guncellenir.
    customerOrderManager_pkg.updateTotalPriceToCustomerOrder(p_customerOrderId => v_customerOrderId,
                                                             p_totalPrice      => v_totalPriceWithTax);
    -- Siparisi tamamlanan urunler sepetten cikartilir.
    basketProductManager_pkg.deleteProductListFromBasket(p_list_basketProduct => v_list_basketProduct);
  
    commit;
  
  exception
    when others then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_COMPLATE_ORDER);
    
  end;

  function getTotalPriceWithTax(p_customerOrderId customerorder.customerorderid%type)
    return customerorder.totalprice%type is
    v_totalPrice    customerorderdetail.unitprice%type;
    v_taxPercentage tax.taxpercentage%type;
    V_TAXNAME CONSTANT VARCHAR2(50) := 'KDV';
    v_totalPriceWithTax customerorder.totalprice%type;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.customerOrderParameters(p_customerOrderId => p_customerOrderId);
  
    -- Vergi dahil toplam siparis tutari hesaplanir.
    v_totalPrice        := customerorderdetailManager_pkg.getTotalPrice(p_customerOrderId => p_customerOrderId);
    v_taxPercentage     := taxManager_pkg.getTaxPercentage(p_taxName => V_TAXNAME);
    v_totalPriceWithTax := v_totalPrice * (100 + v_taxPercentage) / 100;
  
    return v_totalPriceWithTax;
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
  
    -- CSV dosyasýný oluþtur
    v_file := utl_file.fopen('MY_DIRECTORY',
                             'customerId_' || p_customerId ||
                             '_CustomerOrderList.csv',
                             'W');
  
    -- Baþlýk satýrýný yaz
    utl_file.put_line(v_file,
                      '''''OrderNo'''', ''''OrderDate'''', ''''OrderStatus'''', ''''TotalPrice'''', ''''FullName'''', ''''DeliveryAddressDetail'''', ''''PhoneNumber'''', ''''BrandName, ''''ProductName'''', ''''ProductQuantity'''', ''''ProductUnitPrice''''');
  
    i := v_customerOrderList.first;
  
    while i is not null loop
    
      j := v_customerOrderList(i).productList.first;
      while j is not null loop
        utl_file.put_line(v_file,
                          '''''' || v_customerOrderList(i).orderNo ||
                          ''''', ''''' || v_customerOrderList(i).orderDate ||
                          ''''', ''''' || v_customerOrderList(i).orderStatus ||
                          ''''', ''''' || v_customerOrderList(i).totalPrice ||
                          ''''',  ''''' || v_customerOrderList(i).fullName ||
                          ''''', ''''' || v_customerOrderList(i).DeliveryAddressDetail ||
                          ''''', ''''' || v_customerOrderList(i).phoneNumber ||
                          ''''', ''''' || v_customerOrderList(i).productList(j).Brandname ||
                          ''''', ''''' || v_customerOrderList(i).productList(j).Productname ||
                          ''''', ''''' || v_customerOrderList(i).productList(j).Productquantity ||
                          ''''', ''''' || v_customerOrderList(i).productList(j).Productunitprice ||
                          '''''');
      
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
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_ORDER_CSV_FILE);
  end;

end orderManagement_pkg;
/
