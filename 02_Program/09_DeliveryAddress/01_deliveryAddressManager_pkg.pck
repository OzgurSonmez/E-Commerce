create or replace noneditionable package deliveryAddressManager_pkg is

 function getDeliveryAddressDetailByCustomerId(p_customerId customer.customerid%type) 
    return sys_refcursor;

end deliveryAddressManager_pkg;
/
create or replace noneditionable package body deliveryAddressManager_pkg is

  function getDeliveryAddressDetailByCustomerId(p_customerId customer.customerid%type)
    return sys_refcursor is
    c_deliveryAddress sys_refcursor;
  begin
    -- Parametre kontrolu yapilir.
    ecpValidate_pkg.customerParameters(p_customerId => p_customerId);
  
    -- Frontend'e musteriye ait teslimat adreslerini gonderir.
    open c_deliveryAddress for
      select (c.firstname || ' ' || c.lastname) fullName,
             (a.addressdesciption || ' ' || d.districtname || ' / ' ||
             city.cityname || ' / ' || country.countryname) deliveryAddressDetail,
             da.deliveryaddressid deliveryAddressId,
             p.phonenumber phoneNumber
        from customer        c,
             deliveryaddress da,
             address         a,
             district        d,
             city,
             country,
             phone           p
       where da.customerid = c.customerid
         and da.addressid = a.addressid
         and a.districtid = d.districtid
         and d.cityid = city.cityid
         and city.countryid = country.countryid
         and da.phoneid = p.phoneid
         and c.customerid = p_customerId;
  
    return c_deliveryAddress;
  
  exception
    when others then
      if c_deliveryAddress%isopen then
        close c_deliveryAddress;
      end if;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
    
  end;

end deliveryAddressManager_pkg;
/
