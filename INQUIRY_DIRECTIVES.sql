/*
 * CC flags enable/disable at compile time.
 */

create or replace procedure ccflag_p(p_id number) is
    l_number number;
begin
    l_number := p_id;
    $if $$DOUBLE_EVERYTHING $then
        l_number := l_number * 2;
    $end
    dbms_output.put_line(l_number);
end;

-- Check CC flag settings
SELECT * FROM user_plsql_object_settings where plsql_ccflags is not null;

set serveroutput on 
begin ccflag_p(66); end;
/

alter procedure ccflag_p compile plsql_ccflags='DOUBLE_EVERYTHING:TRUE';

alter session set plsql_ccflags='DOUBLE_EVERYTHING:TRUE'; -- ???

alter procedure ccflag_p compile reuse settings; -- ???


create or replace procedure ccflag2_p(p_id number) is
    l_number number(1) := 1;
begin
    $if $$DEBUG $then
        dbms_output.put_line('Passed in ' || p_id);
    $end
    l_number := l_number * 10;
exception
    when others then
        $if $$DEBUG $then
            dbms_output.put_line('l_number was ' || l_number);
        $end
        raise;
end;

set serveroutput on 
begin ccflag2_p(3); end;
/

alter procedure ccflag2_p compile plsql_ccflags='DEBUG:TRUE';


create or replace procedure ccflag3_p(p_id number) is
    l_number number(1) := 1;
begin
    $if $$DEBUG $then
        dbms_output.put_line($$plsql_line || ' of ' || $$plsql_unit);
    $end
    l_number := l_number * 10;
    $if $$DEBUG $then
        dbms_output.put_line($$plsql_line || ' of ' || $$plsql_unit);
    $end
exception
    when others then
        $if $$DEBUG $then
            dbms_output.put_line($$plsql_line || ' of ' || $$plsql_unit);
        $end
        raise;
end;

alter procedure ccflag3_p compile plsql_ccflags='DEBUG:TRUE';

set serveroutput on 
begin ccflag3_p(3); end;
/


set serveroutput on 
begin
    dbms_preprocessor.print_post_processed_source(
        'PROCEDURE', USER, 'ccflag3_p');
end;
/

alter procedure ccflag3_p compile plsql_ccflags='DEBUG:FALSE';

alter procedure ccflag3_p compile;
