/********************
 * Reference cursor *
 ********************/

-- Weak reference
set serveroutput on
declare
    TYPE ref_cur is ref cursor;
    v_cur ref_cur;
    v_animal animal%rowtype;
begin
    -- Whole record.
    open v_cur for select * from animal order by animal_name;
    fetch v_cur into v_animal;
    close v_cur;
    
    -- Single column.
    open v_cur for select animal_name from animal order by animal_name;
    fetch v_cur into v_animal.animal_name;
    dbms_output.put_line(v_animal.animal_name);
    close v_cur;
end;
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

