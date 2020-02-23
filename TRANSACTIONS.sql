SELECT distinct sid FROM v$mystat;

set serveroutput on 
begin
    insert into animal (animal_name) values('xyz');
end;
/

SELECT * FROM animal;
begin rollback; end;
/

-- https://docs.oracle.com/database/121/REFRN/GUID-3F9F26AA-197F-4D36-939E-FAF1EFD8C0DD.htm#REFRN30125
SELECT
    vlo.session_id,
    (
        SELECT do.object_name
        FROM dba_objects do
        where do.object_id = vlo.object_id
    ) object_name,
    vlo.locked_mode,
    case vlo.locked_mode
        when 0 then 'NONE: Lock Request (not yet obtained)'
        when 1 then 'NULL'
        when 2 then 'ROWS_S (SS): Row Share Lock'
        when 3 then 'ROW_X (SX): Row Exclusive Table Lock'
        when 4 then 'SHARE (S): Share Table Lock'
        when 5 then 'S/ROW-X (SSX): Share Row Exclusive Table Lock'
        when 6 then 'Exclusive (X): Exclusive Table Lock'
        else '???'
    end locked_mode_desc
FROM v$locked_object vlo;


-- For update locks records for update as it queries them
-- and holds them until a commit or rollback occurs.
DECLARE 
    l_animal animal%rowtype;
BEGIN 
    SELECT *
    into l_animal
    FROM animal
    where animal_id = 1
    for update of animal_name;
END;
/

-- Other session...
update animal set animal_name = 'Small ' || animal_name where animal_id = 1;

rollback;


-- ROW_X (SX): Row Exclusive Table Lock.
DECLARE 
    cursor cur_animal is
    SELECT * FROM animal
    where animal_id = 1
    for update of animal_name;
    l_animal animal%rowtype;
BEGIN 
    open cur_animal;
        fetch cur_animal into l_animal;
        update animal
        set animal_name = 'Hippo 1234'
        where current of cur_animal;
    close cur_animal;
END;
/


-- Use of no wait, add exception handler to this example.
-- Exception thrown, when other lock exists on it...
-- >>> Consider: same row must be affected!
DECLARE 
    cursor cur_animal is
    SELECT * FROM animal
    where animal_id = 1
    for update of animal_name NOWAIT; --<<<!!!
    l_animal animal%rowtype;
BEGIN 
    open cur_animal;
        fetch cur_animal into l_animal;
        update animal
        set animal_name = 'Hippo 1234'
        where current of cur_animal;
    close cur_animal;
exception
    when exception_list.e_resource_busy then
        dbms_output.put_line('Waited too long...');
END;
/

create or replace package exception_list as
    e_resource_busy exception;
    pragma exception_init(e_resource_busy, -54);
end;
/


-- Updates rolled back even when row that fails is not
-- the first one processed.
DECLARE 
    cursor cur_animal is
    SELECT * FROM animal
    order by animal_id
    for update of animal_name nowait;
    l_animal animal%rowtype;
BEGIN 
    open cur_animal;
    loop
        fetch cur_animal into l_animal;
        exit when cur_animal%notfound;
        update animal
        set animal_name = animal_name || ' 1234'
        where current of cur_animal;
        dbms_output.put_line('Updated ' || l_animal.animal_id);
    end loop;
    close cur_animal;
exception
    when exception_list.e_resource_busy then
        dbms_output.put_line('Waited too long...');  
END;
/



