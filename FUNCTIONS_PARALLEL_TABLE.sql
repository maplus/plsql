create table bunch_of_numbers(col1 number unique);

begin
    for idx in 1..10 loop
        insert into bunch_of_numbers values(idx);
    end loop;
end;
/

create or replace function return_table_paral_f(p_refcur sys_refcursor)
    return number_t
    pipelined -- Not explicitely needed for parallel.
    parallel_enable(partition p_refcur by any) as
    l_number number;
begin
    loop fetch p_refcur into l_number;
        exit when p_refcur%NOTFOUND;
        PIPE ROW(l_number);
    end loop;
end;

SELECT * FROM table(return_table_paral_f(CURSOR(SELECT * FROM bunch_of_numbers)));


create or replace package parallel_pkg as
    -- Needed to give info about types in the ref cursor.
    type number_cursors is ref cursor return bunch_of_numbers%rowtype;
    
    function return_table_range_f(p_refcur number_cursors)
        return number_t
        pipelined
        parallel_enable(partition p_refcur by range(col1))
        order p_refcur by (col1);

    function return_table_hash_f(p_refcur  number_cursors)
        return number_t
        pipelined
        parallel_enable(partition p_refcur by hash(col1))
        cluster p_refcur by (col1);
 end;

create or replace package body parallel_pkg as
    function return_table_range_f(p_refcur  number_cursors)
        return number_t
        pipelined
        parallel_enable(partition p_refcur by range(col1))
        order p_refcur by (col1) as
        l_number number;
    begin
        loop fetch p_refcur into l_number;
            exit when p_refcur%notfound;
            pipe row(l_number);
        end loop;
    end;
    
    function return_table_hash_f(p_refcur  number_cursors)
        return number_t
        pipelined
        parallel_enable(partition p_refcur by hash(col1))
        cluster p_refcur by (col1) as
        l_number number;
    begin
        loop fetch p_refcur into l_number;
            exit when p_refcur%notfound;
            pipe row(l_number);
        end loop;
    end;
end;

SELECT * FROM table(parallel_pkg.return_table_range_f(CURSOR(SELECT * FROM bunch_of_numbers)));
SELECT * FROM table(parallel_pkg.return_table_hash_f(CURSOR(SELECT * FROM bunch_of_numbers)));

