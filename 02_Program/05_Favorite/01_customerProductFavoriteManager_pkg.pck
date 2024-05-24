create or replace package customerProductFavoriteManager_pkg is

   procedure addProductToFavorite(p_customerId customer.customerid%type,
                                  p_productId product.productid%type);    
       
   
   procedure removeProductFromFavorite(p_customerId customer.customerid%type,
                                  p_productId product.productid%type); 
                                  
end customerProductFavoriteManager_pkg;
/
create or replace package body customerProductFavoriteManager_pkg is

   procedure addProductToFavorite(p_customerId customer.customerid%type,
                                  p_productId product.productid%type) is
     cursor c_customerProductFavorite is
                                select cpf.customerid, cpf.productid, cpf.isfavorite 
                                       from customerproductfavorite cpf
                                       where cpf.customerid = p_customerId
                                             and cpf.productid = p_productId for update;
     v_customerProductFavorite  c_customerProductFavorite%rowtype;
   begin
       
       open c_customerProductFavorite;
       fetch c_customerProductFavorite into v_customerProductFavorite;
       if c_customerProductFavorite%notfound then
         insert into customerproductfavorite(customerid, productid, isfavorite)
                values(p_customerId, p_productId, 1);
         productManager_pkg.increaseProductFavoriteCount(p_productId => p_productId);
       else
         if v_customerProductFavorite.Isfavorite != 1 then
          update customerproductfavorite cpf
                 set cpf.isfavorite = 1
                 where cpf.customerid = v_customerProductFavorite.customerId
                       and cpf.productid = v_customerProductFavorite.productId;
          productManager_pkg.increaseProductFavoriteCount(p_productId => p_productId);
          end if;
       end if;      
       
       close c_customerProductFavorite;
       commit;
       
       exception
       when others then
        close c_customerProductFavorite;
        rollback;
        raise_application_error(-20105,
                              'Beklenmedik bir hata olustu. Hata kodu: ' ||
                              sqlerrm);                             
                                 
       
     end; 
     
     
   procedure removeProductFromFavorite(p_customerId customer.customerid%type,
                                  p_productId product.productid%type) is
     cursor c_customerProductFavorite is
                                select cpf.customerid, cpf.productid, cpf.isfavorite from customerproductfavorite cpf
                                       where cpf.customerid = p_customerId
                                             and cpf.productid = p_productId for update;
     v_customerProductFavorite  c_customerProductFavorite%rowtype;
   begin
     
      open c_customerProductFavorite;
      fetch c_customerProductFavorite into v_customerProductFavorite;
              
       if c_customerProductFavorite%notfound then
         close c_customerProductFavorite;
         raise_application_error(-20105,'Urun zaten favori degil.');                        
       else
         if v_customerProductFavorite.Isfavorite != 0 then
          update customerproductfavorite cpf
                 set cpf.isfavorite = 0
                 where cpf.customerid = v_customerProductFavorite.customerId
                       and cpf.productid = v_customerProductFavorite.productId;
          productManager_pkg.decreaseProductFavoriteCount(p_productId => p_productId);
          end if;
       end if;    
       
       close c_customerProductFavorite;

            
       commit;
       
       exception
       when others then
        close c_customerProductFavorite;
        rollback;
        raise_application_error(-20105,
                              'Beklenmedik bir hata olustu. Hata kodu: ' ||
                              sqlerrm);                             
                                 
       
     end;    
       
end customerProductFavoriteManager_pkg;
/
