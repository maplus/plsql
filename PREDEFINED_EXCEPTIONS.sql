set serveroutput on
DECLARE
    v_i int := 11;
BEGIN
    v_i := v_i / 0;
exception
    when others then
        dbms_output.put_line(sqlcode || ', ' || sqlerrm);
END;
/

set serveroutput on
DECLARE
    v_i int := 11;
BEGIN
    v_i := v_i / 0;
exception
    when ZERO_DIVIDE then
        dbms_output.put_line(sqlcode || ', ' || sqlerrm);
    when others then
        dbms_output.put_line(sqlcode || ', ' || sqlerrm);
END;
/

set serveroutput on
DECLARE
    v_animal_name ANIMAL.ANIMAL_NAME%TYPE;
BEGIN
    SELECT ANIMAL.ANIMAL_NAME
    into v_animal_name
    FROM animal
    where animal.ANIMAL_ID = -1;
exception
    when too_many_rows then
        dbms_output.put_line(sqlcode || ', ' || sqlerrm);
    when no_data_found then
        dbms_output.put_line(sqlcode || ', ' || sqlerrm);
END;
/

set serveroutput on
DECLARE
    v_animal_id ANIMAL.ANIMAL_ID%Type := 2;
    v_animal_name ANIMAL.ANIMAL_NAME%TYPE := 'Lion';
BEGIN
    insert into animal(animal_id, animal_name)
    values(v_animal_id, v_animal_name);
exception
    when dup_val_on_index then
        update animal set animal_name = v_animal_name where animal_id = v_animal_id;
END;
/

SELECT * FROM animal;