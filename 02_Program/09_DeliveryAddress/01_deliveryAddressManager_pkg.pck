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
    end;
    
end deliveryAddressManager_pkg;
/
