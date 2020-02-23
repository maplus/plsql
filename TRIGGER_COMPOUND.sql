-- One compound per type and table allowed.
create or replace trigger animal3_compound
for insert on animal3
compound trigger
    l_var int := 1;
    
    before statement is
    begin
        dbms_output.put_line(l_var || '. Insert compound before stmt');
        l_var := l_var + 1;
    end before statement;
    before each row is
    begin
        dbms_output.put_line(l_var || '. Insert compound before each row');
        l_var := l_var + 1;
    end before each row;
    after each row is
    begin
        dbms_output.put_line(l_var || '. Insert compound after each row');
        l_var := l_var + 1;
    end after each row;
    after statement is
    begin
        dbms_output.put_line(l_var || '. Insert compound after stmt');
        l_var := l_var + 1;
    end after statement;
end;

create or replace trigger animal3_compound
for update on animal3
compound trigger
    l_var int := 1;

    before statement is
    begin
        dbms_output.put_line(l_var || '. Update compound before stmt');
        l_var := l_var + 1;
    end before statement;
    before each row is
    begin
        dbms_output.put_line(l_var || '. Update compound before each row');
        l_var := l_var + 1;
    end before each row;
    after each row is
    begin
        dbms_output.put_line(l_var || '. Update compound after each row');
        l_var := l_var + 1;
    end after each row;
    after statement is
    begin
        dbms_output.put_line(l_var || '. Update compound after stmt');
        l_var := l_var + 1;
   end after statement;
end;

SELECT * FROM animal3;

update animal3 set animal_name = animal_name where animal_id > 1;

