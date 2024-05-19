create or replace noneditionable package customerManager_pkg is

  procedure register(p_firstname customer.firstname%type,
                     p_lastname  customer.lastname%type,
                     p_password  customer.passwordhash%type,
                     p_emailId   customer.emailid%type);

  function isPasswordSaltExists(p_passwordSalt in customer.passwordsalt%type)
    return pls_integer;

end customerManager_pkg;
/
create or replace noneditionable package body customerManager_pkg is

  procedure register(p_firstname customer.firstname%type,
                     p_lastname  customer.lastname%type,
                     p_password  customer.passwordhash%type,
                     p_emailId   customer.emailid%type) is
    v_customerId   customer.customerid%type;
    v_passwordHash customer.passwordhash%type;
    v_passwordSalt customer.passwordsalt%type;
  begin
    v_customerId := customer_seq.nextval;
  
    -- Salt üretir.
    v_passwordSalt := passwordSecurity_pkg.generateSalt();
  
    -- Üretilen salt ile passwordu birle?tirip hash'ler
    v_passwordHash := passwordSecurity_pkg.generateHash(p_password => p_password,
                                                        p_salt     => v_passwordSalt);
  
    insert into customer
      (customerid,
       firstname,
       lastname,
       passwordhash,
       passwordSalt,
       emailid,
       isaccountactive)
    VALUES
      (v_customerId,
       p_firstname,
       p_lastname,
       v_passwordHash,
       v_passwordSalt,
       p_emailId,
       1);
  
    commit;
  
  exception
    when value_error then
      rollback;
      raise_application_error(-20101, 'Geçersiz veri hatasý.');
    when others then
      rollback;
      raise_application_error(-20105,
                              'Beklenmeyen bir hata oluþtu. Hata kodu: ' ||
                              sqlerrm);
    
  end;

  function isPasswordSaltExists(p_passwordSalt in customer.passwordsalt%type)
    return pls_integer is
    v_passwordSaltExists pls_integer;
  begin
    -- Parametreden gelen passwordSalt'ýn varlýðýný customer tablosunda kontrol eder.
    select case
             when exists (select 1
                     from customer c
                    where c.passwordsalt = p_passwordSalt) 
                    then 1
             else 0
           end
      into v_passwordSaltExists
      from dual;
  
    return v_passwordSaltExists;
  end;
end customerManager_pkg;
/
