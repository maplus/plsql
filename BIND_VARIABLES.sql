/*
 * https://community.oracle.com/docs/DOC-915518
 * https://asktom.oracle.com/pls/asktom/f?p=100:11:0::::P11_QUESTION_ID:2320123769177
 */


-- Not working >> out param in select???
SET SERVEROUTPUT ON
DECLARE 
    l_idx INT := 1;
    l_animal_id INT;
BEGIN 
--    EXECUTE IMMEDIATE 'SELECT * FROM animal WHERE animal_id = :1 RETURNING animal_id INTO :2' USING l_idx, OUT l_animal_id;
--    dbms_output.put_line('animal_id ' || l_animal_id);
    EXECUTE IMMEDIATE 'SELECT * FROM animal WHERE animal_id = :1' USING l_idx;
END;
/

-- NOT WORKiNG
SET SERVEROUTPUT ON
declare
    variable l_bind1 varchar2(30);
BEGIN 
    :l_bind1 := 'test';
    dbms_output.put_line(:l_bind1);
END;
/

-- NOT WORKiNG
SET SERVEROUTPUT ON; 
BEGIN 
    :v_bind1 := 'Manish Sharma'; 
END; 
/

-- SQL+
variable animal_id number
exec :animal_id := 10
select * from animal where animal_id = :animal_id;


-- Performance trouble
set serveroutput on
declare
    type rc is ref cursor;
    l_rc rc;
    l_dummy all_objects.object_name%type;
    l_start number default dbms_utility.get_time;
begin
    for i in 1 .. 1000 loop
        open l_rc for
        'select object_name
        from all_objects
        where object_id = ' || i;
        fetch l_rc into l_dummy;
        close l_rc;
        -- dbms_output.put_line(l_dummy);
    end loop;
    dbms_output.put_line(round((dbms_utility.get_time-l_start)/100, 2) || ' Seconds...' );
end;
/

set serveroutput on
declare
    type rc is ref cursor;
    l_rc rc;
    l_dummy all_objects.object_name%type;
    l_start number default dbms_utility.get_time;
begin
    for i in 1 .. 1000 loop
        open l_rc for
        'select object_name
        from all_objects
        where object_id = :x'
        using i;
        fetch l_rc into l_dummy;
        close l_rc;
        -- dbms_output.put_line(l_dummy);
    end loop;
    dbms_output.put_line(round((dbms_utility.get_time-l_start)/100, 2) || ' Seconds...' );
end;
/






