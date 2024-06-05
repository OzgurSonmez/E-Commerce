create or replace noneditionable package register_pkg is
  
  procedure customerRegister(p_customerRegister in register_type);

end register_pkg;
/
create or replace noneditionable package body register_pkg is

  procedure customerRegister(p_customerRegister in register_type) is
     v_emailId email.emailid%type;
  begin
    -- Email adresini ekler.
    emailManager_pkg.addEmail(p_customerRegister.emailAddress);
    -- Eklenen email adresin id'sini doner.
    v_emailId := emailManager_pkg.getEmailIdByEmailAddress(p_emailAddress => p_customerRegister.emailAddress);
    
    -- Musteri kaydi olusturulur.
    customerManager_pkg.register(p_firstname => p_customerRegister.firstName,
                                 p_lastname  => p_customerRegister.lastName,
                                 p_password  => p_customerRegister.password,
                                 p_emailId   => v_emailId);
                                 
    commit;
    
    exception
     when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_REGISTER);                                   
  end;
end register_pkg;
/
