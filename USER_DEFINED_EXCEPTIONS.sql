create table demo (
    e int,
    constraint ck_demo_less check (e < 11)
);

insert into demo values(11);

set serveroutput on
DECLARE
    e_not_less_than_eleven EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_not_less_than_eleven, -2290);
BEGIN
    insert into demo values(11);
exception
    when e_not_less_than_eleven then
        dbms_output.put_line('e must be < 11!');
END;
/

set serveroutput on
DECLARE
    v_i int := 11;
    e_not_less_than_eleven EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_not_less_than_eleven, -20000);
BEGIN
    if v_i > 10 then
        raise_application_error(-20000, 'e must be < 11!');
    end if;
exception
    when e_not_less_than_eleven then
        dbms_output.put_line('Really, e must be < 11!');
END;
/
