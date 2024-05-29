create or replace noneditionable package customerManager_pkg is

  procedure register(p_firstname customer.firstname%type,
                     p_lastname  customer.lastname%type,
                     p_password  customer.passwordhash%type,
                     p_emailId   customer.emailid%type);

  function getCustomerIdByEmailId(p_emailId customer.emailid%type) 
    return customer.customerid%type;
  
  function isPasswordSaltExists(p_passwordSalt in customer.passwordsalt%type)
    return boolean;

  function isPasswordCorrect(p_emailId  customer.emailid%type,
                             p_password customer.passwordhash%type)
    return boolean;

  procedure changePassword(p_emailId     email.emailid%type,
                           p_newPassword customer.passwordhash%type);

end customerManager_pkg;
/
create or replace noneditionable package body customerManager_pkg is

  procedure register(p_firstname customer.firstname%type,
                     p_lastname  customer.lastname%type,
                     p_password  customer.passwordhash%type,
                     p_emailId   customer.emailid%type) is
    v_customerId      customer.customerid%type;
    v_passwordHash    customer.passwordhash%type;
    v_passwordSalt    customer.passwordsalt%type;
    v_isAccountActive customer.isaccountactive%type;
  begin
    v_customerId := customer_seq.nextval;
  
    -- Salt üretir.
    v_passwordSalt := passwordSecurity_pkg.generateSalt();
  
    -- Üretilen salt ile passwordu birlestirip hash'ler
    v_passwordHash := passwordSecurity_pkg.generateHash(p_password => p_password,
                                                        p_salt     => v_passwordSalt);
    -- Default olarak hesap aktif olusturulur.                                                    
    v_isAccountActive := 1;
  
    -- Parametre kontrolleri yapilir.
    ecpValidate_pkg.emailParameters(p_emailId => p_emailId);
    ecpValidate_pkg.customerParameters(p_customerId      => v_customerId,
                                       p_firstName       => p_firstname,
                                       p_lastName        => p_lastname,
                                       p_passwordHash    => v_passwordHash,
                                       p_passwordSalt    => v_passwordSalt,
                                       p_isAccountActive => v_isAccountActive);
  
    -- Yeni müsteri eklenir.
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
       v_isAccountActive);
  
    -- Musteriye ait bir sepet olusturur.
    basketManager_pkg.addBasket(p_customerId => v_customerId);
  
    -- Musteriye ait bir oturum durumu olusturur.
    customerSessionManager_pkg.addCustomerSession(p_customerId => v_customerId); 
    
    -- Musteri eklenmezse hata uretir
  exception
    when dup_val_on_index then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_DUPLICATE);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_BASKET_PRODUCT_INSERT);
    
  end;

  function getCustomerIdByEmailId(p_emailId customer.emailid%type)
    return customer.customerid%type is
    v_customerId customer.customerid%type;
  begin
    
  -- EmailId'ye gore aktif hesabin customerId'sini getirir.
    select c.customerid
      into v_customerId
      from customer c
     where c.emailid = p_emailId
       and c.isaccountactive = 1;
   
   return v_customerId;  
   exception
    when no_data_found then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_ID_NOT_FOUND);
    when too_many_rows then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_ID_TOO_MANY_ROWS);
    when others then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);

  end;

  function isPasswordSaltExists(p_passwordSalt in customer.passwordsalt%type)
    return boolean is
    v_passwordSaltExists pls_integer;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.customerParameters(p_passwordSalt => p_passwordSalt);
  
    -- Parametreden gelen passwordSalt'in varligini customer tablosunda kontrol eder.
    -- Sonucu 1 veya 0 olarak doner.
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
  
    if v_passwordSaltExists = 1 then
      return true;
    else
      return false;
    end if;
  
  exception
    when no_data_found then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_PASSWORD_NOT_FOUND);
    when others then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
  end;

  function isPasswordCorrect(p_emailId  customer.emailid%type,
                             p_password customer.passwordhash%type)
    return boolean is
    v_passwordSalt   customer.passwordsalt%type;
    v_passwordHash   customer.passwordhash%type;
    v_passwordHashed customer.passwordhash%type;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.emailParameters(p_emailId => p_emailId);
  
    -- Parametreden gelen emailId'ye gore musterinin Hash ve Salt parolasini getirir.
    select passwordsalt, passwordhash
      into v_passwordSalt, v_passwordHash
      from customer c
     where c.emailid = p_emailId;
  
    -- Parametreden gelen parola ile musterinin salt parolarisini hash'ler.
    v_passwordHashed := passwordsecurity_pkg.generateHash(p_password => p_password,
                                                          p_salt     => v_passwordSalt);
  
    -- Veritabanindaki hash ile uretilen hash esitleniyorsa 1, esitlenmiyorsa 0 doner.
    if (v_passwordHash = v_passwordHashed) then
      return true;
    else
      return false;
    end if;
  
    -- EmailId'ye gore parola bulunamazsa hata verir.
  exception
    when no_data_found then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_PASSWORD_NOT_FOUND);
    when too_many_rows then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_PASSWORD_TOO_MANY_ROWS);
    when others then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
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
    v_newPasswordHash := passwordsecurity_pkg.generateHash(p_password => p_newPassword,
                                                           p_salt     => v_newPasswordSalt);
  
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.emailParameters(p_emailId => p_emailId);
    ecpValidate_pkg.customerParameters(p_passwordHash => v_newPasswordHash,
                                       p_passwordSalt => v_newPasswordSalt);
  
    -- Sifre degisikligi icin cursor acilir ve yeni salt ve hash parolalar update edilir.
    open c_changePasswordCustomer;
    fetch c_changePasswordCustomer
      into v_changePasswordCustomer;
    update customer c
       set c.passwordhash = v_newPasswordHash,
           c.passwordsalt = v_newPasswordSalt
     where current of c_changePasswordCustomer;
    close c_changePasswordCustomer;
  
    -- Musteri sifresi degismezse hata uretir.
    if sql%notfound then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_PASSWORD_FOR_UPDATE);
    end if; 
   
    -- Uygun musteri bulunamazsa hata verir.
    -- Benzersiz password salt uretilmezse hata verir.
  exception
    when no_data_found then
      close c_changePasswordCustomer;
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_NOT_FOUND);
    when dup_val_on_index then
      close c_changePasswordCustomer;
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_DUPLICATE);
    when others then
      close c_changePasswordCustomer;
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
    
  end;

end customerManager_pkg;
/
