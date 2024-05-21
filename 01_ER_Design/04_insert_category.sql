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
  (5, 'Yazýcýlar & Projeksiyon', 1);

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
  (8, 'Ayakkabý', 2);

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
  (11, 'Köpek', 3);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (12, 'Balýk', 3);

-- Bilgisayar & Tablet(4) Alt kategori
insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (13, 'Dizüstü Bilgisayar', 4);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (14, 'Tablet', 4);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (15, 'Çevre Birimleri', 4);

-- Yazýcýlar & Projeksiyon(5) Alt kategori

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (16, 'Yazýcýlar', 5);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (17, 'Projeksiyon Cihazý', 5);

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
  (20, 'Cep Telefonu Aksesuarlarý', 6);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (21, 'Telsiz ve Masaüstü Telefonlarý', 6);

-- Giyim(7) Alt kategori

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (22, 'Kadýn', 7);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (23, 'Erkek', 7);

-- Ayakkabý(8) Alt kategori  
insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (24, 'Kadýn Ayakkabý', 8);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (25, 'Erkek Ayakkabý', 8);

-- Taký(9) Alt kategori  
insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (26, 'Saat', 9);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (27, 'Güneþ Gözlüðü', 9);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (28, 'Taký', 9);

-- Kedi(10) Alt kategori  
insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (29, 'Kedi Mamalarý', 10);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (30, 'Kedi Kumlarý', 10);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (31, 'Týrmalama / Oyun Evleri', 10);

-- Köpek(11) Alt kategori  
insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (32, 'Köpek Mamalarý', 11);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (33, 'Köpek Bakým Ürünleri', 11);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (34, 'Köpek Mama Kaplarý', 11);

-- Balýk(12) Alt kategori  
insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (35, 'Balýk Yemleri', 12);

insert into category
  (categoryid, categoryname, parentcategoryid)
values
  (36, 'Akvaryum', 12);


commit;


