alter session set "_ORACLE_SCRIPT"=true;  

create user ECommerceProject
  identified by 1
  default tablespace USERS
  temporary tablespace TEMP
  profile DEFAULT
  quota unlimited on users;
  
  
-- Grant/Revoke role privileges 
-- Connect yetkisi tanýmlanýr
grant connect to ECommerceProject;

-- Kullanýcýya veri tabaný yöneticisi yetkisi verilir
grant dba to  ECommerceProject;

-- Kullanýcýya temel veritabaný nesnelerine (tablo, dizin, prosedür vb.) eriþim yetkileri saðlar
grant resource to  ECommerceProject;

-- Grant/Revoke system privileges 
-- Kullanýcýnýn sýnýrsýz bir þekilde tablespace kullanabilmesine izin verir
grant unlimited tablespace to  ECommerceProject;
