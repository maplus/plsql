create or replace procedure db_prc(p_var in varchar2 := 'default') as
begin
    dbms_output.put_line(p_var);
end;

set serveroutput on 
call db_prc();
exec db_prc('test it');
begin db_prc('test it again'); end;
/

create or replace procedure db_prc2(p_var in out varchar2 /*:= 'default' -- OUT and IN OUT formal parameters may not have default expressions*/) as
begin
    dbms_output.put_line(p_var);
    p_var := p_var || ' 1';
end;

set serveroutput on 
--call db_prc2('test2 it'); -- output parameter not a bind variable
DECLARE 
    l_var varchar2(16) := 'test2 it again';
BEGIN 
    db_prc2(l_var);
    dbms_output.put_line(l_var);
END;
/

-- Execute as sys...
SELECT LAST_ACTIVE_TIME,
       PARSING_SCHEMA_NAME,
       PARSE_CALLS,
       EXECUTIONS,
       SQL_TEXT
  FROM v$sql
 WHERE INSTR (SQL_TEXT, 'db_prc') > 0
order by LAST_ACTIVE_TIME desc;


create or replace procedure db_prc3(p_var_in in varchar2 := 'default',
                                    p_var_out out varchar2) as
begin
    dbms_output.put_line(p_var_in);
    p_var_out := p_var_in || ' 1';
end;

set serveroutput on 
declare
    l_var varchar2(50) := 'test3...';
begin
    db_prc3('abc', l_var);
    dbms_output.put_line(l_var);
    
    db_prc3(p_var_out => l_var);
    dbms_output.put_line(l_var);
end;
/


create or replace procedure db_prc4(p_animal ANIMAL2%rowtype) as
begin
    dbms_output.put_line(p_animal.animal_name);
end;

set serveroutput on 
begin
    for l_animal in (select * from animal2 order by animal_name) loop
        db_prc4(l_animal);
    end loop;
end;
/
