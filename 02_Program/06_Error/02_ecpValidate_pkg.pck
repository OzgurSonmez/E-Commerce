create or replace package ecpValidate_pkg is

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
 

end ecpValidate_pkg;
/
create or replace package body ecpValidate_pkg is

    procedure emailParameters(p_emailId      in number default null,
                              p_emailAddress in varchar2 default null) is
    begin
      -- EmailId'yi kontrol eder
      if p_emailId is not null then
        if (p_emailId < 0 or p_emailId > 99999999999999999999) then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_EMAIL_ID_INVALID);
        end if;
      end if;
       
      -- EmailAddress'in karakter sayisini ve formatini kontrol eder
      if p_emailAddress is not null then
        if length(p_emailAddress) > 255 then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_EMAIL_ADDRESS_TOO_LONG);   
        elsif not regexp_like(p_emailAddress, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') then
              ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_EMAIL_ADDRESS_INVALID);          
        end if;
      end if;
       
    end;
    
    
    procedure customerParameters(p_customerId     in number default null,
                                 p_firstName      in varchar2 default null,
                                 p_lastName       in varchar2 default null,
                                 p_birthDate      in date default null,
                                 p_passwordHash   in varchar2 default null,
                                 p_passwordSalt   in varchar2 default null,              
                                 p_identityNumber in varchar default null,
                                 p_isAccountActive in number default null)  is
    begin
      
      -- CustomerId'yi kontrol eder.
      if p_customerId is not null then
         if p_customerId < 0 or p_customerId > 99999999999999999999 then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_ID_INVALID);
         end if;  
      end if;
      
      -- FirstName'in uzunlugunu kontrol eder.
      if p_firstName is not null then
         if length(p_firstName) > 100 then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_FIRST_NAME_TOO_LONG);
         end if;  
      end if;
      
      -- LastName'in uzunlugunu kontrol eder.
      if p_lastName is not null then
         if length(p_lastName) > 100 then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_LAST_NAME_TOO_LONG);
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
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_PASSWORD_HASH_TOO_LONG);
         end if;  
      end if;
      
      -- PasswordSalt'in uzunlugunu kontrol eder.
      if p_passwordSalt is not null then
         if length(p_passwordSalt) > 255 then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_PASSWORD_SALT_TOO_LONG);
         end if;  
      end if;      

      
      -- IdentityNumber'in uzunlugunu kontrol eder.
      if p_identityNumber is not null then
         if length(p_identityNumber) > 12 then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_IDENTITY_NUMBER_TOO_LONG);
         end if;
      end if;    

      -- isAccuntActive'in degerini kontrol eder.
      if p_isAccountActive is not null then
        if p_isAccountActive not in (0,1) then
          ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CUSTOMER_IS_ACCOUNT_ACTIVE_INVALID);
        end if;
      end if;
      
    
    end; 
     

    procedure productParameters(p_productId          in number default null,
                                p_productName        in varchar2 default null,
                                p_productDescription in varchar2 default null,
                                p_price              in number default null,
                                p_discountPercentage in number default null,
                                p_favCount           in number default null) is
    begin
      -- ProductId'yi kontrol eder.
      if p_productId is not null then
        if (p_productId < 0 or p_productId > 99999999999999999999) then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_ID_INVALID);
        end if;
      end if;
      
      -- ProductName'in uzunlugunu kontrol eder.
      if p_productName is not null then
         if length(p_productName) > 100 then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_NAME_TOO_LONG);
         end if;  
      end if;
      
      -- Product Description'in uzunlugunu kontrol eder.
      if p_productDescription is not null then
         if length(p_productDescription) > 2000 then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_DESCRIPTION_TOO_LONG);
         end if;  
      end if;
      
      -- Product Price'i kontrol eder.
      if p_price is not null then
        if (p_price < 0 or p_price > 99999999999999999999) then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_PRICE_INVALID);
        end if;
      end if;
      
      -- Product Discount Percentage'i kontrol eder.
      if p_discountPercentage is not null then
        if (p_discountPercentage < 0 or p_discountPercentage > 100) then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_DISCOUNT_PERCENTAGE_INVALID);
        end if;
      end if;
      
      -- Favorite Count'u kontrol eder.
      if p_favCount is not null then
        if (p_favCount < 0 or p_favCount > 99999999999999999999) then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PRODUCT_FAVORITE_COUNT_INVALID);
        end if;
      end if;  
      
      
      
    end;  
    
    
    procedure brandParameters(p_brandId     in number default null,
                              p_brandName   in varchar2 default null) is
    begin
      -- BrandId'yi kontrol eder.
      if p_brandId is not null then
        if (p_brandId < 0 or p_brandId > 9999999999) then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_BRAND_ID_INVALID);
        end if;
      end if;
      
      -- Brand Name'in uzunlugunu kontrol eder.
      if p_brandName is not null then
         if length(p_brandName) > 100 then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_BRAND_NAME_TOO_LONG);
         end if;  
      end if;
      
    end;
    
    
    procedure categoryParameters(p_categoryId        in number default null,
                                 p_categoryName      in varchar2 default null,
                                 p_parentCategoryId  in number default null) is
    begin
      -- CategoryId'yi kontrol eder.
      if p_categoryId is not null then
        if (p_categoryId < 0 or p_categoryId > 99999999) then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CATEGORY_ID_INVALID);
        end if;
      end if;
      
      -- Category Name'in uzunlugunu kontrol eder.
      if p_categoryName is not null then
         if length(p_categoryName) > 100 then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_CATEGORY_NAME_TOO_LONG);
         end if;  
      end if;
      
      -- ParentCategoryId'yi kontrol eder.
      if p_parentCategoryId is not null then
        if (p_parentCategoryId < 0 or p_parentCategoryId > 99999999) then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_PARENT_CATEGORY_ID_INVALID);
        end if;
      end if;
   
    end;                             

end ecpValidate_pkg;
/
