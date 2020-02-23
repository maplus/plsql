set serveroutput on 
DECLARE 
    cursor v_animal_cur is
    SELECT a.animal_name,
        cursor (
            SELECT s.STRIPE_COLOR
            FROM animal_stripe s
            where s.animal_id = a.animal_id
        )
    FROM animal a
    order by a.animal_id;
    
    v_animal_stripe_cur SYS_REFCURSOR;
    v_animal_name animal.animal_name%TYPE;
    v_stripe_color ANIMAL_STRIPE.STRIPE_COLOR%TYPE;
BEGIN
    open v_animal_cur;
    fetch v_animal_cur into v_animal_name, v_animal_stripe_cur;
    dbms_output.put_line(v_animal_name);
    loop
        fetch v_animal_stripe_cur into v_stripe_color;
        exit when v_animal_stripe_cur%notfound;
        dbms_output.put_line('- ' || v_stripe_color);
    end loop;
    close v_animal_stripe_cur;
    close v_animal_cur;
END;
/


-- Cursor behaviour as usual...
set serveroutput on 
DECLARE 
    cursor v_animal_cur is
    SELECT a.animal_name,
        cursor (
            SELECT s.STRIPE_COLOR
            FROM animal_stripe s
            where s.animal_id = a.animal_id
        )
    FROM animal a
    order by a.animal_id;
    
    v_animal_stripe_cur SYS_REFCURSOR;
    v_animal_name animal.animal_name%TYPE;
    v_stripe_color ANIMAL_STRIPE.STRIPE_COLOR%TYPE;
BEGIN
    open v_animal_cur;
    fetch v_animal_cur into v_animal_name, v_animal_stripe_cur;
    dbms_output.put_line(v_animal_name);
    for i in 1..3 loop
        fetch v_animal_stripe_cur into v_stripe_color;
        dbms_output.put_line('- ' || v_stripe_color || ', i: ' || i || ', rowcount: ' || v_animal_stripe_cur%rowcount);
        if v_animal_stripe_cur%found then
            dbms_output.put_line('Found one...');
        end if;
        if v_animal_stripe_cur%notfound then
            dbms_output.put_line('Did not find one...');
        end if;
    end loop;
    close v_animal_stripe_cur;
    close v_animal_cur;
END;
/ 


-- Pass nested cursor as parameter (as other ref cursors)
set serveroutput on 
DECLARE 
    cursor v_animal_cur is
    SELECT a.animal_name,
        cursor (
            SELECT s.STRIPE_COLOR
            FROM animal_stripe s
            where s.animal_id = a.animal_id
        )
    FROM animal a
    order by a.animal_id;

    v_animal_stripe_cur SYS_REFCURSOR;
    v_animal_name animal.animal_name%TYPE;

    procedure process_stripes(p_stripe_cur SYS_REFCURSOR) is
        v_color animal_stripe.stripe_color%type;
    begin
        loop
            fetch p_stripe_cur into v_color;
            exit when p_stripe_cur%notfound;
            dbms_output.put_line('- ' || v_color);
        end loop;
    end;
BEGIN 
    open v_animal_cur;
    loop
        fetch v_animal_cur into v_animal_name, v_animal_stripe_cur;
        exit when v_animal_cur%notfound;
        dbms_output.put_line(v_animal_name);
        process_stripes(v_animal_stripe_cur);
    end loop;
END;
/


