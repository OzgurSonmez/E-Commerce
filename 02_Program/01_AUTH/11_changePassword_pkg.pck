create or replace noneditionable package changePassword_pkg is

  procedure changeCustomerPassword(p_changeCustomerPassword in changePassword_type);

end changePassword_pkg;
/
create or replace noneditionable package body changePassword_pkg is

  procedure changeCustomerPassword(p_changeCustomerPassword in changePassword_type) is
    v_emailId email.emailid%type;
    v_isPasswordCorrect boolean;
  begin
    -- Eposta adresine gore emailId alynyr.
    v_emailId := emailManager_pkg.getEmailIdByEmailAddress(p_emailAddress => p_changeCustomerPassword.emailAddress);
    
    -- Parametreden gelen parolanin dogrulugunu kontrol eder.
    v_isPasswordCorrect := customerManager_pkg.isPasswordCorrect(p_emailId => v_emailId,p_password => p_changeCustomerPassword.current_password);
    
    if (v_isPasswordCorrect) then
      -- Parola do?ruysa, yeni parolayy de?i?tir
      customerManager_pkg.changePassword(p_emailId => v_emailId, p_newPassword => p_changeCustomerPassword.new_password);
    else
      -- Parola yanly?sa, bir hata mesajy d�ner
      raise_application_error(-20100, 'Mevcut parola yanlis.');
    end if;
    
    
  end;

end changePassword_pkg;
/
