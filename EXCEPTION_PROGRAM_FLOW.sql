set serveroutput on
DECLARE
    v_i int;
BEGIN
    begin
        v_i := 'A';
    exception
        when others then
            dbms_output.put_line('when others');
            raise;
    end;
    
    dbms_output.put_line('next line');
    
exception
    when others then
        dbms_output.put_line('others when others');
END;
/

set serveroutput on
begin
    raise no_data_found;
end;
/

set serveroutput on
begin
    raise no_data_found;
exception
    when no_data_found then
        raise dup_val_on_index;
end;
/

set serveroutput on
begin
    insert into animal(animal_id, animal_name)
    values(3, 'Monkey');
    insert into animal(animal_id, animal_name)
    values(4, 'Ant');
exception
    when dup_val_on_index then
        rollback;
end;
/

SELECT * FROM animal;




