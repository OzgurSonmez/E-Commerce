create or replace noneditionable package customerManager_pkg is

  procedure register(p_firstname customer.firstname%type,
                     p_lastname  customer.lastname%type,
                     p_password  customer.passwordhash%type,
                     p_emailId   customer.emailid%type);

  function isPasswordSaltExists(p_passwordSalt in customer.passwordsalt%type)
    return pls_integer;

  function isPasswordCorrect(p_emailId  customer.emailid%type,
                             p_password customer.passwordhash%type)
    return pls_integer;

  procedure changePassword(p_emailId     email.emailid%type,
                           p_newPassword customer.passwordhash%type);

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
    values
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
      raise_application_error(-20101, 'Geçersiz veri hatasy.');
    when others then
      rollback;
      raise_application_error(-20105,
                              'Beklenmeyen bir hata olu?tu. Hata kodu: ' ||
                              sqlerrm);
    
  end;

  function isPasswordSaltExists(p_passwordSalt in customer.passwordsalt%type)
    return pls_integer is
    v_passwordSaltExists pls_integer;
  begin
    -- Parametreden gelen passwordSalt'yn varly?yny customer tablosunda kontrol eder.
    select case
             when exists (select 1
                     from customer c
                    where c.passwordsalt = p_passwordSalt) then
              1
             else
              0
           end
      into v_passwordSaltExists
      from dual;
  
    return v_passwordSaltExists;
  end;

  function isPasswordCorrect(p_emailId  customer.emailid%type,
                             p_password customer.passwordhash%type)
    return pls_integer is
    v_passwordSalt   customer.passwordsalt%type;
    v_passwordHash   customer.passwordhash%type;
    v_passwordHashed customer.passwordhash%type;
  begin
  
    select passwordsalt, passwordhash
      into v_passwordSalt, v_passwordHash
      from customer c
     where c.emailid = p_emailId;
  
    v_passwordHashed := passwordsecurity_pkg.generateHash(p_password => p_password,
                                                          p_salt     => v_passwordSalt);
  
    if (v_passwordHash = v_passwordHashed) then
      return 1;
    else
      return 0;
    end if;
  
  exception
    when no_data_found then
      return 0;
  end;

  procedure changePassword(p_emailId     email.emailid%type,
                           p_newPassword customer.passwordhash%type) is
    cursor c_changePasswordCustomer is
      select c.passwordhash, c.passwordsalt
        from customer c
       where c.emailid = p_emailId
         for update;
    v_changePasswordCustomer c_changePasswordCustomer%rowtype;
    v_newPasswordHash        customer.passwordhash%type;
    v_newPasswordSalt        customer.passwordsalt%type;
  begin
    v_newPasswordSalt := passwordsecurity_pkg.generateSalt();
    v_newPasswordHash := passwordsecurity_pkg.generateHash(p_password => p_newPassword, p_salt => v_newPasswordSalt);
    
    open c_changePasswordCustomer;
    fetch c_changePasswordCustomer into v_changePasswordCustomer;
       update customer c
        set c.passwordhash = v_newPasswordHash, c.passwordsalt = v_newPasswordSalt
        where current of c_changePasswordCustomer;
    close c_changePasswordCustomer;
    commit;
    
    exception 
      when others then
      close c_changePasswordCustomer;
      rollback;
      raise_application_error(-20104, 'Sifre degistirme basarisiz. ' || SQLERRM);
    
  end;

end customerManager_pkg;
/
