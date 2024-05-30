create or replace noneditionable package basketProductManager_pkg is

  function getProductCountInBasket(p_basketId  basketproduct.basketid%type,
                                   p_productId basketproduct.productid%type)
    return pls_integer;

  procedure addProductToBasket(p_basketProduct in basketProduct_type);

  procedure deleteProductFromBasket(p_basketId  basketproduct.basketid%type,
                                    p_productId basketproduct.productid%type);
  
  function getQuantityOfTheProductInBasket(p_basketId  basketproduct.basketid%type,
                                           p_productId basketproduct.productid%type)
    return basketProduct.productquantity%type;
  
  
  procedure decreaseProductFromBasket(p_basketProduct in basketProduct_type);
  
  
  function getSelectedBasketProductByBasketId(p_basketId basketProduct.basketid%type) 
    return getBasketProductList_type;
    
  procedure deleteProductListFromBasket(p_list_basketProduct getBasketProductList_type); 
  
  procedure reverseSelectedStatusOfTheProductInBasket(p_basketId  basketproduct.basketid%type,
                                                      p_productId basketproduct.productid%type);

end basketProductManager_pkg;
/
create or replace noneditionable package body basketProductManager_pkg is

  function getProductCountInBasket(p_basketId  basketproduct.basketid%type,
                                   p_productId basketproduct.productid%type)
    return pls_integer is
    v_productCount pls_integer;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.basketParameters(p_basketId => p_basketId);
    ecpValidate_pkg.productParameters(p_productId => p_productId); 
  
    -- Musterinin sepetinde parametreden gelen urunun varligini kontrol eder.
    select count(*)
      into v_productCount
      from basketproduct bp
     where bp.basketid = p_basketId
       and bp.productid = p_productId;
       
    -- Urun satir sayisini doner.
    return v_productCount;
  end;

  procedure addProductToBasket(p_basketProduct in basketProduct_type) is
    cursor c_updateProductQuantity is
      select bp.productquantity
        from basketProduct bp
       where bp.basketid = p_basketProduct.basketId
         and bp.productid = p_basketProduct.productId
         for update;
  
    v_currentProductQuantity basketProduct.Productquantity%type;
    v_productCount           pls_integer;
    v_basketProductId        basketProduct.basketproductid%type;
    v_isSelected             basketProduct.Isselected%type := 1;
    err_product_not_found_in_basket exception;    
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.basketParameters(p_basketId => p_basketProduct.basketId);
    ecpValidate_pkg.productParameters(p_productId => p_basketProduct.productId);  
    
    
    v_productCount := getProductCountInBasket(p_basketId  => p_basketProduct.basketId,
                                              p_productId => p_basketProduct.productId);
                                              
    -- Sepette daha once belirtilen urun varsa urun adedine ekleme yapar.
    if v_productCount > 0 then
      -- Parametre kontrolu yapilir.
      ecpValidate_pkg.basketProductParameters(p_productQuantity => (v_currentProductQuantity +
                                  nvl(p_basketProduct.productQuantity, 1)));
      open c_updateProductQuantity;
      fetch c_updateProductQuantity
        into v_currentProductQuantity;
        
      -- Urun adedi guncellenir.  
      update basketproduct bp
         set bp.productquantity = v_currentProductQuantity +
                                  nvl(p_basketProduct.productQuantity, 1)
       where current of c_updateProductQuantity;
       
      close c_updateProductQuantity;
      
      -- Guncellenecek urun sepette bulunamazsa hata verir.
      if sql%notfound then
         raise err_product_not_found_in_basket;         
      end if;
      
    -- Sepette daha once belirtilen urun yoksa sepete urunu ekler.
    else
      v_basketProductId := basketProduct_seq.Nextval;
      -- Parametre kontrolu yapilir.
      ecpValidate_pkg.basketProductParameters(p_basketProductId => v_basketProductId,
                                              p_productQuantity => nvl(p_basketProduct.productQuantity, 1),
                                              p_isSelected => v_isSelected);
                                              
      -- Sepete urunu belirtilen adette ekler. Adet belirtilmemisse 1 adet ekler.                                        
      insert into basketproduct
        (basketproductid, basketid, productid, productquantity, isselected)
      values
        (v_basketProductId,
         p_basketProduct.basketId,
         p_basketProduct.productId,
         nvl(p_basketProduct.productQuantity, 1),
         v_isSelected);
    end if;
  
    commit;
  
  exception
    when err_product_not_found_in_basket then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_NOT_FOUND_IN_BASKET_FOR_UPDATE);
    when others then
      close c_updateProductQuantity;
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
    
  end;

  procedure deleteProductFromBasket(p_basketId  basketproduct.basketid%type,
                                    p_productId basketproduct.productid%type) is
  err_product_not_found_to_delete_from_basket exception;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.basketParameters(p_basketId => p_basketId);
    ecpValidate_pkg.productParameters(p_productId => p_productId);
    
    -- Parametreden gelen urunu sepetten siler.
    delete from basketproduct bp
     where bp.basketid = p_basketId
       and bp.productid = p_productId;
       
     -- Silinecek urun sepette bulunamazsa hata verir.
    if sql%notfound then
      raise err_product_not_found_to_delete_from_basket;      
    end if;
  
    commit;
  
  exception
    when err_product_not_found_to_delete_from_basket then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_NOT_FOUND_TO_DELETE_FROM_BASKET);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
  end;

  function getQuantityOfTheProductInBasket(p_basketId  basketproduct.basketid%type,
                                           p_productId basketproduct.productid%type)
    return basketProduct.productquantity%type is
    v_quantityOfTheProductInBasket basketProduct.productquantity%type;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.basketParameters(p_basketId => p_basketId);
    ecpValidate_pkg.productParameters(p_productId => p_productId);
    
    -- Sepetteki urun adedini bulur.
    select bp.productquantity
      into v_quantityOfTheProductInBasket
      from basketproduct bp
     where bp.basketid = p_basketId
       and bp.productid = p_productId
       for update;
    return v_quantityOfTheProductInBasket;
   
   -- Sepette urun bulunamazsa veya bir sepette ayni urun birden fazla satirda olursa hata verir.
  exception
    when no_data_found then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_NOT_FOUND_IN_BASKET);
    when too_many_rows then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_TOO_MANY_ROWS_IN_BASKET);         
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
    
  end;

  procedure decreaseProductFromBasket(p_basketProduct in basketProduct_type) is
    v_currentProductQuantity basketProduct.Productquantity%type;
    v_resultProductQuantity  basketProduct.Productquantity%type;
    err_product_not_found_in_basket_for_update exception;
    err_product_not_found_to_delete_from_basket exception;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.basketParameters(p_basketId => p_basketProduct.basketId);
    ecpValidate_pkg.productParameters(p_productId => p_basketProduct.productId);
    ecpValidate_Pkg.basketProductParameters(p_productQuantity => p_basketProduct.productQuantity);
  
    -- Urunun sepetteki guncel adedi getirilir.
    v_currentProductQuantity := getQuantityOfTheProductInBasket(p_basketId  => p_basketProduct.basketId,
                                                                p_productId => p_basketProduct.productId);
    -- Urunu sepetten cikartildiginde kac adet kalacagi hesaplanir.                                                            
    v_resultProductQuantity := v_currentProductQuantity -
                               nvl(p_basketProduct.productQuantity, 1);
  
    if v_resultProductQuantity > 0 then
      -- Urunun sepette kalacak adedi 0'dan buyuk ise deger guncellenir.
      update basketProduct bp
         set bp.productquantity = v_resultProductQuantity
       where bp.basketid = p_basketProduct.basketId
         and bp.productid = p_basketProduct.productId;
       -- Guncellenecek urun sepette bulunamazsa hata verir.
      if sql%notfound then
        raise err_product_not_found_in_basket_for_update;         
      end if;
    else
      -- Urunun sepette kalacak adedi 0 veya daha az ise urun sepetten silinir.
      deleteProductFromBasket(p_basketId  => p_basketProduct.basketId,
                              p_productId => p_basketProduct.productId);
      -- Silinecek urun sepette bulunamazsa hata verir.
      if sql%notfound then
        raise err_product_not_found_to_delete_from_basket;         
      end if;       
    end if;
  
    commit;
  
  exception
    when err_product_not_found_in_basket_for_update then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_NOT_FOUND_IN_BASKET_FOR_UPDATE);
    when err_product_not_found_to_delete_from_basket then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_NOT_FOUND_TO_DELETE_FROM_BASKET);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
    
  end;

  
  
  function getSelectedBasketProductByBasketId(p_basketId basketProduct.basketid%type)
    return getBasketProductList_type is
    
    v_basketProductList getBasketProductList_type := getBasketProductList_type();
    i pls_integer := 0;
  
    -- Sepetten secili olan urunleri getirir.
    cursor c_basketProduct is
      select bp.basketproductid,
             bp.basketid,
             bp.productid,
             bp.productquantity,
             p.price,
             bp.isselected
        from basketproduct bp, product p
       where bp.productid = p.productid
         and bp.basketid = p_basketId
         and bp.isselected = 1;
  
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.basketParameters(p_basketId => p_basketId);
    
  
    -- Sepetten secili olan urunleri bir listeye atar.
    for v_basketProduct in c_basketProduct loop
      i := i + 1;
      v_basketProductList.extend;
      v_basketProductList(i) := getBasketProduct_type(basketProductId  => v_basketProduct.basketproductid,
                                                      basketId         => v_basketProduct.basketid,
                                                      productId        => v_basketProduct.productid,
                                                      productQuantity  => v_basketProduct.productquantity,
                                                      productUnitPrice => v_basketProduct.Price,
                                                      isSelected       => v_basketProduct.isselected);
    end loop;
  
    return v_basketProductList;
    
    exception
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
                              
  end;
  
  
  procedure deleteProductListFromBasket(p_list_basketProduct getBasketProductList_type) is
    v_list_index pls_integer;
    err_product_not_found_to_delete_from_basket exception;
  begin    
    v_list_index := p_list_basketProduct.first;
    
     while v_list_index is not null loop
       -- Parametre kontrolu yapilir.
       ecpValidate_pkg.basketProductParameters(p_basketProductId => p_list_basketProduct(v_list_index).basketProductId);
       
       -- basketProductId ile eslesen sepetteki urunler silinir.    
       delete basketproduct bp
          where bp.basketproductid = p_list_basketProduct(v_list_index).basketProductId;
        -- Silinecek urun sepette bulunamazsa hata verir.
       if sql%notfound then
         raise err_product_not_found_to_delete_from_basket;         
       end if; 
          
      v_list_index := p_list_basketProduct.Next(v_list_index);
    end loop;
    
    exception
      when err_product_not_found_to_delete_from_basket then
        rollback;
         ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_NOT_FOUND_TO_DELETE_FROM_BASKET);
      when others then
         rollback;
         ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
  end;
  
  

  
  
  procedure reverseSelectedStatusOfTheProductInBasket(p_basketId  basketproduct.basketid%type,
                                                      p_productId basketproduct.productid%type) is
  cursor c_selectedStatus is 
                          select bp.isselected from basketproduct bp
                                 where bp.basketid = p_basketId
                                       and bp.productid = p_productId
                                           for update;
  v_selectedStatus basketproduct.isselected%type;
  err_product_not_found_in_basket exception;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.basketParameters(p_basketId => p_basketId);
    ecpValidate_pkg.productParameters(p_productId => p_productId);
    
    open c_selectedStatus;
    fetch c_selectedStatus into v_selectedStatus;
    
    -- Urunun sepetteki durumu secili de�ilse ise secilmise cevirir.
    if v_selectedStatus = 0 then
      update basketproduct bp
         set bp.isselected = 1
         where current of c_selectedStatus;
      -- Guncellenecek urun sepette bulunamazsa hata verir.
      if sql%notfound then
        raise err_product_not_found_in_basket;         
      end if;
      
    -- Urunun sepetteki durumu secili ise secilmemise cevirir.
    else 
      update basketproduct bp
         set bp.isselected = 0
         where current of c_selectedStatus;
      -- Guncellenecek urun sepette bulunamazsa hata verir.
      if sql%notfound then
         raise err_product_not_found_in_basket;
      end if;
    end if;
    
    close c_selectedStatus;
    
    commit;
    
    exception
      when err_product_not_found_in_basket then
        rollback;
        ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_NOT_FOUND_IN_BASKET_FOR_UPDATE);
      when others then
         rollback;
         ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
        
  end;
  
  
  
  
end basketProductManager_pkg;
/
