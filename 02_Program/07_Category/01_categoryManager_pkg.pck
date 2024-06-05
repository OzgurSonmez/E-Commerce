create or replace noneditionable package categoryManager_pkg is

  function getAllCategories return sys_refcursor;

end categoryManager_pkg;
/
create or replace noneditionable package body categoryManager_pkg is

  function getAllCategories return sys_refcursor is
    c_categories sys_refcursor;
  begin
    open c_categories for
      select categoryid,
             categoryname,
             coalesce(parentcategoryid, -1) as parentcategoryid
      from category;
    return c_categories;
  end;
end categoryManager_pkg;
/
