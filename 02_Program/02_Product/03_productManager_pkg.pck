create or replace noneditionable package productManager_pkg is

    procedure addProduct(p_addProduct in addProduct_type);
    
    procedure deleteProduct(p_productId product.productid%type);

end productManager_pkg;
/
create or replace noneditionable package body productManager_pkg is

  procedure addProduct(p_addProduct in addProduct_type) is
    v_productId product.productid%type;
  begin
    if (p_addProduct.discountPercentange < 0 or p_addProduct.discountPercentange > 100) then
       raise_application_error(-20107, 'Ýndirim oraný 0 ile 101 arasýnda olmalýdýr.');
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
       
       productCategoryManager_pkg.addProductCategory(p_productId => v_productId, p_categoryId => p_addProduct.categoryId);
       
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
end productManager_pkg;
/
