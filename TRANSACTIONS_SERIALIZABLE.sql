/*
 * Verifies that transaction could be correctly replayed if
 * run in a serialized mode.
 * None of the records it touced can be modified by another
 * session.
 */

create table animal_tmp(animal_id int, animal_name varchar2(30));

insert into animal_tmp (animal_id, animal_name) values(1, 'abc ' || sysdate);
insert into animal_tmp (animal_id, animal_name) values(2, 'def ' || sysdate);
commit;

-- Serializable means transactions would run even if they were run one after the other.
-- Serializable must be the first statement in transaction.
begin
    execute immediate 'set transaction isolation level serializable';
    update animal_tmp
    set animal_name = 'Animal ' || animal_id;
    commit;
end;
/

SELECT * FROM animal_tmp;


create or replace package exception_list as
    e_resource_busy exception;
    pragma exception_init(e_resource_busy, -54);
    e_not_serializable exception;
    pragma exception_init(e_not_serializable, -8177);
end;
/

begin
    execute immediate 'set transaction isolation level serializable';
end;
/

-- Execute statements in session two...

begin
    update animal_tmp
    set animal_name = 'Animal ' || animal_id;
    dbms_output.put_line('Name Set');
exception
    when exception_list.e_not_serializable then
        dbms_output.put_line('Unable to serialize. Please try again.');
        rollback; --<<<!!! Ends serializable transaction...
end;

-- Clean up.
drop table animal_tmp;


-- Session two.
SELECT * FROM animal_tmp;

delete animal_tmp;
commit;

