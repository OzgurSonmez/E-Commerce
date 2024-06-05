create or replace noneditionable package changePassword_pkg is

  procedure changeCustomerPassword(p_changeCustomerPassword in changePassword_type);

end changePassword_pkg;
/
create or replace noneditionable package body changePassword_pkg is

  procedure changeCustomerPassword(p_changeCustomerPassword in changePassword_type) is
    v_emailId email.emailid%type;
    v_isPasswordCorrect boolean;
    err_current_password_false exception;
  begin
    -- Eposta adresine gore emailId alinir.
    v_emailId := emailManager_pkg.getEmailIdByEmailAddress(p_emailAddress => p_changeCustomerPassword.emailAddress);
    
    -- Parametreden gelen parolanin dogrulugunu kontrol eder.
    v_isPasswordCorrect := customerManager_pkg.isPasswordCorrect(p_emailId => v_emailId,p_password => p_changeCustomerPassword.current_password);
    
    if (v_isPasswordCorrect) then
      -- Parola dogruysa, yeni parola ile degistirir
      customerManager_pkg.changePassword(p_emailId => v_emailId, p_newPassword => p_changeCustomerPassword.new_password);
    else
      -- Parola yanlissa, bir hata mesaji döner
      dbms_output.put_line('Parola yanlis');
      raise err_current_password_false;
    end if;
    
    commit;
    
    exception
    when err_current_password_false then
      dbms_output.put_line('false exception');      
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CURRENT_PASSWORD_FALSE);
    when others then
      dbms_output.put_line('others exception');
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CHANGE_PASSWORD);
  end;

end changePassword_pkg;
/
