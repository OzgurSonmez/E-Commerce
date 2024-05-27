create or replace noneditionable package ecpError_pkg is

  -- Hata kodlari --------------
  ERR_CODE_OTHERS CONSTANT NUMBER := -20100;
  ERR_CODE_EMAIL_ADDRESS_DUPLICATE CONSTANT NUMBER := -20101;
  ERR_CODE_EMAIL_ADDRESS_NOT_FOUND CONSTANT NUMBER := -20102;
  ERR_CODE_EMAIL_ADDRESS_TOO_MANY_ROWS CONSTANT NUMBER := -20103;
  ERR_CODE_CUSTOMER_DUPLICATE CONSTANT NUMBER := -20104;
  ERR_CODE_CUSTOMER_PASSWORD_NOT_FOUND CONSTANT NUMBER := -20105;
  ERR_CODE_CUSTOMER_NOT_FOUND CONSTANT NUMBER := -20106;
  
  -- Hata mesajlari --------------
  ERR_MSG_OTHERS CONSTANT VARCHAR2(100) := 'Beklenmedik bir hata olustu. '; 
  ERR_MSG_EMAIL_ADDRESS_DUPLICATE CONSTANT VARCHAR2(100) := 'Bu email adresi zaten kayitli.';
  ERR_MSG_EMAIL_ADDRESS_NOT_FOUND CONSTANT VARCHAR2(100) := 'Bu email adresi bulunamadi.';
  ERR_MSG_EMAIL_ADDRESS_TOO_MANY_ROWS CONSTANT VARCHAR2(100) := 'Ayni email adresine ait birden fazla kayit bulundu.';
  ERR_MSG_CUSTOMER_DUPLICATE CONSTANT VARCHAR2(100) := 'Musteri tablosunda benzersiz anahtar veya indeks hatasi.';
  ERR_MSG_CUSTOMER_PASSWORD_NOT_FOUND CONSTANT VARCHAR2(100) := 'Musteri hash veya salt parolasi bulunamadi.';
  ERR_MSG_CUSTOMER_NOT_FOUND CONSTANT VARCHAR2(100) := 'Musteri bulunamadi';
  
  -- Validasyon hata kodlari --------------
  -- Email
  ERR_CODE_EMAIL_ID_INVALID CONSTANT NUMBER := -20501;
  ERR_CODE_EMAIL_ADDRESS_TOO_LONG CONSTANT NUMBER := -20502;
  ERR_CODE_EMAIL_ADDRESS_INVALID CONSTANT NUMBER := -20503;
  -- Customer
  ERR_CODE_CUSTOMER_ID_INVALID CONSTANT NUMBER := -20504;
  ERR_CODE_CUSTOMER_FIRST_NAME_TOO_LONG CONSTANT NUMBER := -20505;
  ERR_CODE_CUSTOMER_LAST_NAME_TOO_LONG CONSTANT NUMBER := -20506;
  ERR_CODE_CUSTOMER_PASSWORD_HASH_TOO_LONG CONSTANT NUMBER := -20507;
  ERR_CODE_CUSTOMER_PASSWORD_SALT_TOO_LONG CONSTANT NUMBER := -20508;
  ERR_CODE_CUSTOMER_IS_ACCOUNT_ACTIVE_INVALID CONSTANT NUMBER := -20509;  
  ERR_CODE_IDENTITY_TYPE_ID_INVALID CONSTANT NUMBER := -20510;
  ERR_CODE_IDENTITY_NUMBER_TOO_LONG CONSTANT NUMBER := -20511;
  ERR_CODE_GENDER_ID_INVALID CONSTANT NUMBER := -20512;
  
  -- Validasyon hata mesajlari --------------
  -- Email
  ERR_MSG_EMAIL_ID_INVALID CONSTANT VARCHAR2(100) := 'Gecersiz Email Id.';
  ERR_MSG_EMAIL_ADDRESS_TOO_LONG CONSTANT VARCHAR2(100) := 'Email adresi cok uzun.';
  ERR_MSG_EMAIL_ADDRESS_INVALID CONSTANT VARCHAR2(100) := 'Gecersiz email adresi';
  -- Customer
  ERR_MSG_CUSTOMER_ID_INVALID CONSTANT VARCHAR2(100) := 'Gecersiz Musteri Id.';
  ERR_MSG_CUSTOMER_FIRST_NAME_TOO_LONG CONSTANT VARCHAR2(100) := 'Musteri ismi cok uzun.';
  ERR_MSG_CUSTOMER_LAST_NAME_TOO_LONG CONSTANT VARCHAR2(100) := 'Musteri soyismi cok uzun.';
  ERR_MSG_CUSTOMER_PASSWORD_HASH_TOO_LONG CONSTANT VARCHAR2(100) := 'Musterinin hash sifresi cok uzun.';
  ERR_MSG_CUSTOMER_PASSWORD_SALT_TOO_LONG CONSTANT VARCHAR2(100) := 'Musterinin salt sifresi cok uzun.';
  ERR_MSG_CUSTOMER_IS_ACCOUNT_ACTIVE_INVALID CONSTANT VARCHAR2(100) := 'Gecersiz aktiflik durumu.';
  ERR_MSG_IDENTITY_TYPE_ID_INVALID CONSTANT VARCHAR2(100) := 'Gecersiz Kimlik Tipi Id.';
  ERR_MSG_IDENTITY_NUMBER_TOO_LONG CONSTANT VARCHAR2(100) := 'Kimlik numarasi cok uzun.';
  ERR_MSG_GENDER_ID_INVALID CONSTANT VARCHAR2(100) := 'Gecersiz Cinsiyet Id.';
  
  procedure raiseError(p_ecpErrorCode in number);

end ecpError_pkg;
/
create or replace noneditionable package body ecpError_pkg is


  procedure raiseError(p_ecpErrorCode in number) is
  errorMessage varchar2(100);  
  begin
    
    -- Hata koduna gore hata mesajini belirler.
    case p_ecpErrorCode
      when ERR_CODE_EMAIL_ADDRESS_DUPLICATE then
          errorMessage := ERR_MSG_EMAIL_ADDRESS_DUPLICATE;
      when ERR_CODE_EMAIL_ADDRESS_NOT_FOUND then
          errorMessage := ERR_MSG_EMAIL_ADDRESS_NOT_FOUND;
      when ERR_CODE_EMAIL_ADDRESS_TOO_MANY_ROWS then
          errorMessage := ERR_MSG_EMAIL_ADDRESS_TOO_MANY_ROWS;
      when ERR_CODE_EMAIL_ID_INVALID then
          errorMessage := ERR_MSG_EMAIL_ID_INVALID;
      when ERR_CODE_EMAIL_ADDRESS_TOO_LONG then
          errorMessage := ERR_MSG_EMAIL_ADDRESS_TOO_LONG;  
      when ERR_CODE_EMAIL_ADDRESS_INVALID then
          errorMessage := ERR_MSG_EMAIL_ADDRESS_INVALID;  
      when ERR_CODE_CUSTOMER_ID_INVALID then
          errorMessage := ERR_MSG_CUSTOMER_ID_INVALID;
      when ERR_CODE_CUSTOMER_FIRST_NAME_TOO_LONG then
          errorMessage := ERR_MSG_CUSTOMER_FIRST_NAME_TOO_LONG;
      when ERR_CODE_CUSTOMER_LAST_NAME_TOO_LONG then
          errorMessage := ERR_MSG_CUSTOMER_LAST_NAME_TOO_LONG;
      when ERR_CODE_CUSTOMER_PASSWORD_HASH_TOO_LONG then
          errorMessage := ERR_MSG_CUSTOMER_PASSWORD_HASH_TOO_LONG;
      when ERR_CODE_CUSTOMER_PASSWORD_SALT_TOO_LONG then
          errorMessage := ERR_MSG_CUSTOMER_PASSWORD_SALT_TOO_LONG;
      when ERR_CODE_CUSTOMER_IS_ACCOUNT_ACTIVE_INVALID then
          errorMessage := ERR_MSG_CUSTOMER_IS_ACCOUNT_ACTIVE_INVALID;    
      when ERR_CODE_IDENTITY_TYPE_ID_INVALID then
          errorMessage := ERR_MSG_IDENTITY_TYPE_ID_INVALID;
      when ERR_CODE_IDENTITY_NUMBER_TOO_LONG then
          errorMessage := ERR_MSG_IDENTITY_NUMBER_TOO_LONG;  
      when ERR_CODE_GENDER_ID_INVALID then
          errorMessage := ERR_MSG_GENDER_ID_INVALID;
      when ERR_CODE_CUSTOMER_DUPLICATE then
          errorMessage := ERR_MSG_CUSTOMER_DUPLICATE;
      when ERR_CODE_CUSTOMER_PASSWORD_NOT_FOUND then
          errorMessage := ERR_MSG_CUSTOMER_PASSWORD_NOT_FOUND;    
      when ERR_CODE_CUSTOMER_NOT_FOUND then
          errorMessage := ERR_MSG_CUSTOMER_NOT_FOUND;    
      
      
      
  
          
      else
          errorMessage := ERR_MSG_OTHERS || sqlerrm;          
    end case;
      -- Hata verir.  
      raise_application_error(p_ecpErrorCode, errorMessage); 
  end;
end ecpError_pkg;
/
