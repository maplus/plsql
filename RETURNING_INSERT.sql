--alter table animal2 add (animal_id int);
--truncate table animal2;
--alter table animal2 modify animal_id not null;
--alter table animal2 add constraint pk_animal2 primary key (animal_id) using index;

set serveroutput on
DECLARE 
    v_animal_id ANIMAL2.ANIMAL_ID%type;
    v_animal_name ANIMAL2.ANIMAL_NAME%type;    
    v_row_num constant int := 10;
BEGIN 
    delete from animal2 where animal_id in (3, 6, 9);
    for i in 1..v_row_num loop
        begin
            insert into animal2(animal_id, animal_name)
            values (i, 'my animal ' || i)
            returning animal_id, animal_name
                into v_animal_id, v_animal_name;
            dbms_output.put_line(v_animal_id || ', ' || v_animal_name);
        exception
            when dup_val_on_index then
                null;
        end;
    end loop;
END;
/


set serveroutput on 
DECLARE 
    type l_animal_tbl is table of animal2%rowtype;
    l_animal l_animal_tbl := l_animal_tbl();
    l_num_rows constant int := 100;
    
    type l_n_tbl is table of number;
    l_n l_n_tbl := l_n_tbl();
BEGIN 
    l_animal.extend(l_num_rows);
    
    for i in 1..l_animal.count loop
        l_animal(i).animal_id := i;
        l_animal(i).animal_name := 'My animal ' || i;
    end loop;
    
    execute immediate ('truncate table animal2');
    
    forall i in 1..l_animal.count
        insert into animal2 values l_animal(i)
        returning animal_id
        bulk collect into l_n;
    
    dbms_output.put_line(l_n.count || ' records created.');
END;
/