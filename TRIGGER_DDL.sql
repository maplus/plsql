create or replace trigger no_ddl
before ddl
on schema
begin
    --raise_application_error(-20000, 'no ddl allowed');
    dbms_output.put_line('you should not execute ddl...');
end;

create table my_test_tbl(test varchar2(30));


create or replace trigger before_create
before create
on schema
begin
    dbms_output.put_line('You created a ' || ORA_DICT_OBJ_TYPE || 
                            ' object, named ' || ORA_DICT_OBJ_NAME);
end;

set serveroutput on 
declare
    l_num int;
begin
    select count(*) into l_num from user_tables where table_name = 'MY_TEST_TBL';
    if l_num > 0 then 
        execute immediate 'drop table my_test_tbl';
    end if;
end;
create table my_test_tbl(
    test varchar2(30),
    constraint pk_my_test_tbl primary key (test));


create or replace trigger all_ddl
before ddl
on schema
begin
    dbms_output.put_line('That is a ' || ora_sysevent);
end;

CREATE OR REPLACE TRIGGER get_ddl
BEFORE DDL
ON SCHEMA
DECLARE
    l_ddl_line_count NUMBER;
    l_sql ORA_NAME_LIST_T;
BEGIN
    l_ddl_line_count := ORA_SQL_TXT(l_sql);
    FOR idx IN 1..l_ddl_line_count LOOP
        dbms_output.put_line(idx || ' ' || l_sql(idx));
    END LOOP;
end;

CREATE OR REPLACE TRIGGER get_privs
BEFORE DDL
ON SCHEMA
DECLARE
    l_ddl_line_count NUMBER;
    l_privs ORA_NAME_LIST_T;
BEGIN
    l_ddl_line_count := ORA_PRIVILEGE_LIST(l_privs);
    FOR idx IN 1..l_ddl_line_count LOOP
        dbms_output.put_line(idx || ' ' || l_privs(idx));
    END LOOP;
end;

grant all on animal3 to public;
