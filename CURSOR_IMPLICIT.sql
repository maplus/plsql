/*******************
 * Implicit cursor *
 *******************/

set serveroutput on
DECLARE
    v_animal animal%ROWTYPE;
BEGIN
    for v_animal in (select * from animal order by animal_name) loop
        dbms_output.put_line('Found record ' || sql%rowcount);
    end loop;
END;
/


set serveroutput on 
declare
    v_rec animal%rowtype;
begin
    SELECT * into v_rec FROM animal where animal_id = 1;
    dbms_output.put_line(sql%rowcount);
    if sql%found then
        dbms_output.put_line('Found one');
    end if;
    
    SELECT * into v_rec FROM animal where animal_id = -1;
exception
    when no_data_found then
        dbms_output.put_line(sql%rowcount);
        if sql%notfound then
            dbms_output.put_line('Did not find one');
        end if;
end;
/
