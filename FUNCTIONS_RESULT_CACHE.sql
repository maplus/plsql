create or replace function f_animal_count
    return number result_cache is
    l_ret_val number;
begin
    SELECT COUNT(*)
    into l_ret_val
    FROM animal;
    return l_ret_val;
end;

set serveroutput on 
begin
    dbms_output.put_line(f_animal_count);
end;
/

-- missing rights! exec as system/sys>> GRANT select_catalog_role TO mydwh; 
SELECT id, object_no, name, type, invalidations FROM v$result_cache_objects where name like '%ANIMAL%';
SELECT name, value FROM v$result_cache_statistics where name = 'Find Count';

insert into animal(animal_name) values('test animal');
commit;



