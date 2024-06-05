create or replace noneditionable package brandManager_pkg is

  function getAllBrands return sys_refcursor;

end brandManager_pkg;
/
create or replace noneditionable package body brandManager_pkg is

  function getAllBrands return sys_refcursor is
    c_brands sys_refcursor;
  begin
    -- Frontend'e tum markalari gonderir.
    open c_brands for
      select b.brandid, b.brandname from brand b;
      
    return c_brands;
    
  exception
    when others then
      if c_brands%isopen then
        close c_brands;
      end if;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
    
  end;

end brandManager_pkg;
/
