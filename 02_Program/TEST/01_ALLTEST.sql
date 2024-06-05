--------------------- MODUL 1 ---------------------------------------------------------------------------------

-- Register
declare
  test_register register_type := register_type('Test', 'Account', 'testaccount@gmail.com', 'test123');
begin
  authManagement_pkg.register(p_register => test_register);
end;

-- Login 
declare
  test_login login_type := login_type('testaccount@gmail.com' , 'test123');
begin
  authManagement_pkg.login(p_login => test_login);
  end;


-- Change Password
declare
  test_changePassword changePassword_type := changePassword_type('testaccount@gmail.com',current_password => 'test123',new_password => 'test321');
begin
  authManagement_pkg.changePassword(p_changePassword => test_changePassword);
  end;

select c.customerid,
       c.firstname,
       c.lastname,
       c.emailid,
       e.emailaddress,
       c.passwordhash,
       c.passwordsalt,
       cs.islogin
  from customer c, email e, customersession cs
 where c.emailid = e.emailid
   and c.customerid = cs.customerid(+)
   and c.firstname like 'Test';


--------------------- MODUL 2 ---------------------------------------------------------------------------------

-- Add Product
declare
  addProduct_test addProduct_type := addProduct_type(categoryId          => 13,
                                                     brandId             => 2,
                                                     productName         => 'Test2',
                                                     productDescription  => 'Test desc',
                                                     price               => 10000,
                                                     discountPercentange => 99);                                                    

begin
  productManager_pkg.addProduct(addProduct_test);
end;

select * from product p, productcategory pc
       where p.productid = pc.productid(+)       
         and p.productid > 130;

-- Delete Product
begin
  productManager_pkg.deleteProduct(p_productId => 196);
end;



-- filter Products
declare
  v_filterProduct filterProduct_type := filterProduct_type(categoryId     => '25', -- 1-28, 3,10,11,12 yok
                                                              brandId        => '', -- 1-23
                                                              productName    => '',
                                                              minPrice      => '',
                                                              maxPrice      => '',
                                                              orderBy        => '', -- price, discount , favcount
                                                              orderDirection => ''); -- ascending, descending
  c_products sys_refcursor;
begin
 c_products := productManager_pkg.filterProduct(p_filterProduct => v_filterProduct);
 end;


select c.categoryid         categoryId,
       c.categoryname       categoryName,
       b.brandid            brandId,
       b.brandname          brandName,
       p.productname        productName,
       p.price              price,
       p.discountpercentage discount,
       p.favcount           favcount
  from product p, productcategory pc, brand b, category c
 where p.productid = pc.productid
   and p.brandid = b.brandid
   and pc.categoryid = c.categoryid
 order by c.categoryname



--------------------- MODUL 3 ---------------------------------------------------------------------------------

-- Add product to basket
declare
  v_basketProduct_test basketProduct_type := basketProduct_type(basketId        => 41,
                                                                productId       => 12, -- 1-120
                                                                productQuantity => 11,
                                                                isSelected      => 0);
begin
  basketProductManager_pkg.addProductToBasket(v_basketProduct_test);
end;


select b.customerid,
       b.basketid,
       bp.productid,
       bp.productquantity,
       bp.isselected
  from basket b, basketproduct bp
 where b.basketid = bp.basketid(+)
   and b.customerid = 181;


-- Delete product
declare
  v_basketId  basketproduct.basketid%type := 41;
  v_productId basketproduct.productid%type := 10;
begin
  basketProductManager_pkg.deleteProductFromBasket(p_basketId  => v_basketId,
                                                   p_productId => v_productId);
end;

-- Decrease product
declare
  v_basketProduct_test basketProduct_type := basketProduct_type(basketId        => 41,
                                                                productId       => 12,
                                                                productQuantity => 3,
                                                                isSelected      => 0);
begin
  basketProductManager_pkg.decreaseProductFromBasket(v_basketProduct_test);
end;



--------------------- MODUL 4 ---------------------------------------------------------------------------------

-- Compelete order
begin
  orderManagement_pkg.completeOrder(p_customerId => 181, p_deliveryAddressId => 1);
end;

-- CustomerOrderList
select * from customerorder co, customerorderdetail cod
       where co.customerorderid = cod.customerorderid
          and co.customerid = 181;
          
-- Customer Basket  
select * from basketProduct bp, basket b, deliveryaddress da
       where b.basketid = bp.basketid
             and b.customerid = da.customerid
             and b.customerid = 181;


--------------------- MODUL 5 ---------------------------------------------------------------------------------

-- CustomerOrderList dbms_output.put_line

declare
 v_customerOrderList getCustomerOrderList_type := getCustomerOrderList_type();
 i pls_integer := 0;
 j pls_integer := 0;
begin
  v_customerOrderList := orderManagement_pkg.getCustomerOrderList(p_customerId => 181); -- CustomerId
  i := v_customerOrderList.first;  
  
  while i is not null loop
        dbms_output.put_line(v_customerOrderList(i).orderNo || ' ' ||
                             v_customerOrderList(i).orderDate || ' ' ||
                             v_customerOrderList(i).totalPrice || '₺  ' ||
                             v_customerOrderList(i).orderStatus || ' ' ||
                             v_customerOrderList(i).fullName || ' ' ||
                             v_customerOrderList(i).DeliveryAddressDetail || ' ' ||
                             v_customerOrderList(i).phoneNumber);
         j := v_customerOrderList(i).productList.first; 
         while j is not null loop
            dbms_output.put_line('-----> ' || v_customerOrderList(i).productList(j).Brandname || ' ' ||
                             v_customerOrderList(i).productList(j).Productname || ' ' ||
                             v_customerOrderList(i).productList(j).Productquantity || ' adet ' ||
                             v_customerOrderList(i).productList(j).Productunitprice || '₺');            
            j := v_customerOrderList(i).productList.next(j);
         end loop;   
         i := v_customerOrderList.next(i);
         dbms_output.put_line('');
  end loop;  
end;   

-- CSV file

begin
  orderManagement_pkg.getCustomerOrderList_csvFile(p_customerId => 181); -- CustomerId
end;



--------------------- MODUL 6 ---------------------------------------------------------------------------------

-- Add product to favorite

begin
  customerProductFavoriteManager_pkg.addProductToFavorite(p_customerId => 181,p_productId => 109);
end;

-- Remove product from favorite
begin
  customerProductFavoriteManager_pkg.removeProductFromFavorite(p_customerId => 181,p_productId => 109);
end;


select * from customerproductfavorite cpf
       where cpf.customerid = 181;

select p.productid, p.favcount from product p
       where p.productid = 109;
