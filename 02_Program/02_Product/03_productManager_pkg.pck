create or replace noneditionable package productManager_pkg is

  procedure addProduct(p_addProduct in addProduct_type);

  procedure deleteProduct(p_productId product.productid%type);

  function filterProduct(p_filterProduct in filterProduct_type) return sys_refcursor;
  
  procedure increaseProductFavoriteCount(p_productId product.productid%type);
  
  procedure decreaseProductFavoriteCount(p_productId product.productid%type);

end productManager_pkg;
/
create or replace noneditionable package body productManager_pkg is

  procedure addProduct(p_addProduct in addProduct_type) is
    v_productId product.productid%type;
  begin
  
    v_productId := product_seq.nextval;
  
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.brandParameters(p_brandId => p_addProduct.brandId);
    ecpValidate_pkg.productParameters(p_productId          => v_productId,
                                      p_productName        => p_addProduct.productName,
                                      p_productDescription => p_addProduct.productDescription,
                                      p_price              => p_addProduct.price,
                                      p_discountPercentage => p_addProduct.discountPercentange);
    ecpValidate_pkg.categoryParameters(p_categoryId => p_addProduct.categoryId);
  
    -- Urun eklenir.
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
  
    -- Urun bir kategoriye eklenir.
    productCategoryManager_pkg.addProductCategory(p_productId  => v_productId,
                                                  p_categoryId => p_addProduct.categoryId);
  
    commit;
  
  exception
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_INSERT);
  end;

  procedure deleteProduct(p_productId product.productid%type) is
    err_product_not_found_to_delete exception;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.productParameters(p_productId => p_productId);
  
    -- Urunu silmeden once kategoriye bagliligi kaldirilir.
    productCategoryManager_pkg.deleteProductCategoryByProductId(p_productId => p_productId);
  
    -- Urun silinir.
    delete product p where p.productid = p_productId;
  
    -- Silinen bir urun yoksa hata uret.
    if sql%notfound then
      raise err_product_not_found_to_delete;
    end if;
  
    commit;
  exception
    when err_product_not_found_to_delete then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_NOT_FOUND_TO_DELETE);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
  end;

  function filterProduct(p_filterProduct in filterProduct_type)
    return sys_refcursor is
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
    v_counter     pls_integer := 0;
  
  begin
    -- parametre kontrolu yapilir.
    ecpValidate_pkg.categoryParameters(p_categoryId => p_filterProduct.categoryId);
    ecpValidate_pkg.brandParameters(p_brandId => p_filterProduct.brandId);
    ecpValidate_pkg.productParameters(p_productName => p_filterProduct.productName,
                                      p_price       => p_filterProduct.minPrice);
    ecpValidate_pkg.productParameters(p_price => p_filterProduct.maxPrice);
  
    -- recursiveCategory sorgusu parametreden gelen categoryId'nin alt kategorileri d�ner.
    -- categoryId null de�er gelirse t�m kategorileri d�ner.
    -- parametreden gelebilecek di�er filtrelerin null durumu kontrol edilerek where kosuluna eklenmistir.
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
                  select rc.categoryId            categoryId,
                         rc.categoryName          categoryName,                         
                         b.brandId                brandId,
                         b.brandname              brandName,                         
                         p.productId              productId,
                         p.productname            productName,
                        (p.price * (100 - p.discountpercentage) / 100)  price,
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
  
    -- Dinamik sorguyu calistirmak icin cursor acilir.
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
  
    -- Cursor'daki sonuclar islenir.
    -- loop
    --   fetch v_cursor
    --     into v_rec_product;
    --   exit when v_cursor%notfound;
  
    --   v_counter := v_counter + 1;
    --   dbms_output.put_line(v_counter || '-> ' ||
    --                        v_rec_product.categoryName || ' ' ||
    --                        v_rec_product.brandName || ' ' ||
    --                        v_rec_product.productName || ' ' ||
    --                        v_rec_product.price || ' ' ||
    --                        v_rec_product.discount || ' ' ||
    --                        v_rec_product.favcount);
    -- end loop;
  
    -- close v_cursor;
    return v_cursor;
  exception
    when others then
      if v_cursor%isopen then
        close v_cursor;
      end if;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
  end;

  procedure increaseProductFavoriteCount(p_productId product.productid%type) is
  
    v_currentProductFavoriteCount product.favcount%type;
  
    err_product_favorite_count_for_update exception;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.productParameters(p_productId => p_productId);
  
    -- Urunun favori sayisi alinir ve kitlenir.   
    select p.favcount
      into v_currentProductFavoriteCount
      from product p
     where p.productid = p_productId
       for update;
  
    -- Favori sayisini artt�r.
    update product p
       set p.favcount = v_currentProductFavoriteCount + 1
     where p.productid = p_productId;
  
    -- Urunun favori sayisi degismezse hata verir.
    if sql%notfound then
      raise err_product_favorite_count_for_update;
    end if;
  
  exception
    when err_product_favorite_count_for_update then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_FAVORITE_COUNT_FOR_UPDATE);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
  end;

  procedure decreaseProductFavoriteCount(p_productId product.productid%type) is
  
    v_currentProductFavoriteCount product.favcount%type;
  
    err_product_favorite_count_for_update exception;
    err_product_not_found                 exception;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.productParameters(p_productId => p_productId);
  
    -- Urunun favori sayisi alinir ve kitlenir.
    select p.favcount
      into v_currentProductFavoriteCount
      from product p
     where p.productid = p_productId
       for update;
  
    -- Favori sayisini azalt.
    update product p
       set p.favcount = v_currentProductFavoriteCount - 1
     where p.productid = p_productId;
  
    -- Urunun favori sayisi degismezse hata verir.
    if sql%notfound then
      raise err_product_favorite_count_for_update;
    end if;
  
  exception
    when err_product_favorite_count_for_update then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_FAVORITE_COUNT_FOR_UPDATE);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
  end;

end productManager_pkg;
/
