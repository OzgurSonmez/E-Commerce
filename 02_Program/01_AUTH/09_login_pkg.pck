create or replace noneditionable package login_pkg is

  procedure customerLogin(p_login in login_type);

end login_pkg;
/
create or replace noneditionable package body login_pkg is

  procedure customerLogin(p_login in login_type) is
    v_emailId email.emailid%type;
    v_authenticate pls_integer;
  begin
    v_emailId := emailManager_pkg.getEmailIdByEmailAddress(p_login.emailAddress);
    
    v_authenticate := customerManager_pkg.isPasswordCorrect(p_emailId => v_emailId, p_password => p_login.password); 
    
    if(v_authenticate = 1) then
       dbms_output.put_line('Giris yapildi.');
    else 
      dbms_output.put_line('Hatali giris.');
      end if;
  end;
end login_pkg;
/
