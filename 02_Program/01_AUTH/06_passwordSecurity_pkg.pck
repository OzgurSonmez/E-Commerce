create or replace noneditionable package passwordSecurity_pkg is

-- Verilen parola ve salt'y birle?tirip hash'ler
  function generateHash(p_password VARCHAR2,
                        p_salt     customer.passwordsalt%type)
    return customer.passwordhash%type;
    
-- Rastgele 16 karakter salt üretir
   function generateSalt return customer.passwordsalt%type;

end passwordSecurity_pkg;
/
create or replace noneditionable package body passwordSecurity_pkg is

  -- Verilen parola ve salt'i birlestirip hash'ler
  function generateHash(p_password VARCHAR2,
                        p_salt     customer.passwordsalt%type)
    return customer.passwordhash%type is
  begin
    --SHA-256 algoritmasi kullanilir.
    return rawtohex(dbms_crypto.hash(utl_i18n.string_to_raw(p_password ||
                                                            p_salt,
                                                            'AL32UTF8'),
                                     dbms_crypto.hash_sh256));
  end;

  function generateSalt return customer.passwordsalt%type is
    v_generatedSalt customer.passwordsalt%type;
  begin
    loop
      -- 16 karakter rastgele string üretir. 
      -- 'p' : Dönen string, yazdirilabilir karakterlerden olusur.
      v_generatedSalt := dbms_random.string('p', 16);
      -- Olusturulan salt benzersiz olana kadar yeni salt uretilir.
      -- Salt mevcutsa true doner. False donene kadar salt uretilir.
      exit when Customermanager_Pkg.isPasswordSaltExists(v_generatedSalt) = false;
    end loop;
    return v_generatedSalt;
  end;

end passwordSecurity_pkg;
/
