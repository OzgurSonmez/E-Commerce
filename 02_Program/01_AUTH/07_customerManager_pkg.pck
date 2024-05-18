create or replace noneditionable package customerManager_pkg is
  
  procedure register(p_firstname customer.firstname%type,
                     p_lastname  customer.lastname%type,
                     p_password  customer.passwordhash%type,
                     p_emailId   customer.emailid%type);

end customerManager_pkg;
/
create or replace noneditionable package body customerManager_pkg is

  procedure register(p_firstname customer.firstname%type,
                     p_lastname  customer.lastname%type,
                     p_password  customer.passwordhash%type,
                     p_emailId   customer.emailid%type) is
      v_customerId customer.customerid%type;
      v_passwordHash customer.passwordhash%type;
      v_passwordSalt customer.passwordsalt%type;       
  begin
      v_customerId := customer_seq.nextval;
      
      -- Salt üretir.
      v_passwordSalt := passwordSecurity_pkg.generateSalt();      
      
      -- Üretilen salt ile passwordu birleþtirip hash'ler
      v_passwordHash := passwordSecurity_pkg.generateHash(p_password => p_password, p_salt => v_passwordSalt);
        
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
  end;
    
end customerManager_pkg;
/
