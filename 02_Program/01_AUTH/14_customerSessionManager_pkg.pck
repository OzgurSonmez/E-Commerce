create or replace noneditionable package customerSessionManager_pkg is

   procedure addCustomerSession(p_customerId customersession.customerid%type);
   
   procedure setLoginStatusTrue(p_customerId customersession.customerid%type);

end customerSessionManager_pkg;
/
create or replace noneditionable package body customerSessionManager_pkg is

  procedure addCustomerSession(p_customerId customersession.customerid%type) is
    v_customerSessionId customersession.customersessionid%type;
    v_isLogin           customersession.islogin%type;
  begin
    v_customerSessionId := customerSession_seq.nextval;
    -- Uye olduktan sonra oturum kapali olarak ayarlansin.
    v_isLogin := 0;
  
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.customerParameters(p_customerId => p_customerId);
    ecpValidate_pkg.customerSessionParameters(p_customerSessionId => v_customerSessionId,
                                              p_isLogin           => v_isLogin);
  
    -- Musteri oturum durumu eklenir.
    insert into customersession
      (customersessionid, customerid, islogin)
    values
      (v_customerSessionId, p_customerId, v_isLogin);
  
    -- Musteri oturum durumu eklenmezse hata uretir
  exception
    when dup_val_on_index then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_SESSION_DUPLICATE);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_SESSION_INSERT);
  end;

  procedure setLoginStatusTrue(p_customerId customersession.customerid%type) is
  
    v_currentLoginStatus                     customersession.islogin%type;
    v_loginStatus                            customersession.islogin%type;
    err_customer_session_is_login_for_update exception;
  begin
    -- Oturum durumu 1 secilir.
    v_loginStatus := 1;
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.customerParameters(p_customerId => p_customerId);
    ecpValidate_pkg.customerSessionParameters(p_isLogin => v_loginStatus);
  
    -- Guncellenecek satir kilitlenir. 
    select cs.islogin
      into v_currentLoginStatus
      from customersession cs
     where cs.customerid = p_customerId
       for update;
  
    -- Oturum durumu kapali ise acar.
    if (v_currentLoginStatus = 0) then
      update customersession cs set cs.islogin = v_loginStatus;
      -- Oturum durumu guncellenmezse hata verir
      if sql%notfound then
        raise err_customer_session_is_login_for_update;
      end if;
    end if;
  
  exception
    when err_customer_session_is_login_for_update then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_SESSION_IS_LOGIN_FOR_UPDATE);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
  end;
end customerSessionManager_pkg;
/
