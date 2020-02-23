/*
 * PLSQL code that executes as its own transaction.
 * Not part of the main transaction (if one exists).
 * Must be committed or rolled back before rejoining
 * main transaction.
 */

create table animal_tmp(
    animal_id int not null primary key,
    animal_name varchar2(30)
);

-- Create procedure that is an autonomous transaction.
create or replace procedure create_animal(p_id number, p_name varchar2) is
    pragma autonomous_transaction; --<<<!!!
begin
    insert into animal_tmp
    values(p_id, p_name);
    commit;
end;
/

begin
    insert into animal_tmp values(1, 'Zebra');
    create_animal(2, 'Panda');
    rollback;
end;
/

SELECT * FROM animal_tmp;


-- Table to log errors.
create table error_log (
    program_name varchar2(30),
    timestamp date,
    error_number number
);

-- Violate a PK and insert a log entry.
begin
    insert into animal_tmp values(2, 'Other Panda');
exception
    when dup_val_on_index then
        declare
            e_code number := sqlcode;
        begin
            insert into error_log
            values('create animal', sysdate, e_code);
        end;
end;
/

rollback; -- Entry disapears...
SELECT * FROM error_log;


-- An autonomous transaction procedure to save the error needed!
create or replace procedure save_error_p(p_prog varchar2, p_err number) is
    pragma autonomous_transaction;
begin
    insert into error_log
    values(p_prog, sysdate, p_err);
    commit; --<<<!!!
end;
/

-- Violate a PK and save a log entry.
begin
    insert into animal_tmp values(2, 'Other Panda');
exception
    when dup_val_on_index then
        declare
            e_code number := sqlcode;
        begin
            save_error_p('create animal', e_code);
        end;
end;
/

rollback;
SELECT * FROM error_log;


-- Clean up.
drop table animal_tmp;
