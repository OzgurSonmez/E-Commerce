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
    v_emailId := emailManager_pkg.getEmailIdByEmailAddress(p_customerLogin.emailAddress);
    
    v_authenticate := customerManager_pkg.isPasswordCorrect(p_emailId => v_emailId, p_password => p_customerLogin.password); 
    
    if(v_authenticate) then
       v_customerId := customerManager_pkg.getCustomerIdByEmailId(p_emailId => v_emailId);
       customerSessionManager_pkg.setLoginStatusTrue(p_customerId => v_customerId);
       dbms_output.put_line('Giris yapildi.');
    else 
      dbms_output.put_line('Hatali giris.');
      end if;
  end;
end login_pkg;
/
