create or replace package ecpValidate_pkg is

  procedure emailParameters(p_emailId      in number default null,
                            p_emailAddress in varchar2 default null); 

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

end ecpValidate_pkg;
/
