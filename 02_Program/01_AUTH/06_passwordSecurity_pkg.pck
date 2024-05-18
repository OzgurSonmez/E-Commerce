﻿create or replace noneditionable package passwordSecurity_pkg is

-- Verilen parola ve salt'ý birleþtirip hash'ler
  function generateHash(p_password VARCHAR2,
                        p_salt     customer.passwordsalt%type)
    return customer.passwordhash%type;
    
-- Rastgele 16 karakter salt üretir
   function generateSalt return customer.passwordsalt%type;

end passwordSecurity_pkg;
/
create or replace noneditionable package body passwordSecurity_pkg is

  -- Verilen parola ve salt'ý birleþtirip hash'ler
  function generateHash(p_password VARCHAR2,
                        p_salt     customer.passwordsalt%type)
    return customer.passwordhash%type is
  begin
    return rawtohex(dbms_crypto.hash(utl_i18n.string_to_raw(p_password ||
                                                            p_salt,
                                                            'AL32UTF8'),
                                     dbms_crypto.hash_sh256));
  end;

  function generateSalt return customer.passwordsalt%type is
  begin
    -- 16 karakter rastgele string üretir. 
    -- 'p' : Dönen string, yazdýrýlabilir karakterlerden oluþur.
    return dbms_random.string('p', 16);
  end;

end passwordSecurity_pkg;
/