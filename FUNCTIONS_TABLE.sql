create or replace type number_t as table of number;

create or replace function return_table_f(p_id number)
    return number_t as
    l_ret_val number_t := number_t();
begin
    l_ret_val.extend(p_id);
    for idx in 1..l_ret_val.count loop
        l_ret_val(idx) := idx;
    end loop;
    return(l_ret_val);
end;

/*
    column_value := default name of the column when table has only ond column.
*/

select * FROM TABLE(return_table_f(5)) f;
SELECT f.column_value,
    min(column_value) over (partition by column_value) min_column_name,
    max(column_value) over (partition by column_value) max_column_name,
    lead(column_value) over (partition by 0 order by column_value) lead_column_name,
    lag(column_value) over (partition by 0 order by column_value) lag_column_name
FROM TABLE(return_table_f(5)) f;

SELECT * FROM TABLE(return_table_f(5)) a join TABLE(return_table_f(3)) b on a.COLUMN_VALUE = b.COLUMN_VALUE;


create or replace type numbers_o as object (positive_nr number, negative_nr number);
create or replace type numbers_t as table of numbers_o;

create or replace function return_table2_f(p_id number)
    return numbers_t as
    l_numbers numbers_t := numbers_t();
begin
    l_numbers.extend(P_id);
    for idx in 1..l_numbers.count loop
        l_numbers(idx) := numbers_o(idx, idx * -1);
    end loop;
    return l_numbers;
end;

SELECT * FROM TABLE(return_table2_f(5));


create or replace type animal_o as object (animal_id int,
                                            animal_name varchar2(30),
                                            animal_ascii varchar2(100));

create or replace type animal_t as table of animal_o;

create or replace function ascii_animal_f
    return animal_t as
    l_animal_t animal_t := animal_t();
    l_animal_ascii varchar2(100);
begin
    for l_animal in (select * from animal) loop
        l_animal_ascii := null;
        for idx in 1..length(l_animal.animal_name) loop
            l_animal_ascii := l_animal_ascii || ascii(substr(l_animal.animal_name, idx, 1));
        end loop;
        
        l_animal_t.extend;
        l_animal_t(l_animal_t.last) := animal_o(l_animal.animal_id, l_animal.animal_name, l_animal_ascii);
    end loop;
    return l_animal_t;
end;

--set serveroutput on
SELECT * FROM table(ascii_animal_f());

