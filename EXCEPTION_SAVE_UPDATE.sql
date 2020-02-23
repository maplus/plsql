set serveroutput on 
DECLARE 
    type l_animal_id_tbl is table of ANIMAL2.ANIMAL_ID%type;
    l_animal_id l_animal_id_tbl := l_animal_id_tbl();
    type l_animal_name_tbl is table of varchar2(100);
    l_animal_name l_animal_name_tbl := l_animal_name_tbl();
    
    e_dml_error exception;
    pragma exception_init(e_dml_error, -24381);
BEGIN 
    l_animal_id.extend(3);
    l_animal_name.extend(3);
    
    for idx in 1..l_animal_id.count loop
        l_animal_id(idx) := idx;
        l_animal_name(idx) := rpad(idx, 100, idx);
    end loop;
    
    begin
        forall idx in 1..l_animal_id.count save exceptions
            update animal2
            set animal_name = l_animal_name(idx)
            where animal_id = l_animal_id(idx);
        exception
            when e_dml_error then
                for idx in 1..sql%bulk_exceptions.count loop
                    dbms_output.put_line('Error code ' || sql%bulk_exceptions(idx).error_code ||
                                            ' at element ' || sql%bulk_exceptions(idx).error_index);
                    dbms_output.put_line(l_animal_id(sql%bulk_exceptions(idx).error_index) ||
                                            ', ' || l_animal_name(sql%bulk_exceptions(idx).error_index));
                end loop;
    end;
END;
/
