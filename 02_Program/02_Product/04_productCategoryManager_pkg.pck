create or replace noneditionable package productCategoryManager_pkg is

  procedure addProductCategory(p_productId  product.productid%type,
                               p_categoryId category.categoryid%type);
  
  procedure deleteProductCategoryByProductId(p_productId  product.productid%type);

end productCategoryManager_pkg;
/
create or replace noneditionable package body productCategoryManager_pkg is

  procedure addProductCategory(p_productId  product.productid%type,
                               p_categoryId category.categoryid%type) is
  begin
    -- Parametre kontrolu
    ecpValidate_pkg.productParameters(p_productId => p_productId);
    ecpValidate_pkg.categoryParameters(p_categoryId => p_categoryId);
  
    -- Kategoriye urun ekler.
    insert into productcategory
      (productid, categoryid)
    values
      (p_productId, p_categoryId);
  
    commit;
    -- Kayit eklenemediginde hata verir. 
  exception
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_CATEGORY_INSERT);
    
  end;

  procedure deleteProductCategoryByProductId(p_productId product.productid%type) is
    err_product_category_not_found_to_delete exception;
  begin
    -- Parametre kontrolu
    ecpValidate_pkg.productParameters(p_productId => p_productId);
  
    -- Kategoriden urun siler.
    delete productcategory pc where pc.productid = p_productId;
  
    -- Kayýt silinemediginde hata verir
    if sql%notfound then
      raise err_product_category_not_found_to_delete;
    end if;
  
    commit;
  
  exception
    when err_product_category_not_found_to_delete then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_CATEGORY_NOT_FOUND_TO_DELETE);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
  end;

end productCategoryManager_pkg;
/
