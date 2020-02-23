/*
 * Functions in select list of SQL query.
 * SQL query from table function.
 * Embed PLSQL in sub-query
 *  WITH clause
 *  WITH_PLSQL hint
 * User defined functions (UDF)
 */

create table animal_tmp(
    animal_id int not null primary key,
    animal_name varchar2(30)
);

begin
    insert into animal_tmp values(1, 'Zebra');
    insert into animal_tmp values(2, 'Panda');
    commit;
end;
/


-- Function to reverse string.
create or replace function reverser_f(p_str varchar2) return varchar2 is
    l_ret_val varchar2(100);
begin
    for idx in reverse 1..length(p_str) loop
        l_ret_val := l_ret_val || substr(p_str, idx, 1);
        dbms_output.put_line(idx || ', ' || l_ret_val);
    end loop;
    return l_ret_val;
end;
/

set serveroutput on
SELECT animal_name, reverser_f(animal_name) reversed_name FROM animal_tmp;


-- Hold return values.
create or replace type name_jumble_o as object(
    normal_name varchar2(30),
    reversed_name varchar2(30)
);

create or replace type name_jumble_t as table of name_jumble_o;

-- return records types.
create or replace function name_jumble_f return name_jumble_t
    pipelined as
begin
    for l_animal in (select * from animal_tmp) loop
        pipe row(
            name_jumble_o(
                l_animal.animal_name,
                reverser_f(l_animal.animal_name)
            )
        );
    end loop;
end;
/

SELECT * FROM table(name_jumble_f) where normal_name = 'Zebra';


-- Funs in with clause.
with 
    function rev_f(p_name varchar2) return varchar2 as
        l_ret_val varchar2(30);
    begin
        for idx in reverse 1..length(p_name) loop
            l_ret_val := l_ret_val || substr(p_name, idx, 1);
        end loop;
        return l_ret_val;
    end;
SELECT rev_f(animal_name) FROM animal_tmp;


-- Procs in with clause.
with
    procedure proc_p(p_name in out varchar2) as
        l_tmp varchar2(30);
    begin
        for idx in reverse 1..length(p_name) loop
            l_tmp := l_tmp || substr(p_name, idx, 1);
        end loop;
        p_name := l_tmp;      
    end;
    function rev_f(p_name varchar2) return varchar2 as
        l_ret_val varchar2(30);
    begin
        l_ret_val := p_name;
        proc_p(l_ret_val);
        return(l_ret_val);
    end;
SELECT rev_f(animal_name) FROM animal_tmp;


-- PLSQL in DML.
delete /*+ WITH_PLSQL */ animal_tmp a
where reverser_f(a.animal_name) in (
    with
        function rev_f(p_name varchar2) return varchar2 as
            l_ret_val varchar2(30);
        begin
            for idx in reverse 1..length(p_name) loop
                l_ret_val := l_ret_val || substr(p_name, idx, 1);
            end loop;
            return l_ret_val;
        end;
        SELECT rev_f(b.animal_name) FROM animal_tmp b
    );
    
    
-- UDFs usally run faster than non-UDFs
create or replace function reverser2_f(p_str varchar2) return varchar2 is
    pragma UDF;
    l_ret_val varchar2(100);
begin
    for idx in reverse 1..length(p_str) loop
        l_ret_val := l_ret_val || substr(p_str, idx, 1);
        dbms_output.put_line(idx || ', ' || l_ret_val);
    end loop;
    return l_ret_val;
end;
/

SELECT reverser2_f(animal_name) FROM animal_tmp;


-- Clean up.
--drop table animal_tmp;

