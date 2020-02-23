/*
 * Transactions that continue to see data as at their start
 * regardless of any other committed changes.
 */

-- Read only transaction must be first statement in transaction.
begin
    dbms_transaction.read_only; --<<<!!!
    for idx in 1..5 loop
        for v in (select * from animal order by animal_id) loop
            dbms_output.put_line('Loop ' || x || ' ' || v.animal_name);
        end loop;
        dbms_lock.sleep(10);
    end loop;
end;
/
commit;

-- Other session.
update animal
set animal_name = 'Small ' || animal_name;
commit;
