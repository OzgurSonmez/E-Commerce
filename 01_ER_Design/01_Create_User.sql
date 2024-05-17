alter session set "_ORACLE_SCRIPT"=true;  

create user ECommerceProject
  identified by 1
  default tablespace USERS
  temporary tablespace TEMP
  profile DEFAULT
  quota unlimited on users;
  
  
-- Grant/Revoke role privileges 
-- Connect yetkisi tan�mlan�r
grant connect to ECommerceProject;

-- Kullan�c�ya veri taban� y�neticisi yetkisi verilir
grant dba to  ECommerceProject;

-- Kullan�c�ya temel veritaban� nesnelerine (tablo, dizin, prosed�r vb.) eri�im yetkileri sa�lar
grant resource to  ECommerceProject;

-- Grant/Revoke system privileges 
-- Kullan�c�n�n s�n�rs�z bir �ekilde tablespace kullanabilmesine izin verir
grant unlimited tablespace to  ECommerceProject;
