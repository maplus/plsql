create or replace type number_t as table of number;

create or replace function f_return_table(p_id number) return number_t
    deterministic as
    l_number_t number_t := number_t();
begin
    l_number_t.extend(p_id);
    for idx in 1..l_number_t.count loop
        l_number_t(idx) := idx;
    end loop;
    return l_number_t;
end;

set serveroutput on 
declare
    l_number_t number_t := number_t();
begin
    l_number_t := f_return_table(3);
    for idx in 1..l_number_t.count loop
        dbms_output.put_line(l_number_t(idx));
    end loop;
end;
/


create or replace function f_refcursor return sys_refcursor is
    l_refcur sys_refcursor;
begin
    open l_refcur for select * from animal;
    return l_refcur;
end;

set serveroutput on 
declare
    v_refcur sys_refcursor;
    v_animal animal%rowtype;
begin
    v_refcur := f_refcursor;
    loop
        fetch v_refcur into v_animal;
        exit when v_refcur%notfound;
        dbms_output.put_line(v_animal.animal_name);
    end loop;
end;
/
