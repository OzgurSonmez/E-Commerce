create or replace type getbasketProduct_type as object
(
       basketProductId number(20),
       basketId number(20),
       productId number(20),
       productUnitPrice number(11,2),
       productQuantity number(10),
       isSelected number(1)
)
-- Sepet bilgilerinin bulundugu bir tip oluşturuldu.
/
