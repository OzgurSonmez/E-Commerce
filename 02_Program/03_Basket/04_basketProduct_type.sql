create or replace type basketProduct_type as object
(
       basketId number(20),
       productId number(20),
       productQuantity number(10),
       isSelected number(1)
)
-- Urunun sepete eklenmesi icin gerekli parametrelerden bir tip oluþturuldu.
