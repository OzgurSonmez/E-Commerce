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
    insert into productcategory
      (productid, categoryid)
    values
      (p_productId, p_categoryId);
  
    commit;
  
  exception
    when value_error then
      rollback;
      raise_application_error(-20101, 'Geçersiz veri hatasý.');
    when others then
      rollback;
      raise_application_error(-20105,
                              'Beklenmeyen bir hata oluþtu. Hata kodu: ' ||
                              sqlerrm);
  end;
  
  
  procedure deleteProductCategoryByProductId(p_productId product.productid%type) is
  begin
    delete productcategory pc where pc.productid = p_productId;
  
  exception
    when others then
      rollback;
      raise_application_error(-20105,
                              'Beklenmeyen bir hata olustu. Hata kodu: ' ||
                              sqlerrm);
  end;

end productCategoryManager_pkg;
/
