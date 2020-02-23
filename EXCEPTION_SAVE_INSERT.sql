set serveroutput on 
DECLARE 
    type l_animal_tbl is table of animal2%rowtype;
    l_animal l_animal_tbl := l_animal_tbl();
    l_num_rows constant int := 3;
    
    e_dml_error exception;
    pragma exception_init(e_dml_error, -24381);
BEGIN 
    l_animal.extend(l_num_rows);
    
    for i in 1..l_animal.count loop
        l_animal(i).animal_id := i;
        l_animal(i).animal_name := 'My animal ' || i;
    end loop;
    
    begin
        forall i in 1..l_animal.count save exceptions
            insert into animal2 values l_animal(i);
    exception
        when e_dml_error then
            for i in 1..sql%bulk_exceptions.count loop
                dbms_output.put_line('Error ' || sql%bulk_exceptions(i).error_code ||
                                        ' at element ' || sql%bulk_exceptions(i).error_index);
                dbms_output.put_line('- Animal was ' || l_animal(sql%bulk_exceptions(i).error_index).animal_id ||
                                        ', ' || l_animal(sql%bulk_exceptions(i).error_index).animal_name);
            end loop;
    end;
END;
/