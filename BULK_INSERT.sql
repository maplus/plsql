/*
    not working???
*/
set serveroutput on 
declare
    TYPE v_animal_rec is RECORD (
        animal_id animal.animal_id%TYPE,
        animal_name animal.animal_name%TYPE,
        created_stmp ANIMAL.CREATED_STMP%TYPE,
        created_by ANIMAL.CREATED_BY%TYPE);
    TYPE v_animal_tbl IS TABLE OF v_animal_rec;
    v_animal v_animal_tbl := v_animal_tbl();
    num_rows int := 3;
begin
    v_animal.extend(num_rows);
    for i in 1..num_rows loop
        v_animal(i).animal_id := SEQ_ANIMAL_ID.nextval;
        v_animal(i).animal_name := 'MyAnimal ' || i;
        v_animal(i).created_stmp := sysdate;
        v_animal(i).created_by := user;
    end loop;
    
    forall i in 1..v_animal.count
        insert into animal values v_animal(i);
end;
/

-- Working!

--create table animal2(animal_name varchar2(50));
set timing on
set serveroutput on 
declare
    type v_animal_rec is record(animal_name ANIMAL2.ANIMAL_NAME%type, animal_id ANIMAL2.ANIMAL_ID%type);
    type v_animal_tbl is table of v_animal_rec;
    v_animal v_animal_tbl := v_animal_tbl();
    
    v_num_rec constant int := 1000000;
begin
    v_animal.extend(v_num_rec);
    for i in 1..v_num_rec loop
        v_animal(i).animal_name := 'my animal ' || i;
        v_animal(i).animal_id := i;
    end loop;
    
--    execute immediate('create table animal2(animal_name varchar2(50))');
    execute immediate('truncate table animal2');

    forall i in 1..v_animal.count
        insert into animal2 values v_animal(i);
        
--    dbms_output.put_line(sql%bulk_rowcount(v_animal.count)); -- That makes no sense for me!
--    execute immediate('drop table animal2');    
end;
/
-- SELECT * FROM animal2;