create or replace noneditionable package brandManager_pkg is

  function getAllBrands return sys_refcursor;

end brandManager_pkg;
/
create or replace noneditionable package body brandManager_pkg is

  function getAllBrands return sys_refcursor is
    c_brands sys_refcursor;
  begin
    open c_brands for
      select b.brandid, b.brandname from brand b;
    return c_brands;
  end;

end brandManager_pkg;
/
