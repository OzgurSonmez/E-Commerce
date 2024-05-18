create or replace package register_pkg is
  
  v_customerId customer.customerid%type;
  v_emailId email.emailid%type; 
  
  procedure customerRegister(p_register in register_type);

end register_pkg;
/
create or replace package body register_pkg is

  procedure customerRegister(p_register in register_type) is
  begin
    v_emailId    := emailManager_pkg.addEmail(p_register.emailAddress);
    v_customerId := customer_seq.nextval;
  
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
       p_register.firstName,
       p_register.lastName,
       p_register.password,
       p_register.password,
       v_emailId,
       1);
  end;

end register_pkg;
/
