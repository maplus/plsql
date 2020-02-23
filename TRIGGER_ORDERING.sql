create or replace trigger animal3_one
before insert on animal3
for each row
begin
    :new.animal_id := 33;
    dbms_output.put_line('one');
end;

create or replace trigger animal3_two
before insert on animal3
for each row
follows animal3_one
begin
    if :new.animal_id = 33 then
        :new.animal_id := 66;
    end if;
    dbms_output.put_line('two');
end;

create or replace trigger animal3_three
before insert on animal3
for each row
follows animal3_two
begin
    if :new.animal_id = 66 then
        :new.animal_id := 99;
    end if;
    dbms_output.put_line('three');
end;

insert into animal3(animal_name) values('Leopard');

SELECT * FROM animal3;

rollback;
