set serveroutput on 
DECLARE 
    type l_animal_id_tbl is table of ANIMAL2.ANIMAL_ID%type;
    l_animal_id l_animal_id_tbl := l_animal_id_tbl();
    l_num_rec constant int := 3;
BEGIN 
    l_animal_id.extend(3);
    for idx in 1..l_num_rec loop
        l_animal_id(idx) := idx;
    end loop;
    
    forall idx in 1..l_animal_id.count
        delete from animal2
        where animal_id = l_animal_id(idx);
        
    for idx in 1..l_animal_id.count loop
        dbms_output.put_line('idx ' || idx || ' deleted ' || sql%bulk_rowcount(idx) || ' rec(s)');
    end loop;
    
    rollback;
END;
/
