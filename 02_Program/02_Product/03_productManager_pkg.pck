create or replace noneditionable package productManager_pkg is

  procedure addProduct(p_addProduct in addProduct_type);

  procedure deleteProduct(p_productId product.productid%type);

  procedure filterProduct(p_filterProduct in filterProduct_type);
  
  procedure increaseProductFavoriteCount(p_productId product.productid%type);
  
  procedure decreaseProductFavoriteCount(p_productId product.productid%type);

end productManager_pkg;
/
create or replace noneditionable package body productManager_pkg is

  procedure addProduct(p_addProduct in addProduct_type) is
    v_productId product.productid%type;
  begin
    if (p_addProduct.discountPercentange < 0 or
       p_addProduct.discountPercentange > 100) then
      raise_application_error(-20107,
                              'Ýndirim oraný 0 ile 101 arasýnda olmalýdýr.');
    end if;
  
    v_productId := product_seq.nextval;
  
    insert into product
      (productid,
       brandid,
       productname,
       productdescription,
       price,
       discountpercentage,
       favcount)
    values
      (v_productId,
       p_addProduct.brandId,
       p_addProduct.productName,
       p_addProduct.productDescription,
       p_addProduct.price,
       NVL(p_addProduct.discountPercentange, 0),
       0);
  
    productCategoryManager_pkg.addProductCategory(p_productId  => v_productId,
                                                  p_categoryId => p_addProduct.categoryId);
  
    commit;
  
  exception
    when value_error then
      rollback;
      raise_application_error(-20101, 'Geçersiz veri hatasý.');
    when others then
      rollback;
      raise_application_error(-20105,
                              'Beklenmeyen bir hata olustu. Hata kodu: ' ||
                              sqlerrm);
    
  end;

  procedure deleteProduct(p_productId product.productid%type) is
  begin
  
    productCategoryManager_pkg.deleteProductCategoryByProductId(p_productId => p_productId);
    delete product p where p.productid = p_productId;
  
    if (sql%rowcount = 0) then
      raise_application_error(-20101, 'Silinecek ürün bulunamadý.');
    end if;
  
    commit;
  exception
    when others then
      rollback;
      raise_application_error(-20105,
                              'Beklenmeyen bir hata olustu. Hata kodu: ' ||
                              sqlerrm);
  end;

  procedure filterProduct(p_filterProduct in filterProduct_type) is
    v_query  varchar2(3000);
    v_cursor sys_refcursor;
  
    type rec_product is record(
      categoryName category.categoryname%type,
      brandName    brand.brandname%type,
      productName  product.productname%type,
      price        product.price%type,
      discount     product.discountpercentage%type,
      favcount     product.favcount%type);
  
    v_rec_product rec_product;
  
  BEGIN
    -- recursiveCategory sorgusu parametreden gelen categoryId'nin alt kategorileri döner.
    -- categoryId null deðer gelirse tüm kategorileri döner.
    -- parametreden gelebilecek diðer filtrelerin null durumu kontrol edilerek where kosuluna eklenmistir.
    v_query := 'with recursiveCategory(categoryId, categoryName, parentCategoryId) as (
                  select cat.categoryid, cat.categoryname, cat.parentcategoryid
                     from category cat
                        where (:categoryId is null and cat.parentcategoryid is null)
                           or (:categoryId is not null and cat.categoryid = :categoryId)
                  union all
                  select ct.categoryid, ct.categoryname, ct.parentcategoryid
                     from category ct, recursivecategory rc
                        where ct.parentcategoryid = rc.categoryid
                 )
                  select rc.categoryName          categoryName,
                         b.brandname              brandName,
                         p.productname            productName,
                         p.price                  price,
                         p.discountpercentage     discount,
                         p.favcount               favcount
                      from product p, productcategory pc, recursiveCategory rc, brand b
                         where p.productid = pc.productid 
                           and p.brandid = b.brandid 
                           and pc.categoryid = rc.categoryid 
                           and (:brandId is null or p.brandid = :brandId)
                           and (:productName is null or lower(p.productname) like ''%'' || lower(:productName) || ''%'')
                           and (:minPrice is null or p.price >= :minPrice)
                           and (:maxPrice is null or p.price <= :maxPrice)
                          order by ';
  
    -- Parametreden gelebilecek siralama secenegi
    if p_filterproduct.orderBy = 'price' then
      v_query := v_query || 'p.price ';
    elsif p_filterproduct.orderBy = 'discount' then
      v_query := v_query || 'p.discountpercentage ';
    elsif p_filterproduct.orderBy = 'favcount' then
      v_query := v_query || 'p.favcount ';
    else
      v_query := v_query || 'p.productid ';
    end if;
  
    -- Siralama yonu secenegi
    if p_filterproduct.orderDirection = 'descending' then
      v_query := v_query || 'desc ';
    elsif p_filterproduct.orderDirection = 'ascending' then
      v_query := v_query || 'asc ';
    else
      v_query := v_query || 'asc ';
    end if;
  
    open v_cursor for v_query
      using p_filterProduct.categoryId,
            p_filterProduct.categoryId,
            p_filterProduct.categoryId,
            p_filterProduct.brandId,
            p_filterProduct.brandId,
            p_filterProduct.productName,
            p_filterProduct.productName,
            p_filterProduct.minPrice,
            p_filterProduct.minPrice,
            p_filterProduct.maxPrice,
            p_filterProduct.maxPrice;
  
    loop
      fetch v_cursor
        into v_rec_product;
      exit when v_cursor%notfound;
    
      dbms_output.put_line(' ' || v_rec_product.categoryName || ' ' ||
                           v_rec_product.brandName || ' ' ||
                           v_rec_product.productName || ' ' ||
                           v_rec_product.price || ' ' ||
                           v_rec_product.discount || ' ' ||
                           v_rec_product.favcount);
    end loop;
  
    close v_cursor;
  
  exception
    when others then
      if v_cursor%isopen then
        close v_cursor;
      end if;
      raise_application_error(-20105,
                              'Urünleri listelerken beklenmedik bir hata olustu. Hata kodu: ' ||
                              sqlerrm);
  END;

  procedure increaseProductFavoriteCount(p_productId product.productid%type) is
  
    cursor c_productFavoriteCount is
      select p.favcount
        from product p
       where p.productid = p_productId
         for update;
    v_currentProductFavoriteCount product.favcount%type;
  begin
    open c_productFavoriteCount;
    fetch c_productFavoriteCount
      into v_currentProductFavoriteCount;
  
    if c_productFavoriteCount%found then
      update product p 
             set p.favcount = v_currentProductFavoriteCount + 1
             where current of c_productFavoriteCount;
    else
      rollback;
      raise_application_error(-20117,
                              'Belirtilen productId ile eslesen urun bulunamadi.');
    end if;
  
    close c_productFavoriteCount;
    
    exception
       when others then
        if c_productFavoriteCount%isopen then
          close c_productFavoriteCount;          
        end if;
        rollback;
        raise_application_error(-20105,
                              'Beklenmedik bir hata olustu. Hata kodu: ' ||
                              sqlerrm);
  end;
  
  
  procedure decreaseProductFavoriteCount(p_productId product.productid%type) is
  
    cursor c_productFavoriteCount is
      select p.favcount
        from product p
       where p.productid = p_productId
         for update;
    v_currentProductFavoriteCount product.favcount%type;
  begin
    
    open c_productFavoriteCount;
    fetch c_productFavoriteCount
      into v_currentProductFavoriteCount;
  
    if c_productFavoriteCount%found then
      update product p 
             set p.favcount = v_currentProductFavoriteCount - 1
             where current of c_productFavoriteCount;
    else
      rollback;
      raise_application_error(-20117,
                              'Belirtilen productId ile eslesen urun bulunamadi.');
    end if;
    close c_productFavoriteCount; 
    
    exception
       when others then
        if c_productFavoriteCount%isopen then
          close c_productFavoriteCount;          
        end if;
        rollback;
        raise_application_error(-20105,
                              'Beklenmedik bir hata olustu. Hata kodu: ' ||
                              sqlerrm);
  end;

end productManager_pkg;
/
