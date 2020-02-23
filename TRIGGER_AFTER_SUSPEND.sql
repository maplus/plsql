SELECT * FROM user_ts_quotas;

set serveroutput on 
begin
    for idx in 1..10000 loop
        insert into demo values(rpad(idx, 30, idx));
    end loop;
end;
/
-- ORA-01536: space quota exceeded for tablespace 'TS_MYDWH'

create trigger after_suspend
after suspend on database --schema
begin
    raise_application_error(-20000, 'Forced suspend to fail');
end;

-- Continue study... prio low

