-- After logon
create table logon_log(
    username varchar2(30),
    logon_timestamp timestamp
);

create or replace trigger after_logon
after logon on schema -- database
begin
    insert into logon_log(username, logon_timestamp)
    values(ora_login_user, systimestamp);
    
end;


-- Before logoff
create table logoff_log(
    username varchar2(30),
    logon_timestamp timestamp
);

create or replace trigger before_logoff
before logoff on schema -- database
begin
    insert into logoff_log(username, logon_timestamp)
    values(ora_login_user, systimestamp);
    
end;


-- After startup

-- Before shutdown

-- Server error
create or replace trigger after_servererror
after servererror on schema -- database
begin
    dbms_output.put_line('User ' || ora_login_user || ' Event ' || ora_sysevent);
    dbms_output.put_line('Error stack levels ' || ora_server_error_depth);
    for idx in 1..ora_server_error_depth loop
        dbms_output.put_line(ora_server_error_depth || ' ' || ora_server_error_msg(idx));
        dbms_output.put_line('Param count ' || ora_server_error_num_params(idx));
        if ora_server_error_num_params(idx) > 0 then
            for idx2 in 1..ora_server_error_num_params(idx) loop
                dbms_output.put_line(ora_server_error_param(idx, idx2));
            end loop;
        end if;
    end loop;
end;

set serveroutput on 
begin
    raise dup_val_on_index;
end;
/

-- ora_is_servererror(1)