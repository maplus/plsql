/*
 * Mark points in code for rollback:
 *   Database changes rolled back
 *   Code not rolled back or run again
 * Don't survive commits or rollbacks.
 */

create table animal_tmp(
    animal_id int not null primary key,
    animal_name varchar2(30)
);

begin
    insert into animal_tmp values(1, 'Zebra');
    insert into animal_tmp values(2, 'Panda');
    insert into animal_tmp values(3, 'Tiger');
end;

commit;

-- insert, savepoint, insert, rollback to savepoint
begin
    insert into animal_tmp values(4, 'Lion');
    savepoint savepoint1;
    insert into animal_tmp values(5, 'Hippo');
    rollback to savepoint1;
end;

SELECT * FROM animal_tmp order by animal_id;


-- Savepoints do not survive across commits or rollback.
begin
    savepoint before_update;
    update animal_tmp
    set animal_name = 'Large ' || animal_name;
    commit;
    rollback to before_update;
exception
    when exception_list.e_bad_savepoint then
        dbms_output.put_line('Invalid Savepoint Used');
end;
/

create or replace package exception_list as
    e_resource_busy exception;
    pragma exception_init(e_resource_busy, -54);
    e_not_serializable exception;
    pragma exception_init(e_not_serializable, -8177);
    e_bad_savepoint exception;
    pragma exception_init(e_bad_savepoint, -1086);
end;
/


-- Can rollback from exception handlers to savepoint
-- in main code block.
begin
    savepoint before_ins;
    insert into animal_tmp values(3, 'Tiger');
exception
    when dup_val_on_index then
        dbms_output.put_line('Duplcate ID');
        rollback to before_ins;
end;
/

commit;


-- Cannot rollback to savepoint in another exception handler.
begin
    insert into animal_tmp values(3, 'Tiger');
exception
    when dup_val_on_index then
        dbms_output.put_line('Duplicate ID');
        rollback to before_ins;
    when others then
        savepoint before_ins;
end;
/


create or replace procedure savepoint_p as
begin
    savepoint in_savepoint;
    insert into animal_tmp values(100, 'Animal 100');
end;
/

begin
    insert into animal_tmp values(98, 'Animal 98');
    savepoint_p;
    insert into animal_tmp values(99, 'Animal 99');
    rollback to in_savepoint;
end;
/

SELECT * FROM animal_tmp order by animal_id;


delete animal_tmp;
commit;

begin
    for idx in 1..10 loop
        savepoint animal_sp;
        insert into animal_tmp values(idx, 'Animal ' || idx);
        if mod(idx, 2) = 0 then
            rollback to animal_sp;
        end if;
    end loop;
end;
/

SELECT * FROM animal_tmp order by animal_id;


-- Clean up.
drop table animal_tmp;

