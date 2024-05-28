create or replace noneditionable package customerProductFavoriteManager_pkg is

   procedure addProductToFavorite(p_customerId customer.customerid%type,
                                  p_productId product.productid%type);    
       
   
   procedure removeProductFromFavorite(p_customerId customer.customerid%type,
                                       p_productId product.productid%type);                                
   
                                  
end customerProductFavoriteManager_pkg;
/
create or replace noneditionable package body customerProductFavoriteManager_pkg is

   procedure addProductToFavorite(p_customerId customer.customerid%type,
                                  p_productId product.productid%type) is
     cursor c_customerProductFavorite is
                                select cpf.customerid, cpf.productid, cpf.isfavorite 
                                       from customerproductfavorite cpf
                                       where cpf.customerid = p_customerId
                                             and cpf.productid = p_productId for update;
     v_customerProductFavorite  c_customerProductFavorite%rowtype;
     v_isFavorite customerproductfavorite.isfavorite%type := 1;
   begin
       -- Parametre kontrolu yapilir.
       ecpValidate_pkg.customerParameters(p_customerId => p_customerId);
       ecpValidate_pkg.productParameters(p_productId => p_productId);
       ecpValidate_pkg.customerProductFavoriteParameters(p_isFavorite => v_isFavorite);
       
       open c_customerProductFavorite;
       fetch c_customerProductFavorite into v_customerProductFavorite;
       
       -- Urun daha once hic favoriye alinmadiysa tabloya kayit eklenir.
       if c_customerProductFavorite%notfound then
         insert into customerproductfavorite(customerid, productid, isfavorite)
                values(p_customerId, p_productId, v_isFavorite);
         -- Kayit eklenemediginde hata verir.
         if sql%notfound then
           close c_customerProductFavorite;
           rollback;
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_PRODUCT_FAVORITE_INSERT);
         end if;
         
         -- Urunun favori sayisini artirir.
         productManager_pkg.increaseProductFavoriteCount(p_productId => p_productId);
       else
         -- Urun daha once favoriye eklendiyse ve guncel olarak favoride degilse favoriye alinir.
         if v_customerProductFavorite.Isfavorite != 1 then
          update customerproductfavorite cpf
                 set cpf.isfavorite = v_isFavorite
                 where cpf.customerid = v_customerProductFavorite.customerId
                       and cpf.productid = v_customerProductFavorite.productId;
           -- Kayit guncellenemediginde hata verir.
           if sql%notfound then
             close c_customerProductFavorite;
             rollback;
             ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_PRODUCT_FAVORITE_NOT_FOUND_FOR_UPDATE);
           end if;
         
         -- Urunun favori sayisini artirir.
          productManager_pkg.increaseProductFavoriteCount(p_productId => p_productId);
         end if;
       end if;      
       
       close c_customerProductFavorite;
       commit;
       
       exception
       when others then
        close c_customerProductFavorite;
        rollback;
        ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);   
     end; 
     
     
   procedure removeProductFromFavorite(p_customerId customer.customerid%type,
                                  p_productId product.productid%type) is
     cursor c_customerProductFavorite is
                                select cpf.customerid, cpf.productid, cpf.isfavorite from customerproductfavorite cpf
                                       where cpf.customerid = p_customerId
                                             and cpf.productid = p_productId for update;
     v_customerProductFavorite  c_customerProductFavorite%rowtype;
     v_isFavorite customerproductfavorite.isfavorite%type := 0;
   begin
      -- Parametre kontrolu yapilir.
      ecpValidate_pkg.customerParameters(p_customerId => p_customerId);
      ecpValidate_pkg.productParameters(p_productId => p_productId);
      ecpValidate_pkg.customerProductFavoriteParameters(p_isFavorite => v_isFavorite);
       
      open c_customerProductFavorite;
      fetch c_customerProductFavorite into v_customerProductFavorite;
       
       -- Uygun urun bulunamazsa cursoru kapat       
       if c_customerProductFavorite%notfound then
         close c_customerProductFavorite;
       -- Urun daha once favoriye eklendiyse ve guncel olarak favorideyse favoriden cikartilir.                        
       else
         if v_customerProductFavorite.Isfavorite != 0 then
          update customerproductfavorite cpf
                 set cpf.isfavorite = v_isFavorite
                 where cpf.customerid = v_customerProductFavorite.customerId
                       and cpf.productid = v_customerProductFavorite.productId;
            -- Kayit guncellenemediginde hata verir.
            if sql%notfound then
              close c_customerProductFavorite;
              rollback;
              ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_PRODUCT_FAVORITE_NOT_FOUND_FOR_UPDATE);
            end if;
            
          -- Urunun favori sayisini azaltilir.
          productManager_pkg.decreaseProductFavoriteCount(p_productId => p_productId);
          end if;
       end if;    
       
       close c_customerProductFavorite;            
       commit;
       
       exception
       when others then
        close c_customerProductFavorite;
        rollback;
        ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);    
     end;    
   
end customerProductFavoriteManager_pkg;
/
