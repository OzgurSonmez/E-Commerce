create or replace noneditionable type register_type as object
(
       firstName VARCHAR2(100),
       lastName VARCHAR2(100),
       emailAddress VARCHAR2(255),
       password VARCHAR2(255)
)
-- Kullan�c�n�n kay�t olabilmesi i�in gerekli parametrelerden bir tip olu�turuldu.
/
