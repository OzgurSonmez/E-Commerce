create or replace noneditionable type register_type as object
(
       firstName VARCHAR2(100),
       lastName VARCHAR2(100),
       emailAddress VARCHAR2(255),
       password VARCHAR2(255)
)
-- Kullanýcýnýn kayýt olabilmesi için gerekli parametrelerden bir tip oluþturuldu.
/
