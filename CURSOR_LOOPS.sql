-- For loop with an implicit cursor
set serveroutput on
begin
    for v_animal in (select * from animal) loop
        dbms_output.put_line(v_animal.animal_name || ', ' || sql%rowcount);
    end loop;
end;
/


-- For loop with an explicit cursor
set serveroutput on
declare
    cursor v_cur is
    SELECT * FROM animal;
begin
    for v_animal in v_cur loop
        dbms_output.put_line(v_animal.animal_name || ', ' || v_cur%rowcount);
    end loop;
end;
/


-- Explicit loop with explicit cursor
set serveroutput on
declare
    cursor v_cur is
    SELECT * FROM animal;
    
    v_animal animal%rowtype;
begin
    open v_cur;
    loop
        fetch v_cur into v_animal;
        exit when v_cur%notfound;
        dbms_output.put_line(v_animal.animal_name || ', ' || v_cur%rowcount);
    end loop;
    close v_cur;
end;
/