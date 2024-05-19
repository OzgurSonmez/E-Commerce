create or replace noneditionable package emailManager_pkg is

  function addEmail(p_emailAddress email.emailaddress%type)
    return email.emailid%type;
    
  function getEmailIdByEmailAddress(p_emailAddress email.emailaddress%type)
    return email.emailid%type;

end emailManager_pkg;
/
create or replace noneditionable package body emailManager_pkg is

  function addEmail(p_emailAddress email.emailaddress%type)
    return email.emailid%type is
     v_emailId email.emailid%type;
  begin
    v_emailId := email_seq.nextval;
    insert into email
      (emailid, emailaddress)
    values
      (v_emailId, p_emailAddress);
    return v_emailId;    
    
    exception
      when dup_val_on_index then
           raise_application_error(-20100, 'Bu email adresi zaten kayytly.');
      when others then
           raise_application_error(-20105, 'Beklenmeyen bir hata olu?tu. Hata kodu: ' || sqlerrm);
  end;
  
  function getEmailIdByEmailAddress(p_emailAddress email.emailaddress%type)
    return email.emailid%type is
    v_emailId email.emailid%type;
  begin
    select emailid into v_emailId from email e
         where e.emailaddress = p_emailAddress;
    return v_emailId;
    
    -- Data yoksa e-posta adresi bulunamadý.
    exception
      when no_data_found then
        return 0;   
  end;

end emailManager_pkg;
/
