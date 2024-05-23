-- IdentityType
insert into identitytype(identitytypeid,typename)
       values(1,'T�rkiye Cumhuriyeti Kimlik Kart�'); 

insert into identitytype(identitytypeid,typename)
       values(2,'Pasaport'); 

-- Gender
insert into gender(genderid,gendername)
       values(1,'Kad�n');

insert into gender(genderid,gendername)
       values(2,'Erkek');

-- Phone
insert into phone(phoneid,phonenumber)
       values(1,557-557-57-57);


---------------------------------------------------------

-- Country
insert into country(countryid,countryname)
       values(1,'T�rkiye');

-- City
insert into city(cityid,countryid,cityname)
       values(1,1,'�stanbul');
       
insert into city(cityid,countryid,cityname)
       values(2,1,'Bursa');

insert into city(cityid,countryid,cityname)
       values(3,1,'Sinop');


-- District
insert into district(districtid,cityid,districtname)
       values(1,1,'Pendik');

insert into district(districtid,cityid,districtname)
       values(2,1,'Kad�k�y');

insert into district(districtid,cityid,districtname)
       values(3,1,'Be�ikta�');
       

-- Address
insert into address(addressid,districtid,addressdesciption)
       values(1,1,'Esenyal� Mh. Vatan Cd. No:1 D:1');

----------------------------------------------------------
-- Tax
insert into tax(taxid,taxname,taxpercentage)
       values(1,'Katma De�er Vergisi (KDV)',20);

-- OrderStatus
insert into orderstatustype(orderstatustypeid,typename)
       values(1,'Sipari� al�nd�');
       
insert into orderstatustype(orderstatustypeid,typename)
       values(2,'Sipari� haz�rlan�yor');

insert into orderstatustype(orderstatustypeid,typename)
       values(3,'Sipari� kargoya verildi');

insert into orderstatustype(orderstatustypeid,typename)
       values(4,'Sipari� tamamland�');

insert into orderstatustype(orderstatustypeid,typename)
       values(5,'Sipari� iptal edildi');

insert into orderstatustype(orderstatustypeid,typename)
       values(6,'Sipari� iade edildi');
       
       
commit;





