/*SELECT * FROM bunch_of_numbers;
update bunch_of_numbers set col1 = col1 + 64;
commit;*/

create or replace package cursors as
    type number_cursor is ref cursor return bunch_of_numbers%rowtype;

    function return_table_f(p_curs number_cursor)
        return number_t
        pipelined
        parallel_enable (partition p_curs by range(col1))
        order p_curs by (col1);
end;

create or replace package body cursors as
    function return_table_f(p_curs number_cursor)
        return number_t
        pipelined
        parallel_enable (partition p_curs by range(col1))
        order p_curs by (col1) as
        l_number number;
    begin
        loop fetch p_curs into l_number;
            exit when p_curs%notfound;
            pipe row(l_number);
        end loop;
    end;
end;

SELECT * FROM table(cursors.return_table_f(cursor(select * from bunch_of_numbers)));


create or replace package cursors as
    type number_cursor is ref cursor return bunch_of_numbers%rowtype;
    type vc2_10_t is table of varchar2(10);

    function return_table_f(p_curs number_cursor)
        return number_t
        pipelined
        parallel_enable (partition p_curs by range(col1))
        order p_curs by (col1);

    function return_chr_f(p_curs number_cursor)
        return vc2_10_t
        pipelined;
end;

create or replace package body cursors as
    function return_table_f(p_curs number_cursor)
        return number_t
        pipelined
        parallel_enable (partition p_curs by range(col1))
        order p_curs by (col1) as
        l_number number;
    begin
        loop fetch p_curs into l_number;
            exit when p_curs%notfound;
            pipe row(l_number);
        end loop;
    end;
    
    function return_chr_f(p_curs number_cursor)
        return vc2_10_t
        pipelined as
        l_vc2_10 varchar2(10);
    begin
        loop fetch p_curs into l_vc2_10;
            exit when p_curs%notfound;
            pipe row(chr(l_vc2_10));
        end loop;
    end;
end;

SELECT * FROM table (cursors.return_chr_f(cursor(
    SELECT * FROM table (cursors.return_table_f(cursor(SELECT * FROM bunch_of_numbers))))));

