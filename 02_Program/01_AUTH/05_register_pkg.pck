create or replace noneditionable package register_pkg is
  
  procedure customerRegister(p_customerRegister in register_type);

end register_pkg;
/
create or replace noneditionable package body register_pkg is

  procedure customerRegister(p_customerRegister in register_type) is
     v_emailId email.emailid%type; 
  begin
    emailManager_pkg.addEmail(p_customerRegister.emailAddress);
    v_emailId := emailManager_pkg.getEmailIdByEmailAddress(p_emailAddress => p_customerRegister.emailAddress);
    
    customerManager_pkg.register(p_firstname => p_customerRegister.firstName,
                                 p_lastname  => p_customerRegister.lastName,
                                 p_password  => p_customerRegister.password,
                                 p_emailId   => v_emailId);

  end;
end register_pkg;
/
