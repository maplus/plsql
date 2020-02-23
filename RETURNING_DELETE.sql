set serveroutput on 
DECLARE 
    l_animal_id ANIMAL2.ANIMAL_ID%type;
    l_animal_name ANIMAL2.ANIMAL_NAME%type;
BEGIN 
    for idx in 1..3 loop
        delete from animal2
        where animal_id = idx
        returning animal_id, animal_name
        into l_animal_id, l_animal_name;
        dbms_output.put_line(l_animal_id || ', ' || l_animal_name);
    end loop;
    rollback;
END;
/


set serveroutput on 
DECLARE 
    type l_animal_id_tbl is table of ANIMAL2.ANIMAL_ID%type; 
    l_animal_id l_animal_id_tbl := l_animal_id_tbl();
    type l_animal_name_tbl is table of ANIMAL2.ANIMAL_NAME%type;
    l_animal_name l_animal_name_tbl := l_animal_name_tbl();
BEGIN
    delete from animal2
    returning animal_id, animal_name
    bulk collect into l_animal_id, l_animal_name;
    
    dbms_output.put_line('Deleted ' || l_animal_id.count || ' recs.');
    for idx in 1..l_animal_id.count loop
        dbms_output.put_line('. ' || l_animal_id(idx) || ', ' || l_animal_name(idx));
    end loop;
    
    rollback;
END;
/
