set serveroutput on
declare
    -- index-by type and variable
    TYPE v_index_by_t IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;
    v_ib v_index_by_t;
    
    -- table type and variable
    TYPE v_table_t IS TABLE OF VARCHAR2(20);
    v_table v_table_t := v_table_t();
    
    -- varray type and variable
    TYPE v_varray_t IS VARRAY(4) OF VARCHAR2(20);
    v_varray v_varray_t := v_varray_t();
begin
    dbms_output.put_line('INDEX-BY TYPE AND VARIABLE');
    dbms_output.put_line('-- when empty... --');
    dbms_output.put_line('index by COUNT  ' || v_ib.COUNT);
    dbms_output.put_line('index by FIRST  ' || v_ib.FIRST);
    dbms_output.put_line('index by LAST  ' || v_ib.LAST);
    v_ib(1) := 'abc';
    v_ib(2) := 'def';
    v_ib(3) := 'ghi';
    dbms_output.put_line('-- when 3 values entered... --');
    dbms_output.put_line('index by COUNT  ' || v_ib.COUNT);
    dbms_output.put_line('index by FIRST  ' || v_ib.FIRST);
    dbms_output.put_line('index by LAST  ' || v_ib.LAST);
    
    dbms_output.put_line('-- simple for loop... --');
    for i in 1 .. v_ib.count loop
        dbms_output.put_line(i || ', ' || v_ib(i));
    end loop;
    
    dbms_output.put_line('-- first/next loop... --');
    declare
        v_i binary_integer;
    begin
        v_i := v_ib.first;
        loop
            exit when v_i is null;
            dbms_output.put_line(v_i || ', ' || v_ib(v_i));
            v_i := v_ib.next(v_i);
        end loop;
    end;
    
    dbms_output.put_line('-- last/prior loop... --');
    declare
        v_i binary_integer;
    begin
        v_i := v_ib.last;
        loop
            exit when v_i is null;
            dbms_output.put_line(v_i || ', ' || v_ib(v_i));
            v_i := v_ib.prior(v_i);
        end loop;
    end;
        
    dbms_output.put_line('-- delete middle elem (simple for loop would cause exception)... --');
    v_ib.delete(2);
    dbms_output.put_line('index by COUNT  ' || v_ib.COUNT);
    
    dbms_output.put_line('-- first/next loop... --');
    declare
        v_i binary_integer;
    begin
        v_i := v_ib.first;
        loop
            exit when v_i is null;
            dbms_output.put_line(v_i || ', ' || v_ib(v_i));
            v_i := v_ib.next(v_i);
        end loop;
    end;
    
    dbms_output.put_line('-- last/prior loop... --');
    declare
        v_i binary_integer;
    begin
        v_i := v_ib.last;
        loop
            exit when v_i is null;
            dbms_output.put_line(v_i || ', ' || v_ib(v_i));
            v_i := v_ib.prior(v_i);
        end loop;
    end;

    -------------------------------------------------------------------------
    dbms_output.put(chr(13) || chr(10));
    dbms_output.put_line('VARRAY TYPE AND VARIABLE');
    dbms_output.put_line('-- when empty... --');
    dbms_output.put_line('table by COUNT ' || v_varray.COUNT);
    dbms_output.put_line('table by FIRST ' || v_varray.FIRST);
    dbms_output.put_line('table by LAST  ' || v_varray.LAST);
    v_varray.extend(4);
    v_varray(1) := 'abc';
    v_varray(2) := 'def';
    v_varray(3) := 'ghi';
    dbms_output.put_line('-- when 3 values entered... --');
    dbms_output.put_line('table by COUNT ' || v_varray.COUNT);
    dbms_output.put_line('table by FIRST ' || v_varray.FIRST);
    dbms_output.put_line('table by LAST  ' || v_varray.LAST);

    dbms_output.put_line('-- simple for loop... --');
    for i in 1 .. v_varray.count loop
        dbms_output.put_line(i || ', ' || v_varray(i));
    end loop;
    
    dbms_output.put_line('-- first/next loop... --');
    declare
        v_i binary_integer;
    begin
        v_i := v_varray.first;
        loop
            exit when v_i is null;
            dbms_output.put_line(v_i || ', ' || v_varray(v_i));
            v_i := v_varray.next(v_i);
        end loop;
    end;
    
    dbms_output.put_line('-- last/prior loop... --');
    declare
        v_i binary_integer;
    begin
        v_i := v_varray.last;
        loop
            exit when v_i is null;
            dbms_output.put_line(v_i || ', ' || v_varray(v_i));
            v_i := v_varray.prior(v_i);
        end loop;
    end;
    
    dbms_output.put_line('-- delete all elems (doesn''t allow sparse varray)... --');
    v_varray.delete;
    dbms_output.put_line('index by COUNT  ' || v_varray.COUNT);
    
    dbms_output.put_line('-- simple for loop... --');
    for i in 1 .. v_varray.count loop
        dbms_output.put_line(i || ', ' || v_varray(i));
    end loop;
    
    dbms_output.put_line('-- first/next loop... --');
    declare
        v_i binary_integer;
    begin
        v_i := v_varray.first;
        loop
            exit when v_i is null;
            dbms_output.put_line(v_i || ', ' || v_varray(v_i));
            v_i := v_varray.next(v_i);
        end loop;
    end;
    
    dbms_output.put_line('-- last/prior loop... --');
    declare
        v_i binary_integer;
    begin
        v_i := v_varray.last;
        loop
            exit when v_i is null;
            dbms_output.put_line(v_i || ', ' || v_varray(v_i));
            v_i := v_varray.prior(v_i);
        end loop;
    end;

    -------------------------------------------------------------------------
    dbms_output.put_line(chr(13) || chr(10));
    dbms_output.put_line('TABLE TYPE AND VARIABLE');
    dbms_output.put_line('-- when empty... --');
    dbms_output.put_line('table by COUNT ' || v_table.COUNT);
    dbms_output.put_line('table by FIRST ' || v_table.FIRST);
    dbms_output.put_line('table by LAST  ' || v_table.LAST);
    v_table.extend(3);
    v_table(1) := 'abc';
    v_table(2) := 'def';
    v_table(3) := 'ghi';
    dbms_output.put_line('-- when 3 values entered... --');
    dbms_output.put_line('table by COUNT ' || v_table.COUNT);
    dbms_output.put_line('table by FIRST ' || v_table.FIRST);
    dbms_output.put_line('table by LAST  ' || v_table.LAST);
    
    dbms_output.put_line('-- simple for loop... --');
    for i in 1 .. v_table.count loop
        dbms_output.put_line(i || ', ' || v_table(i));
    end loop;
    
    dbms_output.put_line('-- first/next loop... --');
    declare
        v_i binary_integer;
    begin
        v_i := v_table.first;
        loop
            exit when v_i is null;
            dbms_output.put_line(v_i || ', ' || v_table(v_i));
            v_i := v_table.next(v_i);
        end loop;
    end;
    
    dbms_output.put_line('-- last/prior loop... --');
    declare
        v_i binary_integer;
    begin
        v_i := v_table.last;
        loop
            exit when v_i is null;
            dbms_output.put_line(v_i || ', ' || v_table(v_i));
            v_i := v_table.prior(v_i);
        end loop;
    end;    
    dbms_output.put_line('-- delete middle elem (simple for loop would cause exception)... --');
    v_table.delete(2);
    dbms_output.put_line('index by COUNT  ' || v_table.COUNT);
    
    dbms_output.put_line('-- first/next loop... --');
    declare
        v_i binary_integer;
    begin
        v_i := v_table.first;
        loop
            exit when v_i is null;
            dbms_output.put_line(v_i || ', ' || v_table(v_i));
            v_i := v_table.next(v_i);
        end loop;
    end;
    
    dbms_output.put_line('-- last/prior loop... --');
    declare
        v_i binary_integer;
    begin
        v_i := v_table.last;
        loop
            exit when v_i is null;
            dbms_output.put_line(v_i || ', ' || v_table(v_i));
            v_i := v_table.prior(v_i);
        end loop;
    end;
end;
/