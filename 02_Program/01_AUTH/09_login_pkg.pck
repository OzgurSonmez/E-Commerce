create or replace noneditionable package login_pkg is

  procedure customerLogin(p_customerLogin in login_type);

end login_pkg;
/
create or replace noneditionable package body login_pkg is

  procedure customerLogin(p_customerLogin in login_type) is
    v_emailId email.emailid%type;
    v_authenticate boolean;
    v_customerId customer.customerid%type;
  begin
    -- Parametreden gelen email adresinin email id'sini getirir.
    v_emailId := emailManager_pkg.getEmailIdByEmailAddress(p_customerLogin.emailAddress);
    
    -- Parola dogrulugunu kontrol eder.
    v_authenticate := customerManager_pkg.isPasswordCorrect(p_emailId => v_emailId, p_password => p_customerLogin.password); 
    
    -- Parolanýn dogruluk durumuna gore giris islemini gerceklestirir.
    if(v_authenticate) then
       -- Parola dogru ise
       -- CustomerId'yi emailId'ye gore getirir. 
       v_customerId := customerManager_pkg.getCustomerIdByEmailId(p_emailId => v_emailId);
       
       -- Oturum durumu setlenir.
       customerSessionManager_pkg.setLoginStatusTrue(p_customerId => v_customerId);
       dbms_output.put_line('Giris yapildi.');
    else 
      -- Parola yanlis ise islem yapilmaz...
      dbms_output.put_line('Hatali giris.');
      end if;
    
    commit;
      
    exception
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_LOGIN);
  end;
end login_pkg;
/
