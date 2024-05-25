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
    select Count(*)
      into v_productCount
      from basketproduct bp
     where bp.basketid = p_basketId
       and bp.productid = p_productId;
  
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
    v_productBasketId        basketProduct.basketproductid%type;
  begin
    v_productCount := getProductCountInBasket(p_basketId  => p_basketProduct.basketId,
                                              p_productId => p_basketProduct.productId);
  
    if v_productCount > 0 then
      open c_updateProductQuantity;
      fetch c_updateProductQuantity
        into v_currentProductQuantity;
      update basketproduct bp
         set bp.productquantity = v_currentProductQuantity +
                                  nvl(p_basketProduct.productQuantity, 1)
       where current of c_updateProductQuantity;
      close c_updateProductQuantity;
    
    else
      v_productBasketId := basketProduct_seq.Nextval;
      insert into basketproduct
        (basketproductid, basketid, productid, productquantity, isselected)
      values
        (v_productBasketId,
         p_basketProduct.basketId,
         p_basketProduct.productId,
         nvl(p_basketProduct.productQuantity, 1),
         1);
    end if;
  
    commit;
  
  exception
    when others then
      close c_updateProductQuantity;
      rollback;
      raise_application_error(-20104,
                              'Urun sepete eklenirken bir hata olustu. ' ||
                              SQLERRM);
    
  end;

  procedure deleteProductFromBasket(p_basketId  basketproduct.basketid%type,
                                    p_productId basketproduct.productid%type) is
  begin
    -- Parametreden gelen product'i basket'den siler.
    delete from basketproduct bp
     where bp.basketid = p_basketId
       and bp.productid = p_productId;
  
    commit;
  
  exception
    when no_data_found then
      raise_application_error(-20120, 'Silinecek urun bulunamadi.');
    when others then
      rollback;
      raise_application_error(-20100,
                              'Urun sepetten silinirken bir hata olustu.');
  end;

  function getQuantityOfTheProductInBasket(p_basketId  basketproduct.basketid%type,
                                           p_productId basketproduct.productid%type)
    return basketProduct.productquantity%type is
    v_quantityOfTheProductInBasket basketProduct.productquantity%type;
  begin
    select bp.productquantity
      into v_quantityOfTheProductInBasket
      from basketproduct bp
     where bp.basketid = p_basketId
       and bp.productid = p_productId
       for update;
    return v_quantityOfTheProductInBasket;
  
  exception
    when others then
      rollback;
      raise_application_error(-20104,
                              'Beklenmedik bir hata olustu. ' || SQLERRM);
    
  end;

  procedure decreaseProductFromBasket(p_basketProduct in basketProduct_type) is
    v_currentProductQuantity basketProduct.Productquantity%type;
    v_resultProductQuantity  basketProduct.Productquantity%type;
  begin
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
    else
      -- Urunun sepette kalacak adedi 0 veya daha az ise urun sepetten silinir.
      deleteProductFromBasket(p_basketId  => p_basketProduct.basketId,
                              p_productId => p_basketProduct.productId);
    end if;
  
    commit;
  
  exception
    when others then
      rollback;
      raise_application_error(-20104,
                              'Beklenmedik bir hata olustu. ' || SQLERRM);
    
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
      raise_application_error(-20104,
                              'Beklenmedik bir hata olustu. ' || SQLERRM);
                              
  end;
  
  
  procedure deleteProductListFromBasket(p_list_basketProduct getBasketProductList_type) is
    v_list_index pls_integer;
  begin
    v_list_index := p_list_basketProduct.first;
    
     while v_list_index is not null loop    
      delete basketproduct bp
          where bp.basketproductid = p_list_basketProduct(v_list_index).basketProductId;    
      v_list_index := p_list_basketProduct.Next(v_list_index);
    end loop;
    
    exception
      when others then
         rollback;
         raise_application_error(-20104,'Beklenmedik bir hata olustu. ' || SQLERRM);
  end;
  
  
  
  procedure reverseSelectedStatusOfTheProductInBasket(p_basketId  basketproduct.basketid%type,
                                                      p_productId basketproduct.productid%type) is
  cursor c_selectedStatus is 
                          select bp.isselected from basketproduct bp
                                 where bp.basketid = p_basketId
                                       and bp.productid = p_productId
                                           for update;
  v_selectedStatus basketproduct.isselected%type;
  begin
    open c_selectedStatus;
    fetch c_selectedStatus into v_selectedStatus;
    
    if v_selectedStatus = 0 then
      update basketproduct bp
         set bp.isselected = 1
         where current of c_selectedStatus;
    else 
      update basketproduct bp
         set bp.isselected = 0
         where current of c_selectedStatus;
    end if;
    
    close c_selectedStatus;
    
    commit;
    
    exception
      when others then
         rollback;
         raise_application_error(-20104,'Beklenmedik bir hata olustu. ' || SQLERRM);
        
  end;
  
  
  
  
end basketProductManager_pkg;
/
