create or replace noneditionable package taxManager_pkg is

  function getTaxPercentage(p_taxName tax.taxname%type)
    return tax.taxpercentage%type;

end taxManager_pkg;
/
create or replace noneditionable package body taxManager_pkg is

  function getTaxPercentage(p_taxName tax.taxname%type)
    return tax.taxpercentage%type is
    v_taxPercentage tax.taxpercentage%type;
    begin
      -- Parametre kontrolu yapilir.
      ecpValidate_pkg.taxParameters(p_taxName => p_taxName);
      
      -- Parametreden gelen verginin yuzdesi bulunur.
      select t.taxpercentage into v_taxPercentage from tax t
          where lower(t.taxname) like ('%' || lower(p_taxName) || '%'); 
          dbms_output.put_line(v_taxPercentage);
           
      return v_taxPercentage;
      
      exception
        when no_data_found then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_TAX_NOT_FOUND); 
        when too_many_rows then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_TAX_TOO_MANY_ROWS); 
        when others then
           ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
    end;
end taxManager_pkg;
/
