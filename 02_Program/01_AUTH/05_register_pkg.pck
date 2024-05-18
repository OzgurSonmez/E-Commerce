create or replace noneditionable package register_pkg is
  
  v_emailId email.emailid%type; 
  
  procedure customerRegister(p_register in register_type);

end register_pkg;
/
create or replace noneditionable package body register_pkg is

  procedure customerRegister(p_register in register_type) is
  begin
    v_emailId := emailManager_pkg.addEmail(p_register.emailAddress);
  
    customerManager_pkg.register(p_firstname => p_register.firstName,
                                 p_lastname  => p_register.lastName,
                                 p_password  => p_register.password,
                                 p_emailId   => v_emailId);

  end;
end register_pkg;
/
