create or replace noneditionable package ecpError_pkg is

  -- Hata kodlari
  ERR_CODE_OTHERS CONSTANT NUMBER := -20100;
  ERR_CODE_EMAIL_ADDRESS_DUPLICATE CONSTANT NUMBER := -20101;
  ERR_CODE_EMAIL_ADDRESS_NOT_FOUND CONSTANT NUMBER := -20102;
  ERR_CODE_EMAIL_ADDRESS_TOO_MANY_ROWS CONSTANT NUMBER := -20103;
  
  -- Hata mesajlari
  ERR_MSG_OTHERS CONSTANT VARCHAR2(100) := 'Beklenmedik bir hata olustu. '; 
  ERR_MSG_EMAIL_ADDRESS_DUPLICATE CONSTANT VARCHAR2(100) := 'Bu email adresi zaten kayitli.';
  ERR_MSG_EMAIL_ADDRESS_NOT_FOUND CONSTANT VARCHAR2(100) := 'Bu email adresi bulunamadi.';
  ERR_MSG_EMAIL_ADDRESS_TOO_MANY_ROWS CONSTANT VARCHAR2(100) := 'Ayni email adresine ait birden fazla kayit bulundu.';
  
  
  -- Validasyon hata kodlari
  ERR_CODE_EMAIL_ID_INVALID CONSTANT NUMBER := -20501;
  ERR_CODE_EMAIL_ADDRESS_TOO_LONG CONSTANT NUMBER := -20502;
  ERR_CODE_EMAIL_ADDRESS_INVALID CONSTANT NUMBER := -20503;
  
  -- Validasyon hata mesajlari
  ERR_MSG_EMAIL_ID_INVALID CONSTANT VARCHAR2(100) := 'Gecersiz Email Id.';
  ERR_MSG_EMAIL_ADDRESS_TOO_LONG CONSTANT VARCHAR2(100) := 'Email adresi cok uzun.';
  ERR_MSG_EMAIL_ADDRESS_INVALID CONSTANT VARCHAR2(100) := 'Gecersiz email adresi';
 
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
      
      
          
      else
          errorMessage := ERR_MSG_OTHERS || sqlerrm;          
    end case;
      -- Hata verir.  
      raise_application_error(p_ecpErrorCode, errorMessage); 
  end;
end ecpError_pkg;
/
