create or replace package taxManager_pkg is

  function getTaxPercentage(p_taxName tax.taxname%type)
    return tax.taxpercentage%type;

end taxManager_pkg;
/
create or replace package body taxManager_pkg is

  function getTaxPercentage(p_taxName tax.taxname%type)
    return tax.taxpercentage%type is
    v_taxPercentage tax.taxpercentage%type;
    begin
      select t.taxpercentage into v_taxPercentage from tax t
          where lower(t.taxname) like ('%' || lower(p_taxName) || '%'); 
          dbms_output.put_line(v_taxPercentage);
           
      return v_taxPercentage;
      
      exception
        when no_data_found then
           raise_application_error(-20100, 'Vergi bulunamadi');
        when too_many_rows then
           raise_application_error(-20100, 'Girilen vergi adindan birden fazla var.');
        when others then
           raise_application_error(-20105, 'Beklenmeyen bir hata olustu. Hata kodu: ' || sqlerrm);
    end;
end taxManager_pkg;
/
