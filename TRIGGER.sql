alter trigger xyz disable;

for each row -- row level else statement level

SELECT * FROM user_triggers;

drop trigger animal2_test_trg;
create or replace trigger animal2_test_trg
before insert or update or delete on animal2
begin
    if inserting then
        dbms_output.put_line('inserting');
    elsif updating then
        dbms_output.put_line('updating');
    elsif deleting then
        dbms_output.put_line('deleting');
    else
        dbms_output.put_line('unknown');
    end if;
end;

set serveroutput on 
declare
    type l_animal2_tbl is table of animal2%rowtype;
    l_animal2 l_animal2_tbl := l_animal2_tbl();
begin
    l_animal2.extend(1);
    l_animal2(1).animal_id := -1;
    l_animal2(1).animal_name := 'Default';
    
    forall idx in 1..l_animal2.count
        insert into animal2 values l_animal2(idx);
        
    forall idx in 1..l_animal2.count
        update animal2 set animal_name = l_animal2(idx).animal_name where animal_id = l_animal2(idx).animal_id;
        
    forall idx in 1..l_animal2.count
        delete from animal2 where animal_id = l_animal2(idx).animal_id;
end;
/


create or replace trigger animal2_dml_trg
before delete or update on animal2
for each row
begin
    if deleting then
        dbms_output.put_line('Deleting: ' || :old.animal_id || ', ' || :old.animal_name);
    elsif updating then
        dbms_output.put_line('Updating: ' || :old.animal_id || ', ' || :old.animal_name
                                || ' to ' || :new.animal_id || ', ' || :new.animal_name);
    end if;
end;
/

set serveroutput on
insert into animal2 values('Default', -1); 
update animal2 set animal_name = 'Test' where animal_id = -1;
delete from animal2 where animal_id = -1;


-- Prevent update, delete.
create or replace trigger animal2_dml_trg_raise
before update or delete on animal2
begin
    if updating then
        raise_application_error(-20000, 'Updating not allowed');
    elsif deleting then
        raise_application_error(-20001, 'Deleting not allowed');
    end if;
end;

-- Specific column/value expected. >>> not working as expected!!!
create or replace trigger animal2_dml_trg_raise2
before update of animal_id on animal2
referencing OLD as old_rec NEW as new_rec
for each row
when (old_rec.animal_id is null or old_rec.animal_id <= 0)
begin
    raise_application_error(-20000, 'Updating for ' || :old_rec.animal_id || ' not allowed');
end;

set serveroutput on
alter trigger animal2_dml_trg_raise disable;
update animal2 set animal_name = 'Test';
update animal2 set animal_name = 'Test' where animal_id > 0;
alter trigger animal2_dml_trg_raise enable;

rollback;
