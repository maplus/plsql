/*
 * Values passed in at compile time...
 * ... which is just before execution.
 * Two methods available:
 * - Concatenate into statement.
 * - Pass into statement using substitution variables.
 */

SELECT * FROM animal;

set serveroutput on 
DECLARE 
    l_panda_species ANIMAL.ANIMAL_SPECIES%type := 'Melanoleuca';
    l_zebra_species ANIMAL.ANIMAL_SPECIES%type := 'Equids';
BEGIN 
    execute immediate 'update animal set animal_species = :1 where animal_name = :2'
        using l_panda_species, 'Panda';
    execute immediate 'update animal set animal_species = ''' || l_zebra_species || ''' where animal_name = ''Zebra''';
END;
/


create or replace procedure table_dropper_p(p_table varchar2) is
    e_not_exists exception;
    pragma exception_init(e_not_exists, -903);
begin
    /*execute immediate 'drop table :1' using p_table;*/ -- Not working >> using substitution variables leads
                                                         --                to a string which is not recognized in this context.
    execute immediate 'drop table ' || p_table;
exception
    when e_not_exists then
        dbms_output.put_line('Table ' || p_table || ' does not exist.');
end;

set serveroutput on 
create table TEST_TBL(test_id number);
begin table_dropper_p('TEST_TBL'); end;
/


create or replace type number_t as table of number;

set serveroutput on 
DECLARE 
    l_numbers number_t := number_t();
BEGIN 
    l_numbers.extend(2);
    l_numbers(1) := 1;
    l_numbers(2) := 2;
    execute immediate 'declare
                        numbers number_t; 
                       begin
                        numbers := :1;
                        dbms_output.put_line(numbers.count);
                       end;'
        using l_numbers;
END;
/


set serveroutput on 
DECLARE 
    l_numbers number_t := number_t();
BEGIN 
    l_numbers.extend(2);
    l_numbers(1) := 1;
    l_numbers(2) := 2;
    forall idx in 1..l_numbers.count
        execute immediate 'update animal set animal_name = animal_name || '' :1'' where animal_id = :1'
            using l_numbers(idx);
END;
/

