set serveroutput on
DECLARE 
    type l_animal_id_tbl is table of char;
    l_animal_id l_animal_id_tbl := l_animal_id_tbl();
    l_num_rec constant int := 3;
    
    e_dml_error exception;
    pragma exception_init(e_dml_error, -24381);
BEGIN 
    l_animal_id.extend(l_num_rec);
    for idx in 1..l_animal_id.count loop
        l_animal_id(idx) := idx;
    end loop;
    l_animal_id(l_animal_id.count) := 'A';
    
    begin
    forall idx in 1..l_animal_id.count save exceptions
        delete from animal2
        where animal_id = l_animal_id(idx);
    exception
        when e_dml_error then
            for idx in 1..sql%bulk_exceptions.count loop
                dbms_output.put_line('error code ' || sql%bulk_exceptions(idx).error_code ||
                                        ', idx ' || sql%bulk_exceptions(idx).error_index);
                dbms_output.put_line('. ' || l_animal_id(sql%bulk_exceptions(idx).error_index));
            end loop;
    end;
    rollback;
END;
/
