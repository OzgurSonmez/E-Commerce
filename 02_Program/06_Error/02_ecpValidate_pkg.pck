create or replace noneditionable package ecpValidate_pkg is

  procedure emailParameters(p_emailId      in number default null,
                            p_emailAddress in varchar2 default null);
                            
  procedure customerParameters(p_customerId      in number default null,
                               p_firstName       in varchar2 default null,
                               p_lastName        in varchar2 default null,
                               p_birthDate       in date default null,
                               p_passwordHash    in varchar2 default null,
                               p_passwordSalt    in varchar2 default null,
                               p_identityNumber  in varchar default null,
                               p_isAccountActive in number default null);             
  
  procedure productParameters(p_productId          in number default null,
                              p_productName        in varchar2 default null,
                              p_productDescription in varchar2 default null,
                              p_price              in number default null,
                              p_discountPercentage in number default null,
                              p_favCount           in number default null);
  
  procedure brandParameters(p_brandId   in number default null,
                            p_brandName in varchar2 default null);
                              

  procedure categoryParameters(p_categoryId        in number default null,
                               p_categoryName      in varchar2 default null,
                               p_parentCategoryId  in number default null);  
                               
                                                   
  procedure basketParameters(p_basketId in number default null);
  
  procedure basketProductParameters(p_basketProductId in number default null,
                                    p_productQuantity in number default null,
                                    p_isSelected      in number default null);                  
  
  procedure customerOrderParameters(p_customerOrderId in number default null,
                                    p_orderNo         in varchar2 default null,
                                    p_orderDate       in date default null,
                                    p_totalPrice      in number default null);
     
  procedure customerOrderDetailParameters(p_customerOrderDetailId in number default null,
                                          p_productQuantity       in number default null,
                                          p_productUnitPrice      in number default null);                                                          

  procedure customerProductFavoriteParameters(p_isFavorite in number default null);

  procedure taxParameters(p_taxId in number default null,
                          p_taxName in varchar2 default null,
                          p_taxPercentage in number default null);

  procedure customerSessionParameters(p_customerSessionId in number default null,
                            p_isLogin           in number default null);

end ecpValidate_pkg;
/
create or replace noneditionable package body ecpValidate_pkg is

  procedure emailParameters(p_emailId      in number default null,
                            p_emailAddress in varchar2 default null) is
    err_email_id_invalid       exception;
    err_email_address_too_long exception;
    err_email_address_invalid  exception;
  begin
    -- EmailId'yi kontrol eder
    if p_emailId is not null then
      if (p_emailId < 0 or p_emailId > 99999999999999999999) then
        raise err_email_id_invalid;
      end if;
    end if;
  
    -- EmailAddress'in karakter sayisini ve formatini kontrol eder
    if p_emailAddress is not null then
      if length(p_emailAddress) > 255 then
        raise err_email_address_too_long;
      
      elsif not
             regexp_like(p_emailAddress,
                         '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') then
        dbms_output.put_line('email kontrol edildi');
        raise err_email_address_invalid;
      end if;
    end if;
  
  exception
    when err_email_id_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_EMAIL_ID_INVALID);
    when err_email_address_too_long then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_EMAIL_ADDRESS_TOO_LONG);
    when err_email_address_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_EMAIL_ADDRESS_INVALID);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_VALIDATE_PARAMETERS_OTHERS);
    
  end;

  procedure customerParameters(p_customerId      in number default null,
                               p_firstName       in varchar2 default null,
                               p_lastName        in varchar2 default null,
                               p_birthDate       in date default null,
                               p_passwordHash    in varchar2 default null,
                               p_passwordSalt    in varchar2 default null,
                               p_identityNumber  in varchar default null,
                               p_isAccountActive in number default null) is
    err_customer_id_invalid                exception;
    err_customer_first_name_too_long       exception;
    err_customer_last_name_too_long        exception;
    err_customer_password_hash_too_long    exception;
    err_customer_password_salt_too_long    exception;
    err_customer_identity_number_too_long  exception;
    err_customer_is_account_active_invalid exception;
  begin
  
    -- CustomerId'yi kontrol eder.
    if p_customerId is not null then
      if p_customerId < 0 or p_customerId > 99999999999999999999 then
        raise err_customer_id_invalid;
      end if;
    end if;
  
    -- FirstName'in uzunlugunu kontrol eder.
    if p_firstName is not null then
      if length(p_firstName) > 100 then
        raise err_customer_first_name_too_long;
      end if;
    end if;
  
    -- LastName'in uzunlugunu kontrol eder.
    if p_lastName is not null then
      if length(p_lastName) > 100 then
        raise err_customer_last_name_too_long;
      end if;
    end if;
  
    -- BirthDate'i kontrol eder.
    if p_birthDate is not null then
      -- Doðum tarihi ile ilgili bir kontrol yapilmadi
      null;
    end if;
  
    -- PasswordHash'in uzunlugunu kontrol eder.
    if p_passwordHash is not null then
      if length(p_passwordHash) > 255 then
        raise err_customer_password_hash_too_long;
      end if;
    end if;
  
    -- PasswordSalt'in uzunlugunu kontrol eder.
    if p_passwordSalt is not null then
      if length(p_passwordSalt) > 255 then
        raise err_customer_password_salt_too_long;
      end if;
    end if;
  
    -- IdentityNumber'in uzunlugunu kontrol eder.
    if p_identityNumber is not null then
      if length(p_identityNumber) > 12 then
        raise err_customer_identity_number_too_long;
      end if;
    end if;
  
    -- isAccuntActive'in degerini kontrol eder.
    if p_isAccountActive is not null then
      if p_isAccountActive not in (0, 1) then
        raise err_customer_is_account_active_invalid;
      end if;
    end if;
  
  exception
    when err_customer_id_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_ID_INVALID);
    when err_customer_first_name_too_long then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_FIRST_NAME_TOO_LONG);
    when err_customer_last_name_too_long then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_LAST_NAME_TOO_LONG);
    when err_customer_password_hash_too_long then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_PASSWORD_HASH_TOO_LONG);
    when err_customer_password_salt_too_long then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_PASSWORD_SALT_TOO_LONG);
    when err_customer_identity_number_too_long then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_IDENTITY_NUMBER_TOO_LONG);
    when err_customer_is_account_active_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_IS_ACCOUNT_ACTIVE_INVALID);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_VALIDATE_PARAMETERS_OTHERS);
    
  end;

  procedure productParameters(p_productId          in number default null,
                              p_productName        in varchar2 default null,
                              p_productDescription in varchar2 default null,
                              p_price              in number default null,
                              p_discountPercentage in number default null,
                              p_favCount           in number default null) is
    err_product_id_invalid                  exception;
    err_product_name_too_long               exception;
    err_product_description_too_long        exception;
    err_product_price_invalid               exception;
    err_product_discount_percentage_invalid exception;
    err_product_favorite_count_invalid      exception;
  begin
    -- ProductId'yi kontrol eder.
    if p_productId is not null then
      if (p_productId < 0 or p_productId > 99999999999999999999) then
        raise err_product_id_invalid;
      end if;
    end if;
  
    -- ProductName'in uzunlugunu kontrol eder.
    if p_productName is not null then
      if length(p_productName) > 100 then
        raise err_product_name_too_long;
      end if;
    end if;
  
    -- Product Description'in uzunlugunu kontrol eder.
    if p_productDescription is not null then
      if length(p_productDescription) > 2000 then
        raise err_product_description_too_long;
      end if;
    end if;
  
    -- Product Price'i kontrol eder.
    if p_price is not null then
      if (p_price < 0 or p_price > 99999999999999999999) then
        raise err_product_price_invalid;
      end if;
    end if;
  
    -- Product Discount Percentage'i kontrol eder.
    if p_discountPercentage is not null then
      if (p_discountPercentage < 0 or p_discountPercentage > 100) then
        raise err_product_discount_percentage_invalid;
      end if;
    end if;
  
    -- Favorite Count'u kontrol eder.
    if p_favCount is not null then
      if (p_favCount < 0 or p_favCount > 99999999999999999999) then
        raise err_product_favorite_count_invalid;
      end if;
    end if;
  
  exception
    when err_product_id_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_ID_INVALID);
    when err_product_name_too_long then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_NAME_TOO_LONG);
    when err_product_description_too_long then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_DESCRIPTION_TOO_LONG);
    when err_product_price_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_PRICE_INVALID);
    when err_product_discount_percentage_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_DISCOUNT_PERCENTAGE_INVALID);
    when err_product_favorite_count_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_FAVORITE_COUNT_INVALID);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_VALIDATE_PARAMETERS_OTHERS);
    
  end;

  procedure brandParameters(p_brandId   in number default null,
                            p_brandName in varchar2 default null) is
    err_brand_id_invalid    exception;
    err_brand_name_too_long exception;
  begin
    -- BrandId'yi kontrol eder.
    if p_brandId is not null then
      if (p_brandId < 0 or p_brandId > 9999999999) then
        raise err_brand_id_invalid;
      end if;
    end if;
  
    -- Brand Name'in uzunlugunu kontrol eder.
    if p_brandName is not null then
      if length(p_brandName) > 100 then
        raise err_brand_name_too_long;
      end if;
    end if;
  
  exception
    when err_brand_id_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_BRAND_ID_INVALID);
    when err_brand_name_too_long then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_BRAND_NAME_TOO_LONG);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_VALIDATE_PARAMETERS_OTHERS);
    
  end;

  procedure categoryParameters(p_categoryId       in number default null,
                               p_categoryName     in varchar2 default null,
                               p_parentCategoryId in number default null) is
    err_category_id_invalid        exception;
    err_category_name_too_long     exception;
    err_parent_category_id_invalid exception;
  begin
    -- CategoryId'yi kontrol eder.
    if p_categoryId is not null then
      if (p_categoryId < 0 or p_categoryId > 99999999) then
        raise err_category_id_invalid;
      end if;
    end if;
  
    -- Category Name'in uzunlugunu kontrol eder.
    if p_categoryName is not null then
      if length(p_categoryName) > 100 then
        raise err_category_name_too_long;
      end if;
    end if;
  
    -- ParentCategoryId'yi kontrol eder.
    if p_parentCategoryId is not null then
      if (p_parentCategoryId < 0 or p_parentCategoryId > 99999999) then
        raise err_parent_category_id_invalid;
      
      end if;
    end if;
  
  exception
    when err_category_id_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CATEGORY_ID_INVALID);
    when err_category_name_too_long then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CATEGORY_NAME_TOO_LONG);
    when err_parent_category_id_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PARENT_CATEGORY_ID_INVALID);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_VALIDATE_PARAMETERS_OTHERS);
    
  end;

  procedure basketParameters(p_basketId in number default null) is
    err_basket_id_invalid exception;
  begin
    -- BasketId'yi kontrol eder.
    if p_basketId is not null then
      if (p_basketId < 0 or p_basketId > 99999999999999999999) then
        raise err_basket_id_invalid;
      end if;
    end if;
  
  exception
    when err_basket_id_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_BASKET_ID_INVALID);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_VALIDATE_PARAMETERS_OTHERS);
  end;

  procedure basketProductParameters(p_basketProductId in number default null,
                                    p_productQuantity in number default null,
                                    p_isSelected      in number default null) is
    err_basket_product_id_invalid          exception;
    err_product_quantity_invalid           exception;
    err_basket_product_is_selected_invalid exception;
  begin
    -- BasketProductId'yi kontrol eder.
    if p_basketProductId is not null then
      if (p_basketProductId < 0 or p_basketProductId > 99999999999999999999) then
        raise err_basket_product_id_invalid;
      end if;
    end if;
    -- Product Quantity'yi kontrol eder.
    if p_productQuantity is not null then
      if (p_productQuantity < 0 or p_productQuantity > 9999999999) then
        raise err_product_quantity_invalid;
      end if;
    end if;
    -- isSelected'in degerini kontrol eder.
    if p_isSelected is not null then
      if p_isSelected not in (0, 1) then
        raise err_basket_product_is_selected_invalid;
      end if;
    end if;
  
  exception
    when err_basket_product_id_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_BASKET_PRODUCT_ID_INVALID);
    when err_product_quantity_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_QUANTITY_INVALID);
    when err_basket_product_is_selected_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_BASKET_PRODUCT_IS_SELECTED_INVALID);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_VALIDATE_PARAMETERS_OTHERS);
    
  end;

  procedure customerOrderParameters(p_customerOrderId in number default null,
                                    p_orderNo         in varchar2 default null,
                                    p_orderDate       in date default null,
                                    p_totalPrice      in number default null) is
    err_customer_order_id_invalid  exception;
    err_customer_order_no_too_long exception;
    err_total_price_invalid        exception;
  begin
    -- CustomerOrderId'yi kontrol eder.
    if p_customerOrderId is not null then
      if (p_customerOrderId < 0 or
         p_customerOrderId > 99999999999999999999999) then
        raise err_customer_order_id_invalid;
      end if;
    end if;
    -- Order No'nun uzunlugunu kontrol eder.
    if p_orderNo is not null then
      if length(p_orderNo) > 30 then
        raise err_customer_order_no_too_long;
      end if;
    end if;
    -- Order Date'yi kontrol eder.
    if p_orderDate is not null then
      null;
    end if;
    -- Total price'i kontrol eder.
    if p_totalPrice is not null then
      if (p_totalPrice < 0 or p_totalPrice > 99999999999999999999999) then
        raise err_total_price_invalid;
      end if;
    end if;
  
  exception
    when err_customer_order_id_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_ORDER_ID_INVALID);
    when err_customer_order_no_too_long then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_ORDER_NO_TOO_LONG);
    when err_total_price_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_TOTAL_PRICE_INVALID);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_VALIDATE_PARAMETERS_OTHERS);
  end;

  procedure customerOrderDetailParameters(p_customerOrderDetailId in number default null,
                                          p_productQuantity       in number default null,
                                          p_productUnitPrice      in number default null) is
    err_customer_order_detail_id_invalid exception;
    err_product_quantity_invalid         exception;
    err_product_price_invalid            exception;
  begin
    -- CustomerOrderDetailId'yi kontrol eder.
    if p_customerOrderDetailId is not null then
      if (p_customerOrderDetailId < 0 or
         p_customerOrderDetailId > 9999999999999999999999999) then
        raise err_customer_order_detail_id_invalid;
      end if;
    end if;
    -- Product Quantity'yi kontrol eder.
    if p_productQuantity is not null then
      if (p_productQuantity < 0 or p_productQuantity > 9999999999) then
        raise err_product_quantity_invalid;
      end if;
    end if;
    -- Product Unit Price'i kontrol eder.
    if p_productUnitPrice is not null then
      if (p_productUnitPrice < 0 or p_productUnitPrice > 9999999999) then
        raise err_product_price_invalid;
      end if;
    end if;
  
  exception
    when err_customer_order_detail_id_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_ORDER_DETAIL_ID_INVALID);
    when err_product_quantity_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_QUANTITY_INVALID);
    when err_product_price_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_PRICE_INVALID);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_VALIDATE_PARAMETERS_OTHERS);
  end;

  procedure customerProductFavoriteParameters(p_isFavorite in number default null) is
    err_product_is_favorite_invalid exception;
  begin
    -- isFavorite'nin degerini kontrol eder.
    if p_isFavorite is not null then
      if p_isFavorite not in (0, 1) then
        raise err_product_is_favorite_invalid;
      end if;
    end if;
  
  exception
    when err_product_is_favorite_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_PRODUCT_IS_FAVORITE_INVALID);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_VALIDATE_PARAMETERS_OTHERS);
    
  end;

  procedure taxParameters(p_taxId         in number default null,
                          p_taxName       in varchar2 default null,
                          p_taxPercentage in number default null) is
    err_tax_id_invalid         exception;
    err_tax_name_too_long      exception;
    err_tax_percentage_invalid exception;
  begin
    -- TaxId'yi kontrol eder.
    if p_taxId is not null then
      if (p_taxId < 0 or p_taxId > 999) then
        raise err_tax_id_invalid;
      end if;
    end if;
    -- Tax Name'in uzunlugunu kontrol eder.
    if p_taxName is not null then
      if length(p_taxName) > 100 then
        raise err_tax_name_too_long;
      end if;
    end if;
    -- Tax Percentage'i kontrol eder.
    if p_taxPercentage is not null then
      if (p_taxPercentage < 0 or p_taxPercentage > 99999) then
        raise err_tax_percentage_invalid;
      end if;
    end if;
  
  exception
    when err_tax_id_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_TAX_ID_INVALID);
    when err_tax_name_too_long then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_TAX_NAME_TOO_LONG);
    when err_tax_percentage_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_TAX_PERCENTAGE_INVALID);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_VALIDATE_PARAMETERS_OTHERS);
  end;

  procedure customerSessionParameters(p_customerSessionId in number default null,
                                      p_isLogin           in number default null) is
    err_customer_session_id_invalid       exception;
    err_customer_session_is_login_invalid exception;
  begin
    -- CustomerSessionId'yi kontrol eder.
    if p_customerSessionId is not null then
      if (p_customerSessionId < 0 or
         p_customerSessionId > 99999999999999999999) then
        raise err_customer_session_id_invalid;
      end if;
    end if;
    -- isLogin'nin degerini kontrol eder.
    if p_isLogin is not null then
      if p_isLogin not in (0, 1) then
        raise err_customer_session_is_login_invalid;
      end if;
    end if;
  
  exception
    when err_customer_session_id_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_SESSION_ID_INVALID);
    when err_customer_session_is_login_invalid then
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_SESSION_IS_LOGIN_INVALID);
    when others then
      rollback;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_VALIDATE_PARAMETERS_OTHERS);
  end;

end ecpValidate_pkg;
/
