/*
 * Flags in code that direct compilation behavior.
 * Flage enabled/disabled in package.
 */

-- Version specific code that compile against all versions.
create or replace procedure version_sensitive_code_p as
begin
    if dbms_db_version.ver_le_11 then
        dbms_output.put_LINE('Version 11 code here');
    elsif dbms_db_version.ver_le_12 then
        dbms_output.put_LINE('Version 12 code here');
    else
        dbms_output.put_LINE('Code only works on 11 and 12');
    end if;
end;

set serveroutput on 
begin
    version_sensitive_code_p;
end;
/


-- Version specific code that does not comile against all versions.
create or replace procedure version_sensitive_code2_p as
begin
    $if dbms_db_version.ver_le_11 $then
        dbms_output.put_LINE('Version 11 code here');
    $elsif dbms_db_version.ver_le_12 $then
        dbms_output.put_LINE('Version 12 code here');
    $else
        dbms_output.put_LINE('Code only works on 11 and 12');
    $end
end;

set serveroutput on 
begin
    version_sensitive_code2_p;
end;
/


set serveroutput on 
begin
    dbms_preprocessor.print_post_processed_source(
        --'PROCEDURE', USER, 'version_sensitive_code_p'
        'PROCEDURE', USER, 'version_sensitive_code2_p'
    );
end;
/


create or replace package debug_flags as
    show_params constant boolean :=  true;
    show_loop constant boolean := true;
    show_detail constant boolean := true;
    
    procedure debuggable(p_id number);
end;

create or replace package body debug_flags as
    procedure debuggable(p_id number) is
        l_number number := 1;
    begin
        $if debug_flags.show_detail $then
            dbms_output.put_line($$plsql_code_type);
            $if dbms_db_version.ver_le_9 $then
                null;
            $else
                dbms_output.put_line($$plsql_optimize_level);
            $end
        $end
        $if debug_flags.show_params $then
            dbms_output.put_line('p_id ' || p_id);
        $end
        for idx in 1..p_id loop
            l_number := l_number * p_id;
            $if debug_flags.show_loop $then
                dbms_output.put_line(idX || ' l_number ' || l_number);
            $end
        end loop;
    end;
end;

set serveroutput on 
begin
    debug_flags.debuggable(11);
end;
/


-- $ERROR directive to ensure code does not compile and get used.
set serveroutput on 
create or replace procedure for_version_11_only_p as
begin
    $if dbms_db_version.version <> 11 $then
        $error
            'Do not run this on anything except 11'
        $end
    $end
end;
/
