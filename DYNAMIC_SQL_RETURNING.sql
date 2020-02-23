/*
 * Values returned by dynamic code.
 * Sent back via OUT variables.
 */
 
SELECT * FROM animal;

set serveroutput on 
DECLARE 
    l_animal_id animal.animal_id%type := 1;
    l_animal_name animal.animal_name%type := 'Tiger';
    l_actual_id animal.animal_id%type;
BEGIN 
    execute immediate 'update animal set animal_name = :1 where animal_id = :2 returning animal_id into :3'
        using l_animal_name, l_animal_id, out l_actual_id;
    dbms_output.put_line('Rows updated: ' || sql%rowcount);
    dbms_output.put_line('ID updated  : ' || l_actual_id);
    rollback;
END;
/


set serveroutput on 
DECLARE 
    l_animal_id animal.animal_id%type := 1;
    l_animal_name animal.animal_name%type := 'Tiger';
BEGIN 
    execute immediate 'update animal set animal_name = :1 where animal_id = :2 returning animal_id into :3'
        using l_animal_name, in l_animal_id, out l_animal_id;
    dbms_output.put_line('Rows updated: ' || sql%rowcount);
    dbms_output.put_line('ID updated  : ' || l_animal_id);
    rollback;
END;
/


create or replace type number_t as table of number;

set serveroutput on 
DECLARE 
    l_numbers number_t := number_t();
    l_number number;
BEGIN 
    l_numbers.extend(2);
    l_numbers(1) := 999;
    l_numbers(2) := 1;
    execute immediate 'declare
                        numbers number_t := number_t();
                       begin
                        update animal set animal_name = ''Bob''
                        where animal_id in (select column_value from table(cast(:1 as number_t)))
                        returning animal_id bulk collect into numbers;
                        :2 := numbers;
                       end;'
        using l_numbers, out l_numbers;
    for idx in 1..l_numbers.count loop
        dbms_output.put_line(l_numbers(idx));
    end loop;    
    rollback;
END;
/


