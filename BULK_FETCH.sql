-- All records at once.
set serveroutput on 
declare
    type v_animal_tbl is table of animal%ROWTYPE;
    v_animal v_animal_tbl;
    cursor v_animal_cur is select * from animal;
begin
    open v_animal_cur;
    fetch v_animal_cur bulk collect into v_animal;
    close v_animal_cur;
    
    dbms_output.put_line('Bulk count ' || v_animal.count);
    dbms_output.put_line('Bulk first ' || v_animal.first);
    dbms_output.put_line('Bulk first ' || v_animal.last);
    for i in 1..v_animal.count loop
        dbms_output.put_line('Bulk ' || i || ' ' || v_animal(i).animal_name);
    end loop;
end;
/


-- Single columns instead of rows.
set serveroutput on 
declare
    type v_animal_id_tbl is table of animal.animal_id%TYPE;
    v_animal_id v_animal_id_tbl;
    type v_animal_name_tbl is table of animal.animal_name%TYPE;
    v_animal_name v_animal_name_tbl;
    cursor v_animal_cur is select animal_id, animal_name from animal;
begin
    open v_animal_cur;
    fetch v_animal_cur bulk collect into v_animal_id, v_animal_name;
    close v_animal_cur;
    
    for i in 1..v_animal_id.count loop
        dbms_output.put_line('Bulk ' || i || '  ' || v_animal_id(i) || ', ' || v_animal_name(i));
    end loop;
end;
/


-- Limit number of values retrieved.
set serveroutput on 
declare
    type v_animal_id_tbl is table of animal.animal_id%TYPE;
    v_animal_id v_animal_id_tbl;
    type v_animal_name_tbl is table of animal.animal_name%TYPE;
    v_animal_name v_animal_name_tbl;
    cursor v_animal_cur is select animal_id, animal_name from animal;
begin
    open v_animal_cur;
    loop
        fetch v_animal_cur bulk collect into v_animal_id, v_animal_name limit 4;
        exit when v_animal_id.count = 0;
        
        for i in 1..v_animal_id.count loop
            dbms_output.put_line('Bulk ' || i || ', Cursor ' || v_animal_cur%ROWCOUNT || '; ' || v_animal_id(i) || ', ' || v_animal_name(i));
        end loop;
    end loop;
end;
/




