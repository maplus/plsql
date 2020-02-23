set serveroutput on
begin
    for i in reverse 1 .. 3 loop
        -- CONTINUE;
        -- CONTINUE WHEN i = 2;
        dbms_output.put_line(i);
        -- EXIT;
        -- EXIT WHEN i = 2;
    end loop;
    
declare
    v_stop_now boolean;
begin
    v_stop_now := FALSE;
    loop
        dbms_output.put_line('Simple loop 1');
        v_stop_now := TRUE;
        exit when v_stop_now;
        dbms_output.put_line('Simple loop 2');
    end loop;
    
    v_stop_now := FALSE;
    while not v_stop_now loop
        dbms_output.put_line('Simple while loop 1');
        v_stop_now := TRUE;
        dbms_output.put_line('Simple while loop 2');
    end loop;
end;
end;
/