/********************
 * Reference cursor *
 ********************/
-- Dynamic ref cursor.
DECLARE
    TYPE ref_cur_t IS REF CURSOR;
    l_cur ref_cur_t;
    l_sql CONSTANT VARCHAR2(100) := q'/SELECT object_type, COUNT(*) recs
    FROM user_objects GROUP BY object_type ORDER BY object_type/';
    l_object_type user_objects.object_type%TYPE;
    l_recs INT;
BEGIN
    OPEN l_cur FOR l_sql;
    LOOP
        FETCH l_cur INTO l_object_type, l_recs;
        EXIT WHEN l_cur%NOTFOUND;
        
        dbms_output.put_line(l_object_type || ': ' || l_recs);
    END LOOP;
    CLOSE l_cur;
END;
/

-- Weak reference
SET SERVEROUTPUT ON
DECLARE
    TYPE ref_cur IS REF CURSOR;
    v_cur ref_cur;
    v_animal animal%ROWTYPE;
BEGIN
    -- Whole record.
    OPEN v_cur FOR SELECT * FROM animal ORDER BY animal_name;
    FETCH v_cur INTO v_animal;
    CLOSE v_cur;
    
    -- Single column.
    OPEN v_cur FOR SELECT animal_name FROM animal ORDER BY animal_name;
    FETCH v_cur INTO v_animal.animal_name;
    dbms_output.put_line(v_animal.animal_name);
    CLOSE v_cur;
END;
/

-- Strong reference
set serveroutput on 
declare
    TYPE ref_cur is ref cursor return animal%rowtype;
    v_cur ref_cur;
    v_animal animal%rowtype;
begin
    open v_cur for select * from animal order by animal_name;
    fetch v_cur into v_animal;
    dbms_output.put_line(v_animal.animal_name);
    close v_cur;
end;
/

-- Passed as argument to procedure
set serveroutput on 
declare
    type ref_cur is ref cursor return animal%rowtype;
    v_cur ref_cur;

    procedure abc(p_ref_curs SYS_REFCURSOR) is
        v_animal animal%rowtype;
    begin
        loop
            fetch p_ref_curs into v_animal;
            exit when p_ref_curs%notfound;
            
            dbms_output.put_line(v_animal.animal_name);
        end loop;
    end;
begin
    open v_cur for select * from animal order by animal_name;
    abc(v_cur);
    close v_cur;
end;
/

-- With parameter
set serveroutput on
DECLARE
    type ref_cur is ref cursor;
    v_cur ref_cur;
    v_animal animal%rowtype;
BEGIN
    open v_cur for 'select * from animal where animal_id = :1' using 1;
    fetch v_cur into v_animal;
    close v_cur;
    dbms_output.put_line(v_animal.animal_name);
END;
/
