create or replace noneditionable package basketManager_pkg is

  procedure addBasket(p_customerId customer.customerid%type);

  function getBasketIdByCustomerId(p_customerId customer.customerid%type)
    return basket.basketid%type;


end basketManager_pkg;
/
create or replace noneditionable package body basketManager_pkg is

  procedure addBasket(p_customerId customer.customerid%type) is
    v_basketId basket.basketid%type;
  begin
    v_basketId := basket_seq.nextval;
    
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.customerParameters(p_customerId => p_customerId);
    ecpValidate_pkg.basketParameters(p_basketId => v_basketId);
    
    -- Kullaciya ait bir sepet kimligi tanimlanir.
    insert into basket
      (basketid, customerid)
    values
      (v_basketId, p_customerId);
    
    -- Bir kullaniciya birden fazla sepet eklenirse hata olusur.
  exception
    when dup_val_on_index then      
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_BASKET_DUPLICATE);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);    
  end;

  function getBasketIdByCustomerId(p_customerId customer.customerid%type)
    return basket.basketid%type is
    v_basketId basket.basketid%type;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.customerParameters(p_customerId => p_customerId);
    ecpValidate_pkg.basketParameters(p_basketId => v_basketId);
    
    -- Musteriye ait sepet kimligi bulunur.
    select b.basketid
      into v_basketId
      from basket b
     where b.customerid = p_customerId;
    return v_basketId;
    
    -- Musteriye ait sepet bulunamazsa hata verir.
  exception
    when no_data_found then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_BASKET_NOT_FOUND);
    when others then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
  end;
 
end basketManager_pkg;
/
