set serveroutput on 
DECLARE 
    type l_animal_tbl is table of animal2%rowtype;
    l_animal l_animal_tbl := l_animal_tbl();
    l_num constant int := 4;
BEGIN 
    l_animal.extend(l_num);
    
    for i in 1..l_animal.count loop
        l_animal(i).animal_id := i;
        l_animal(i).animal_name := 'Hippo ' || i;
    end loop;
    
    forall i in 1..l_animal.count
        update animal2
        set animal_name = l_animal(i).animal_name
        where animal_id = l_animal(i).animal_id;
        
    for i in 1..l_animal.count loop
        dbms_output.put_line('Element ' || i || ' updated ' || sql%bulk_rowcount(i) || ' records.');
    end loop;
END;
/
