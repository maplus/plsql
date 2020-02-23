set serveroutput on
declare
begin
    if true then dbms_output.put_line('TRUE'); end if;

    if true then
        dbms_output.put_line('TRUE');
    else
        dbms_output.put_line('FALSE');
    end if;

    if true then
        dbms_output.put_line('TRUE');
    elsif true and false then
        dbms_output.put_line('TRUE and FALSE');
    else
        dbms_output.put_line('FALSE');
    end if;

    declare
        v_number number := 1;
    begin
        case v_number
            when 1 then dbms_output.put_line('It''s one');
            when 2 then dbms_output.put_line('It''s two');
            when 3 then dbms_output.put_line('It''s three');
            else dbms_output.put_line('Far beyond...');
        end case;
        
        case
            when v_number = 1 then dbms_output.put_line('It''s one');
            when v_number = 2 then dbms_output.put_line('It''s two');
            when v_number = 3 then dbms_output.put_line('It''s three');
            else dbms_output.put_line('Far beyond...');
        end case;
    end;
    
    begin
        dbms_output.put_line('1');
        GOTO THIRD;
        dbms_output.put_line('2');
        <<THIRD>>
        dbms_output.put_line('3');
    end;
    
    declare
        v_number number := 1;
    begin
        <<FAKE_LOOP>>
        dbms_output.put_line(v_number);
        v_number := v_number + 1;
        if v_number < 3 then GOTO FAKE_LOOP; end if;
    end;
    
-- PLS-00375: illegal GOTO statement; this GOTO cannot branch to label 'ELSE_STMT'
/*    begin
        if true then GOTO else_stmt;
        else
            <<else_stmt>>
            null;
        end if;
    end;*/
    
-- PLS-00201: identifier 'LABEL_ONE' must be declared
/*    declare
        v_number number := 1;
        procedure sub_proc is
        begin
            <<label_one>>
            null;
        end;
    begin
        v_number := v_number + 1;
        goto label_one;
        sub_proc;
    end;*/
end;
/