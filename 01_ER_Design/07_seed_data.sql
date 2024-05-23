-- IdentityType
insert into identitytype(identitytypeid,typename)
       values(1,'Türkiye Cumhuriyeti Kimlik Kartý'); 

insert into identitytype(identitytypeid,typename)
       values(2,'Pasaport'); 

-- Gender
insert into gender(genderid,gendername)
       values(1,'Kadýn');

insert into gender(genderid,gendername)
       values(2,'Erkek');

-- Phone
insert into phone(phoneid,phonenumber)
       values(1,557-557-57-57);


---------------------------------------------------------

-- Country
insert into country(countryid,countryname)
       values(1,'Türkiye');

-- City
insert into city(cityid,countryid,cityname)
       values(1,1,'Ýstanbul');
       
insert into city(cityid,countryid,cityname)
       values(2,1,'Bursa');

insert into city(cityid,countryid,cityname)
       values(3,1,'Sinop');


-- District
insert into district(districtid,cityid,districtname)
       values(1,1,'Pendik');

insert into district(districtid,cityid,districtname)
       values(2,1,'Kadýköy');

insert into district(districtid,cityid,districtname)
       values(3,1,'Beþiktaþ');
       

-- Address
insert into address(addressid,districtid,addressdesciption)
       values(1,1,'Esenyalý Mh. Vatan Cd. No:1 D:1');

----------------------------------------------------------
-- Tax
insert into tax(taxid,taxname,taxpercentage)
       values(1,'Katma Deðer Vergisi (KDV)',20);

-- OrderStatus
insert into orderstatustype(orderstatustypeid,typename)
       values(1,'Sipariþ alýndý');
       
insert into orderstatustype(orderstatustypeid,typename)
       values(2,'Sipariþ hazýrlanýyor');

insert into orderstatustype(orderstatustypeid,typename)
       values(3,'Sipariþ kargoya verildi');

insert into orderstatustype(orderstatustypeid,typename)
       values(4,'Sipariþ tamamlandý');

insert into orderstatustype(orderstatustypeid,typename)
       values(5,'Sipariþ iptal edildi');

insert into orderstatustype(orderstatustypeid,typename)
       values(6,'Sipariþ iade edildi');
       
       
commit;





