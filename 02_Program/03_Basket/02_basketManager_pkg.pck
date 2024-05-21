create or replace package basketManager_pkg is

  procedure addBasket(p_customerId customer.customerid%type);

end basketManager_pkg;
/
create or replace package body basketManager_pkg is

  procedure addBasket(p_customerId customer.customerid%type) is
    v_basketId basket.basketid%type;
    begin
      v_basketId := basket_seq.nextval;
        insert into basket(basketid, customerid)
               values(v_basketId, p_customerId);
      
      exception
      when dup_val_on_index then
           raise_application_error(-20120, 'Bu kullanicinin birden fazla sepeti olamaz.');
           rollback;
      when others then
           raise_application_error(-20105, 'Beklenmeyen bir hata olustu. Hata kodu: ' || sqlerrm);
           rollback;   
    
      end;

end basketManager_pkg;
/
