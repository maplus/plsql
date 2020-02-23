/*
 * Sets level of code optimization during compilation.
 * The higher the settings the more optimization done.
 */

-- Containts uncalled code.
set serveroutput on 
alter session set plsql_optimize_level = 3;
alter session set plsql_warnings = "ENABLE:INFORMATIONAL";
create or replace procedure optimize_p as
    function will_never_get_called_f
        return number as
    begin
        return 11;
    end;
begin
    dbms_output.put_line('Hello');
end;
/


-- Opportunity for inlining.
set serveroutput on 
alter session set plsql_optimize_level = 3;
alter session set plsql_warnings = "ENABLE:INFORMATIONAL";
create or replace procedure optimize2_p as
    l_number number;
    function call_f return number is
    begin
        return 11;
    end;
begin
    l_number := call_f;
end;
/


-- PLW-06010: keyword "NULL" used as a defined name
set serveroutput on 
alter session set plsql_optimize_level = 3;
alter session set plsql_warnings = "ENABLE:INFORMATIONAL";
create or replace procedure optimize3_p as
    l_dummy varchar2(1);
begin
    SELECT null into l_dummy FROM dual;
end;
/
