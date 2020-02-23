/*
 * Contents not fully known at compile time.
 * Code is compiled just in time to execute.
 * Can be SQL (DDL/DML) or PLSQL.
 */

SELECT * FROM animal;

set serveroutput on 
BEGIN
    -- Dynamic DML.
    execute immediate 'insert into animal (animal_name) values (''Adolf'')';
    -- Dynamic DDL.
    execute immediate 'alter table animal add (animal_species varchar2(30))';
    -- Dynamic PLSQL.
    execute immediate 'begin null; end;';
    -- Raise exception.
    execute immediate 'begin raise no_data_found; end;';
exception
    when no_data_found then
        dbms_output.put_line('no data found was raised...');
END;
/


-- Stack and error trace.
set serveroutput on
begin
    execute immediate 'begin raise no_data_found; end;';
exception
    when others then
        dbms_output.put_line('Call  Stack ' || dbms_utility.format_call_stack);
        dbms_output.put_line('Error Stack ' || dbms_utility.format_error_stack);
        dbms_output.put_line('Stack Back  ' || dbms_utility.format_error_backtrace);
end;
/


-- Sets rowcount.
set serveroutput on
begin
    execute immediate 'update animal set animal_species = ''UNKNOWN''';
    dbms_output.put_line('Records updated ' || sql%rowcount);
end;
/

