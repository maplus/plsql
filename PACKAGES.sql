-- Package header/specification.

create or replace package a_pkg as
    l_var int := 11;
    l_var_const constant int := 7;    
    procedure a_prc(p_id int);
    function a_fun(p_id int) return int;
end;

SELECT * FROM user_objects where object_type = 'PACKAGE';

set serveroutput on 
begin dbms_output.put_line(a_pkg.l_var_const); end;
/

set serveroutput on 
begin
    dbms_output.put_line(a_pkg.l_var);
    a_pkg.l_var := a_pkg.l_var * 2;
    dbms_output.put_line(a_pkg.l_var);
end;
/

alter package a_pkg compile;

create or replace procedure a_prc as
begin
    a_pkg.a_prc(33);
end;
/

SELECT * FROM user_dependencies where name = 'A_PRC';


-- Package body.

create or replace package body a_pkg as
    l_var_private int := 12;
    l_var_const_private int := 12;

    procedure a_prc(p_id int) is
    begin
        dbms_output.put_line('p_id ' || p_id);
    end;
    
    function a_fun_private(p_id int) return int is
    begin
        return p_id + l_var_private;
    end;
    
    function a_fun(p_id int) return int is
    begin
        return a_fun_private(p_id);
    end;
end;

set serveroutput on 
begin
    a_prc;
    a_pkg.a_prc(99);
end;
/

SELECT a_pkg.a_fun(99) FROM dual;


-- Cursors in packages.

create or replace package cur_pkg as
    cursor get_animal(p_id int) is
    select * from animal where animal_id = p_id;
end;

set serveroutput on 
declare
    v_animal cur_pkg.get_animal%rowtype;
begin
    open cur_pkg.get_animal(2);
    fetch cur_pkg.get_animal into v_animal;
    dbms_output.put_line(v_animal.animal_name);
    close cur_pkg.get_animal;
end;
/

