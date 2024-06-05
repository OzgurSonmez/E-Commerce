create or replace noneditionable package categoryManager_pkg is

  function getAllCategories return sys_refcursor;

end categoryManager_pkg;
/
create or replace noneditionable package body categoryManager_pkg is

  function getAllCategories return sys_refcursor is
    c_categories sys_refcursor;
  begin
    -- -- Frontend'e tum kategorileri gonderir.
    open c_categories for
      select categoryid,
             categoryname,
             coalesce(parentcategoryid, -1) as parentcategoryid
        from category;
    return c_categories;
  
  exception
    when others then
      if c_categories%isopen then
        close c_categories;
      end if;
      ecpError_pkg.raiseError(p_ecpErrorCode => ecpError_pkg.ERR_CODE_OTHERS);
    
  end;
end categoryManager_pkg;
/
