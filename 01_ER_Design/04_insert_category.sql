-- Ana kategori
insert into category (categoryid, categoryname) values (1, 'Elektronik');

insert into category (categoryid, categoryname) values (2, 'Moda');

insert into category (categoryid, categoryname) values (3, 'Pet Shop');

-- Elektronik(1) Alt kategori
insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (4, 'Bilgisayar & Tablet', 1);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (5, 'Yaz�c�lar & Projeksiyon', 1);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (6, 'Telefon', 1);

-- Moda(2) Alt kategori
insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (7, 'Giyim', 2);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (8, 'Ayakkab�', 2);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (9, 'Aksesuar', 2);

-- Pet Shop(3) Alt kategori
insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (10, 'Kedi', 3);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (11, 'K�pek', 3);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (12, 'Bal�k', 3);

-- Bilgisayar & Tablet(4) Alt kategori
insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (13, 'Diz�st� Bilgisayar', 4);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (14, 'Tablet', 4);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (15, '�evre Birimleri', 4);

-- Yaz�c�lar & Projeksiyon(5) Alt kategori

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (16, 'Yaz�c�lar', 5);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (17, 'Projeksiyon Cihaz�', 5);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (18, 'Sarf Malzemeleri', 5);

-- Telefon(6) Alt kategori

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (19, 'Cep Telefonu', 6);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (20, 'Cep Telefonu Aksesuarlar�', 6);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (21, 'Telsiz ve Masa�st� Telefonlar�', 6);

-- Giyim(7) Alt kategori

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (22, 'Kad�n', 7);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (23, 'Erkek', 7);

-- Ayakkab�(8) Alt kategori  
insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (24, 'Kad�n Ayakkab�', 8);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (25, 'Erkek Ayakkab�', 8);

-- Tak�(9) Alt kategori  
insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (26, 'Saat', 9);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (27, 'G�ne� G�zl���', 9);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (28, 'Tak�', 9);

-- Kedi(10) Alt kategori  
insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (29, 'Kedi Mamalar�', 10);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (30, 'Kedi Kumlar�', 10);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (31, 'T�rmalama / Oyun Evleri', 10);

-- K�pek(11) Alt kategori  
insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (32, 'K�pek Mamalar�', 11);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (33, 'K�pek Bak�m �r�nleri', 11);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (34, 'K�pek Mama Kaplar�', 11);

-- Bal�k(12) Alt kategori  
insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (35, 'Bal�k Yemleri', 12);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (36, 'Akvaryum', 12);


commit;


