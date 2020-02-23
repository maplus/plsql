set serveroutput on
declare
    v_i int;
begin
    v_i := 'A';
    
exception -- Handler
    when others then -- Generic >> catches every error
        dbms_output.put_line(SQLCODE || ', ' || SQLERRM);
        --null;
end;
/


set serveroutput on
declare
    v_i int;
begin
    v_i := 'A';
    
exception
    when others then
        raise;
end;
/

set serveroutput on 
BEGIN
    insert into MYDWH.ANIMAL a (a.ANIMAL_ID, a.ANIMAL_NAME)
    values (1, initcap('panda' /*'dug'*/));
exception
    when dup_val_on_index then
        dbms_output.put_line('Some blabla explenation');
        dbms_output.put_line(dbms_utility.format_error_stack);
        dbms_output.put_line(dbms_utility.format_error_backtrace);
    when others then
        dbms_output.put_line(SQLCODE || ', ' || SQLERRM);
END;
/

set serveroutput on 
BEGIN
    dbms_output.put_line(SQLCODE || ', ' || SQLERRM);
END;
/
