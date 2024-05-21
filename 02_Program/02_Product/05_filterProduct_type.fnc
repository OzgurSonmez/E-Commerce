create or replace noneditionable type filterProduct_type as object
(
       categoryId number(8),
       brandId number(10),
       productName varchar2(100),
       minPrice number(11,2),
       maxPrice number(11,2),
       orderBy varchar2(100),
       orderDirection varchar2(10)
)
-- �r�n filtrelenmesi i�in kullan�lacak parametrelerden bir tip olu�turuldu.
/
