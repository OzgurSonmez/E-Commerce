create or replace noneditionable package emailManager_pkg is

  v_emailId email.emailid%type;

  function addEmail(p_emailAddress email.emailaddress%type)
    return email.emailid%type;

end emailManager_pkg;
/
create or replace noneditionable package body emailManager_pkg is

  function addEmail(p_emailAddress email.emailaddress%type)
    return email.emailid%type is
  begin
    v_emailId := email_seq.nextval;
    insert into email
      (emailid, emailaddress)
    values
      (v_emailId, p_emailAddress);
    return v_emailId;
  end;

end emailManager_pkg;
/
