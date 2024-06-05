create or replace noneditionable package authManagement_pkg is

  procedure register(p_register in register_type);

  procedure login(p_login in login_type);

  procedure changePassword(p_changePassword in changepassword_type);

end authManagement_pkg;
/
create or replace noneditionable package body authManagement_pkg is

  procedure register(p_register in register_type) is
  begin
    register_pkg.customerRegister(p_customerRegister => p_register);
  end;

  procedure login(p_login in login_type) is
  begin
    login_pkg.customerLogin(p_customerLogin => p_login);
  end;

  procedure changePassword(p_changePassword in changepassword_type) is
  begin
    changePassword_pkg.changeCustomerPassword(p_changeCustomerPassword => p_changePassword);
  end;

end authManagement_pkg;
/
