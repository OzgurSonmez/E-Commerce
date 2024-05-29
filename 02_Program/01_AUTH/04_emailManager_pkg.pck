create or replace noneditionable package emailManager_pkg is

  procedure addEmail(p_emailAddress email.emailaddress%type);
    
    
  function getEmailIdByEmailAddress(p_emailAddress email.emailaddress%type)
    return email.emailid%type;
  

    
end emailManager_pkg;
/
create or replace noneditionable package body emailManager_pkg is

  procedure addEmail(p_emailAddress email.emailaddress%type)
     is
     v_emailId email.emailid%type;
  begin  
    -- Email id ve email adresinin formatini kontrol eder.
    v_emailId := email_seq.nextval;    
    ecpValidate_pkg.emailParameters(p_emailId => v_emailId, p_emailAddress => p_emailAddress); 
    
    -- Email adresini ekler.
    insert into email
      (emailid, emailaddress)
    values
      (v_emailId, p_emailAddress);        
    
    -- Daha once eklenen bir email adresi tekrar eklenmek istendiginde duplicate hatasi alinir.
    exception
      when dup_val_on_index then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_EMAIL_ADDRESS_DUPLICATE);
      when others then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_EMAIL_ADDRESS_INSERT);
  end;
  
  function getEmailIdByEmailAddress(p_emailAddress email.emailaddress%type)
    return email.emailid%type is
    v_emailId email.emailid%type;
  begin
    -- Parametreden gelen email adresinin formatini kontrol eder.
    ecpValidate_pkg.emailParameters(p_emailAddress => p_emailAddress); 
    
    -- Email addresine ait email id'yi alir.
    select emailid into v_emailId from email e
        where e.emailaddress = p_emailAddress;
    return v_emailId;
    
    -- Email adresi ile eslesen veri yoksa no_data_found hatasi alinir.
    -- Email adresi ile eslesen birden fazla veri varsa too_many_rows hatasi alinir.
    exception
      when no_data_found then
       ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_EMAIL_ADDRESS_DUPLICATE);
      when too_many_rows then
        ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_EMAIL_ADDRESS_TOO_MANY_ROWS);
      when others then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);   
  end;

  
end emailManager_pkg;
/
