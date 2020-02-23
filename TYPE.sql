set serveroutput on
declare
    --v_animal_name varchar2(20);
    v_animal_name ANIMAL.ANIMAL_NAME%TYPE;
    cursor c is
    select animal_name from animal order by animal_name;
begin
    open c;
    loop
    fetch c into v_animal_name;
    exit when c%notfound;
        dbms_output.put_line('my animal: ' || v_animal_name);
    end loop;
    close c;
end;
/