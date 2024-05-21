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
    insert into basket
      (basketid, customerid)
    values
      (v_basketId, p_customerId);
  
  exception
    when dup_val_on_index then
      raise_application_error(-20120,
                              'Bu kullanicinin birden fazla sepeti olamaz.');
      rollback;
    when others then
      raise_application_error(-20105,
                              'Beklenmeyen bir hata olustu. Hata kodu: ' ||
                              sqlerrm);
      rollback;
    
  end;
  
  function getBasketIdByCustomerId(p_customerId customer.customerid%type)
    return basket.basketid%type is
      v_basketId basket.basketid%type;
    begin
           select b.basketid into v_basketId from basket b
                  where b.customerid = p_customerId;
           return v_basketId;
           
    exception
      when no_data_found then
           raise_application_error(-20120, 'Bu kullaniciya ait bir sepet yok.');
           return null;
      when others then
           raise_application_error(-20105, 'Beklenmeyen bir hata olustu. Hata kodu: ' || sqlerrm);
           return null; 
    end; 

end basketManager_pkg;
/
