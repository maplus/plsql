set serveroutput on
declare
    v_animal animal%ROWTYPE;
begin
    SELECT *
    into v_animal
    FROM animal a where a.ANIMAL_ID = 2;
    
    dbms_output.put_line(v_animal.animal_id || ', ' || v_animal.animal_name);
end;
/

set serveroutput on
declare
    v_animal animal%ROWTYPE;
begin
    v_animal.animal_name := 'Panda';
    v_animal.created_stmp := sysdate; --!!!
    v_animal.created_by := user;      --!!!
    
    insert into animal
    values v_animal;
    
    dbms_output.put_line(SQL%ROWCOUNT);
end;
/