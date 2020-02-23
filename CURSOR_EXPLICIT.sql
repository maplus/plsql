/*******************
 * Explicit cursor *
 *******************/

SET SERVEROUTPUT ON
DECLARE
    CURSOR c_animal IS
    SELECT *
    FROM animal
    ORDER BY animal_name;
    
    v_animal animal%ROWTYPE;
BEGIN
    OPEN c_animal;
    LOOP
        FETCH c_animal INTO v_animal;
        EXIT WHEN c_animal%NOTFOUND;
            dbms_output.put_line(v_animal.animal_name);
    END Loop;
    CLOSE c_animal;
END;
/ 

-- With parameter
set serveroutput on
DECLARE
    CURSOR c_animal(p_id int) IS
    SELECT *
    FROM animal
    WHERE animal_id = p_id;
    
    v_animal animal%ROWTYPE;
    v_id int := 1;
BEGIN
    open c_animal(v_id);
    loop
        fetch c_animal into v_animal;
        exit when c_animal%NOTFOUND;
            dbms_output.put_line(v_animal.animal_name);
    end loop;
    close c_animal;
END;
/ 


set serveroutput on;
DECLARE
    cursor c is
    SELECT * FROM animal
    order by animal_name;
    
    v_table_row animal%ROWTYPE;
    v_cursor_row c%ROWTYPE;
    
    v_anchored_id animal.animal_id%type;
    v_anchored_name animal.animal_name%type;
    v_anchored_created ANIMAL.CREATED_STMP%type;
    v_anchored_created_by ANIMAL.CREATED_BY%type;
    v_anchored_updated ANIMAL.UPDATED_STMP%type;
    v_anchored_updated_by ANIMAL.UPDATED_BY%type;
    
    v_animal_id int;
    v_animal_name varchar2(30);
    v_animal_created date;
    v_animal_created_by varchar2(50);
    v_animal_updated date;
    v_animal_updated_by varchar2(50);
BEGIN
    open c;
    
    fetch c into v_table_row;
    fetch c into v_cursor_row;
    fetch c into v_anchored_id, v_anchored_name, v_anchored_created, v_anchored_created_by, v_anchored_updated, v_anchored_updated_by;
    fetch c into v_animal_id, v_animal_name, v_animal_created, v_animal_created_by, v_animal_updated, v_animal_updated_by;
    
    close c;
    
    dbms_output.put_line(v_table_row.animal_id || ', ' || v_table_row.animal_name);
    dbms_output.put_line(v_cursor_row.animal_id || ', ' || v_cursor_row.animal_name);
    dbms_output.put_line(v_anchored_id || ', ' || v_anchored_name);
    dbms_output.put_line(v_animal_id || ', ' || v_animal_name);
END;
/


-- Cursor attributes.
set serveroutput on;
DECLARE
    cursor c is
    SELECT * FROM animal
    order by animal_name;
    
    v_table_row animal%ROWTYPE;
BEGIN
    if not c%isopen then
        dbms_output.put_line('Before: cursor is not open');
    end if;
    
    open c;
    
    if c%isopen then
        dbms_output.put_line('Open: cursor is open');
    end if;
    
    for i in 1..5 loop
        fetch c into v_table_row;
        dbms_output.put_line('Fetched rec: ' || c%rowcount);
    
        if c%found then
            dbms_output.put_line('Found one');
        end if;
        if c%notfound then
            dbms_output.put_line('Did not find one');
        end if;
    end loop;
    
    close c;
    
    if not c%isopen then
        dbms_output.put_line('Close: cursor is not open');
    end if;
END;
/ 


set serveroutput on
declare
    cursor v_cur is
    SELECT * FROM animal order by animal_name;
begin
    for v in v_cur loop
        dbms_output.put_line('Record found SQL ' || sql%rowcount);
        dbms_output.put_line('Record found v_cur ' || v_cur%rowcount);
    end loop;
end;
/


set serveroutput on
declare
    cursor cur is
    select * from animal order by animal_name;
begin
    open cur;
    open cur;
exception
    when cursor_already_open then
        dbms_output.put_line('Cursor already open... cannot open already open cursor...');
end;
/


set serveroutput on
declare
    cursor cur is
    select * from animal order by animal_name;
    
    v_animal_row animal%rowtype;
begin
    fetch cur into v_animal_row;
    close cur;
exception
    when invalid_cursor then
        dbms_output.put_line('Cursor is probably not open...');
end;
/

