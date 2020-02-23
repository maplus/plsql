set serveroutput on 
DECLARE 
    l_animal_id animal2.animal_id%type;
    l_animal_name animal2.animal_name%type;
    l_num constant int := 3;
BEGIN
    for idx in 1..l_num loop
        update animal2
        set animal_name = 'hans ' || idx
        where animal_id = idx
        returning animal_id, animal_name -- >1 row updated will cause exception!
        into l_animal_id, l_animal_name;
        dbms_output.put_line(l_animal_id || ' ' || l_animal_name);
    end loop;
END;
/

set serveroutput on 
DECLARE 
    type l_animal_name_tbl is table of animal2.animal_name%type;
    l_animal_name l_animal_name_tbl := l_animal_name_tbl();
    type l_animal_id_tbl is table of ANIMAL2.ANIMAL_ID%type;
    l_animal_id l_animal_id_tbl := l_animal_id_tbl();
BEGIN 
    update animal2
    set animal_name = 'Hanna'
    returning animal_id, animal_name
    bulk collect into l_animal_id, l_animal_name;
    
    dbms_output.put_line(l_animal_id.count || ' rows updated.');
END;
/


set serveroutput on 
DECLARE 
    type l_animal_tbl is table of animal2%rowtype;
    l_animal l_animal_tbl := l_animal_tbl();
    
    type l_upd_id_tbl is table of ANIMAL2.ANIMAL_ID%type;
    l_upd_id l_upd_id_tbl := l_upd_id_tbl();
BEGIN 
    l_animal.extend(2);
    l_animal(1).animal_id := 1;
    l_animal(1).animal_name := 'Loris';
    l_animal(2).animal_id := 2;
    l_animal(2).animal_name := 'Lora';
    
    forall idx in 1..l_animal.count
        update animal2
        set animal_name = l_animal(idx).animal_name
        where animal_id = l_animal(idx).animal_id
        returning animal_id
        bulk collect into l_upd_id;
    dbms_output.put_line(l_upd_id.count || ' rows updated.');
END;
/

